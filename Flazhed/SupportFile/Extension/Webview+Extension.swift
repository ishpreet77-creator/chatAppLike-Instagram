//
//  Webview+Extension.swift
//  Flazhed
//
//  Created by ios2 on 16/12/21.
//

import Foundation
import UIKit
import WebKit

extension WKWebViewConfiguration {
    func set(cookies: [HTTPCookie], completion: (() -> Void)?) {
        if #available(iOS 11.0, *) {
            let waitGroup = DispatchGroup()
            for cookie in cookies {
                waitGroup.enter()
                websiteDataStore.httpCookieStore.setCookie(cookie) { waitGroup.leave() }
            }
            waitGroup.notify(queue: DispatchQueue.main) { completion?() }
        } else {
            cookies.forEach { HTTPCookieStorage.shared.setCookie($0) }
            self.createCookiesInjectionJS(cookies: cookies) {
                let script = WKUserScript(source: $0, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                self.userContentController.addUserScript(script)
                DispatchQueue.main.async { completion?() }
            }
        }
    }

    private func createCookiesInjectionJS (cookies: [HTTPCookie],  completion: ((String) -> Void)?) {
        var scripts: [String] = ["var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } )"]
        let now = Date()

        for cookie in cookies {
            if let expiresDate = cookie.expiresDate, now.compare(expiresDate) == .orderedDescending { continue }
            scripts.append("if (cookieNames.indexOf('\(cookie.name)') == -1) { document.cookie='\(cookie.javaScriptString)'; }")
        }
        completion?(scripts.joined(separator: ";\n"))
    }
}

extension WKWebView {
    func loadWithCookies(request: URLRequest) {
        if #available(iOS 11.0, *) {
            load(request)
        } else {
            var _request = request
            _request.setCookies()
            load(_request)
        }
    }
}

extension URLRequest {

    private static var cookieHeaderKey: String { "Cookie" }
    private static var noAppliedcookieHeaderKey: String { "No-Applied-Cookies" }

    var hasCookies: Bool {
        let headerKeys = (allHTTPHeaderFields ?? [:]).keys
        var hasCookies = false
        if headerKeys.contains(URLRequest.cookieHeaderKey) { hasCookies = true }
        if !hasCookies && headerKeys.contains(URLRequest.noAppliedcookieHeaderKey) { hasCookies = true }
        return hasCookies
    }

    mutating func setCookies() {
        if #available(iOS 11.0, *) { return }
        var cookiesApplied = false
        if let url = self.url, let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let headers = HTTPCookie.requestHeaderFields(with: cookies)
            for (name, value) in headers { setValue(value, forHTTPHeaderField: name) }
            cookiesApplied = allHTTPHeaderFields?.keys.contains(URLRequest.cookieHeaderKey) ?? false
        }
        if !cookiesApplied { setValue("true", forHTTPHeaderField: URLRequest.noAppliedcookieHeaderKey) }
    }
}

/// https://github.com/Kofktu/WKCookieWebView/blob/master/WKCookieWebView/WKCookieWebView.swift
extension HTTPCookie {

    var javaScriptString: String {
        if var properties = properties {
            properties.removeValue(forKey: .name)
            properties.removeValue(forKey: .value)

            return properties.reduce(into: ["\(name)=\(value)"]) { result, property in
                result.append("\(property.key.rawValue)=\(property.value)")
            }.joined(separator: "; ")
        }

        var script = [
            "\(name)=\(value)",
            "domain=\(domain)",
            "path=\(path)"
        ]

        if isSecure { script.append("secure=true") }

        if let expiresDate = expiresDate {
            script.append("expires=\(HTTPCookie.dateFormatter.string(from: expiresDate))")
        }

        return script.joined(separator: "; ")
    }

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
}
extension WKWebView {
    func load(_ request: URLRequest, with cookies: [HTTPCookie]) {
        var request = request
        let headers = HTTPCookie.requestHeaderFields(with: cookies)
        for (name, value) in headers {
            request.addValue(value, forHTTPHeaderField: name)
        }

        load(request)
    }
}


extension WKWebViewConfiguration {

static func includeCookie(preferences:WKPreferences, completion: @escaping (WKWebViewConfiguration?) -> Void) {
    let config = WKWebViewConfiguration()
    
    guard let cookies = HTTPCookieStorage.shared.cookies else {
        completion(config)
        return
    }
    
    config.preferences = preferences
    let dataStore = WKWebsiteDataStore.nonPersistent()
    HTTPCookieStorage.shared.cookieAcceptPolicy = .always
    
    DispatchQueue.main.async {
        let waitGroup = DispatchGroup()
        
        for cookie in cookies{
            waitGroup.enter()
            let customCookie = HTTPCookie(properties: [
                .domain: cookie.domain,
                .path: cookie.path,
                .name: cookie.name,
                .value: cookie.value,
                .secure: cookie.isSecure,
                .expires: cookie.expiresDate ?? NSDate(timeIntervalSinceNow: 31556926)
            ])
            if let cookieData = customCookie{
                dataStore.httpCookieStore.setCookie(cookieData) {
                    waitGroup.leave()
                }
            }
        }
        
        waitGroup.notify(queue: DispatchQueue.main) {
            config.websiteDataStore = dataStore
            completion(config)
        }
    }
}
}
