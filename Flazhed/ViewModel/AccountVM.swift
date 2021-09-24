//
//  AccountVM.swift
//  Flazhed
//
//  Created by IOS32 on 05/02/21.
//

import Foundation
import Alamofire

class AccountVM {
    
    static var shared = AccountVM()
    var unitData:[UnitDataModel] = []
    
    var notificationSetupData:NotificationSetupModel?
    
    private init(){}
    var Prolong_Subsription_Data:SubscriptionModel?
    var Swiping_Subsription_Data:SubscriptionModel?
    var Shake_Subsription_Data:SubscriptionModel?
    

    func callApiUpdateMobile(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiUpdateMobile(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiGetUnit(response: @escaping responseCallBack)
    {
        APIManager.callApiGetUnit(successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.unitData.removeAll()
           self.parseGetUnitData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiUpdateUnit(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiUpdateUnit(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    
    func callApiGetNotificationSetup(response: @escaping responseCallBack)
    {
        APIManager.callApiGetNotificationSetup(successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
             self.parseNotiSetupData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiUpdateNotificationSetup(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiUpdateNotiSetup(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiUpdatePayment(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiPayment(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
          // self.parseGetPreferenceData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiGetMySubscription(response: @escaping responseCallBack)
    {
        APIManager.callApiGetMySubscription(successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            
            self.parseMySubsription(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
}
extension APIManager {

    //MARK:- call Api Update Mobile

    class func callApiUpdateMobile(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.updateMobile(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    //MARK:- call Api get unit

    class func callApiGetUnit(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.getUnit.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    //MARK:- call Api Update Mobile

    class func callApiUpdateUnit(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.updateUnit(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiGetNotificationSetup(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.getNotificationSetup.request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
}
    
    //MARK:- call Api Update notification setup

    class func callApiUpdateNotiSetup(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.updateNotificationSetup(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    
    class func callApiPayment(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.updatePayment(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiGetMySubscription(successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesAccount.get_my_subscription.request(isJsonRequest: true,success:{ (response) in
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
extension AccountVM {
    

    
    func parseGetUnitData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let units = data[ApiKey.kUnit] as? JSONDictionary
            {
               let unit = UnitDataModel(detail: units)
                self.unitData.append(unit)
     
            }
        }
    }
    
    func parseNotiSetupData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {

            if let settings = data[ApiKey.kNotification_settings] as? JSONDictionary
            {
               let setting = NotificationSetupModel(detail: settings)
                self.notificationSetupData=setting
     
            }
        }
    }
  
    func parseMySubsription(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
          
            if let User = data[ApiKey.kParlong] as? JSONDictionary
            {
                let data =  SubscriptionModel(detail: User)
                self.Prolong_Subsription_Data = data
            }
            else
            {
                self.Prolong_Subsription_Data = nil
            }
            if let User = data[ApiKey.kShake] as? JSONDictionary
            {
                let data =  SubscriptionModel(detail: User)
                self.Shake_Subsription_Data = data
            }
            else
            {
                self.Shake_Subsription_Data = nil
            }
            if let User = data[ApiKey.kSwiping] as? JSONDictionary
            {
                let data =  SubscriptionModel(detail: User)
                self.Swiping_Subsription_Data = data
            }
            else
            {
                self.Swiping_Subsription_Data = nil
            }
        }
    }
}

extension APIManager
{
    
    static func callApiForAudioFileUpload(image : [Data], data: JSONDictionary,AudioData:Data,audiParaName:String,imageParaName:String,api:String,imageDrag:Bool,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        Indicator.sharedInstance.showIndicator()
            
            let urlString =  BASE_URL.appending(api)
            
            let headers: HTTPHeaders = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in data {
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
                        
                        if let temp = value as? Int {
                            multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                            
                        }
                        
                        if let temp = value as? NSArray
                        {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                if let string = element as? String {
                                    multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "(num)"
                                    multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    if  !AudioData.isEmpty
                    {
                        //voice.mp3
                        multipartFormData.append(AudioData, withName: audiParaName, fileName: "voice.mp3", mimeType: "mp3/mpeg/mppeg-4")
                    }
                    if imageDrag
                    {
                        print("image drag = \(imageDrag)")
                    for img in image
                    {
                        multipartFormData.append(img, withName: imageParaName, fileName: "images.png", mimeType: "jpeg/jpg/png")
                    }
                    }
                    
                },
                to: urlString, //URL Here
                method: .post,
                headers: headers)
                .responseJSON { (resp) in
                    
                    print("resp is \(resp)")
                    Indicator.sharedInstance.hideIndicator()
                    if let responseDict = resp.value as? JSONDictionary {
                        print(responseDict)
                        successCallback(responseDict)
                        
                    }
                    
                }
     
    }
    
    static func callApiForMultiImages(image1 : Data,image2 : Data, data: JSONDictionary,imageParaName1:String,imageParaName2:String,api:String,fileType:String,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)

//    static func callApiForMultiImages(image1 : Data, data: JSONDictionary,imageParaName1:String,api:String,fileType:String,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        Indicator.sharedInstance.showIndicator()
            
            let urlString =  BASE_URL.appending(api)
            
            let headers: HTTPHeaders = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in data {
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
                        
                        if let temp = value as? Int {
                            multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                            
                        }
                        
                        if let temp = value as? NSArray
                        {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                if let string = element as? String {
                                    multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "(num)"
                                    multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    if fileType.equalsIgnoreCase(string: kVideo)//.lowercased() == kVideo.lowercased()
                    {
                    if  !image1.isEmpty
                    {
                        multipartFormData.append(image1, withName: imageParaName1, fileName: "video.mp4", mimeType: "mp4/mov")
                        multipartFormData.append(image2, withName: imageParaName2, fileName: "thimbnail.png", mimeType: "jpeg/jpg/png")
                    }
                    }
                    else
                    {
                        multipartFormData.append(image1, withName: imageParaName1, fileName: "images.png", mimeType: "jpeg/jpg/png")
                    }

                    
                },
                to: urlString, //URL Here
                method: .post,
                headers: headers)
                .responseJSON { (resp) in
                
                    print("resp is \(resp)")
                    Indicator.sharedInstance.hideIndicator()
                    if let responseDict = resp.value as? JSONDictionary {
                        print(responseDict)
                        successCallback(responseDict)
                        
                    }
                    
                }
    }
    
    
    static func callApiForImage(image1 : Data,imageParaName1:String,api:String,data: JSONDictionary=[:],successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)

    {
        Indicator.sharedInstance.showIndicator()
            
            let urlString =  BASE_URL.appending(api)
            
            let headers: HTTPHeaders = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
            
            AF.upload(
                multipartFormData: { multipartFormData in
                  
                    for (key, value) in data {
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
                        
                        if let temp = value as? Int {
                            multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                            
                        }
                        
                        if let temp = value as? NSArray
                        {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                if let string = element as? String {
                                    multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "(num)"
                                    multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    
                        multipartFormData.append(image1, withName: imageParaName1, fileName: "images.png", mimeType: "jpeg/jpg/png")
            
                },
                to: urlString, //URL Here
                method: .post,
                headers: headers)
                .responseJSON { (resp) in
                    
                    print("resp is \(resp)")
                    Indicator.sharedInstance.hideIndicator()
                    if let responseDict = resp.value as? JSONDictionary {
                        print(responseDict)
                        successCallback(responseDict)
                        
                    }
                    
                }
    }
    
    //"C8pyfycWsTdpacSL8Jim"
    //api_user=1557187836&api_secret=XvUAjDfXERiFWxtUmzC4

    
    //["models":"nudity,wad,offensive","api_user":"1557187836","api_secret":"XvUAjDfXERiFWxtUmzC4"]
    
   // ["models":"nudity,wad,offensive","api_user":"134393085","api_secret":"C8pyfycWsTdpacSL8Jim"]
    
    
   // 'api_user=740176015' \
    //    -F 'api_secret=R7aZqxLGaHNzbxyScbn4' \
    
    
    //-F 'api_user=1966040274' \
   // -F 'api_secret=3gVAco2pTUC25gH5AR7k' \
    
    //["models":"nudity,wad,offensive","api_user":"1966040274","api_secret":"3gVAco2pTUC25gH5AR7k"]
    
    static func callApiForImageCheck(image1 : Data,imageParaName1:String,api:String,data: JSONDictionary=["models":"nudity,wad,offensive","api_user":"134393085","api_secret":"C8pyfycWsTdpacSL8Jim"],successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)

    {
        //Indicator.sharedInstance.showIndicator()
            
            let urlString =  "https://api.sightengine.com/1.0/check.json"//BASE_URL.appending("https://api.sightengine.com/1.0/check.json")
            
           // let headers: HTTPHeaders = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
            
            AF.upload(
                multipartFormData: { multipartFormData in
                  
                    for (key, value) in data {
                        if let temp = value as? String {
                            multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                            
                        }
                        
                        if let temp = value as? Int {
                            multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                            
                        }
                        
                        if let temp = value as? NSArray
                        {
                            temp.forEach({ element in
                                let keyObj = key + "[]"
                                if let string = element as? String {
                                    multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "(num)"
                                    multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    
                        multipartFormData.append(image1, withName: imageParaName1, fileName: "images.png", mimeType: "jpeg/jpg/png")
            
                },
                to: urlString, //URL Here
                method: .post,
                headers: nil)
                .responseJSON { (resp) in
                    
                    print("resp is \(resp)")
                    Indicator.sharedInstance.hideIndicator()
                    
                    if let responseDict = resp.value as? JSONDictionary {
                        print(responseDict)
                        
                        successCallback(responseDict)
                        
                    }
                    else
                    {
                        successCallback([:])
                    }
                    
                }
    }
    
   
    
    
}
