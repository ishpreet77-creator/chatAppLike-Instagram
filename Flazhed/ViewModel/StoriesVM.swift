//
//  StoriesVM.swift
//  Flazhed
//
//  Created by IOS32 on 08/02/21.
//

import Foundation
import Alamofire

class StoriesVM {
    
    static var shared = StoriesVM()
    var StoriesPostData:[StoriesPostDataModel] = []
    
    var notificationSetupData:NotificationSetupModel?
    var Pagination_Details:Pagination_Details_Model?
    var singleStory:SinglePostDataModel?
    
    var page = 0
    
    private init(){}

    func callApiGetStories(showIndiacter:Bool, data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiGetStories(showIndiacter:showIndiacter, data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
            self.StoriesPostData.removeAll()
            
         
           self.parseGetStoriesData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiReportBlock(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiReportBlock(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }

    
    func callApiDeletePost(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiDeletePost(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
            self.StoriesPostData.removeAll()
         
           self.parseGetStoriesData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiLikeStory(showIndiacter:Bool, data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiLikeStory(showIndiacter:showIndiacter, data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
            self.StoriesPostData.removeAll()
            
         
           self.parseGetStoriesData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiGetStoryDetail(showIndiacter:Bool, data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiSingleStory(showIndiacter:showIndiacter, data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
        
           self.parseGetSingleStory(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
extension APIManager {

    //MARK:- call Api get stories

    class func callApiGetStories(showIndiacter:Bool=true,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesStories.getStories(data: data).request(showIndiacter: showIndiacter,isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiReportBlock(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesStories.reportBlock(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
  
    class func callApiDeletePost(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesStories.deletePost(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiLikeStory(showIndiacter:Bool=true,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesStories.likeStory(data: data).request(showIndiacter: showIndiacter,isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiSingleStory(showIndiacter:Bool=true,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesStories.storyDetails(data: data).request(showIndiacter: showIndiacter,isJsonRequest: true,success:{ (response) in
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
extension StoriesVM {
    
    func parseGetStoriesData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let Post_listing = data[ApiKey.kPost_listing] as? JSONDictionary
            {
                if let posts = Post_listing[ApiKey.kPosts] as? JSONArray
                {
                    for post in posts
                    {
                    let post = StoriesPostDataModel(detail: post)
                    self.StoriesPostData.append(post)
                    }
     
              }
                
                if let Pagination_details = Post_listing[ApiKey.kPagination_details] as? JSONDictionary
                {
                    
                    let details = Pagination_Details_Model(detail: Pagination_details)
                    self.Pagination_Details = details
                    
     
                }
            }
        }
    }
    
    func parseGetSingleStory(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
       let detail = SinglePostDataModel(detail: data)
            self.singleStory=detail
    
        }
    }

}
