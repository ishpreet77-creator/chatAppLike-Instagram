//
//  ChatDM.swift
//  Flazhed
//
//  Created by IOS33 on 17/03/21.
//

import Foundation

struct chat_room_details_Model {
    
    var _id:String?
    var deletedAt:String?
    var first_user_id:String?
    var is_open_by_first_user_id:Int?
    var is_open_by_second_user_id:Int?
    var is_read_by_self:Int?
 
    var last_message:String?
    var other_user_details:other_user_details_Model?
    var second_user_id:String?
    
    var chat_room_id:String?
    var chat_time:String?
    var chatDate:Date?
    var message:String?
    var to_user_id:String?
    
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.first_user_id = detail["first_user_id"] as? String
        self.is_open_by_first_user_id = detail["is_open_by_first_user_id"] as? Int
        self.is_open_by_second_user_id = detail["is_open_by_second_user_id"] as? Int
        self.is_open_by_second_user_id = detail["is_read_by_self"] as? Int
        
        self.other_user_details = other_user_details_Model.init(detail: (detail["other_user_details"] as? JSONDictionary) ?? [:])
        self.second_user_id = detail["second_user_id"] as? String
        self.last_message = detail["last_message"] as? String
        self.chat_room_id = detail["chat_room_ids"] as? String
        self.chat_time = detail["chat_time"] as? String
        
        self.chatDate = (detail["chat_time"] as? String)?.dateFromString2(format: .NewISO) ?? Date()
        
        self.message = detail["message"] as? String
        self.to_user_id = detail["to_user_id"] as? String
        
    }
}
struct other_user_details_Model {
    
    var _id:String?
    var authToken:String?
    var country_code:String?
    
    var is_block:Int?
    var is_block_by_admin_by_report:Int?
    var is_shake_count:Int?
    var more_profile_details:MoreProfileDataModel?
    var phone_number:String?
    var profile_data:profileModel?
    
    var report_count:Int?
    var social_id:String?
    var social_type:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.authToken = detail["authToken"] as? String
        self.country_code = detail["country_code"] as? String
        self.is_block = detail["is_block"] as? Int
        
        self.is_block_by_admin_by_report = detail["is_block_by_admin_by_report"] as? Int
        self.is_shake_count = detail["is_shake_count"] as? Int
        
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        
        self.phone_number = detail["phone_number"] as? String
        
        self.profile_data = profileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        
        self.report_count = detail["report_count"] as? Int
        self.social_id = detail["social_id"] as? String
        self.social_type = detail["social_type"] as? String
    }
}




struct Socket_Chat_Model {
    
    var chat_room_id:String?
    var from_user_id:String?
    var message:String?
    var timezone:String?
    var to_user_id:String?
    var messageTime:String?
    
    var other_user_details:other_user_details_Model?
    var second_user_id:String?
    
    init(detail:JSONDictionary) {
        self.chat_room_id = detail["chat_room_id"] as? String
        self.from_user_id = detail["from_user_id"] as? String
        self.message = detail["message"] as? String
        self.timezone = detail["timezone"] as? String
        self.to_user_id = detail["to_user_id"] as? String
        self.messageTime = detail["messageTime"] as? String
    }
}
struct chat_room_Model {

        
        var _id:String?
        var is_open_by_first_user_id:String?
        var is_open_by_second_user_id:String?
        var is_like_by_second_user_id:Int?
        var is_match:Int?
        var like_mode:String?
        var second_user_id:String?
         var first_user_id:String?
       var from_user_id:String?
    
        init(detail:JSONDictionary) {
            self._id = detail["_id"] as? String
            self.is_open_by_first_user_id = detail["is_open_by_first_user_id"] as? String
            self.is_open_by_second_user_id = detail["is_open_by_second_user_id"] as? String
            self.first_user_id = detail["first_user_id"] as? String
            self.second_user_id = detail["second_user_id"] as? String
            self.from_user_id = detail["self_user_id"] as? String
}
}

