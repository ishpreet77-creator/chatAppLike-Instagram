//
//  APIServices+Hangout.swift
//  Flazhed
//
//  Created by IOS32 on 12/02/21.
//

import Foundation

enum APIServicesHangout:APIService {
    
    case createHangout(data: JSONDictionary)
    case myHangouts(data: JSONDictionary)
    case otherHangouts(data: JSONDictionary)
    case deleteHangout(data: JSONDictionary)
    case detailHangout(data: JSONDictionary)
    case likeDislikeHangout(data: JSONDictionary)
    case check_hangout_limit(data: JSONDictionary)
    
    var path: String {
        var path = ""
        switch self {
        case .createHangout:
            path = BASE_URL.appending("create-hangout")
        case .myHangouts:
            path = BASE_URL.appending("my-hangouts")
        case .otherHangouts:
            path = BASE_URL.appending("other-user-hangouts")
        case .deleteHangout:
            path = BASE_URL.appending("delete-hangout-api")
        case .detailHangout:
            path = BASE_URL.appending("hangout-detail-by-id")
        case .likeDislikeHangout:
            path = BASE_URL.appending("hangout-like")
            
        case .check_hangout_limit:
            path = BASE_URL.appending("check_hangout_limit")
            
            

            
        }
        return path
     }
    
    var resource: Resource {
        var resource:Resource!
        let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
        case let .createHangout(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .myHangouts(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .otherHangouts(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .deleteHangout(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .detailHangout(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .likeDislikeHangout(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .check_hangout_limit(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        }
        return resource
    }
}
