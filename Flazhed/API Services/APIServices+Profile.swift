//
//  APIServices+Profile.swift
//  Flazhed
//
//  Created by IOS22 on 21/01/21.
//

import Foundation
enum APIServicesProfile:APIService {

    case getuserProfile
    case getPreference
    case logout
    case setPreference(data: JSONDictionary)
    case deleteAccount
    case updateFacebookData(data: JSONDictionary)
    case updateInstaData(data: JSONDictionary)
    case deleteImage(imageId: String)
    
    var path: String {
        var path = ""
        switch self {
        case .getuserProfile:
            path = BASE_URL.appending("get-profile")
        case .getPreference:
            path = BASE_URL.appending("get-preference")
        case .logout:
            path = BASE_URL.appending("logout")
        case .setPreference:
            path = BASE_URL.appending("set-preference")
            
        case .deleteAccount:
            path = BASE_URL.appending("delete-account")
            
        case .updateFacebookData:
            path = BASE_URL.appending("facebook-post")
        case .updateInstaData:
            path = BASE_URL.appending("instagram-post")
            
        case let .deleteImage(imageId):
            path = BASE_URL.appending("delete-profile-image-single/\(imageId)")
            }
        return path
     }
    
    var resource: Resource {
        var resource:Resource!
        let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
        case .getuserProfile:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
        case .getPreference:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
            
        case .logout:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
        case let .setPreference(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case .deleteAccount:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
            
        case let .updateFacebookData(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .updateInstaData(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case .deleteImage:
            resource = Resource(method: .get, parameters: nil, headers: headerDict)
        }
        return resource
    }
}
