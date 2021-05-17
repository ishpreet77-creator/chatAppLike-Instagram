//
//  APIServices+Chat.swift
//  Flazhed
//
//  Created by IOS33 on 17/03/21.
//

import Foundation
enum APIServicesChat:APIService {
    
    case getMatchesProfile(data: JSONDictionary)
    case createChat(data: JSONDictionary)
    case activeChat(data: JSONDictionary)
    case inActiveChat(data: JSONDictionary)
    case Report_Block_user(data: JSONDictionary)
    
    var path: String {
        var path = ""
        switch self {
        case .getMatchesProfile:
            path = BASE_URL.appending("get-matches")
        case .createChat:
            path = BASE_URL.appending("create-chat-room")
            
        case .activeChat:
            path = BASE_URL.appending("active-chat-rooms")
        case .inActiveChat:
            path = BASE_URL.appending("inactive-chat-room")
            
        case .Report_Block_user:
            path = BASE_URL.appending("report-user")
        }
        return path
     }
    
    var resource: Resource {
        var resource:Resource!
        let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
        
        case let .getMatchesProfile(data):
            resource = Resource(method: .post, parameters: data, headers: headerDict)
        case let .createChat(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .activeChat(data):
            resource = Resource(method: .post, parameters: data, headers: headerDict)
        case let .inActiveChat(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .Report_Block_user(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
       
        }
        return resource
    }
}
