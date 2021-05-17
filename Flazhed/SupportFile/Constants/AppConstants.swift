//
//  AppConstants.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.

import Foundation
import UIKit

//MARK:- For testing
 //let BASE_URL = "http://192.168.3.169:3000/"

//MARK:- For Live
//let BASE_URL = "http://18.216.112.121:3000/api/user/"
//New live url

let BASE_URL = "http://3.141.165.222:3000/api/user/"

//MARK:- For testing
//let BASE_URL =  "http://192.168.3.174:6001/api/user/"

let SOCKET_URL =  "http://192.168.3.174:6001"

//let BASE_URL =  "http://192.168.3.174:6005/api/user/"
// device types
let kDeviceType = "Ios"
let kDeviceToken = "1"

let kNudityCheck = 0.3
let kMinAge = 18
let kMaxAge = 100

let kCurrentCountryCode = "+45"

// App delegate


let TIMEZONE = TimeZone.current.identifier 

var checkIsOnGoing = false
//headers
let kApplicationJson = "application/json"
let kContentType = "Content-Type"
let kAccept = "Accept"
let kAuthorization = "Authorization"



let kError = "Error"
let kEmptyString = ""
let kNotAvailable = "N/A"
let kSomethingWentWrong = "Something went wrong."

//Datamangers Keys
let kAccessToken = "token"
let kBusinessToken = "token"
let kIsUserLoggedIn = "isUserLoggedIn"
let kUserId = "User Id"
let kUserName = "userName"
let kRefferalCode = "kRefferalCode"
let kInstaConnected = "kInstaConnected"
let kType = "type"
let kId = "id"
// StoryBoards
let kMain = "Main"
let kfromBack = "fromBack"
let kComeFrom = "Come From"
let kUserImage = "ProfileImage"
let kRemove = "Remove"
let kProfileComplete = "user id"
let kShowLoader = "Show Loader"

let kfromVC = "login"
let kfaceIdAllow = "faceIdAllow"
let kImageCount = "Image count"

let kCountryName = "Country Name"


//App Const name

let kViewProfile = "View Profile"
let kReportPost = "Report Post"

let kContinue = "Continue"
let kDiscard = "Discard"

let kDeletePost = "Delete Post"

let kRegret = "Regret"
let kExtraShakes = "Extra Shakes"
let kProlong = "Prolong"
let kProfile = "Profile"
let kChat = "Chat"
let kStory = "Story"
let kMatch = "Match"
let kAllMatch = "All Match"
let kVideo = "video"

let kShake = "Shake"
let kShare = "Share"
var kImage = "Image"
var kMyPost = "My post"
var kAllPost = "All Post"
let kCreate = "Hangout create"

let kBothGender = "Male_Female"


// Edit Profile

let hairColorArray = ["Not Important","Black","Brown","Blonde","Auburn","Red","Grey","White","Bold"]
let educationArray = ["Elementary","High School","Bachelor","Master","Ph. D."] //"Not Important",
let kFeet = "Feet & Inches"
let kInches = "Inches"
let kCentimeters = "Centimeters"
let kMeters = "Metric (meters)"

let unitsArray = [kFeet,kCentimeters]

let genderArray = ["Male","Female"]

 
let kNotImportant="Not important"
let kAccount = "Account"
let kDelete = "Delete"

let kLogoutMessage = "Are you sure you want to logout?"
let kLocation = "Please enable location."

let kCancel = "Cancel"
let kYes = "Yes"
let kMonthly = "Monthly"
let kSixMonthly = "Six Monthly"
let kYearly = "Yearly"

let kSocial = "Social"
let kTravel = "Travel"
let kSports = "Sports"
let kBusiness = "Business"
let kHangoutType =  [kSocial,kTravel,kSports,kBusiness]


let kWomen = "FEMALE"
let kMen = "MALE"
let kMenShort = "Men"
let kLatest = "LATEST FIRST"
let kOldest = "OLDEST FIRST"

let kAscending = "ASCENDING AGE"
let kDescending = "DESCENDING AGE"
let kfromHangout = "Create hangout"

let kClatest = "latest"
let kCunread = "unread"
let kCclosest = "closest"

let kHangoutSort =  [kSocial,kTravel,kSports,kBusiness,kWomen,kMen,kLatest,kOldest,kAscending,kDescending]
let kEmptyPhoneAlert = "Please enter phone number."
let kEmptyFeedbackAlert = "Please enter feedback."
let kEmptyDescriptionAlert = "Description must be at least 2 characters long."
let kMinDescriptionAlert = "Please enter description."
let kEmptyOTPAlert = "Please enter OTP."
let kOTPValidAlert = "Please enter valid OTP."
let kEmptyCountryCodeAlert = "Please select country."
let kSucess = "success"
let kAlert = "Alert"
let kAppDelegate = "App delegate"
let kOk = "Ok"
let kGoogle = "Google"
let kFacebook = "Facebook"
let kEditProfile = "Edit Profile"
let kEdit = "EDIT"
let kMale = "Male"
let kFemale = "Female"
let kCurrentUnit = "Current unit"

let kMessage = "MESSAGE"
let kDislikeProfile = "DISLIKE PROFILE"
let kLikeProfile = "LIKE PROFILE"

let kInterested = "INTERESTED"
let kNotInterested = "NOT INTERESTED"


let kEmptyImageAlert = "Please add minimum one image."
let kMaxImageAlert = "Please add minimum one image."
let kEmptyUserNameAlert = "Please enter name."
let kMinUserNameAlert = "Name must be at least 2 characters long."
let kEmptyDOBAlert = "Please select date of birth."
let kEmptyGenderAlert = "Please select gender."
let kEmptyAudioAlert = "No audio found to play."


let kMedia = "media"

let kShareFacebookAlert = "Do you want to share this post on facebook?"
let kInstallFacebookAlert = "It looks like you don't have the Facebook mobile app on your phone. Please install app to share."

let kMinBioAlert = "Bio must be at least 2 characters long."
let kMinJobTitleAlert = "Job title must be at least 2 characters long."
let kMinCompanyNameAlert = "Company name must be at least 2 characters long."
let kMinCityNameAlert = "City name must be at least 2 characters long."

let kMinHeightAlert = "Height should not be lesser than 3 Feet 7 Inches."
let kMaxHeightAlert = "Height should not be greater than 8 Feet 2 Inches."


let kDeleteImageAlert = "Are you sure you want to delete this image?"
let kDeletePostAlert = "Are you sure you want to delete this post?"
let kMinStoryAlert = "Video must be at least 3 seconds long."

let kEmptyEducationAlert = "Please select education."

//MARK:- Hangout section

let kEmptyHangoutImageAlert = "Please upload hangout image."
let kEmptyHangoutTypeAlert = "Please select hangout type."
let kEmptyHangoutHeadingAlert = "Please enter hangout heading."
let kEmptyHangoutDescAlert = "Please enter hangout description."

let kMinHangoutHeadingAlert = "Hangout heading must be at least 2 characters long."
let kMinHangoutDescAlert = "Hangout description must be at least 2 characters long."


let kEmptyHangoutDateAlert = "Please select hangout date."
let kEmptyHangoutTimeAlert = "Please select hangout time."
let kEmptyHangoutPlaceAlert = "Please select hangout place."
let kEmptyPlaceDescAlert = "Enter Additional Description (optional)"

let kEmptyLookingForAlert = "Please select looking for."

let kImageCkeckAlert = "This image contains inappropriate content. Please upload another image."
let kShakeMessageAlert = "Shake sent."

//MARK:- Chat

let kEmptyMessage = "Please enter message."
