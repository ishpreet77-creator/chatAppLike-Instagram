//
//  ChatVM.swift
//  Flazhed
//
//  Created by IOS33 on 17/03/21.
//


import Foundation
import UIKit

class ChatVM {
    
    static var shared = ChatVM()
    var Pagination_Details:Pagination_Details_Model?
    var Match_Pagination_Details:Pagination_Details_Model?
    var lastPage = 0
    var page = 0
    var MatchUserDataArray:[MatchUserListModel] = []
    var chat_room_details_Array:[chat_room_details_Model] = []
    var chat_Room_Data:chat_room_Model?
    var chat_Room_Like_Data:Like_DisLike_Model?
    
    var allMessageToShow:[chat_room_details_Model] = []
    var Rtm_token = ""
    var is_come_from_story_hangout = 0
    var Audio_video_calling_data:audio_video_calling_Model?
    var Active_Chat_Count_data:Active_Chat_Count_Model?
    var Video_Call_Count_data:Video_Call_Count_Model?
    
    var chatArr: JSONArray = []
    var localChatArr: JSONArray = []
    
    private init(){}
    
    func callApiMatchesProfile(showIndiacter:Bool,data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiMatchProfile(showIndiacter:showIndiacter, data:data,successCallback: { (responseDict) in
        
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
    
    func callApiGetActiveChat(showIndiacter:Bool, data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiActiveChat(showIndiacter:showIndiacter, data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.chat_room_details_Array.removeAll()
            self.parseActiveChatData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiGetInActiveChat(showIndiacter:Bool, data: JSONDictionary, page: Int = 0, response: @escaping responseCallBack)
    {
        APIManager.callApiInActiveChat(showIndiacter:showIndiacter,data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.chat_room_details_Array.removeAll()
            self.parseActiveChatData(response:responseDict, page: page)
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
    
    
    func callApiDeleteChat(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiDeleteChat(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiContinueChat(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiContinueChat(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiActiveToInactiveChat(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiActiveToInActiveChat(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiRemoveMatch(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiRemoveMatch(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiAudioVideoCallNotification(ShowIndicator:Bool=true,data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiAudioVideoCallNotification(ShowIndicator:ShowIndicator,data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.parseAudioVideoCall(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApi_RTM_Token_Generate(showIndiacter:Bool=true, response: @escaping responseCallBack)
    {
        APIManager.callApi_RTM_Token_Generate(showIndiacter:showIndiacter, successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.parseRTMToken_Generate(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiSaveCallRecoard(showIndiacter:Bool,data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiSaveCallRecord(showIndiacter:showIndiacter,data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApi_Current_Active_Chat_Count(ShowIndicator:Bool=true,data: JSONDictionary,response: @escaping responseCallBack)
    {

        APIManager.callApi_Current_Active_Chat_Count(showIndiacter:ShowIndicator,data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.parseCurrentActiveChatCount(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }

    }
    
    
    func callApi_Current_Video_Call_Count(showIndiacter:Bool=true, response: @escaping responseCallBack)
    {
        APIManager.callApi_Current_Video_Call_Count(showIndiacter:showIndiacter, successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.parseCurrentVideoCallCount(response: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    
    
    
}
extension APIManager {
    //MARK: - call Api Match profile

    class func callApiMatchProfile(showIndiacter:Bool=true,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.getMatchesProfile(data: data).request(showIndiacter:showIndiacter, isJsonRequest: true,success: { (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
        
    }
    
    
    

    class func callApiCreateRoom(showIndiacter:Bool,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.createChat(data: data).request(showIndiacter:showIndiacter,isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiActiveChat(showIndiacter:Bool, data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.activeChat(data: data).request(showIndiacter:showIndiacter, isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
  
    
    class func callApiInActiveChat(showIndiacter:Bool,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.inActiveChat(data: data).request(showIndiacter: showIndiacter, isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiReportBlockUser(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Report_Block_user(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    class func callApiDeleteChat(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Delete_Chat(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiContinueChat(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Continue_chats(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiActiveToInActiveChat(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Active_Inactive_chats(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    class func callApiRemoveMatch(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Remove_Match(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiAudioVideoCallNotification(ShowIndicator:Bool=true,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Audio_Video_Call_Notification(data: data).request(showIndiacter: ShowIndicator, isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApi_RTM_Token_Generate(showIndiacter:Bool=true, successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Rtm_Token_Generate.request(showIndiacter:showIndiacter, isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    
    
    
    
    class func callApiSaveCallRecord(showIndiacter:Bool,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesChat.save_video_call_record(data: data).request(showIndiacter:showIndiacter,isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    
    class func callApi_Current_Active_Chat_Count(showIndiacter:Bool,data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Current_Chat_Count(data: data).request(showIndiacter:showIndiacter, isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApi_Current_Video_Call_Count(showIndiacter:Bool=true, successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback)
    {
        APIServicesChat.Current_Video_Call_Count.request(showIndiacter:showIndiacter, isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                debugPrint(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
}
//MARK: - Parsing the data
extension ChatVM {
    
    func parseGetMatchUserData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let profile = data[ApiKey.kMatched_profile] as? JSONArray
            {
                    for match in profile
                    {
                    let user = MatchUserListModel(detail: match)
                     self.MatchUserDataArray.append(user)
                    }
            }
    
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Match_Pagination_Details = details
            }
        }
    }
    
    
    func parseActiveChatData(response: JSONDictionary, page: Int = 0){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            if let profile = data[ApiKey.kChat_room_details] as? JSONArray
            {
                self.chatArr = profile
                for match in profile
                {
                    let user = chat_room_details_Model(detail: match)
                    self.chat_room_details_Array.append(user)
                }
//                DispatchQueue.global(qos: .background).async {
//                    self.localChatData(array: self.chatArr, page: page)
//                }
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
            if let is_come_from_story_hangout1 = data["is_come_from_story_hangout"] as? Int
            {
                
                self.is_come_from_story_hangout = is_come_from_story_hangout1
            }
            
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
            }
            if let like_data = data[ApiKey.kFindLikeDislike] as? JSONDictionary
            {
                let details = Like_DisLike_Model(detail: like_data)
                self.chat_Room_Like_Data = details
            }
            else
            {
                self.chat_Room_Like_Data =  nil
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
 
 
    func parseRTMToken_Generate(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            self.Rtm_token = data["rtm_token"] as? String ?? ""
        }
    }
    
    
       func parseAudioVideoCall(response: JSONDictionary){
           if let data = response[ApiKey.kData] as? JSONDictionary
           {
               let detail = audio_video_calling_Model(detail: data)
            self.Audio_video_calling_data = detail
           }
       }
    
    func localChatData(array: JSONArray, page: Int) {
        self.localChatArr.removeAll()
        for data in array {
            let LocalHangout = chat_room_details_Model.init(detail: data).json()
            self.localChatArr.append(LocalHangout)
        }
        self.parseLocalChatListData(page: page)
    }
    
    func parseLocalChatListData(page: Int) {
        DispatchQueue.background(background: {
            if page == 0 {
                CoreDataManager.deleteRecords(entityName: ApiKey.kChatData)
                CoreDataManager.saveChatListData(array: self.localChatArr)
            } else {
                CoreDataManager.appendChatListData(array: self.localChatArr)
            }
        }, completion: {
            self.localChatArr.removeAll()
        })
    }
    
    func parseCurrentActiveChatCount(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            if let data = data["find_record"] as? JSONDictionary
            {
            
            let detail = Active_Chat_Count_Model(detail: data)
         self.Active_Chat_Count_data = detail
            }
            else
            {
                self.Active_Chat_Count_data = nil
            }
        }
        else
        {
            self.Active_Chat_Count_data = nil
        }
    }
    
    
    func parseCurrentVideoCallCount(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
            if let data = data["find_record_b"] as? JSONDictionary
            {
            let detail = Video_Call_Count_Model(detail: data)
            self.Video_Call_Count_data = detail
            }
            else
            {
                self.Video_Call_Count_data = nil
            }
        }
        else
        {
            self.Video_Call_Count_data = nil
        }
        
        
       
    }
    
}
