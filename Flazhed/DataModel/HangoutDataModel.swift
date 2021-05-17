//
//  HangoutDataModel.swift
//  Flazhed
//
//  Created by IOS32 on 12/02/21.
//

import Foundation

struct HangoutDataModel
{
    var _id:String?
    var user_id:String?
    var image:String?
    var hangout_type:String?
    var heading:String?
    var description:String?
    var date:String?
    var time:String?
    var place:String?
    var latitude:Double?
    var longitude:Double?
    var aditional_description:String?
    var looking_for:String?
    var deletedAt:String?
    var age:Int?
    var age_from:Int?
    var age_to:Int?
    
    init(detail:JSONDictionary) {
        
        self._id = detail["_id"] as? String
        self.image = detail["image"] as? String
        self.user_id = detail["user_id"] as? String
        self.hangout_type = detail["hangout_type"] as? String
        self.heading = detail["heading"] as? String
        self.description = detail["description"] as? String
        self.date = detail["date"] as? String
        self.time = detail["time"] as? String
        self.place = detail["place"] as? String
        self.latitude = detail["latitude"] as? Double
        self.longitude = detail["longitude"] as? Double
        self.aditional_description = detail["aditional_description"] as? String
        self.looking_for = detail["looking_for"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.age = detail["age"] as? Int
        self.age_from = detail["age_from"] as? Int
        self.age_to = detail["age_to"] as? Int
    }
}
