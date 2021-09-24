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
    }
}
