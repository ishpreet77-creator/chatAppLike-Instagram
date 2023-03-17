//
//  ApiKey.swift
//  Flazhed
//
//  Created by IOS22 on 18/01/21.
//

import Foundation
import Foundation

class ApiKey {
    //general
    static let kMessage = "message"
    static let kStatus = "status"
    
    static let kResponse = "response"
    static let kResponse2 = "response"
    static let kData = "data"
    static let kToken = "token"
    
    // notification
    // notification
    static let kAps = "aps"
    static let kDetails =  "details"
    static let kNotifyKey =  "Notifykey"
    static let kDeviceType = "1"
    //MARK: - Send OTP
    static let kOTPDATA = "saveOTPData"
    static let kPhoneNumber = "phone_number"
    static let kCountryCode = "country_code"
    static let kOtp = "otp"
    static let kId = "id"
    static let kBirthday = "birthday"
    
    static let k_Id = "_id"
    static let kChildrenId = "children_id"
    static let kDevicetype = "device_type"
    static let KDeviceToken = "device_token"
    static let KVoip_device_token = "voip_device_token"
    //MARK: - Verify OTP
    static let kUser = "user"
    static let kAuthToken = "authToken"
    static let kDeletedAt = "deletedAt"
    static let kEmail = "email"
    static let kIs_block = "is_block"
    static let kSocial_id = "social_id"
    static let kSocial_type = "social_type"
    
    //MARK: - Social Login

    //MARK: Facebook
    static let kPicture = "picture"
    static let kURL = "url"
    static let kProfilePicture = "profile_picture"
    static let kFacebookName = "facebook_name"
    static let kFacebookFriends = "facebook_friends"
    static let kImage = "image"
    static let kName = "name"
    
    //MARK: Complete Profile
    
    static let kTimezone = "timezone"
    static let kUsername = "username"
    static let kfrom_story_only = "from_story_only"
    
    static let kDOB = "dob"
    static let kLatitude = "latitude"
    static let kLongitude = "longitude"
    static let kImages = "images"
    static let kVoice = "voice"
    static let kGender = "gender"
    static let kPurchasePlan = "Purchase Plan"
    //MARK: get Profile
    
    static let kProfile_data = "profile_data"
    static let kIsBlock = "is_block"
    static let kHttps = "http://"
    
    //MARK: get preference
    static let kPreference = "preference"
    static let kchildrens = "childrens"
    static let keducations = "educations"
    static let khairs = "hairs"
    
    static let kBio = "bio"
    
    //MARK: set preference
    static let kshow = "show"
    static let kfrom_age = "from_age"
    static let kto_age = "to_age"
    static let kfrom_height = "from_height"
    static let kto_height = "to_height"
    static let keducation_id = "education_id"
    static let kchildren_id = "children_id"
    static let khair_ids = "hair_ids"
    
    static let khair_name = "hair_name"
    static let keducation_name = "education_name"
    static let kchildren_name = "children_name"
    static let kis_selected = "is_selected"
    static let kEducation_selected = "education_selected"
    static let kChildren_selected = "children_selected"
    static let kHair_selected = "hair_selected"
    
    //MARK: - Home page
    
    static let kOffset = "offset"
    static let kUsers = "users"
    static let kShakeUser = "send_shake_id"
    
    static let kOther_user_id = "other_user_id"
    static let kStoryId = "story_id"
  
    static let kAction = "action"
    static let kLike_mode = "like_mode"
    static let kStory_Id = "story_id"
    static let kHangout_Id = "hangout_id"
    //MARK: - Edit profile
    static let kAge = "age"
    static let kJob_title = "job_title"
    static let kCompany_name = "company_name"
    
    static let kCity = "city"
    static let kEducation_id = "education_id"
    static let kHair_id = "hair_id"
    static let kChildren_id = "children_id"
    static let kChildren_ids = "children_ids"
    
    static let kCity_latitude = "city_latitude"
    static let kCity_longitude = "city_longitude"
    static let kHeight = "height"
    
    
    //MARK: - Unit
    
    static let kUnit = "unit"
    static let kNotification_settings = "notification_settings"
    
    static let knew_message_push = "new_message_push"
    static let knew_matches_push = "new_matches_push"
    static let knew_like_push = "new_like_push"
    static let knew_hangout_push = "new_hangout_push"
    
    static let knew_message_mail = "new_message_mail"
    static let knew_matches_mail = "new_matches_mail"
    static let knew_like_mail = "new_like_mail"
    static let knew_hangout_mail = "new_hangout_mail"
    static let kteam_flazhed = "team_flazhed"
    static let knew_shake_push = "new_shake_push"
    
    static let kUser_id = "user_id"
    
    
    //MARK: - Post stories
    
    static let kPost_listing = "post_listing"
    static let kPosts = "posts"
    static let kPost_details = "post_details"
    static let kPost_text = "post_text"
    static let kFile_name = "file_name"
    static let kFile_type = "file_type"
    static let kThumbnail = "thumbnail"
    static let kPagination_details = "pagination_details"
    
    
    
    static let kPost_id = "post_id"
    static let kReason_text = "reason_text"
    static let kBlock_status = "block_status"
    
    static let kfilter_my_post = "filter_my_post"
    static let kfilter_matched_profile = "filter_matched_profile"
    static let kfilter_all_post = "filter_all_post"
    static let kfilter_img = "filter_img"
    static let kfilter_video = "filter_video"
   
    //MARK: - Facebook data
    
    static let kFacebook_data = "facebook_data"
    static let kInstagram_data = "instagram_data"
    
    
    //MARK: - Hangout
    
    static let kHangout_listing = "hangout_listing"
    static let kSubscription_id = "subscription_id"
    static let kTransaction_id = "transaction_id"
    
    static let kHangout_type = "hangout_type"
    static let kHeading = "heading"
    static let kDescription = "description"
    
    static let kDate = "date"
    static let kTime = "time"
    static let kPlace = "place"
    
    static let kAditional_description = "aditional_description"
    static let kLooking_for = "looking_for"
    
    static let kAge_from = "age_from"
    static let kAge_to = "age_to"
    static let kHangout_id = "hangout_id"
    static let kHangout_details = "hangout_details"
    static let kFilter_type = "filter_type"
    static let kIs_like = "is_like"
    
    static let kAction_type = "action_type"
    
    
    
    static let ksocial = "social"
    static let ktravel = "travel"
    static let kbusiness = "business"
    static let ksport = "sport"
    static let kman = "man"
    static let kwomen = "women"
    static let klatest_first = "latest_first"
    static let kolder_first = "older_first"
    static let kascending_age = "ascending_age"
    static let kdescending_age = "descending_age"
    
    //MARK: - Chat module
    static let kMatched_profile = "matched_profile"
    static let kOpen_status = "open_status"
    static let kFilter = "filter"
    static let kChat_room_details = "chat_room_details"
    static let kChat_room = "chat_room"
    static let kChat_details = "chat_details"
    static let kChat_room_id = "chat_room_id"
    static let kFindLikeDislike = "findLikeDislike"
    
    static let kAmount = "amount"
    static let kSubscription_type = "subscription_type"
    static let kSubName = "name"
    static let kExtra_shake = "extra_shake"
    static let kMonth_up_to = "month_up_to"
    
    static let kShake_radius = "shake_radius"
    
    
    static let kParlong = "Parlong"
    static let kSwiping = "Swiping"
    static let kShake = "Shake"
    
    
    static let kHangout = "Hangout"
    static let kStory = "Story"
    static let kChating = "Chating"
    
    
    
    static let kTo_user_id = "to_user_id"
    static let kCall_type = "call_type"
    static let kRole_type = "role_type"
    static let kRegret_type = "type"
    
    
// MARK: Core Data Manager Keys
    static let kAppName = "Flazhed"
    static let kHangouts = "hangouts"
    static let kHangoutListing = "HangoutListing"
    static let kappData = "appData"
    
    static let kStoryListing = "StoryListing"
    static let kStories = "stories"
    
    static let kMyProfile = "MyProfile"
    static let kOwnProfile = "OwnProfile"
    static let kProfileDetails = "profileDetails"
    
    static let kCoreDataEnLtityArray:[String] = [kHangoutListing,kMyProfile,kOwnProfile,kStoryListing]
    
    static let kChatData = "ChatData"
    static let kChatDetails = "chatDetails"
}
