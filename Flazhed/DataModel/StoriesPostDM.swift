//
//  StoriesPostDM.swift
//  Flazhed
//
//  Created by IOS32 on 08/02/21.
//

import Foundation

struct StoriesPostDataModel {

    
    var post_details:PostdetailModel?
    var profile_data:ProfileData?
    var like_dislike_name:String?
    var more_profile_details:MoreProfileDataModel?
    var user_id:String?
    var is_liked_by_other_user_id:Int?
    
    var phone_number:Int?
    var country_code:String?
    var social_id:String?
    var social_type:String?
    var email:String?
    var is_block:Int?
    var device_type:String?
    var device_token:String?
    var is_shake_count:Int?

    var like_dislike:Like_DisLike_Model?
    var is_liked_by_self_user:Int?
    
    
    init(detail:JSONDictionary) {
        
        
        self.post_details = PostdetailModel.init(detail: (detail["post_details"] as? JSONDictionary) ?? [:])
        
        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.like_dislike_name = detail[ApiKey.kName] as? String
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.user_id = detail["user_id"] as? String
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int

        self.phone_number = detail["phone_number"] as? Int
        self.country_code = detail["country_code"] as? String
        self.social_id = detail["social_id"] as? String
        self.social_type = detail["social_type"] as? String
        self.email = detail["email"] as? String
        
        self.device_type = detail["device_type"] as? String
        self.device_token = detail["device_token"] as? String
        self.is_shake_count = detail["is_shake_count"] as? Int
        self.is_block = detail["is_block"] as? Int
        
        self.like_dislike = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
    }
}



//post_details
struct PostdetailModel {
    
    var _id:String?
    var user_id:String?
    var file_type:String?
    var file_name:String?
    var post_text:String?
    var deletedAt:String?
    var post_date_time:String?
    var thumbnail:String?
    var is_block_by_admin:String?
    var report_count:Int?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.user_id = detail["user_id"] as? String
        self.file_type = detail["file_type"] as? String
        self.file_name = detail["file_name"] as? String
        
        self.post_text = detail["post_text"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        
        self.post_date_time = detail["post_date_time"] as? String
        self.thumbnail = detail["thumbnail"] as? String
        
        self.is_block_by_admin = detail["is_block_by_admin"] as? String
        self.report_count = detail["report_count"] as? Int
       
    }
}

//post_details
struct Like_DisLike_Model {
    
    var _id:String?
    var chat_end_time_inactive:String?
    var chat_start_time_active:String?
    var first_user_id:String?
    var is_like_by_first_user_id:Int?
    var is_like_by_second_user_id:Int?
    var is_match:Int?
    var like_mode:String?
    var second_user_id:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.chat_end_time_inactive = detail["chat_end_time_inactive"] as? String
        self.chat_start_time_active = detail["chat_start_time_active"] as? String
        self.first_user_id = detail["first_user_id"] as? String
        
        self.is_like_by_first_user_id = detail["is_like_by_first_user_id"] as? Int
        self.is_like_by_second_user_id = detail["is_like_by_second_user_id"] as? Int
        self.is_match = detail["is_match"] as? Int
        
        self.like_mode = detail["like_mode"] as? String
        self.second_user_id = detail["second_user_id"] as? String
    }
}

//pagination_details

struct Pagination_Details_Model {
    
    var limit:Int?
    var offset:Int?
    var totalCount:Int?
    var totalPage:Int?
    
    init(detail:JSONDictionary) {
        self.limit = detail["limit"] as? Int
        self.offset = detail["offset"] as? Int
        self.totalCount = detail["totalCount"] as? Int
        self.totalPage = detail["totalPage"] as? Int
    }
}


