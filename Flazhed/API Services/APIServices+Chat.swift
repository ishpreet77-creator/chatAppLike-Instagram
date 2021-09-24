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
    case Delete_Chat(data: JSONDictionary)
    case Continue_chats(data: JSONDictionary)
    case Active_Inactive_chats(data: JSONDictionary)
    case Remove_Match(data: JSONDictionary)
    case Audio_Video_Call_Notification(data: JSONDictionary)
    case Rtm_Token_Generate
    
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
            
        case .Delete_Chat:
            path = BASE_URL.appending("delete-chats")
        case .Continue_chats:
            path = BASE_URL.appending("continue-chats")
        case .Active_Inactive_chats:
            path = BASE_URL.appending("active-to-inactive")
            
        case .Remove_Match:
            path = BASE_URL.appending("remove-match")
            
        case .Audio_Video_Call_Notification:
            path = BASE_URL.appending("audio-video-calling")
            
        case .Rtm_Token_Generate:
            path = BASE_URL.appending("rtm-token-generate")
            
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
        case let .Delete_Chat(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .Continue_chats(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .Active_Inactive_chats(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .Remove_Match(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .Audio_Video_Call_Notification(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case  .Rtm_Token_Generate:
            resource = Resource(method: .get, parameters: nil, headers:headerDict)
        }
        return resource
    }
}
