//
//  ChatDM.swift
//  Flazhed
//
//  Created by IOS33 on 17/03/21.
//

import Foundation


struct MatchUserListModel {
    var profile_data:OnlyImageNameProfileModel?
    
    //var second_table_like_dislike:SecondTableLikeDislikeModel?
    
   // var like_dislike:String?
   // var like_mode_by_other_user:String?
   // var like_mode_by_self:String?
    
  //  var more_profile_details:MoreProfileDataModel?
    var user_id:String?
    var is_liked_by_other_user_id:Int?
    
    var is_liked_by_self_user:Int?
    //var is_liked_by_other_user_id:Int?
  //  var phone_number:Int?
  //  var country_code:String?
  //  var social_id:String?
   // var social_type:String?
   // var email:String?
   // var is_block:Int?
    var enable_red_dot:Int?
  //  var device_type:String?
  //  var device_token:String?
   // var is_shake_count:Int?
  //  var post_details:[PostdetailModel]?
  //  var hangout_details:[HangoutDataModel]?
  //  var unit_settings:unitDataModel?
    
    //var facebook_data:FacebookDataModel?

   // var Insta_data:InstaDataModel?
    
    //var Single_Hangout_Details:HangoutDataModel?
   // var Single_Story_Details:PostdetailModel?
    
    var like_dislikeData:Like_DisLike_Model?
    //var arrAllPostCollection:[AllPostModel]!
   // var story_like_by_self:Int?
    //var hangout_like_by_self:Int?
    
    var response_other_user:Int?
    var response_self_user:Int?
    var continue_chat_status_other_user:Int?
    var is_read_by_second_user:Int?
    var is_continue_from_user:Int?
    var is_continue_to_user:Int?
    var self_send_message:Int?
    var prolong_subscription_is_active:Int?
    var continue_chat_status:Int?
    
    init(detail:JSONDictionary) {
        self.profile_data = OnlyImageNameProfileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
  
        self.user_id = detail["user_id"] as? String
        self.enable_red_dot = detail["enable_red_dot"] as? Int
        
        //MARK: - for match
        self.response_other_user = detail["response_other_user"] as? Int
        self.response_self_user = detail["response_self_user"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
        self.is_read_by_second_user = detail["is_read_by_second_user"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
        self.is_continue_from_user = detail["is_continue_from_user"] as? Int
        self.is_continue_to_user = detail["is_continue_to_user"] as? Int
        self.self_send_message = detail["self_send_message"] as? Int
        self.prolong_subscription_is_active = detail["prolong_subscription_is_active"] as? Int
        self.continue_chat_status = detail["continue_chat_status"] as? Int

        self.like_dislikeData = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
   
    }
    
}




struct chat_room_details_Model {
    
    var _id:String?
    var deletedAt:String?
    var first_user_id:String?
    var is_open_by_first_user_id:Int?
    var is_open_by_second_user_id:Int?
    var is_read_by_self:Int?
    var continue_chat_status:Int?
    var is_come_from_story_hangout:Int?
    var last_message_time:String?
    var last_message:String?
    var last_message_sender_user_id:String?
    var have_parlong:Int?
    
    
    var other_user_details:other_user_details_Model?
    var second_user_id:String?
    var like_dislike:Like_DisLike_Model?
    var chat_room_id:String?
    var chat_time:String?
    var chatDate:Date?
    var message:String?
    var file_type:String?
    var message_type:String?
    var last_message_type:String?
    
    
    var to_user_id:String?
    var last_message_file_type:String?
    
    var unread_count:Int?
    var is_read_by_second_user:Int?
    var response_other_user:Int?
    var self_send_message:Int?
    var continue_chat_status_other_user:Int?
    
    var item_title:String?
    var item_image:String?
    var item_id:String?
    var is_continue_from_user:Int?
    var is_continue_to_user:Int?
    
    var username:String?
    var image:String?
    var imageData:Data?
    
    init(detail:JSONDictionary) {
        
        self.have_parlong = detail["have_parlong"] as? Int
        self.is_continue_to_user = detail["is_continue_to_user"] as? Int
        self.is_continue_from_user = detail["is_continue_from_user"] as? Int
        self.self_send_message = detail["self_send_message"] as? Int
        
        self.item_title = detail["item_title"] as? String
        self.item_image = detail["item_image"] as? String
        self.item_id = detail["item_id"] as? String
        
        self.file_type = detail["file_type"] as? String
        self.message_type = detail["message_type"] as? String
        self.last_message_type = detail["last_message_type"] as? String
        self.last_message_sender_user_id = detail["last_message_sender_user_id"] as? String
        
        self._id = detail["_id"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.first_user_id = detail["first_user_id"] as? String
        self.last_message_file_type = detail["last_message_file_type"] as? String
        self.is_open_by_first_user_id = detail["is_open_by_first_user_id"] as? Int
        self.is_open_by_second_user_id = detail["is_open_by_second_user_id"] as? Int
        self.is_open_by_second_user_id = detail["is_read_by_self"] as? Int
        self.is_read_by_second_user = detail["is_read_by_second_user"] as? Int
        self.continue_chat_status = detail["continue_chat_status"] as? Int
        self.response_other_user = detail["response_other_user"] as? Int
        
        self.is_come_from_story_hangout = detail["is_come_from_story_hangout"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
            
        self.other_user_details = other_user_details_Model.init(detail: (detail["other_user_details"] as? JSONDictionary) ?? [:])
        self.like_dislike = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        
        self.second_user_id = detail["second_user_id"] as? String
        self.last_message = detail["last_message"] as? String
        self.chat_room_id = detail["chat_room_ids"] as? String
        self.chat_time = detail["chat_time"] as? String
        
        self.chatDate = (detail["chat_time"] as? String)?.dateFromString2(format: .NewISO) ?? Date()
        
        self.message = detail["message"] as? String
        self.to_user_id = detail["to_user_id"] as? String
        
        self.unread_count = detail["unread_count"] as? Int
        self.last_message_time = detail["last_message_time"] as? String
        
        if let name = self.other_user_details?.profile_data?.username {
            self.username = name
            self.image = self.other_user_details?.profile_data?.image
        } else {
            self.username = detail["username"] as? String
            self.imageData = detail["imageData"] as? Data
        }
    }
    
    private init() {}
    
    func json() -> Dictionary<String,Any> {
        var dict = [String: Any]()
        dict["_id"] = self._id
        dict["last_message"] = self.last_message
        dict["username"] = self.username
        dict["imageData"] = HangoutVM.shared.stringToData(string: self.image ?? kEmptyString)
        return dict
    }
    
}
struct other_user_details_Model {
    
    var _id:String?
    var profile_data:OnlyImageNameProfileModel?
  //  var authToken:String?
  //  var country_code:String?
    
   // var is_block:Int?
   // var is_block_by_admin_by_report:Int?
   // var is_shake_count:Int?
   // var more_profile_details:MoreProfileDataModel?
    //var phone_number:String?
   
    
   // var report_count:Int?
   /// var social_id:String?
    //var social_type:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.profile_data = OnlyImageNameProfileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
//        self.authToken = detail["authToken"] as? String
//        self.country_code = detail["country_code"] as? String
//        self.is_block = detail["is_block"] as? Int
//
//        self.is_block_by_admin_by_report = detail["is_block_by_admin_by_report"] as? Int
//        self.is_shake_count = detail["is_shake_count"] as? Int
//
//        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
//
//        self.phone_number = detail["phone_number"] as? String
//
       
        
//        self.report_count = detail["report_count"] as? Int
//        self.social_id = detail["social_id"] as? String
//        self.social_type = detail["social_type"] as? String
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
struct audio_video_calling_Model {
        
        var call_type:String?
        var chanel_name:String?
        var from_user_id:String?
        var rtc_token:String?
    
        var rtc_token_publish:String?
        var rtc_token_subscriber:String?
        var to_user_id:String?
        var uid:String?
        var uid_publish:String?
        var uid_subscriber:String?
    var rtmToken_publisher:String?
    var rtmToken_subscriber:String?
    
        init(detail:JSONDictionary) {
            self.call_type = detail["call_type"] as? String
            self.chanel_name = detail["chanel_name"] as? String
            self.from_user_id = detail["from_user_id"] as? String
            self.rtc_token = detail["rtc_token"] as? String
            self.to_user_id = detail["to_user_id"] as? String
            self.uid = detail["uid"] as? String
            self.rtc_token_publish = detail["rtc_token_publish"] as? String
            self.rtc_token_subscriber = detail["rtc_token_subscriber"] as? String
            self.uid_publish = detail["uid_publish"] as? String
            self.uid_subscriber = detail["uid_subscriber"] as? String
            
            self.rtmToken_publisher = detail["rtmToken_publisher"] as? String
            self.rtmToken_subscriber = detail["rtmToken_subscriber"] as? String
            
}
}

struct chat_room_Model{

        
        var _id:String?
        var is_open_by_first_user_id:String?
        var is_open_by_second_user_id:String?
        var is_like_by_second_user_id:Int?
        var is_match:Int?
        var like_mode:String?
        var second_user_id:String?
         var first_user_id:String?
       var from_user_id:String?
       var continue_chat_status:Int?
      var is_come_from_story_hangout:Int?
    var have_parlong:Int?
    
        var other_user_details:other_user_details_Model?
    
        init(detail:JSONDictionary) {
            self._id = detail["_id"] as? String
            self.is_open_by_first_user_id = detail["is_open_by_first_user_id"] as? String
            self.is_open_by_second_user_id = detail["is_open_by_second_user_id"] as? String
            self.first_user_id = detail["first_user_id"] as? String
            self.second_user_id = detail["second_user_id"] as? String
            self.from_user_id = detail["self_user_id"] as? String
            self.other_user_details = other_user_details_Model.init(detail: (detail["other_user_details"] as? JSONDictionary) ?? [:])
            self.continue_chat_status = detail["continue_chat_status"] as? Int
            self.have_parlong = detail["have_parlong"] as? Int

            self.is_come_from_story_hangout = detail["is_come_from_story_hangout"] as? Int
}
}

struct Active_Chat_Count_Model {
        
        var total_count_active_chats:Int?
        var simultaneously_chat:Int?
        var active_chats_user_ids:[String?]
    
        init(detail:JSONDictionary) {
            self.total_count_active_chats = detail["total_count_active_chats"] as? Int
            self.simultaneously_chat = detail["simultaneously_chat"] as? Int
            
            self.active_chats_user_ids = detail["active_chats_user_ids"] as? [String] ?? []
            
            
        }
}

struct Video_Call_Count_Model {
        
     
    var chat_subscription:SubscriptionModel?
    var video_count_check:video_count_check_Model?
        init(detail:JSONDictionary) {
            self.chat_subscription = SubscriptionModel.init(detail: (detail["chat_subscription"] as? JSONDictionary) ?? [:])
            self.video_count_check = video_count_check_Model.init(detail: (detail["video_count_check"] as? JSONDictionary) ?? [:])
        }
}

struct video_count_check_Model {
    
    var _id:String?
    var total_video_count:Int?
  
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.total_video_count = detail["total_video_count"] as? Int
    }
}
