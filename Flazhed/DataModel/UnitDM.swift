//
//  Account data Model.swift
//  Flazhed
//
//  Created by IOS32 on 05/02/21.
//

import Foundation

struct UnitDataModel {
    
    var _id:String?
    var unit:String?
    var deletedAt:String?
    var user_id:String?

    init(detail:JSONDictionary)
    {
        self._id=detail[ApiKey.k_Id] as? String
        self.deletedAt=detail[ApiKey.kDeletedAt] as? String
        self.user_id=detail[ApiKey.kUser_id] as? String
        self.unit=detail[ApiKey.kUnit] as? String
    }
}

struct NotificationSetupModel {
    
    var _id:String?
    var deletedAt:String?
    var user_id:String?

    var new_message_push:Int?
    var new_matches_push:Int?
    var new_like_push:Int?

    var new_hangout_push:Int?
    var new_message_mail:Int?
    
    var new_matches_mail:Int?
    var new_like_mail:Int?
    var new_hangout_mail:Int?
    var team_flazhed:Int?
    
    init(detail:JSONDictionary)
    {
        self._id=detail[ApiKey.k_Id] as? String
        self.deletedAt=detail[ApiKey.kDeletedAt] as? String
        self.user_id=detail[ApiKey.kUser_id] as? String
        
        self.new_message_push=detail[ApiKey.knew_message_push] as? Int
        self.new_matches_push=detail[ApiKey.knew_matches_push] as? Int
        self.new_like_push=detail[ApiKey.knew_like_push] as? Int
        self.new_hangout_push=detail[ApiKey.knew_hangout_push] as? Int
        
        self.new_message_mail=detail[ApiKey.knew_message_mail] as? Int
        self.new_matches_mail=detail[ApiKey.knew_matches_mail] as? Int
        self.new_like_mail=detail[ApiKey.knew_like_mail] as? Int
        self.new_hangout_mail=detail[ApiKey.knew_hangout_mail] as? Int
        self.team_flazhed=detail[ApiKey.kteam_flazhed] as? Int
        
        
    }
}
