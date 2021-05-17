//
//  HangoutListDM.swift
//  Flazhed
//
//  Created by IOS33 on 25/02/21.
//

import Foundation
struct HangoutListDM
{
    var hangout_details:HangoutDataModel?
    var is_liked_by_other_user_id:Int?
    var is_liked_by_self_user:Int?
    var like_dislike:Like_DisLike_Model?
    var more_profile_details:MoreProfileDataModel?
    var profile_data:profileModel?
    var unit_settings:unitDataModel?
    var user_id:String?
    
    init(detail:JSONDictionary) {
        
        self.hangout_details = HangoutDataModel.init(detail: (detail["hangout_details"] as? JSONDictionary) ?? [:])
        self.like_dislike = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.profile_data = profileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.unit_settings = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        
        self.user_id = detail["user_id"] as? String
        
    }
}
