//
//  getUserDetail.swift
//  Flazhed
//
//  Created by IOS22 on 21/01/21.
//

import Foundation

struct getUserDetail
{
    var id:String?
    var name:String?
    var phone_number:Int?
    var country_code:String?
    var social_id:String?
    var social_type:String?
    var email:String?
    var is_block:Int?
    var device_type:String?
    var device_token:String?
    var deletedAt:String?
    var authToken:String?
    var profile_data:profileModel?
    
    var more_profile_details:MoreProfileDataModel?
    
    init(detail:JSONDictionary) {
        self.id = detail["_id"] as? String
        self.authToken = detail["authToken"] as? String
        self.name = detail[ApiKey.kName] as? String
        self.phone_number = detail[ApiKey.kPhoneNumber] as? Int ?? 0
        self.country_code = detail[ApiKey.kCountryCode] as? String
        self.social_id = detail[ApiKey.kSocial_id] as? String
        self.social_type = detail[ApiKey.kSocial_type] as? String
        self.is_block = detail[ApiKey.kIsBlock] as? Int
        self.profile_data = profileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
    }
}


struct profileModel
{
    var id:String?
    var username:String?
    var dob:String?
    var gender:String?
    var voice:String?
    var latitude:String?
    var longitude:String?
    var deletedAt:String?
    var images:[userImagesModel]?
    
    init(detail:JSONDictionary) {
        self.id = detail["_id"] as? String
        self.username = detail["username"] as? String
        self.dob = detail["dob"] as? String
        self.gender = detail["gender"] as? String
        self.voice = detail["voice"] as? String
        self.latitude = detail["latitude"] as? String
        self.longitude = detail["longitude"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        images = [userImagesModel]()
        
        for imag in detail["images"] as? JSONArray ?? []
        {
           let img = userImagesModel(detail: imag)
            self.images?.append(img)
        }
        
    }
}
struct userImagesModel
{
    var id:String?
    var image:String?
    var deletedAt:String?

    init(detail:JSONDictionary) {
        self.id = detail["id"] as? String
        self.image = detail["image"] as? String
        self.deletedAt = detail["deletedAt"] as? String
    }
}
