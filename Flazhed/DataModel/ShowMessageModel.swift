//
//  ShowMessageModel.swift
//  Flazhed
//
//  Created by IOS33 on 30/03/21.
//

import Foundation


struct AllMessageModel
{
    //var type:MessageType?
    var messageText:String?
    var messageTime:String?
    var to_user_id:String?

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
