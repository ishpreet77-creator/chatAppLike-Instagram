//
//  ChatVM.swift
//  Flazhed
//
//  Created by IOS33 on 17/03/21.
//


import Foundation

class ChatVM {
    
    static var shared = ChatVM()
    var Pagination_Details:Pagination_Details_Model?
    var lastPage = 0
    var page = 0
    var MatchUserDataArray:[UserListModel] = []
    var chat_room_details_Array:[chat_room_details_Model] = []
    var chat_Room_Data:chat_room_Model?
    var allMessageToShow:[chat_room_details_Model] = []
    
    private init(){}

    
    
    func callApiMatchesProfile(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiMatchProfile(data:data,successCallback: { (responseDict) in
        
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.MatchUserDataArray.removeAll()
           self.parseGetMatchUserData(response:responseDict)
            
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiCreateRoom(showIndiacter:Bool,data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiCreateRoom(showIndiacter:showIndiacter,data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.allMessageToShow.removeAll()
            self.parseCreateRoom(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiGetActiveChat(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiActiveChat(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.chat_room_details_Array.removeAll()
            self.parseActiveChatData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiGetInActiveChat(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiInActiveChat(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.chat_room_details_Array.removeAll()
            self.parseActiveChatData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiReportBlockUser(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiReportBlockUser(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.chat_room_details_Array.removeAll()
            self.parseActiveChatData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
extension APIManager {
    
    
    
    //MARK:- call Api Match profile

    class func callApiMatchProfile(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.getMatchesProfile(data: data).request(isJsonRequest: true,success: { (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    
    

    class func callApiCreateRoom(showIndiacter:Bool,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.createChat(data: data).request(showIndiacter:showIndiacter,isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiActiveChat(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.activeChat(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
  
    
    class func callApiInActiveChat(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.inActiveChat(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiReportBlockUser(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.Report_Block_user(data: data).request(isJsonRequest: true,success:{ (response) in
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
extension ChatVM {
    
    func parseGetMatchUserData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let profile = data[ApiKey.kMatched_profile] as? JSONArray
            {
                    for match in profile
                    {
                    let user = UserListModel(detail: match)
                     self.MatchUserDataArray.append(user)
                    }
            }
    
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
            }
        }
    }
    
    
    func parseActiveChatData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let profile = data[ApiKey.kChat_room_details] as? JSONArray
            {
                    for match in profile
                    {
                    let user = chat_room_details_Model(detail: match)
                     self.chat_room_details_Array.append(user)
                    }
            }
    
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
            }
        }
    }
    
    
    func parseCreateRoom(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
            }
            if let Chat_room = data[ApiKey.kChat_room] as? JSONDictionary
            {
                let details = chat_room_Model(detail: Chat_room)
                self.chat_Room_Data = details
            }
            if let Chat_details = data[ApiKey.kChat_details] as? JSONArray
            {
                for dict in Chat_details
                {
                let details = chat_room_details_Model(detail: dict)
                self.allMessageToShow.append(details)
                }
            }
            
            
            
        }
    }
 
 
}
