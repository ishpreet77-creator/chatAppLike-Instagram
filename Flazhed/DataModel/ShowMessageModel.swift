//
//  ShowMessageModel.swift
//  Flazhed
//
//  Created by IOS33 on 30/03/21.
//

import Foundation
import GiphyUISDK


struct AllMessageModel
{
    //var type:MessageType?
    var _id:String?
    var messageText:String?
    var messageTime:String?
    var to_user_id:String?
    var media:GPHMedia?
    var messageType:String = kMessageType
    
    var item_title:String?
    var item_image:String?
    var item_id:String?
}






struct ShowMessageModel
{
    var type:MessageType?
    var messageText:String?
    var messageTime:String?
    var to_user_id:String?
    var headerAllMessage:[ShowMessageModel]?
}

//Main Collection Model
enum MessageType:String{
    
    case Match = "Match"
    case AudioCall = "AudioCall"
    case VideoCall = "VideoCall"
    case Today = "Today"
    case Yesterday = "Yesterday"
    case OtherDay = "OtherDay"
}
