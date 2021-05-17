//
//  HomeShakeUser.swift
//  Flazhed
//
//  Created by IOS22 on 27/01/21.
//

import Foundation

struct UserListModel {
    var profile_data:ProfileData?
    var like_dislike:String?
    var more_profile_details:MoreProfileDataModel?
    var user_id:String?
    
    var is_liked_by_self_user:Int?
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
    var post_details:[PostdetailModel]?
    var hangout_details:[HangoutDataModel]?
    var unit_settings:unitDataModel?
    
    var facebook_data:FacebookDataModel?

    var Insta_data:InstaDataModel?
    
    
    var like_dislikeData:Like_DisLike_Model?
    var arrAllPostCollection:[AllPostModel]!
    
    
    init(detail:JSONDictionary) {
        
        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.like_dislike = detail[ApiKey.kName] as? String
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.user_id = detail["user_id"] as? String
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int

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
        
        
        
        hangout_details = [HangoutDataModel]()
       
        
        for hangout in detail["hangout_details"] as? JSONArray ?? []
        {
           let post = HangoutDataModel(detail: hangout)
            self.hangout_details?.append(post)
        }
        
        post_details = [PostdetailModel]()
        
        
        for posts in detail["post_details"] as? JSONArray ?? []
        {
           let post = PostdetailModel(detail: posts)
            self.post_details?.append(post)
        }
        
        
        self.unit_settings = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        
        self.facebook_data = FacebookDataModel.init(detail: (detail["facebook_data"] as? JSONDictionary) ?? [:])
        
        self.Insta_data = InstaDataModel.init(detail: (detail["instagram_data"] as? JSONDictionary) ?? [:])
        
        self.like_dislikeData = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        
        self.arrAllPostCollection = self.createAllPostArr()
    }
    
    func createAllPostArr() -> [AllPostModel]{
        
        var arr = [AllPostModel]()
        
      
        
        if let postDetails = post_details{
            for post in postDetails{
                if post._id != nil
                {
                arr.append(
                    AllPostModel.init(type: .story, PostData: post))
                }
            }
        }
        if let HangDetails = hangout_details{
            for hang in HangDetails{
                if hang._id != nil
                {
                arr.append(
                    AllPostModel.init(type: .hangout,hangoutData: hang))
                }
            }
        }
        
        return arr
    }
}

//ProfileDataModel
struct ProfileData {
    
    var _id:String?
    var username:String?
    var dob:String?
    var latitude:String?
    var longitude:String?
    var gender:String?
    var voice:String?
    var createdAt:String?
    var images:[ImageDataModel]?

    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.username = detail["username"] as? String
        self.dob = detail["dob"] as? String
        self.latitude = detail["latitude"] as? String
        
        self.longitude = detail["longitude"] as? String
        self.gender = detail["gender"] as? String
        self.voice = detail["voice"] as? String
        self.createdAt = detail["createdAt"] as? String
        
        images = [ImageDataModel]()
        
        for imag in detail["images"] as? JSONArray ?? []
        {
           let img = ImageDataModel(detail: imag)
            self.images?.append(img)
        }
       
    }
}

//ImageDataModel
struct ImageDataModel {
    
    var _id:String?
    var image:String?
    var updatedAt:String?
    var createdAt:String?


    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.image = detail["image"] as? String
        self.updatedAt = detail["updatedAt"] as? String
        self.createdAt = detail["createdAt"] as? String

    }
}


//ImageDataModel
struct MoreProfileDataModel {
    
    var _id:String?
    var user_id:String?
    var age:Int?
    var job_title:String?
    
    var company_name:String?
    var city:String?
    var height:Int?
    var city_latitude:String?
    
    var city_longitude:String?
    var children_id:String?
    var education_id:String?
    var hari_id:String?
    var bio:String?
    var gender:String?
    var education_selected:educationsDataModel?
    var hair_selected:hairsDataModel?
    var children_selected:[childrensDataModel]?
   
    var arrCollection:[ProfAttributeModel]!
   
    
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.user_id = detail["user_id"] as? String
        self.age = detail["age"] as? Int
        self.job_title = detail["job_title"] as? String
        self.company_name = detail["company_name"] as? String
        
        self.city = detail["city"] as? String
        self.height = detail["height"] as? Int
        self.city_latitude = detail["city_latitude"] as? String
        self.city_longitude = detail["city_longitude"] as? String
        
        self.children_id = detail["children_id"] as? String
        self.education_id = detail["education_id"] as? String
        self.hari_id = detail["hari_id"] as? String
        self.bio = detail["bio"] as? String
        self.gender = detail["gender"] as? String
        
        self.education_selected = educationsDataModel.init(detail: (detail["education_selected"] as? JSONDictionary) ?? [:])
        
        self.hair_selected = hairsDataModel.init(detail: (detail["hair_selected"] as? JSONDictionary) ?? [:])
       // self.children_selected = childrensDataModel.init(detail: (detail["children_selected"] as? JSONDictionary) ?? [:])
        
        
        children_selected = [childrensDataModel]()
        
        for child2 in detail["children_selected"] as? JSONArray ?? []
        {
           let child = childrensDataModel(detail: child2)
            self.children_selected?.append(child)
        }
        
        self.arrCollection = self.createCollectionArr()
    }
    
    func createCollectionArr() -> [ProfAttributeModel]{
        
        var arr = [ProfAttributeModel]()
        
        if let education_selected = education_selected{
            if education_selected.education_name != nil
            {
            arr.append(
              
                ProfAttributeModel.init(type: .education, education_selected: education_selected)
                
            )
            }
        }
        
        if let height = height{
           
            arr.append(
                ProfAttributeModel.init(type: .height, height: height)
            )
            
        }
        
        if let hair_selected = hair_selected{
            if hair_selected.hair_name != nil
            {
            arr.append(
                ProfAttributeModel.init(type: .hairColor, hair_selected: hair_selected)
            )
            }
        }
        
        if let children_selected = children_selected{
            for childrenModel in children_selected{
                if childrenModel.children_name != nil
                {
                arr.append(
                    ProfAttributeModel.init(type: .children, children_selected: childrenModel)
                )
                }
            }
        }
        
        return arr
    }

    
}



//childrens model

struct childrensDataModel {
    
    var _id:String?
    var childrenId:String?
    var image:String?
    var is_selected:Bool?
    var children_name:String?
   
    
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.childrenId = detail["children_id"] as? String
        self.image = detail["image"] as? String
        self.is_selected = detail["is_selected"] as? Bool
        self.children_name = detail["children_name"] as? String
    
}
}

//educations model

struct educationsDataModel {
    var _id:String?
    var is_selected:Bool?
    var education_name:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.is_selected = detail["is_selected"] as? Bool
        self.education_name = detail["education_name"] as? String
    
}
}


//hairs model

struct hairsDataModel {
    var _id:String?
    var is_selected:Bool?
    var hair_name:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.is_selected = detail["is_selected"] as? Bool
        self.hair_name = detail["hair_name"] as? String
    
}
}

//unit model

struct unitDataModel {
    var _id:String?
    var deletedAt:String?
    var unit:String?
    var user_id:String?
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.user_id = detail["user_id"] as? String
        self.unit = detail["unit"] as? String
    
}
}


struct FacebookDataModel {
    var _id:String?
    var deletedAt:String?
    var facebook_data:String?
    var user_id:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.facebook_data = detail["facebook_data"] as? String
        self.user_id = detail["user_id"] as? String
}
}


//Main Collection Model
enum ProfAttributeType{
    
    case education
    case height
    case hairColor
    case children
}
enum PostType{
    
    case story
    case hangout

}


struct ProfAttributeModel{
    
    var type:ProfAttributeType!
    
    var height:Int?
    var education_selected:educationsDataModel?
    var hair_selected:hairsDataModel?
    var children_selected:childrensDataModel?
}

struct AllPostModel{
    
    var type:PostType!

    var hangoutData:HangoutDataModel?
    var PostData:PostdetailModel?
}


struct InstaDataModel {
    var _id:String?
    var deletedAt:String?
    var instagram_data:String?//InstaSendModel?
    var user_id:String?
    var images:[String]?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.instagram_data = detail["instagram_data"] as? String//InstaSendModel
        self.user_id = detail["user_id"] as? String
        
        images = [String]()
        
        for imag in detail["images"] as? NSArray ?? []
        {
            let imgStr = imag as? String ?? ""
               
         
            self.images?.append(imgStr)
        }
}
}
