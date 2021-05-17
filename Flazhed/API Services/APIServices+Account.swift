//
//  APIServices+Account.swift
//  Flazhed
//
//  Created by IOS32 on 05/02/21.
//

import Foundation
import Foundation
enum APIServicesAccount:APIService {
    
    case updateMobile(data: JSONDictionary)
    case getUnit
    case updateUnit(data: JSONDictionary)
    case getNotificationSetup
    case updateNotificationSetup(data: JSONDictionary)
    case updatePayment(data: JSONDictionary)
    
    var path: String {
        var path = ""
        switch self {
       
        case .updateMobile:
            path = BASE_URL.appending("update-phone-number")
        case .getUnit:
            path = BASE_URL.appending("get-unit-settings")
        case .updateUnit:
            path = BASE_URL.appending("update-unit-settings")
        case .getNotificationSetup:
            path = BASE_URL.appending("get-notificatio-setting")
        case .updateNotificationSetup:
            path = BASE_URL.appending("update-notificatio-setting")
            
        case .updatePayment:
            path = BASE_URL.appending("payment-submit")
            }
        return path
     }
    
    var resource: Resource {
        var resource:Resource!
        let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
        case let .updateMobile(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case .getUnit:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
            
        case let .updateUnit(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case .getNotificationSetup:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
            
        case let .updateNotificationSetup(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .updatePayment(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        }
        return resource
    }
}
