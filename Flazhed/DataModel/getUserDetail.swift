//
//  getUserDetail.swift
//  Flazhed
//
//  Created by IOS22 on 21/01/21.
//

import Foundation

struct MyProfileDataModel {
//    var profile_data:ProfileData?

    var like_dislike:String?
    var like_mode_by_other_user:String?
    var like_mode_by_self:String?
    
 var more_profile_details:MoreProfileDataModel?
    var user_id:String?
    var is_liked_by_other_user_id:Int?
    
    var is_liked_by_self_user:Int?
    var phone_number:Int?
    var country_code:String?
    var social_id:String?
    var social_type:String?
    var email:String?
    var is_block:Int?
    var enable_red_dot:Int?
    var device_type:String?
    var device_token:String?
    var is_shake_count:Int?
   //var unit_settings:unitDataModel?
    
    var age:Int?
    var job_title:String?
    var company_name:String?
    var city:String?
    var bio:String?
    var education_name:String?
    var arrCollection:[ProfAttributeModel]!
    
    var username:String?
    var voice:String?
    var images:[ImageDataModel]?
    
    var unit:String?
    
    init(detail:JSONDictionary) {
//        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
  
//        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.user_id = detail["user_id"] as? String
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int

        self.enable_red_dot = detail["enable_red_dot"] as? Int
        
        
        self.phone_number = detail["phone_number"] as? Int
        self.country_code = detail["country_code"] as? String
        self.social_id = detail["social_id"] as? String
        self.social_type = detail["social_type"] as? String
        self.email = detail["email"] as? String
        
        self.device_type = detail["device_type"] as? String
        self.device_token = detail["device_token"] as? String
        self.is_shake_count = detail["is_shake_count"] as? Int
        self.is_block = detail["is_block"] as? Int
      // self.unit_settings = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        if let age = more_profile_details?.age {
            self.age = age
            self.job_title = more_profile_details?.job_title
            self.company_name = more_profile_details?.company_name
            self.city = more_profile_details?.city
            self.bio = more_profile_details?.bio
    //        self.education_name = moreProfileDetail.
            self.arrCollection = more_profile_details?.arrCollection
        } else {
            self.age = detail["age"] as? Int
            self.job_title = detail["job_title"] as? String
            self.company_name = detail["company_name"] as? String
            self.city = detail["city"] as? String
            self.bio = detail["bio"] as? String
            self.education_name = detail["education_name"] as? String
        }
        
        let profileData = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        if let name = profileData.username {
            self.username = name
            self.voice = profileData.voice
            self.images = profileData.images
        } else {
            self.username = detail["username"] as? String
            self.voice = detail["voice"] as? String
//            self.images = detail["bio"] as? [ImageDataModel]
        }
        
        let unitData = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        if let unit = unitData.unit {
            self.unit = unit
        } else {
            self.unit = detail["unit"] as? String
        }
        
    }
    
    private init() {}
    
    func json() -> Dictionary<String,Any> {
        var dict = [String: Any]()
        dict["age"] = self.age
        dict["job_title"] = self.job_title
        dict["company_name"] = self.company_name
        dict["city"] = self.city
        dict["bio"] = self.bio
        dict["username"] = self.username
        dict["voice"] = self.voice
//        dict["images"] = self.images
        dict["unit"] = self.unit
//        dict["imageData"] = HangoutVM.shared.stringToData(string: self.images ?? kEmptyString)
        return dict
    }

}

struct onlyProfileDataModel {
    var profile_data:OnlyImageNameProfileModel?
    var unit_settings:unitDataModel?
    var phone_number:Int?
    init(detail:JSONDictionary) {
        self.profile_data = OnlyImageNameProfileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.unit_settings = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        self.phone_number = detail[ApiKey.kPhoneNumber] as? Int 
    }
}

struct getUserDetail
{
    var id:String?
    var name:String?
   // var phone_number:Int?
   // var country_code:String?
    //var social_id:String?
   // var social_type:String?
    var email:String?
    var is_block:Int?
    var device_type:String?
    var device_token:String?
   // var deletedAt:String?
    var authToken:String?
    var profile_data:OnlyImageNameProfileModel?
    
    var more_profile_details:MoreProfileDataModel?
    
    init(detail:JSONDictionary) {
        self.id = detail["_id"] as? String
        self.authToken = detail["authToken"] as? String
        self.name = detail[ApiKey.kName] as? String
        //self.phone_number = detail[ApiKey.kPhoneNumber] as? Int ?? 0
       // self.country_code = detail[ApiKey.kCountryCode] as? String
        //self.social_id = detail[ApiKey.kSocial_id] as? String
        //self.social_type = detail[ApiKey.kSocial_type] as? String
        self.is_block = detail[ApiKey.kIsBlock] as? Int
        self.profile_data = OnlyImageNameProfileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
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
struct OnlyImageNameProfileModel
{
    var id:String?
    var username:String?
    var voice:String?
    var image:String?//[userImagesModel]?
    
    init(detail:JSONDictionary) {
        self.id = detail["_id"] as? String
        self.username = detail["username"] as? String
        self.voice = detail["voice"] as? String
        let imageArray = detail["images"] as? JSONArray ?? []
        if imageArray.count>0
        {
            let img = userImagesModel(detail: imageArray[0])
            self.image=img.image
        }
    }
    
    private init() {}
    
//    func json() -> Dictionary<String,Any> {
//        var dict = [String: Any]()
//        dict["username"] = self.username
////        dict["imageData"] = HangoutVM.shared.stringToData(string: self.images ?? kEmptyString)
//        return dict
//    }
}



struct userImagesModel
{
    var id:String?
    var image:String?
    var imageData: Data?
    var deletedAt:String?

    init(detail:JSONDictionary) {
        self.id = detail["id"] as? String
        self.image = detail["image"] as? String
        self.imageData = detail["imageData"] as? Data
        self.deletedAt = detail["deletedAt"] as? String
    }
}

struct userShakeCountModel
{
    var totalShakeCount:Int?
    var usedShakedCount:Int?
    var totalShakeLeft:Int?
    
    init(detail:JSONDictionary) {
        self.totalShakeCount = detail["totalShakeCount"] as? Int
        self.usedShakedCount = detail["usedShakedCount"] as? Int
        self.totalShakeLeft = detail["totalShakeLeft"] as? Int
    }
}
