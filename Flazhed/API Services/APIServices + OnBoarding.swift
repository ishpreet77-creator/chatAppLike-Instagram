//
//  APIServices + OnBoarding.swift
//  Flazhed
//
//  Created by IOS22 on 18/01/21.
//

import Foundation
import Foundation

enum OnBoardingApiServices:APIService {
   
    case SocialLogin(data: JSONDictionary)
    case sendOTP(data: JSONDictionary)
    case verifyOTP(data: JSONDictionary)
    case CompleteProfile(data: JSONDictionary)
    var path: String {
        var path = ""
        switch self {
        case .SocialLogin:
            path = BASE_URL.appending("social-login")
        case .sendOTP:
            path = BASE_URL.appending("send-otp")
        case .verifyOTP:
            path = BASE_URL.appending("verify-otp")
        case .CompleteProfile:
            path = BASE_URL.appending("complete-profile")
        
        }
        return path
    }
    var resource: Resource {
        
        var resource: Resource!
         let headerDict = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        switch self {
        case let .SocialLogin(data):
            resource = Resource(method: .post, parameters: data, headers:[kContentType: kApplicationJson])
        
        case let .sendOTP(data):
            resource = Resource(method: .post, parameters: data, headers:[kContentType: kApplicationJson])
        case let .verifyOTP(data):
            resource = Resource(method: .post, parameters: data, headers:[kContentType: kApplicationJson])
        case let .CompleteProfile(data):

            resource = Resource(method: .post, parameters: data, headers: headerDict)

        }
       return resource
    }
    
    
}
