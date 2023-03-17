//
//  HomeShakeUser.swift
//  Flazhed
//
//  Created by IOS22 on 27/01/21.
//

import Foundation

struct HomeUserListModel {
    var profile_data:ProfileData?
    
    var second_table_like_dislike:SecondTableLikeDislikeModel?
    
    var like_dislike:String?
    var like_mode_by_other_user:String?
    var like_mode_by_self:String?
    
    var more_profile_details:MoreProfileDataModel?
    var user_id:String?
    var is_liked_by_other_user_id:Int?
    
    var is_liked_by_self_user:Int?
    //var is_liked_by_other_user_id:Int?
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
   // var post_details:[PostdetailModel]?
   // var hangout_details:[HangoutDataModel]?
    var unit_settings:unitDataModel?


   // var Insta_data:InstaDataModel?
    
    var Single_Hangout_Details:HangoutDataModel?
    var Single_Story_Details:PostdetailModel?
    
    var like_dislikeData:Like_DisLike_Model?
    //var arrAllPostCollection:[AllPostModel]!
    var story_like_by_self:Int?
    var hangout_like_by_self:Int?
    
    var response_other_user:Int?
    var response_self_user:Int?
    var continue_chat_status_other_user:Int?
    var is_read_by_second_user:Int?
    var is_continue_from_user:Int?
    var is_continue_to_user:Int?
    var self_send_message:Int?
    var prolong_subscription_is_active:Int?
    var continue_chat_status:Int?
    var chat_room_details:chat_room_Id_Model?
    var other_user_inactive_state:Int?
    
    
    init(detail:JSONDictionary) {
        self.chat_room_details =  chat_room_Id_Model.init(detail: (detail["chat_room_details"] as? JSONDictionary) ?? [:])
        self.second_table_like_dislike = SecondTableLikeDislikeModel.init(detail: (detail["second_table_like_dislike"] as? JSONDictionary) ?? [:])
        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.like_dislike = detail[ApiKey.kName] as? String
        
        self.like_mode_by_self = detail["like_mode_by_self"] as? String
        self.like_mode_by_other_user = detail["like_mode_by_other_user"] as? String
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.user_id = detail["user_id"] as? String
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.other_user_inactive_state = detail["other_user_inactive_state"] as? Int
        
        //self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.enable_red_dot = detail["enable_red_dot"] as? Int
        
        
        self.phone_number = detail["phone_number"] as? Int
        self.country_code = detail["country_code"] as? String
        self.social_id = detail["social_id"] as? String
        self.social_type = detail["social_type"] as? String
        self.email = detail["email"] as? String
        
        self.device_type = detail["device_type"] as? String
        self.device_token = detail["device_token"] as? String
        self.is_shake_count = detail["is_shake_count"] as? Int
        self.story_like_by_self = detail["story_like_by_self"] as? Int
        self.hangout_like_by_self = detail["hangout_like_by_self"] as? Int
        
        self.is_block = detail["is_block"] as? Int
        //MARK: - for match
        self.response_other_user = detail["response_other_user"] as? Int
        self.response_self_user = detail["response_self_user"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
        self.is_read_by_second_user = detail["is_read_by_second_user"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
        self.is_continue_from_user = detail["is_continue_from_user"] as? Int
        self.is_continue_to_user = detail["is_continue_to_user"] as? Int
        self.self_send_message = detail["self_send_message"] as? Int
        self.prolong_subscription_is_active = detail["prolong_subscription_is_active"] as? Int
        self.continue_chat_status = detail["continue_chat_status"] as? Int

        
        
        
        
        self.Single_Hangout_Details = HangoutDataModel.init(detail: (detail["single_hangout_details"] as? JSONDictionary) ?? [:])
        
        self.Single_Story_Details = PostdetailModel.init(detail: (detail["story_details"] as? JSONDictionary) ?? [:])
        
       // hangout_details = [HangoutDataModel]()
       
        
//        for hangout in detail["hangout_details"] as? JSONArray ?? []
//        {
//           let post = HangoutDataModel(detail: hangout)
//            self.hangout_details?.append(post)
//        }
        
     //   post_details = [PostdetailModel]()
        
        
//        for posts in detail["post_details"] as? JSONArray ?? []
//        {
//           let post = PostdetailModel(detail: posts)
//            self.post_details?.append(post)
//        }
//
        
        self.unit_settings = unitDataModel.init(detail: (detail["unit_settings"] as? JSONDictionary) ?? [:])
        

        
      //  self.Insta_data = InstaDataModel.init(detail: (detail["instagram_data"] as? JSONDictionary) ?? [:])
        
        self.like_dislikeData = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        
       // self.arrAllPostCollection = self.createAllPostArr()
    }
    
//    func createAllPostArr() -> [AllPostModel]{
//
//        var arr = [AllPostModel]()
//
//
//
//        if let postDetails = post_details{
//            for post in postDetails{
//                if post._id != nil
//                {
//                arr.append(
//                    AllPostModel.init(type: .story, PostData: post))
//                }
//            }
//        }
//        if let HangDetails = hangout_details{
//            for hang in HangDetails{
//                if hang._id != nil
//                {
//                arr.append(
//                    AllPostModel.init(type: .hangout,hangoutData: hang))
//                }
//            }
//        }
//
//        return arr
//    }
}










struct UserListModel {
    var profile_data:ProfileData?
    
    var second_table_like_dislike:SecondTableLikeDislikeModel?
    
    var like_dislike:String?
    var like_mode_by_other_user:String?
    var like_mode_by_self:String?
    
    var more_profile_details:MoreProfileDataModel?
    var user_id:String?
    var is_liked_by_other_user_id:Int?
    var other_user_inactive_state:Int?
    
    var is_liked_by_self_user:Int?
    //var is_liked_by_other_user_id:Int?
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
    var post_details:[PostdetailModel]?
    var hangout_details:[HangoutDataModel]?
    var unit_settings:unitDataModel?
    

    var Insta_data:InstaDataModel?
    
    var Single_Hangout_Details:HangoutDataModel?
    var Single_Story_Details:PostdetailModel?
    
    var like_dislikeData:Like_DisLike_Model?
    var arrAllPostCollection:[AllPostModel]!
    var story_like_by_self:Int?
    var hangout_like_by_self:Int?
    
    var response_other_user:Int?
    var response_self_user:Int?
    var continue_chat_status_other_user:Int?
    var is_read_by_second_user:Int?
    var is_continue_from_user:Int?
    var is_continue_to_user:Int?
    var self_send_message:Int?
    var prolong_subscription_is_active:Int?
    var continue_chat_status:Int?
    
    var facebook_Profile_data:Facebook_login_Model?
    
    var chat_room_details:chat_room_Id_Model?
    
    init(detail:JSONDictionary) {
        self.second_table_like_dislike = SecondTableLikeDislikeModel.init(detail: (detail["second_table_like_dislike"] as? JSONDictionary) ?? [:])
        
        self.facebook_Profile_data = Facebook_login_Model.init(detail: (detail["facebook_data"] as? JSONDictionary) ?? [:])
        
        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        self.like_dislike = detail[ApiKey.kName] as? String
        
        self.like_mode_by_self = detail["like_mode_by_self"] as? String
        self.like_mode_by_other_user = detail["like_mode_by_other_user"] as? String
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.user_id = detail["user_id"] as? String
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.other_user_inactive_state = detail["other_user_inactive_state"] as? Int
        
        //self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.enable_red_dot = detail["enable_red_dot"] as? Int
        
    
        
        self.phone_number = detail["phone_number"] as? Int
        self.country_code = detail["country_code"] as? String
        self.social_id = detail["social_id"] as? String
        self.social_type = detail["social_type"] as? String
        self.email = detail["email"] as? String
        
        self.device_type = detail["device_type"] as? String
        self.device_token = detail["device_token"] as? String
        self.is_shake_count = detail["is_shake_count"] as? Int
        self.story_like_by_self = detail["story_like_by_self"] as? Int
        self.hangout_like_by_self = detail["hangout_like_by_self"] as? Int
        
        self.is_block = detail["is_block"] as? Int
        //MARK: - for match
        self.response_other_user = detail["response_other_user"] as? Int
        self.response_self_user = detail["response_self_user"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
        self.is_read_by_second_user = detail["is_read_by_second_user"] as? Int
        self.continue_chat_status_other_user = detail["continue_chat_status_other_user"] as? Int
        self.is_continue_from_user = detail["is_continue_from_user"] as? Int
        self.is_continue_to_user = detail["is_continue_to_user"] as? Int
        self.self_send_message = detail["self_send_message"] as? Int
        self.prolong_subscription_is_active = detail["prolong_subscription_is_active"] as? Int
        self.continue_chat_status = detail["continue_chat_status"] as? Int
        self.chat_room_details =  chat_room_Id_Model.init(detail: (detail["chat_room_details2"] as? JSONDictionary) ?? [:])
        
        
        
        
        self.Single_Hangout_Details = HangoutDataModel.init(detail: (detail["single_hangout_details"] as? JSONDictionary) ?? [:])
        
        self.Single_Story_Details = PostdetailModel.init(detail: (detail["story_details"] as? JSONDictionary) ?? [:])
        
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
    
    private init() {}
    
    func json() -> Dictionary<String,Any> {
        var dict = [String: Any]()
        dict["_id"] = self._id
        dict["image0"] = HangoutVM.shared.stringToData(string: self.images?[0].image ?? kEmptyString)
        dict["image1"] = HangoutVM.shared.stringToData(string: self.images?[1].image ?? kEmptyString)
        dict["image2"] = HangoutVM.shared.stringToData(string: self.images?[2].image ?? kEmptyString)
        dict["image3"] = HangoutVM.shared.stringToData(string: self.images?[3].image ?? kEmptyString)
        dict["image4"] = HangoutVM.shared.stringToData(string: self.images?[4].image ?? kEmptyString)
        dict["image5"] = HangoutVM.shared.stringToData(string: self.images?[5].image ?? kEmptyString)
        dict["image6"] = HangoutVM.shared.stringToData(string: self.images?[6].image ?? kEmptyString)
        dict["image7"] = HangoutVM.shared.stringToData(string: self.images?[7].image ?? kEmptyString)
        dict["image8"] = HangoutVM.shared.stringToData(string: self.images?[8].image ?? kEmptyString)
        return dict
    }
    
}

//ImageDataModel
struct ImageDataModel {
    
    //var _id:String?
    var image:String?
    //var updatedAt:String?
   // var createdAt:String?


    init(detail:JSONDictionary) {
       // self._id = detail["_id"] as? String
        self.image = detail["image"] as? String
        //self.updatedAt = detail["updatedAt"] as? String
       // self.createdAt = detail["createdAt"] as? String

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
    var children_name_da:String?
    
    
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.childrenId = detail["children_id"] as? String
        self.image = detail["image"] as? String
        self.is_selected = detail["is_selected"] as? Bool
        self.children_name = detail["children_name"] as? String
        self.children_name_da = detail["children_name_da"] as? String

}
}

//educations model

struct educationsDataModel {
    var _id:String?
    var is_selected:Bool?
    var education_name:String?
    var education_name_da:String?
    init(detail:JSONDictionary)
    {
        self._id = detail["_id"] as? String
        self.is_selected = detail["is_selected"] as? Bool
        self.education_name = detail["education_name"] as? String
        self.education_name_da = detail["education_name_da"] as? String
   }
}


//hairs model

struct hairsDataModel {
    var _id:String?
    var is_selected:Bool?
    var hair_name:String?
    var hair_name_da:String?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.is_selected = detail["is_selected"] as? Bool
        self.hair_name = detail["hair_name"] as? String
        self.hair_name_da = detail["hair_name_da"] as? String
}
}

//unit model

struct unitDataModel {
    var _id:String?
    //var deletedAt:String?
    var unit:String?
    //var user_id:String?
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
       // self.deletedAt = detail["deletedAt"] as? String
       // self.user_id = detail["user_id"] as? String
        self.unit = detail["unit"] as? String
    
}
}


struct SecondTableLikeDislikeModel {
    var _id:String?
    var by_like_mode:String?
    var first_user_id:String?
    var hangout_id:String?
    
    var is_like_by_first_user_id:Int?
    var is_like_by_second_user_id:Int?
    var second_user_id:String?
    var story_id:String?
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.by_like_mode = detail["by_like_mode"] as? String
        self.first_user_id = detail["first_user_id"] as? String
        self.hangout_id = detail["hangout_id"] as? String
        
        self.is_like_by_first_user_id = detail["is_like_by_first_user_id"] as? Int
        self.is_like_by_second_user_id = detail["is_like_by_second_user_id"] as? Int
        self.second_user_id = detail["hangout_id"] as? String
        self.story_id = detail["story_id"] as? String
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
    var images:[String]? = []
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.deletedAt = detail["deletedAt"] as? String
        self.instagram_data = detail["instagram_data"] as? String//InstaSendModel
        self.user_id = detail["user_id"] as? String
        
        self.images = detail["images"] as? [String]
        
        //images = [String]()
        
//        for imag in detail["images"] as? NSArray ?? []
//        {
//            let imgStr = imag as? String ?? ""
//
//
//            self.images?.append(imgStr)
//        }
}
}



struct InstagramPostModel {
    var imageUrl:String = ""
    var PostType:String = ""
}



