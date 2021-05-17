//
//  AuthViewModel.swift
//  Flazhed
//
//  Created by IOS22 on 18/01/21.
//

import Foundation
class OnBoardingVM {
    
    static var shared = OnBoardingVM()
    private init(){}
    
    var sendOTPData = JSONDictionary()
    var verifyOtpData = JSONDictionary()
    var LoginUserData = JSONDictionary()
    var UserProfileData = JSONDictionary()
   
    var socialDetails = JSONDictionary()  //email,name,Image
    var loginUserDetail:getUserDetail?
    
    func callApiSocialLoginAPI(data: JSONDictionary,  response: @escaping responseCallBack)
    {
        APIManager.callApiSocialLogin(data:data, successCallback: { (responseDict) in
            print(responseDict)
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           self.parseUserLoginData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiForSendOTPAPI(data: JSONDictionary,  response: @escaping responseCallBack)
    {
        APIManager.callApiSendOTP(data:data, successCallback: { (responseDict) in
            print(responseDict)
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           self.parseSendOTPData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiForVerifyOTPAPI(data: JSONDictionary,  response: @escaping responseCallBack)
    {
       
        APIManager.callApiverifyOTP(data:data, successCallback: { (responseDict) in
            print(responseDict)
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           self.parseVerifyOTPData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
 
    func callApiForCompleteProfile(data: JSONDictionary,mediaArray: [Data]?,  response: @escaping responseCallBack)
    {
       
        APIManager.callApiCompleteProfile(data: data, imageDict: mediaArray, successCallback: { (responseDict) in
            print(responseDict)
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           //self.parseSendOTPData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
}
extension APIManager {
    
    
    //MARK:- call Api Social Login Facebook, google,apple
    
    class func callApiSocialLogin(data: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        OnBoardingApiServices.SocialLogin(data: data).request(isJsonRequest: true,success: { (response) in
            
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
                print(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    //MARK:- call Api Send OTP
    
    class func callApiSendOTP(data: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        OnBoardingApiServices.sendOTP(data: data).request(isJsonRequest: true,success: { (response) in
            
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
                print(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    //MARK:- call Api verify OTP
   
    class func callApiverifyOTP(data: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        OnBoardingApiServices.verifyOTP(data: data).request(isJsonRequest: true,success: { (response) in
            
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
                print(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    //MARK:- call Api Complete Profile
    
    class func callApiCompleteProfile(data: JSONDictionary,imageDict:[Data]?,  successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        OnBoardingApiServices.CompleteProfile(data: data).request(mediaArray: imageDict,mediaName: "images", success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
}


//MARK:- Parsing the data


extension OnBoardingVM {
    
    func parseUserLoginData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            print(data)
            if let User = data[ApiKey.kUser] as? JSONDictionary
            {
             //   LoginUserData=User
                let detail=getUserDetail(detail: User)
               self.loginUserDetail=detail
                
            }
        }
    }
    
    
    func parseSendOTPData(response: JSONDictionary){
        if let data = response[ApiKey.kOTPDATA] as? JSONDictionary
        {
            print(data)
         
             sendOTPData=data
            
        }
    }
    
    func parseVerifyOTPData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            print(data)
            if let kOTPDATA = data[ApiKey.kUser] as? JSONDictionary
            {
               // verifyOtpData=kOTPDATA
                let detail=getUserDetail(detail: kOTPDATA)
               self.loginUserDetail=detail
            }
        }
    }
    
    func parseUpdateProfileData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            print(data)
            if let kOTPDATA = data[ApiKey.kUser] as? JSONDictionary
            {
                UserProfileData=kOTPDATA
             
            }
        }
    }
    
}
