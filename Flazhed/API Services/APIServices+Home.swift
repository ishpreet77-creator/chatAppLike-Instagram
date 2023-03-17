//
//  APIServices+Home.swift
//  Flazhed
//
//  Created by IOS22 on 25/01/21.
//

import Foundation

enum APIServicesHome:APIService {

    case ShakeSent(data: JSONDictionary)
    case ShakeSentUser(data: JSONDictionary)
    case likeUnlikeUser(data: JSONDictionary)
    case AnonymousUser(data: JSONDictionary)
    case UpdateLatLong(data: JSONDictionary)
    case getUserDetails(data: JSONDictionary)
    case RegretShake(data: JSONDictionary)
    case RemoveStoryHangout(data: JSONDictionary)
    case getShakeCount
    
    var path: String {
        var path = ""
        switch self {
        case .ShakeSent:
            path = BASE_URL.appending("send-notification-by-shake")
        case .ShakeSentUser:
            path = BASE_URL.appending("get-user-by-shake")
        case .likeUnlikeUser:
            path = BASE_URL.appending("like-dislike")
        case .AnonymousUser:
            path = BASE_URL.appending("get-user-by-anonymous")
        case .UpdateLatLong:
            path = BASE_URL.appending("cronjob-update-user-location-after-five-minutes")
        case .getUserDetails:
            path = BASE_URL.appending("get-user-anonymous-by-id")
        case .RegretShake:
            path = BASE_URL.appending("regret-shake")
        case .RemoveStoryHangout:
            path = BASE_URL.appending("delete-second-table-like-dislike")
        case .getShakeCount:
            path = BASE_URL.appending("shakeCount")
            }
        return path
     }
    
    var resource: Resource {
        var resource:Resource!
        let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
    
        case let .ShakeSent(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .ShakeSentUser(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .likeUnlikeUser(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .AnonymousUser(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .UpdateLatLong(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .getUserDetails(data):
            resource = Resource(method: .post, parameters: data, headers: headerDict)
        case let .RegretShake(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .RemoveStoryHangout(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case .getShakeCount:
            resource = Resource(method: .get, parameters: nil, headers:headerDict)

        }
        return resource
    }
}
