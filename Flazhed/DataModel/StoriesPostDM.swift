//
//  StoriesPostDM.swift
//  Flazhed
//
//  Created by IOS32 on 08/02/21.
//

import Foundation

struct StoriesPostDataModel {

    var _id:String?
    //var post_details:PostdetailModel?
  //  var profile_data:ProfileData?
   // var more_profile_details:MoreProfileDataModel?
   // var like_dislike:Like_DisLike_Model?
    
    
    var username:String?
    var userImage:String?
    var userImageData:Data?
    
    var voice:String?
    
    var file_name:String?
    var file_type:String?
    var thumbnail:String?
    var post_date_time:String?
    var post_text:String?
    var post_id:String?
    
    var user_id:String?
    var is_liked_by_other_user_id:Int?
    var like_dislike_name:String?
    var phone_number:Int?
    var country_code:String?
    var social_id:String?
    var social_type:String?
    var email:String?
    var is_block:Int?
    var device_type:String?
    var device_token:String?
    var is_shake_count:Int?

    
    var is_liked_by_self_user:Int?
    var story_like_by_self:Int?
    var chat_room_details:chat_room_Id_Model?
    var other_user_inactive_state:Int?
    
    init(detail:JSONDictionary) {
      
        
        self._id = detail["_id"] as? String
       

        let postDetail =  PostdetailModel.init(detail: (detail["post_details"] as? JSONDictionary) ?? [:])
        let profileDetail = OnlyImageNameProfileModel.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        
        if let name = profileDetail.username
        {
            self.username = name
            self.voice = profileDetail.voice
            self.userImage = profileDetail.image
        }
        else
        {
            self.username = detail["username"] as? String
            self.voice = detail["voice"] as? String
            self.userImage = detail["userImage"] as? String
            self.userImageData = detail["userImage"] as? Data
        }
        self.chat_room_details =  chat_room_Id_Model.init(detail: (detail["chat_room_details"] as? JSONDictionary) ?? [:])
        
        if postDetail.user_id != nil
        {
        self.user_id = postDetail.user_id
        self.file_type = postDetail.file_type
            let fileType = postDetail.file_type ?? kEmptyString
            self.file_name = postDetail.file_name
            
            
//            if kVideo.equalsIgnoreCase(string: self.file_type ?? kEmptyString) {
//                let videoURL =
//                    StoriesVM.shared.saveVideo(string: self.file_name ?? kEmptyString)
//                self.file_name  = videoURL.absoluteString
//            }

            
//            if kVideo.equalsIgnoreCase(string: fileType)
//            {
//                let videoURL =
//                    StoriesVM.shared.saveVideo(string: self.file_name ?? kEmptyString)
//                dict[APIKeys.kVideo] = videoURL
//            }
//            else
//            {
//
//            }
        
        self.thumbnail = postDetail.thumbnail
        self.post_date_time = postDetail.post_date_time
        self.post_text = postDetail.post_text
        self.post_id = postDetail._id
        }
        else
        {
            self.file_name = (detail["file_name"] as? URL)?.absoluteString
            self.file_type = (detail["file_type"] as? String)
            self.user_id = detail["user_id"] as? String
            
            self.thumbnail = detail["thumbnail"] as? String
            self.post_date_time = detail["post_date_time"] as? String
            self.post_text = detail["post_text"] as? String
            self.post_id = detail["post_id"] as? String
            
        }
        
          
          self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
          self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
          self.story_like_by_self = detail["story_like_by_self"] as? Int
        self.other_user_inactive_state = detail["other_user_inactive_state"] as? Int
        
        
        
        /*
        self._id = detail["_id"] as? String
        
        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        
        self.post_details = PostdetailModel.init(detail: (detail["post_details"] as? JSONDictionary) ?? [:])
    
        self.like_dislike_name = detail[ApiKey.kName] as? String
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.like_dislike = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        
        self.user_id = detail["user_id"] as? String
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
        
      
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        self.story_like_by_self = detail["story_like_by_self"] as? Int
        
        */
    }
    
    
    func json() -> Dictionary<String,Any> {
        var dict = [String: Any]()
        dict["_id"] = self._id
        
        dict["file_type"] = self.file_type
        dict["post_id"]  = self.post_id
        
        
        dict["thumbnail"] = self.thumbnail
        dict["post_date_time"]  = self.post_date_time
        
        dict["post_text"] = self.post_text
        dict["post_id"]  = self.post_id
        
        dict["is_liked_by_self_user"]  = self.is_liked_by_self_user
        
        dict["is_liked_by_other_user_id"] = self.is_liked_by_other_user_id
        dict["story_like_by_self"]  = self.story_like_by_self
        dict["username"]  = self.username
        dict["userImage"]  = self.userImage
    
        dict["userImageData"]  = HomeVM.shared.stringToData(string: self.userImage ?? kEmptyString)
        if kVideo.equalsIgnoreCase(string: self.file_type ?? kEmptyString) {
            let videoURL =
                StoriesVM.shared.saveVideo(string: self.file_name ?? kEmptyString)
            dict["file_name"]  = videoURL
        } else {
            dict["file_name"]  = self.file_name
        }
        return dict
    }
    
}


//post_details
struct PostdetailModel {
    
    var _id:String?
    var user_id:String?
    var file_type:String?
    var file_name:String?
    var post_text:String?
    //var deletedAt:String?
    var post_date_time:String?
    var thumbnail:String?
   // var is_block_by_admin:String?
    //var report_count:Int?
    
    init(detail:JSONDictionary) {
        self._id = detail["_id"] as? String
        self.user_id = detail["user_id"] as? String
        self.file_type = detail["file_type"] as? String
        self.file_name = detail["file_name"] as? String
        
        self.post_text = detail["post_text"] as? String
        //self.deletedAt = detail["deletedAt"] as? String
        
        self.post_date_time = detail["post_date_time"] as? String
        self.thumbnail = detail["thumbnail"] as? String
        
        //self.is_block_by_admin = detail["is_block_by_admin"] as? String
       // self.report_count = detail["report_count"] as? Int
       
    }
}

//post_details
struct Like_DisLike_Model {
    
    var _id:String?
    var chat_end_time_inactive:String?
    var chat_start_time_active:String?
    var first_user_id:String?
    var is_like_by_first_user_id:Int?
    var is_like_by_second_user_id:Int?
    var is_match:Int?
    var like_mode:String?
    var second_user_id:String?
    
    var like_mode_by_second_user:String?
    
    var like_mode_by_first_user:String?
    
    var is_continue_from_user:Int?
    var is_continue_to_user:Int?
    
    init(detail:JSONDictionary) {
        self.is_continue_to_user = detail["is_continue_to_user"] as? Int
        self.is_continue_from_user = detail["is_continue_from_user"] as? Int
        
        self._id = detail["_id"] as? String
        self.chat_end_time_inactive = detail["chat_end_time_inactive"] as? String
        self.chat_start_time_active = detail["chat_start_time_active"] as? String
        self.first_user_id = detail["first_user_id"] as? String
        
        self.is_like_by_first_user_id = detail["is_like_by_first_user_id"] as? Int
        self.is_like_by_second_user_id = detail["is_like_by_second_user_id"] as? Int
        self.is_match = detail["is_match"] as? Int
        
        self.like_mode = detail["like_mode"] as? String
        self.second_user_id = detail["second_user_id"] as? String
        
        self.like_mode_by_second_user = detail["like_mode_by_second_user"] as? String
        self.like_mode_by_first_user = detail["like_mode_by_first_user"] as? String
    }
}

//pagination_details

struct Pagination_Details_Model {
    
    var limit:Int?
    var offset:Int?
    var totalCount:Int?
    var totalPage:Int?
    
    init(detail:JSONDictionary) {
        self.limit = detail["limit"] as? Int
        self.offset = detail["offset"] as? Int
        self.totalCount = detail["totalCount"] as? Int
        self.totalPage = detail["totalPage"] as? Int
    }
}


struct StoriesListTypeModel
{
    var type:CellType?
    var storyData:StoriesPostDataModel?
}




struct SinglePostDataModel {

    
    var _id:String?
//    var post_details:PostdetailModel?
    var profile_data:ProfileData?
//    var like_dislike_name:String?
//    var more_profile_details:MoreProfileDataModel?
    var user_id:String?
//    var is_liked_by_other_user_id:Int?
//
//    var phone_number:Int?
//    var country_code:String?
//    var social_id:String?
//    var social_type:String?
//    var email:String?
//    var is_block:Int?
//    var device_type:String?
//    var device_token:String?
//    var is_shake_count:Int?
//
//    var like_dislike:Like_DisLike_Model?
//    var is_liked_by_self_user:Int?
//    var story_like_by_self:Int?
//
    var username:String?
    var userImage:String?
    var voice:String?
    
    var file_name:String?
    var file_type:String?
    var thumbnail:String?
    var post_date_time:String?
    var post_text:String?
    var post_id:String?
    
    
    
    
    
    init(detail:JSONDictionary) {
        
        self._id = detail["_id"] as? String

        
        let postDetail =  PostdetailModel.init(detail: (detail["single_post_details"] as? JSONDictionary) ?? [:])
        //let profileDetail = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
       // self.username = profileDetail.username ?? kEmptyString
        //self.voice = profileDetail.voice
        
        self.user_id = postDetail.user_id
        self.file_type = postDetail.file_type
        self.file_name = postDetail.file_name
        self.thumbnail = postDetail.thumbnail
        self.post_date_time = postDetail.post_date_time
        self.post_text = postDetail.post_text
        self.post_id = postDetail._id
    
        
      
        self.profile_data = ProfileData.init(detail: (detail["profile_data"] as? JSONDictionary) ?? [:])
        /*
        self.like_dislike_name = detail[ApiKey.kName] as? String
        self.more_profile_details = MoreProfileDataModel.init(detail: (detail["more_profile_details"] as? JSONDictionary) ?? [:])
        self.user_id = detail["user_id"] as? String
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
        
        self.like_dislike = Like_DisLike_Model.init(detail: (detail["like_dislike"] as? JSONDictionary) ?? [:])
        self.is_liked_by_other_user_id = detail["is_liked_by_other_user_id"] as? Int
        self.is_liked_by_self_user = detail["is_liked_by_self_user"] as? Int
        self.story_like_by_self = detail["story_like_by_self"] as? Int
        
        */
    }
}



struct Facebook_login_Model {
    
    var facebook_data:String?
    var user_id:String?
    var username:String?
    var images:[String]? = []
    
    
    init(detail:JSONDictionary) {
        self.facebook_data = detail["facebook_data"] as? String
        self.user_id = detail["user_id"] as? String
        self.username = detail["username"] as? String
        self.images = detail["images"] as? [String]
    }
}


struct chat_room_Id_Model {
    
    var _id:String?

    init(detail:JSONDictionary) {

        self._id = detail["_id"] as? String
        
    }
}

