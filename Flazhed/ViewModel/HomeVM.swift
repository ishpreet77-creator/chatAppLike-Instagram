//
//  HomeVM.swift
//  Flazhed
//
//  Created by IOS22 on 25/01/21.
//

import Foundation

class HomeVM {
    
    static var shared = HomeVM()
    private init(){}
    
    var ShakeData = JSONDictionary()
    var ShakeUserDataArray:[UserListModel] = []

    var viewProfileUserDetail:UserListModel?
    
    var AnonymousUserDataArray:[UserListModel] = []
    
    var Pagination_Details:Pagination_Details_Model?
    
    //MARK:- call Api Shake sent

    func callApiShakeSent(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiShakeSent(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    //MARK:- call Api Home sent

    func callApiGetShakeUser(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiShakeSentUser(data:data,successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
            if self.ShakeUserDataArray.count>0
            {
                self.ShakeUserDataArray.removeAll()
            }
           self.parseShakeUserData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    //MARK:- call Api Like Unlike

    func callApiForLikeUnlikeUser(showIndiacter:Bool=true,data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiForLikeUnlikeUser(showIndiacter:showIndiacter,data:data,successCallback: { (responseDict) in
     
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseShakeUserData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    
    //MARK:- call Api ano sent

    func callApiGetAnonymousUser(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiForAnonymousUser(data:data,successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            if self.AnonymousUserDataArray.count>0
            {
                self.AnonymousUserDataArray.removeAll()
            }
           self.parseAnonymousUserData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    //MARK:- call Api Get User Details

    func callApiGetUserDetails(data: String,response: @escaping responseCallBack)
    {
        APIManager.callApiForUserDetails(data:data,successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           
            self.parseUserDetails(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
}
//MARK:- Parsing the data
extension HomeVM {
    
    func parseShakeData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
          
            if let User = data[ApiKey.kUser] as? JSONDictionary
            {
   
                ShakeData = User

            }
        }
    }
    
    //MARK:- parse shake user
    
    func parseShakeUserData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            
            if let shake_list = data["shake_list"] as? JSONArray
            {
            for dict in shake_list
            {
                let user = UserListModel(detail: dict)
                self.ShakeUserDataArray.append(user)
            }
            }
            
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
                
            }
            print("self.ShakeUserDataArray? = \(self.ShakeUserDataArray)")
        }
    }
    
    //MARK:- parse ano user
    
    func parseAnonymousUserData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            
            if let anonymous_list = data["anonymous_list"] as? JSONArray
            {
            for dict in anonymous_list
            {
                let user = UserListModel(detail: dict)
                

                self.AnonymousUserDataArray.append(user)
            }
            }
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
                
            }
            print("self.AnonymousUserDataArray? = \(self.AnonymousUserDataArray.count)")
        }
    }
    
    //MARK:- parse ano user
    
    func parseUserDetails(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
                let user = UserListModel(detail: data)
                self.viewProfileUserDetail = user
        }
    }
    
    
}
extension APIManager {
    
    
    //MARK:- call Api View Profile


    
   class func callApiShakeSent(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
       APIServicesHome.ShakeSent(data: data).request(isJsonRequest: true,success:{ (response) in
           if let responseDict = response as? JSONDictionary {
            print(responseDict)
               successCallback(responseDict)
           } else {
               successCallback([:])
           }
       }, failure: failureCallback)
   }
    
    
    class func callApiShakeSentUser(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHome.ShakeSentUser(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }

    class func callApiForLikeUnlikeUser(showIndiacter:Bool=true,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHome.likeUnlikeUser(data: data).request(showIndiacter:showIndiacter,isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiForAnonymousUser(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHome.AnonymousUser(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }

    
    class func callApiForUserDetails(data: String,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHome.getUserDetails(userId: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}
