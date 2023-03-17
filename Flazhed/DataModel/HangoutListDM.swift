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
    var hangout_like_by_self:Int?
    var is_liked_by_self_user:Int?
//    var like_dislike:Like_DisLike_Model?
//    var more_profile_details:MoreProfileDataModel?
//    var profile_data:profileModel?
//    var unit_settings:unitDataModel?
    var user_id:String?
    var username : String?
    var profileImage: String?
    var profileImageData: Data?
    var _id:String?
    var hangout_user_id:String?
    var image:String?
    var imageData:Data?
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
        
        hangout_details = HangoutDataModel.init(detail: (detail["hangout_details"] as? JSONDictionary) ?? [:])
      //  self.like_dislike = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
       // self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        let profile_data = OnlyImageNameProfileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        //self.unit_settings = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        self.hangout_like_by_self = detail["hangout_like_by_self"] as? Int
        self.user_id = detail["user_id"] as? String
        if let name = profile_data.username
        {
            self.username = name
           // let images = profile_data.images
           // if images?.count ?? 0 > 0 {
                
            
            let imageName = profile_data.image ?? ""
            if !imageName.contains(kHttps) &&  !imageName.contains(kHttp)
            {
                self.profileImage = IMAGE_BASE_URL+imageName
            }
            else
            {
                self.profileImage = imageName
            }
            
            //}
        } else {
            self.username = detail["username"] as? String
            self.profileImageData = detail["profileImageData"] as? Data
        }
        
        if let id = hangout_details?._id {
            self._id = id
            self.hangout_user_id = hangout_details?.user_id
            let imageName = hangout_details?.image ?? ""
            if !imageName.contains(kHttps) &&  !imageName.contains(kHttp)
            {
                self.image = kHangoutTale+imageName
            }
            else
            {
                self.image = imageName
            }
            
            self.hangout_type = hangout_details?.hangout_type
            self.heading = hangout_details?.heading
            self.description = hangout_details?.description
            self.date = hangout_details?.date
            self.time = hangout_details?.time
            self.place = hangout_details?.place
            self.latitude = hangout_details?.latitude
            self.longitude = hangout_details?.longitude
            self.aditional_description = hangout_details?.aditional_description
            self.looking_for = hangout_details?.looking_for
            self.deletedAt = hangout_details?.deletedAt
            self.age = hangout_details?.age
            self.age_from = hangout_details?.age_from
            self.age_to = hangout_details?.age_to
        } else {
            self._id = detail["_id"] as? String
            self.hangout_user_id = detail["hangout_user_id"] as? String
            self.imageData = detail["imageData"] as? Data
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
    
    private init() {}
    
    func json() -> Dictionary<String,Any> {
        var dict = [String: Any]()
        dict["username"] = self.username
        dict["profileImageData"] = HangoutVM.shared.stringToData(string: self.profileImage ?? kEmptyString)
        dict["_id"] = self._id
        dict["hangout_user_id"] = self.hangout_user_id
        dict["imageData"] = HangoutVM.shared.stringToData(string: self.image ?? kEmptyString)
        dict["hangout_type"] = self.hangout_type
        dict["heading"] = self.heading
        dict["description"] = self.description
        dict["date"] = self.date
        dict["time"] = self.time
        dict["place"] = self.place
        dict["latitude"] = self.latitude
        dict["longitude"] = self.longitude
        dict["aditional_description"] = self.aditional_description
        dict["looking_for"] = self.looking_for
        dict["deletedAt"] = self.deletedAt
        dict["age"] = self.age
        dict["age_from"] = self.age_from
        dict["age_to"] = self.age_to
        return dict
    }
}


struct HangoutListTypeModel
{
    var type:CellType?
    var hangoutData:HangoutListDM?
}

enum CellType {
    case hangoutList
    case storyList
    case ads
}
