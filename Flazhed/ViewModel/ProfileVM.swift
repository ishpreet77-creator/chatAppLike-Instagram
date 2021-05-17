//
//  ProfileVM.swift
//  Flazhed
//
//  Created by IOS22 on 21/01/21.
//

import Foundation
class ProfileVM {
    
    static var shared = ProfileVM()
    private init(){}
    
var viewProfileData = getUserDetail(detail: JSONDictionary())
    
    var ProfileDataArray =  [getUserDetail]()
    var ProfileData = JSONDictionary()
    var PreferenceData = JSONDictionary()
    var ChildrensData = JSONArray()
    var EducationsData = JSONArray()
    var HairsData = Array<hairsDataModel>()
    var viewProfileUserDetail:UserListModel?
    var childrenDataArray:[childrensDataModel] = []
    var educationDataArray:[educationsDataModel] = []
    var hairsDataArray:[hairsDataModel] = []
    
    func callApiViewProfile(response: @escaping responseCallBack)
    {
        APIManager.callApiViewProfile(successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
            self.childrenDataArray.removeAll()
            self.hairsDataArray.removeAll()
            self.educationDataArray.removeAll()
            
           self.parseGetUserData(response:responseDict)
            
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiSetPreference(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiSetPreference(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiGetPreference(response: @escaping responseCallBack)
    {
        APIManager.callApiGetPreference(successCallback: { (responseDict) in
          
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
           self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiLogout(response: @escaping responseCallBack)
    {
        APIManager.callApiLogout(successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
        
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiDeleteAccount(response: @escaping responseCallBack)
    {
        APIManager.callApiDeleteAccount(successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
        
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiUpdateFacebookData(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiUpdateFacebookData(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiUpdateInstaData(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiUpdateInstaData(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    
    func callApiDeleteImage(imageId:String,response: @escaping responseCallBack)
    {
        APIManager.callApiDeleteImage(imageId: imageId,successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
        
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
extension APIManager {
    
    
    //MARK:- call Api View Profile

    class func callApiViewProfile(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.getuserProfile.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    
    
    //MARK:- call Api set preference

    class func callApiSetPreference(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.setPreference(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
     
    
    //MARK:- call Api get preference

    class func callApiGetPreference(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.getPreference.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    
    
    class func callApiLogout(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.logout.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    class func callApiDeleteAccount(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.deleteAccount.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    //MARK:- call Api update facebook data

    class func callApiUpdateFacebookData(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.updateFacebookData(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiUpdateInstaData(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.updateInstaData(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiDeleteImage(imageId:String,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesProfile.deleteImage(imageId: imageId).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
}


//MARK:- Parsing the data
extension ProfileVM {
    
    func parseGetUserData(response: JSONDictionary){
 
            if let data = response[ApiKey.kData] as? JSONDictionary
            {
                
                if let users = data[ApiKey.kUser] as? JSONDictionary
                {
                    let user = UserListModel(detail: users)
                    self.viewProfileUserDetail = user
                }
                if let childrens = data[ApiKey.kchildrens] as? JSONArray
                {
                    for child in childrens
                    {
                        let children1 = childrensDataModel(detail: child)
                        if children1.children_name?.uppercased() != kNotImportant.uppercased()
                        {
                            self.childrenDataArray.append(children1)
                        }
                        
                    
                       
                    }
                }
                if let educations = data[ApiKey.keducations] as? JSONArray
                {
                    for education in educations
                    {
                        let education1 = educationsDataModel(detail: education)
                        if education1.education_name?.uppercased() != kNotImportant.uppercased()
                        {
                            self.educationDataArray.append(education1)
                        }
                    
                    }
                }
                if let hairs = data[ApiKey.khairs] as? JSONArray
                {
                    for hair in hairs
                    {
                    let hair1 = hairsDataModel(detail: hair)
                        if hair1.hair_name?.uppercased() != kNotImportant.uppercased()
                        {
                        self.hairsDataArray.append(hair1)
                        }
                    }
                }
                

            }
        
    }
    
    
    
    func parseGetPreferenceData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
          
            if let User = data[ApiKey.kPreference] as? JSONDictionary
            {
                PreferenceData = User
            }
            if let childrens = data[ApiKey.kchildrens] as? JSONArray
            {
                ChildrensData = childrens
            }
            if let educations = data[ApiKey.keducations] as? JSONArray
            {
                EducationsData = educations
            }
            if let hairs = data[ApiKey.khairs] as? JSONArray
            {
                HairsData.removeAll()
                for dict in hairs{
                    HairsData.append(hairsDataModel.init(detail: dict))
                }
            }
        }
    }

  
}

