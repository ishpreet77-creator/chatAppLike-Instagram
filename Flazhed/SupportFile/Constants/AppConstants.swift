//
//  AppConstants.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.

import Foundation
import UIKit

//MARK:- For testing
 //let BASE_URL = "http://192.168.3.169:3000/"


//MARK:- AWS New Client (Live) url
//

let BASE_URL = "http://3.16.108.232:3000/api/user/"
let SOCKET_URL = "http://3.16.108.232:3000/"


//MARK:- New Client (Live) url
//

//let BASE_URL = "http://3.141.165.222:3000/api/user/"
//let SOCKET_URL =  "http://3.141.165.222:3000"

//MARK:- For testing
//let BASE_URL =  "http://192.168.3.174:6001/api/user/"

//for WFH
//let BASE_URL =  "http://1.6.98.142:4009/api/user/"

//MARK:- For Office testing

//let SOCKET_URL =  "http://192.168.3.121:7005" // 6006 //7001 //7005
//let BASE_URL =  "http://192.168.3.121:7005/api/user/"
////////////

let APP_NAME = "Niirly"
let APP_LINK = "https://testflight.apple.com/join/12i5ZUzv"
let APP_WEBSITE_LINK = "https://niirly.com/"

let APP_MOTTO = "The dating app that gives you what you have the courage to ask for."

let TERM_URL = "http://niirly.com"
let Privacy_Policy_URL = "http://niirly.com"
let INSTAGRAM_URL="https://www.instagram.com/"

let AGORA_APP_ID = "4f41cf7988c047bfacd8b4896e108632"
let AGORA_App_Secret = "5d42b515eff14590b2c6cb2a7a5b878d"
var AGORA_TOKEN = "0064f41cf7988c047bfacd8b4896e108632IAAXm4cFOec0Vj2Jc9MGjgeLeNseX9pkauwqtufHx1jqAiPyfmgAAAAAEABF38j4qUDDYAEA6AOpX8Jg"



//let AGORA_APP_ID = "18e40f77d30343edaca3b0fb9a965fe4"
//let AGORA_App_Secret = "5d42b515eff14590b2c6cb2a7a5b878d"
//var AGORA_TOKEN = "00618e40f77d30343edaca3b0fb9a965fe4IABzO+J8U3cqxcZ4j3pDfWSweMhXgTDz4qOrzGzxdleiOT1Mz9oAAAAAEACqPfBqjnTlYAEAAQCNdOVg"


let ShareHangoutText = "Hey check out my hangout at https://testflight.apple.com/join/12i5ZUzv"
let ShareAppText = "Hey check out my app at https://testflight.apple.com/join/12i5ZUzv"

var AGORA_CHANEL_NAME = "Flazhed demo"
var AGORA_CHANEL_UID = "0"

// device types
let kDeviceType = "Ios"
let kDeviceToken = "1"

let kNudityCheck = 0.3
let kImagePercent:CGFloat = 45.0
let kLongImagePercent:CGFloat = 65.0
let kMinAge = 18
let kMaxAge = 100
let kTimeRing48 = 72

let kTimeRing = 4320
let kTimeRing24 = 1440

let kTimeLeft48 = 2880

let kCurrentCountryCode = "+45"

// App delegate


let TIMEZONE = TimeZone.current.identifier
var CALENDER = Calendar.current
var checkIsOnGoing = false
//headers
let kApplicationJson = "application/json"
let kContentType = "Content-Type"
let kAccept = "Accept"
let kAuthorization = "Authorization"

let kError = "Something went wrong. Try again."//"Error"

let kLoginSession = "Login session expire. Please login again."

let kEmptyString = ""
let kNotAvailable = "N/A"
let kSomethingWentWrong = "Something went wrong. Try again."

//Datamangers Keys
let kAccessToken = "token"
let kBusinessToken = "token"
let kIsUserLoggedIn = "isUserLoggedIn"
let kUserId = "User Id"
let kOtherUserId = "Other User Id"

let kUserName = "userName"
let kRefferalCode = "kRefferalCode"
let kInstaConnected = "kInstaConnected"
let kType = "type"
let kMessageType = "Text"
let kId = "id"
// StoryBoards
let kMain = "Main"
let kfromBack = "fromBack"
let kComeFrom = "Come From"
let kUserImage = "ProfileImage"
let kRemove = "Remove"
let kRemoveMatch = "removematch"
let kBlockMatch = "block"
let kProfileComplete = "user id"
let kShowLoader = "Show Loader"

let kfromVC = "login"
let kfaceIdAllow = "faceIdAllow"
let kImageCount = "Image count"

let kCountryName = "Country Name"


//App Const name

let kViewProfile = "View Profile"
let kReportPost = "Report Post"
let kBaseVC = "Base VC"
let kContinue = "Continue"
let kDiscard = "Discard"

let kDeletePost = "Delete Post"

let kRegret = "Regret"
let kExtraShakes = "Extra Shakes"
let kProlong = "Parlong"
let kProfile = "Profile"
let kChat = "Chat"
let kStory = "Story"
let kMatch = "Match"
let kAllMatch = "All Match"
let kPushToken = "Push Token"

//Paymeny Method
let kShake = "Shake"
let kSwiping = "Swiping"
let kParlong = "Parlong"


let kShare = "Share"
var kImage = "Image"
var kMyPost = "My post"
var kAllPost = "All Post"
let kCreate = "Hangout create"
var kSetting = "OPEN SETTING"

let kBothGender = "Male_Female"
let kPreference = "Preference"

// Edit Profile

let hairColorArray = ["Not Important","Black","Brown","Blonde","Auburn","Red","Grey","White","Bold"]
let educationArray = ["Elementary","High School","Bachelor","Master","Ph. D."] //"Not Important",
let kNotImportant="Not important"

let kToddler = "Toddler"
let kPreschool = "Preschool"
let kYoung = "Young"
let kTeen = "Teen"
let kAdult = "Adult"


var childrenNameArray = [kNotImportant,kToddler,kPreschool,kYoung,kTeen,kAdult]


let kFeet = "Feet & Inches"
let kInches = "Inches"
let kCentimeters = "Centimeters"
let kMeters = "Metric (meters)"

let unitsArray = [kFeet,kCentimeters]

let genderArray = ["Male","Female"]

 
let kPhD="Ph. D"

let kAccount = "Account"
let kDelete = "DELETE"

let kLogoutMessage = "Are you sure you want to logout?"
let kLocation = "Please enable location."

let kSettingMessage = "Please enable the camera, microphone and library permission from the settings."


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

let kCamera = "Camera"
let kHangout = "Hangout"
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
let kHomePage = "Home Page"
let kHome = "Home"
let kOk = "Ok"
let kGoogle = "Google"
let kFacebook = "Facebook"
let kEditProfile = "Edit Profile"
let kEdit = "EDIT"
let kSHARE = "SHARE"

let kGiphy = "giphy.com"


let kMale = "Male"
let kFemale = "Female"
let kCurrentUnit = "Current unit"

let kMessage = "MESSAGE"
let kDislikeProfile = "DISLIKE PROFILE"
let kLikeProfile = "LIKE PROFILE"
let kLikeStory = "LIKE STORY"

let kInterested = "INTERESTED"
let kNotInterested = "NOT INTERESTED"


let kEmptyImageAlert = "Please add minimum one image."
let kMaxImageAlert = "Please add minimum one image."
let kEmptyUserNameAlert = "Please enter name."
let kMinUserNameAlert = "Name must be at least 2 characters long."
let kEmptyDOBAlert = "Please select date of birth."

let kEmptyDOBAlert1 = "Please enter day."
let kEmptyDOBAlert2 = "Please enter month."
let kEmptyDOBAlert3 = "Please enter year."
let kEmptyDOBAlert4 = "Age should be between 18 to 100 years."
let kEmptyDOBAlert5 = "Please enter date of birth."

let kEmptyGenderAlert = "Please select gender."
let kEmptyAudioAlert = "No audio found to play."


let kMedia = "media"

let kShareFacebookAlert = "Do you want to share this post on facebook?"
let kInstallFacebookAlert = "It looks like you don't have the Facebook mobile app on your phone. Please install app to share."

let kMinBioAlert = "Bio must be at least 2 characters long."
let kMinJobTitleAlert = "Job title must be at least 2 characters long."
let kMinCompanyNameAlert = "Company name must be at least 2 characters long."
let kMinCityNameAlert = "City must be at least 2 characters long."

let kMinHeightAlert = "Height should not be lesser than 3 Feet 7 Inches."
let kMaxHeightAlert = "Height should not be greater than 8 Feet 2 Inches."

let kEmptyHeightAlert = "Please enter height."

let kDeleteImageAlert = "Are you sure you want to delete this image?"
let kDeletePostAlert = "Are you sure you want to delete this post?"
let kMinStoryAlert = "Video must be at least 3 seconds long."

let kEmptyEducationAlert = "Please select education."
let kEmptyChildAlert = "Please select children."
let kEmptyHairAlert = "Please select hair color."

let kDeleteAudioAlert = "Are you sure you want to delete this audio recording?"


let kEmptyBiolert = "Please enter bio."
let kEmptyJobTitlelert = "Please enter job title."

let kEmptyCompanyNamelert = "Please enter company name."
let kEmptyCitylert = "Please enter city."

let kEmptyHeightert = "Please enter height."

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
let kGif = "GIF"
let kText = "Text"
let kAudio = "Audio"
let kVideo = "Video"

let kHour = "Hour"
let kHours = "Hours"

let kMinute = "Minute"
let kMinutes = "Minutes"

let kSecond = "Second"
let kSeconds = "Seconds"



let kCallTry = "You tried to"
let kCallMissed = "Missed"
let kVideoSession = "You had a video call with "
let kAudioSession = "You had a audio call with "

let kCallAudioTry = "You tried to"

let kCallConnected = "Call connected"
let kCallDisConnected = "Call disconnected"


let kCommentedOn = "Commented on "

let kEmptyActive = "No active chat found."
let kEmptyInActive = "No inactive chat found."
let kMatchMessage = "You matched with "

let kOptionChoose = "Choose Option"
let kCopy = "Copy"
let kDeleteMessage = "Delete"

let kEndChat = "End Chat"
let kContinueChat = "Continue Chat"

let kTrue = "true"
let kProduct_id = "product_id"

let swipeMonthly = "com.swipe.monthly"
let swipeHalfYear = "com.swipe.halfyear"
let swipeYearly = "com.swipe.yearly"

//MARK:- For shake
let shakeOne = "com.shake.1"
let shakeThree = "com.shake.3"
let shakeFive = "com.shake.5"

//MARK:- For prolong chat

let prolongMonthly = "com.prolong.monthly"
let ProlongHalfyearly = "com.prolong.halfyearly"
let prolongYearly = "com.prolong.yearly"
let kPremium = "premium"

//MARK:- For URL Page

let kTermOfService = "Terms of Service"
let kPrivacyPolicy = "Privacy Policy"

let kPublisher = "publisher"
let kSubscriber = "subscriber"

let kCalling = "Calling"
let kConnected = "Connected"
//MARK:- For feedback changes

let kAnonymous = "Anonymous"


//Auth Section

let kVerification = "Verification"
let kVerificationSend = "We will send you an  to this mobile to verify."
let kOneTimePassword = "One Time Password"
let kToVerify = " to this mobile to verify."
let kPhoneNumber = "Phone Number"
let kOTPsent = "Enter the OTP sent to "

let kAddVoice = "Add Voice"
let kLeaveAShortVoice = "Leave a short voice recording of your normal voice. Around 3 - 5 seconds."
let kLeaveAShort = "Leave a short "
let kVoiceRecording = "voice recording"
let kVoiceAround = " of your normal voice. Around 3 - 5 seconds."

let kUsername = "Username"
let kARealName = "A real name helps other users "
let kYou = " you."
let kTrust = "trust"
let kName = "Name"

let kProfilePicture = "Profile Picture"
let kAddingAtLeast = "Adding at least 3 pictures increases your chance by "
let k20x = "20x."

let kGender = "Gender"
let kLetUs  = "Let us know your "
let kGender2 = "gender."

let kDateofBirth = "Date of Birth"
let kWeWill = "We will connect you with "
let klikeMinded = "like-minded"
let kPeople = " people."


