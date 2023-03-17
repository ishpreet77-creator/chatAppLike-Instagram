//
//  SubscriptionModel.swift
//  Flazhed
//
//  Created by IOS33 on 28/05/21.
//

import Foundation
struct SubscriptionModel {
    
    var _id:String?
    var user_id:String?
    var subscription_type:String?
    var subscription_start_date:String?
    var subscription_start_time:String?
    var subscription_end_date:String?
    var subscription_end_time:String?
    var subscription_is_active:Int?
    var name:String?
    var payment_id:String?
    var month_up_to:Int?
    var deletedAt:String?
    var extra_shake:Int?
    
    var hangout_days_active:Int?
    var monthly_video_call:Int?
    var call_max_duration:Int?
    
    var number_of_interested_hangouts:Int?
    var picture_per_day:Int?
    
    var same_hangout:Int?
    var shake_radius:Int?
    
    var simultaneously_chat:Int?
    var video_length:Int?
    var video_per_day:Int?

    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.user_id = detail["user_id"] as? String
        self.subscription_type = detail["subscription_type"] as? String
        self.subscription_start_date = detail["subscription_start_date"] as? String
        self.subscription_start_time = detail["subscription_start_time"] as? String
        self.subscription_end_date = detail["subscription_end_date"] as? String
        self.subscription_is_active = detail["subscription_is_active"] as? Int
        self.name = detail["name"] as? String
        self.payment_id = detail["payment_id"] as? String
        self.month_up_to = detail["month_up_to"] as? Int
        self.deletedAt = detail["deletedAt"] as? String
        self.extra_shake = detail["extra_shake"] as? Int
        
        self.hangout_days_active = detail["hangout_days_active"] as? Int
        
        self.monthly_video_call = detail["monthly_video_call"] as? Int
        self.number_of_interested_hangouts = detail["number_of_interested_hangouts"] as? Int
        self.picture_per_day = detail["picture_per_day"] as? Int
        
        self.same_hangout = detail["same_hangout"] as? Int
        self.shake_radius = detail["shake_radius"] as? Int
        self.simultaneously_chat = detail["simultaneously_chat"] as? Int
        self.video_length = detail["video_length"] as? Int
        self.video_per_day = detail["video_per_day"] as? Int
        self.call_max_duration = detail["call_max_duration"] as? Int
        
        
    }
}

struct  User_Profile_Update_Counter_Model {
    
    var _id:String?
    var count:Int?
 
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.count = detail["count"] as? Int

    }
}


struct Post_Data_Model {
    
    var _id:String?
    var total_image_count:Int?
 
    var total_video_count:Int?

    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.total_image_count = detail["total_image_count"] as? Int
        self.total_video_count = detail["total_video_count"] as? Int
        
        
    }
}
