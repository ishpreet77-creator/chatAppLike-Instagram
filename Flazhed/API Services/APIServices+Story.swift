//
//  APIServices+Story.swift
//  Flazhed
//
//  Created by IOS32 on 08/02/21.
//

import Foundation
import Foundation
enum APIServicesStories:APIService {
    
    case getStories(data: JSONDictionary)
    case storyDetails(data: JSONDictionary)
    case reportBlock(data: JSONDictionary)
    case deletePost(data: JSONDictionary)
    case likeStory(data: JSONDictionary)
    var path: String {
        var path = ""
        switch self {
        case .getStories:
            path = BASE_URL.appending("get-all-post")
        case .storyDetails:
            path = BASE_URL.appending("story-details")
        case .reportBlock:
            path = BASE_URL.appending("report-post")
        case .deletePost:
            path = BASE_URL.appending("delete-post-api")
        case .likeStory:
            path = BASE_URL.appending("story-like")
            }
        return path
     }
    
    var resource: Resource {
        var resource:Resource!
        let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
        case let .getStories(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .storyDetails(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        case let .reportBlock(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .deletePost(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
            
        case let .likeStory(data):
            resource = Resource(method: .post, parameters: data, headers:headerDict)
        }
        return resource
    }
}
