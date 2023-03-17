//
//  AppConstants.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.

import Foundation
import UIKit


//MARK: - For Office testing
//let SOCKET_URL =  "http://192.168.3.174:3000"

//MARK: - For live app

let SOCKET_URL =  "https://app.niirly.com"

let BASE_URL = SOCKET_URL+"/api/user/"

//let IMAGE_BASE_URL =  SOCKET_URL+"/"

let IMAGE_BASE_URL =  SOCKET_URL+"/"

let kHangoutTale = IMAGE_BASE_URL+"hangout/"
let kstoryTale = IMAGE_BASE_URL+"story/"
let kHangoutBack = "hangout/"
let kStoryBack = "story/"
//////////////

let APP_NAME = "Niirly"
let APP_LINK = "https://testflight.apple.com/join/12i5ZUzv"
let APP_WEBSITE_LINK = "https://niirly.com/"

let APP_SHARE_LINK = "Im inviting you to join Niirly, a community where you find and meet users in a short radius. Install the app with the following link: https://wfczs.app.link/efANhMRKYlb".localized()//"Say goodbye to fake and superficial photo-centric dating apps lacking traits of personality.Say Hello to a dating community matching with people based on personality, common interests and chemistry!. Install the app with following link: https://wfczs.app.link/efANhMRKYlb".localized()


let APP_MOTTO = "The dating app that gives you what you have the courage to ask for.".localized()

let TERM_URL = "https://niirly.com/Services/Terms.html"
let Privacy_Policy_URL = "https://niirly.com/Services/Privacypolicy.html"
let INSTAGRAM_URL="https://www.instagram.com/"
let APP_ADMIN_EMAIL = "admin@niirly.com"
let APP_HELP_SUBJECT = "Niirly Help".localized()
let APP_HELP_MESSAGE = "Please share your query here with your name and phone number and we will help you to solve this issue.".localized()

//MARK: - For live app

let APP_ADS_ID = "ca-app-pub-9730116356670864/5503166982"
//MARK: - For testing app
//let APP_ADS_ID = "ca-app-pub-3940256099942544/2934735716"

let AGORA_APP_ID = "4f41cf7988c047bfacd8b4896e108632"
let AGORA_App_Secret = "5d42b515eff14590b2c6cb2a7a5b878d"
var AGORA_TOKEN = "0064f41cf7988c047bfacd8b4896e108632IAAXm4cFOec0Vj2Jc9MGjgeLeNseX9pkauwqtufHx1jqAiPyfmgAAAAAEABF38j4qUDDYAEA6AOpX8Jg"



//let AGORA_APP_ID = "18e40f77d30343edaca3b0fb9a965fe4"
//let AGORA_App_Secret = "5d42b515eff14590b2c6cb2a7a5b878d"
//var AGORA_TOKEN = "00618e40f77d30343edaca3b0fb9a965fe4IABzO+J8U3cqxcZ4j3pDfWSweMhXgTDz4qOrzGzxdleiOT1Mz9oAAAAAEACqPfBqjnTlYAEAAQCNdOVg"


let ShareHangoutText = "Hey check out my hangout at https://testflight.apple.com/join/12i5ZUzv".localized()
let ShareAppText = "Hey check out my app at https://testflight.apple.com/join/12i5ZUzv".localized()

var AGORA_CHANEL_NAME = "Flazhed demo"
var AGORA_CHANEL_UID = "0"

// device types
let kDeviceType = "Ios"
let kDeviceToken = "1"
let kHttp = "http://"
let kHttps = "https://"



// App delegate


//headers
let kApplicationJson = "application/json"
let kContentType = "Content-Type"
let kAccept = "Accept"
let kAuthorization = "Authorization"

let kError = "Your internet connection appears to be offline. Please try again.".localized()//"Something went wrong. Try again."//"Error"

let kLoginSession = "Login session expire. Please login again.".localized()

let kEmptyString = ""
let kNotAvailable = "N/A"
let kSomethingWentWrong = "Your internet connection appears to be offline. Please try again.".localized()//"Something went wrong. Try again."

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

let kSimple = "Simple".localized()
let kRunningOut = "run out".localized()
let kHangoutTypes = "Hangout Types".localized()
let kNumberofInterested = "Number of Interested".localized()


let kNumberofStories = "Number of Stories".localized()
let kDailyShakes = "Daily Shakes".localized()
let kBasicFree = "Basic Free".localized()
let kExtraChats = "Extra Chats".localized()
let kExtraCall = "Extra Calls".localized()
let ksimultaneouschats = "You have run out of simultaneous chats.".localized()
let ksimultaneousCall = "You have run out of video calls.".localized()
let kStoryVideo = "You have run out of story video.".localized()
let kStoryImage = "You have run out of story image.".localized()

let kGetMore = "GET MORE".localized()


let kfromVC = "login"
let kfaceIdAllow = "faceIdAllow"
let kImageCount = "Image count"

let kCountryName = "Country Name".localized()


//App Const name

let kViewProfile = "View Profile"
let kReportPost = "Report Post".localized()
let kBaseVC = "Base VC"
let kContinue = "Continue".localized()
let kDiscard = "Discard".localized()

let kDeletePost = "Delete Post".localized()

let kRegret = "Regret".localized()
let kExtraShakes = "Extra Shakes".localized()
let kProlong = "Parlong".localized()
let kProfile = "Profile".localized()
let kChat = "Chat".localized()
let kChating = "Chating".localized()
let kStory = "Story".localized()
let kMatch = "Match".localized()
let kAllMatch = "All Match".localized()
let kPushToken = "Push Token"

let kMessageList = "Message List"

let kStories = "Stories"

//Paymeny Method
let kShake = "Shake"
let kSwiping = "Swiping"
let kParlong = "Parlong"


let kShare = "Share".localized()
var kImage = "Image".localized()
var kMyPost = "My post".localized()
var kAllPost = "All Post".localized()
let kCreate = "Hangout create".localized()
var kSetting = "OPEN SETTINGS".localized()

let kBothGender = "Male_Female"
let kPreference = "Preference"

// Edit Profile

let kNotImportant="Not important"//.localized()

let kToddler = "Toddler"//.localized()
let kPreschool = "Preschool"//.localized()
let kYoung = "Young"//.localized()
let kTeen = "Teen"//.localized()
let kAdult = "Adult"//.localized()

let kBlack = "Black"//.localized()
let kBrown = "Brown"//.localized()
let kBlonde = "Blonde"//.localized()
let kAuburn = "Auburn"//.localized()
let kRed = "Red"//.localized()
let kGrey = "Grey"//.localized()
let kWhite = "White"//.localized()
let kBold = "Bold"//.localized()
let hairColorArray = [kNotImportant,kBlack,kBrown,kBlonde,kAuburn,kRed,kGrey,kWhite,kBold]


let kElementary = "Elementary"//.localized()
let kHighSchool = "High School"//.localized()
let kBachelor = "Bachelor"//.localized()
let kMaster = "Master"//.localized()
let kMPhD = "Ph. D."//.localized()

let educationArray = [kElementary,kHighSchool,kBachelor,kMaster,kPhD]
var childrenNameArray = [kNotImportant,kToddler,kPreschool,kYoung,kTeen,kAdult]




let kFeet = "Feet & Inches"//.localized()
let kInches = "Inches"//.localized()
let kCentimeters = "Centimeters"
let kMeters = "Metric (meters)"

let kHEIGHTIn = "HEIGHT (In Centimeters)".localized()

let unitsArray = [kFeet,kCentimeters]



 
let kPhD="Ph. D"//.localized()

let kAccount = "ACCOUNT".localized()
let kDelete = "DELETE".localized()




let kCancel = "Cancel".localized()
let kYes = "Yes".localized()
let kMonthly = "Monthly".localized()
let kSixMonthly = "Six Monthly".localized()
let kYearly = "Yearly".localized()




let kFree = "Free".localized()
let kPlus = "Plus".localized()
let kGold = "Gold".localized()
let kPlatinum = "Platinum".localized()



let kSocial = "Social".localized()
let kTravel = "Travel".localized()
let kSports = "Sports".localized()
let kBusiness = "Business".localized()
let kHangoutType =  [kSocial,kTravel,kSports,kBusiness]

let kCamera = "Camera".localized()
let kHangout = "Hangout".localized()
let kWomen = "WOMEN"
let kMen = "MEN"
let kMan1 = "Man"
let kWoman1 = "Woman"
let kMenShort = "Men".localized()
let kWomenShort = "Women".localized()
let kLatest = "LATEST FIRST".localized()
let kOldest = "OLDEST FIRST".localized()

let kAscending = "ASCENDING AGE".localized()
let kDescending = "DESCENDING AGE".localized()
let kfromHangout = "Create hangout".localized()

let kClatest = "latest"//.localized()
let kCunread = "unread"//.localized()
let kCclosest = "closest"//.localized()

let kSucess = "success"//.localized()
let kAlert = "Alert".localized()
let kAppDelegate = "App delegate"
let kHomePage = "Home Page"
let kHome = "Home"
let kOk = "Ok".localized()
let kGoogle = "Google".localized()
let kFacebook = "Facebook".localized()
let kEditProfile = "Edit Profile".localized()
let kEdit = "EDIT".localized()
let kSHARE = "SHARE".localized()

let kGiphy = "giphy.com"


let kMale = "Male"
let kFemale = "Female"

let genderArray = [kMale,kFemale]

let kCurrentUnit = "Current unit".localized()

let kMessage = "MESSAGE"//.localized()
let kMessages = "Messages".localized()
let kDislikeProfile = "DISLIKE PROFILE".localized()
let kLikeProfile = "LIKE PROFILE".localized()
let kLikeStory = "LIKE STORY".localized()

let kInterested = "INTERESTED".localized()
let kNotInterested = "NOT INTERESTED".localized()
let kInternet = "Internet".localized()

let kLogoutMessage = "Are you sure you want to logout?".localized()
let kCameraSetting = "Please enable the camera permission from the settings.".localized()
let kLocationSetting = "Please enable the location permission from the settings.".localized()//"Please enable location."
let kLocation = "Please enable location.".localized()

let kSettingMessage = "Please enable the camera, microphone and library permission from the settings.".localized()
let kusername = "Enter Username".localized()

let kHangoutSort =  [ksocial,ktravel,ksport,kbusiness,kWomen,kMen,kLatest,kOldest,kAscending,kDescending]
let kEmptyPhoneAlert = "Please enter phone number.".localized()
let kEmptyFeedbackAlert = "Please enter feedback.".localized()
let kEmptyDescriptionAlert = "Description must be at least 2 characters long.".localized()
let kMinDescriptionAlert = "Please enter description.".localized()
let kEmptyOTPAlert = "Please enter OTP.".localized()
let kOTPValidAlert = "Please enter valid OTP.".localized()
let kEmptyCountryCodeAlert = "Please select country.".localized()

let kEmptyImageAlert = "Please add minimum two image.".localized()
let kMaxImageAlert = "Please add minimum one image.".localized()
let kEmptyUserNameAlert = "Please enter name.".localized()
let kMinUserNameAlert = "Name must be at least 2 characters long.".localized()
let kEmptyDOBAlert = "Please select date of birth.".localized()

let kEmptyDOBAlert1 = "Please enter day.".localized()
let kEmptyDOBAlert2 = "Please enter month.".localized()
let kEmptyDOBAlert3 = "Please enter year.".localized()
let kEmptyDOBAlert4 = "Age should be between 16 to 100 years.".localized()
let kEmptyDOBAlert5 = "Please enter date of birth.".localized()

let kEmptyGenderAlert = "Please select gender.".localized()
let kEmptyAudioAlert = "No audio found to play.".localized()


let kMedia = "media"

let kShareFacebookAlert = "Do you want to share this post on facebook?".localized()
let kInstallFacebookAlert = "It looks like you don't have the Facebook mobile app on your phone. Please install app to share.".localized()

let kMinBioAlert = "Bio must be at least 2 characters long.".localized()
let kMinJobTitleAlert = "Job title must be at least 2 characters long.".localized()
let kMinCompanyNameAlert = "Company name must be at least 2 characters long.".localized()
let kMinCityNameAlert = "City must be at least 2 characters long.".localized()

let kMinHeightAlert = "Height should not be lesser than 3 Feet 7 Inches.".localized()
let kMaxHeightAlert = "Height should not be greater than 8 Feet 2 Inches.".localized()

let kEmptyHeightAlert = "Please enter height.".localized()

let kDeleteImageAlert = "Are you sure you want to delete this image?".localized()
let kDeletePostAlert = "Are you sure you want to delete this post?".localized()
let kMinStoryAlert = "Video must be at least 3 seconds long.".localized()

let kEmptyEducationAlert = "Please select education.".localized()
let kEmptyChildAlert = "Please select children.".localized()
let kEmptyHairAlert = "Please select hair color.".localized()

let kDeleteAudioAlert = "Are you sure you want to delete this audio recording?".localized()


let kEmptyBiolert = "Please enter bio.".localized()
let kEmptyJobTitlelert = "Please enter job title.".localized()

let kEmptyCompanyNamelert = "Please enter company name.".localized()
let kEmptyCitylert = "Please enter city.".localized()

let kEmptyHeightert = "Please enter height.".localized()

//MARK: - Hangout section

let kEmptyHangoutImageAlert = "Please upload hangout image.".localized()
let kEmptyHangoutTypeAlert = "Please select hangout type.".localized()
let kEmptyHangoutHeadingAlert = "Please enter hangout heading.".localized()
let kEmptyHangoutDescAlert = "Please enter hangout description.".localized()

let kMinHangoutHeadingAlert = "Hangout heading must be at least 2 characters long.".localized()
let kMinHangoutDescAlert = "Hangout description must be at least 2 characters long.".localized()


let kEmptyHangoutDateAlert = "Please select hangout date.".localized()
let kEmptyHangoutTimeAlert = "Please select hangout time.".localized()
let kEmptyHangoutPlaceAlert = "Please select hangout place.".localized()
let kEmptyPlaceDescAlert = "Enter Additional Description (optional)".localized()

let kEmptyLookingForAlert = "Please select looking for.".localized()

let kImageCkeckAlert = "This image contains inappropriate content. Please upload another image.".localized()

let kImageFacebookCount = "You can select maximum 10 images.".localized()

let kShakeMessageAlert = "Shake sent.".localized()

//MARK: - Chat

let kEmptyMessage = "Please enter message.".localized()
let kGif = "GIF"
let kText = "Text"
let kAudio = "Audio"
let kVideo = "Video"

let kHour = "Hour".localized()
let kHours = "Hours".localized()

let kMinute = "Minute".localized()
let kMinutes = "Minutes".localized()

let kSecond = "Second".localized()
let kSeconds = "Seconds".localized()



let kCallTry = "You tried to".localized()
let kCallMissed = "Missed".localized()
let kVideoSession = "You had a video call with ".localized()
let kAudioSession = "You had a audio call with ".localized()

let kCallAudioTry = "You tried to".localized()

let kCallConnected = "Call connected".localized()
let kCallDisConnected = "Call disconnected".localized()

let kOfflieMessage = "You are offline.".localized()
let kOnlineMessage = "You are online.".localized()

let kCommentedOn = "Commented on ".localized()

let kEmptyActive = "No active chat found.".localized()
let kEmptyInActive = "No inactive chat found.".localized()
let kMatchMessage = "You matched with ".localized()

let kOptionChoose = "Choose Option".localized()
let kCopy = "Copy".localized()
let kDeleteMessage = "Delete".localized()

let kEndChat = "End Chat".localized()
let kContinueChat = "Continue Chat".localized()

let kTrue = "true".localized()
let kProduct_id = "product_id"

let swipeMonthly = "com.swipe.monthly"
let swipeHalfYear = "com.swipe.halfyear"
let swipeYearly = "com.swipe.yearly"

//MARK: - For shake
let shakeOne = "com.shake.1"
let shakeThree = "com.shake.3"
let shakeFive = "com.shake.5"

//MARK: - For prolong chat

let prolongMonthly = "com.prolong.monthly"
let ProlongHalfyearly = "com.prolong.halfyearly"
let prolongYearly = "com.prolong.yearly"
let kPremium = "premium"



let kPublisher = "publisher"
let kSubscriber = "subscriber"

let kCalling = "Calling".localized()
let kConnected = "Connected".localized()
//MARK: - For feedback changes

let kAnonymous = "Anonymous".localized()


//Auth Section

//MARK: - Login

let kWelcome = "Welcome".localized()
let kDatingDesc = "Dating app with actual dating :)".localized()
let kByContinuing = "By continuing, you agree to our ".localized()
let kAnd = " & ".localized()
let kLogInWithGoogle = "Log In with Google".localized()
let kLogInWithFacebook = "Log In with Facebook".localized()
let kLogInWithMobile = "Log In with Mobile".localized()
let kPLAY = "PLAY".localized()
let kPressAndHold = "Press and hold to record".localized()
let kFINISH = "FINISH".localized()

let kFGetStarted = "Get \n Started".localized()
let kWelcomeToNiirly = "Welcome to Niirly, an awesome community of anonymous people.Try shaking your phone in the home screen for 2 seconds and your profile will be sent out to people in a 100 meter radius.You can also create a \"Hangout\" or a \"Story\" which will stay for 24 hours and wont have your profile hidden.".localized()
let kSetYourMatch = "Set Your Match Preferences".localized()
let kSendAShake = "Send a Shake to people nearby".localized()
let kHangoutWith = "Hangout with like minded people".localized()
let kGetOnSwiping = "Get on swiping!".localized()
let kCHECKMYPREFERENCES = "CHECK MY PREFERENCES".localized()

//MARK: - Profile section

let kPREFERENCES = "PREFERENCES".localized()
let kMYHANGOUTS = "MY HANGOUTS".localized()
let kACCOUNT = "ACCOUNT".localized()
let kHELP = "HELP".localized()
let kINVITEFRIEND="INVITE FRIENDS".localized()


//MARK: -Edit Profile section
let kBIO = "BIO".localized()
let kAGE = "AGE".localized()
let kJOBTITLE = "JOB TITLE".localized()
let kCOMPANYNAME = "COMPANY NAME".localized()
let kCITY = "CITY".localized()
//let kEDUCATION = "EDUCATION"
let kGENDER = "GENDER".localized()
let kHEIGHT = "HEIGHT".localized()
//let kHAIRCOLOR = "HAIR COLOR"
//let kCHILDREN = "CHILDREN"

let kCONNECTINSTAGRAM = "CONNECT INSTAGRAM".localized()
let kCONNECTFACEBOOK = "CONNECT FACEBOOK".localized()

let kCONNECTEDFACEBOOK = "CONNECTED FACEBOOK".localized()
let kCONNECTEDINSTAGRAM = "CONNECTED INSTAGRAM".localized()

let kFacebookPost = "Facebook's Post".localized()
let kInstagramPost = "Instagram's Post".localized()

let kIn = "In ".localized()
let kHeightCm = "HEIGHT (In cm)".localized()
let kSProfile =  " 's Profile".localized()

//MARK: -Prefrence section
let kSHOW =  "SHOW".localized()
let kFacebookPhotos = "Facebook Photos".localized()
let kInstagramPhotos = "Instagram Photos".localized()

//MARK: -Account section

let kGetThe = "Get the most of the app. ".localized()
let kUpgradeTo = "Upgrade to Premium and receive daily shakes and more...".localized()
let k$5mo = "$5.99/mo"
var kMOBILENUMBER =  "MOBILE NUMBER".localized()
let kUNITS = "UNITS".localized()
let kNOTIFICATIONS = "NOTIFICATIONS".localized()
let kTermOfService = "Terms of Service".localized()
let kPrivacyPolicy = "Privacy Policy".localized()


let kContinuePrivacy = "By continuing you agree to our Privacy Policy and Terms of Service.".localized()

let kGDPRGuidelines = "GDPR Guidelines".localized()
let kCONTACTUS = "CONTACT US".localized()
let kTermsOfService = "Terms of Service".localized()
let kLogout =  "Logout".localized()
let kDeleteAccount = "Delete Account".localized()
let kConfirmDelete = "Confirm Delete".localized()
let kAreYouSureDelete =  "Are you sure you want to delete your account?".localized()

//MARK: -Notification section
let kPUSHNOTIFICATIONS = "PUSH NOTIFICATIONS".localized()
let kEMAIL = "EMAIL".localized()
let kPROMOTIONAL = "PROMOTIONAL".localized()
let kTEAMFLAZHED = "TEAM FLAZHED".localized()

let kNEWMATCHES = "NEW MATCHES".localized()
let kNEWMESSAGESL = "NEW MESSAGES".localized()
let kNEWLIKES = "NEW LIKES".localized()

var list = [kNEWMATCHES,kNEWMESSAGESL,kNEWLIKES]

//MARK: -Mobile verification section
let kCOUNTRYCODE = "COUNTRY CODE".localized()
let kVerificationOTP  = "Verification OTP sent to".localized()
let kOTP = "OTP".localized()
let kENTEROTPHERE  = "ENTER OTP HERE".localized()
//let kOTPVERIFY = "VERIFY"

//MARK: -Subscription section
var listOldPremium = ["The \"Ice Breaker\"","The \"Romantique\"","The \"Connoisseur\""]
var dayPackList = ["1 extra per day","3 extra per day","5 extra per day"]
var monthPackList = ["1 month starter pack","6 months basic pack","12 months premium pack"]

let kSameHangouts = "Same Hangouts".localized()
let kDaysActive  = "Days Active".localized()
let kNumberOfInterested = "Number of Interested".localized()
let kSimultaneousChats  = "Simultaneous Chats".localized()

let kVideoCallsPerMonth = "Video Calls per Month".localized()
let kPicturesPerDay  = "Pictures per Day".localized()
let kVideosPerDay = "Videos per Day".localized()
let kVideoLength  = "Video Length".localized()

let kRegretSwipeNew = "Regret swipe".localized()
let kExpandRadius = "Expand Radius (m)".localized()
let kDailyShakesNew = "Daily Shakes".localized()
let kVideoLengthNew  = "Video Length".localized()

//MARK: -Popup section
let kAreYouSure = "Are You Sure?".localized()
let kDELETEIMAGE = "DELETE IMAGE".localized()
let kDELETERECORDING = "DELETE RECORDING".localized()
let kConfirmLogout = "Confirm Logout".localized()

//MARK: -Story section
let kSORT = "SORT".localized()
let kBLOCKANDREPORT = "BLOCK AND REPORT USER".localized()
let kENDCHAT = "END CHAT".localized()
let kREMOVEMATCH = "REMOVE MATCH".localized()

let kPROLONGCHAT = "PROLONG CHAT".localized()
let kDELETECHAT = "DELETE CHAT".localized()

let kEBLOCKONLY = "BLOCK ONLY".localized()
let kINAPPROPRIATECONTENT = "INAPPROPRIATE CONTENT".localized()
let kPERSONISMINOR = "PPERSON IS MINOR".localized()
let kBADOFFLINEBEHAVIOR = "BAD OFFLINE BEHAVIOR".localized()
let kFEELSLIKESPAM = "FEELS LIKE SPAM".localized()
let kHatespeechorymbols = "Hate speech or symbols".localized()
let kViolence = "Violence or dangerous organisations".localized()
let kBullying = "Bullying or harassment".localized()
let kSuicide = "Suicide or self-injury".localized()
let kVOTHER = "OTHER".localized()



var kBlockReportArray = [kEBLOCKONLY,kINAPPROPRIATECONTENT,kPERSONISMINOR,kBADOFFLINEBEHAVIOR,kFEELSLIKESPAM,kHatespeechorymbols,kViolence,kBullying,kSuicide,kVOTHER]

let kDiscardPhoto  = "Discard Photo".localized()
let kDiscardPhotoMessage = "Are you sure you want to discard? This photo has not been saved.".localized()
let kEndChatQue = "End Chat?".localized()
let kEndChatMessage = "Are you sure you want to end chat? ".localized()
let kYESEND = "YES, END".localized()

let kRemoveMatchQue  = "Remove Match?".localized()
let kkRemoveMatchMessage = "Are you sure you want to remove this user? ".localized()
let kYESEMOVE = "YES, REMOVE".localized()
let kContinueChatQue = "Continue Chat?".localized()

let kYourChatWith = "Your chat with ".localized()
let kwillBeInactive = " will be inactive if you end this chat.".localized()

let kDays = "days".localized()
let kDay = "day".localized()

let kIsAboutTo = " is about to run out. You have ".localized()
let kToDecide  = " to decide if you want to continue or not. ".localized()

let kDeleteThisPost  = "Are you sure you want to delete this post? ".localized()
let kDeleteThisHangout = "Are you sure you want to delete this Hangout?".localized()
let kDeleteHangout  =  "DELETE HANGOUT".localized()
let kShakeSent  =  "Shake Sent".localized()
let kShakeSentMessage  =  "Request has been sent to the nearby users. You will be able to see the list once they like your profile. Till then, do you want to Play Anonymous?".localized()

let kPLAYANONYMOUS  =  "PLAY ANONYMOUS".localized()
let kdeleteThisStory  =  "Are you sure you want to delete this Story?".localized()

let kDELETESTORY  =  "DELETE STORY".localized()
let kDiscardThis  =  "Are you sure you want to discard? This".localized()

let kNotBeenSaved =  "has not been saved.".localized()
let kStorytToFacebook  =  "Post your story to Facebook".localized()

let kPostOnFacebook  = "Do you want to share this post on facebook?".localized()
let kSHAREPOST = "SHARE POST".localized()

let kIMAGES = "IMAGES".localized()
let kVIDEOS = "VIDEOS".localized()
let kONLYMATCHES = "ONLY MATCHES".localized()
let kMYPOSTS = "MY POSTS".localized()
let kALLPOSTS = "ALL POSTS".localized()

//MARK: -Chat section
let kMicrophonePermission = "Please enable the microphone permission from the settings.".localized()
let kLibraryPermission = "Please enable the library permission from the settings.".localized()
let kCameraAndMicrophonePermission = "Please enable the camera and microphone permission from the settings.".localized()
let kUNREAD = "UNREAD".localized()
let kLATEST = "LATEST".localized()
let kCLOSESTTOME = "CLOSEST TO ME".localized()

let kAPPLY = "APPLY".localized()
let kUhHh = "Uh Oh!".localized()
let kHasnAccepted = " hasn't accepted you request  yet.".localized()

let kTellUsMore = "Tell Us More".localized()
let kSENDFEEDBACK = "SEND FEEDBACK".localized()



let kOKAY = "OKAY".localized()
let kHasnAcceptedYou = "hasn't accepted your chat request yet.".localized()
let kHasLeft = "has left the chat.".localized()
let kYouAreStill = "You are still waiting on ".localized()
let kToAccept = " to accept the chat 😊.".localized()


let kFeedbackReceived = "Feedback Received".localized()
let kThankyouFor = "Thank you for your time.".localized()
let kHasBeen =  "has been".localized()
let kHasBeenPost =  "'s post has been".localized()
let kHasBeenHangout =  "'s hangout has been".localized()


let kBLOCKANDREPORTPOST = "BLOCK AND REPORT POST".localized()
let kBLOCKANDREPORTHAGOUT = "BLOCK AND REPORT HANGOUT".localized()


//MARK: -Home section
let kItAMatch = "It's A Match!".localized()
let kSTARTCHATTING = "START CHATTING".localized()
let kCANCELSHAKE = "Cancel Shake".localized()

//MARK: -Hangout section
let kTimeAndDate = "Time and Date".localized()
let kLocation2 = "Location".localized()
let kLookingFor = "Looking for".localized()
let kBetweenAge = "Between age".localized()

let kNothingHere = "Nothing Here".localized()
let kMyHangouDesc = "A Hangout is your way of creating an event and invite people to join. You set the place, date and time and type of event. It's a great way of meeting new friends and dates.A Hangout will expire after hangout created date.".localized()


let kRUNSFOR = "RUNS FOR".localized()
let kDATE = "DATE".localized()
let kTIME = "TIME".localized()
let kPLACE = "PLACE".localized()

let kADDITIONALDESCRIPTION  = "ADDITIONAL DESCRIPTION".localized()
let kNEXT = "NEXT".localized()
let kHANGOUTIMAGE = "HANGOUT IMAGE".localized()
let kHANGOUTTYPE = "HANGOUT TYPE".localized()

let kHEADING  = "HEADING".localized()
let kDESCRIPTION = "DESCRIPTION".localized()


let kGoPremium  = "Go Premium".localized()
let kNoThanks = "No Thanks".localized()

let kTODAY   = "TODAY".localized()
let kYesterday = "Yesterday".localized()

let kREMOVEMATCH2 = "REMOVE MATCH".localized()
//let kGETPREMIUM = "GET PREMIUM"


let kVerification = "Verification".localized()
let kVerificationSend = "We will send you an One Time Password to this mobile to verify.".localized()
let kOneTimePassword = "One Time Password".localized()
let kToVerify = " to this mobile to verify.".localized()
let kPhoneNumber = "Phone Number".localized()
let kChangeNumber = "Change Number".localized()

let kOTPsent = "Enter the OTP sent to ".localized()

let kAddVoice = "Add Voice".localized()
let kLeaveAShortVoice = "Leave a short voice recording of your normal voice. Around 3 - 5 seconds.".localized()
let kLeaveAShort = "Leave a short ".localized()
let kVoiceRecording = "voice recording".localized()
let kVoiceAround = " of your normal voice. Around 3 - 5 seconds.".localized()

let kUsername = "Username".localized()
let kARealName = "A real name helps other users ".localized()
let kYou = " you.".localized()
let kTrust = "trust".localized()
let kName = "Name".localized()

let kProfilePicture = "Profile Picture".localized()
let kAddingAtLeast = "Add minimum 2 pictures of yourself.".localized() //We prefer atleast 2
let k20x = "20x.".localized()

let kGender = "Gender".localized()
let kLetUs  = "Let us know your ".localized()
let kGender2 = "gender.".localized()

let kDateofBirth = "Date of Birth".localized()
let kWeWill = "We will connect you with ".localized()
let klikeMinded = "like-minded".localized()
let kPeople = " people.".localized()



//New Subscription changes

let kExtraShake = "Extra Shakes".localized()
let kExtraShakeMessage = "Don't bother about shake limits anymore.".localized()

let kRegretSwipe = "Regret Swiping Right?".localized()
let kRegretSwipeMessage = "Get Premium and never regret swiping.".localized()

let kProlongChats = "Prolong Chats".localized()
let kProlongChatsMessage = "Get more time to know more about the\n other person.".localized()

let kP9 = "$9.99"
let kP12 = "$12.99"
let kP15 = "$15.99"
let kP22 = "$22.99"

let kPInfinity = 999999
let kInfinitySign = "∞"

let kHideIndicator = "Hide Indicator"

let kDidAppear = "Did Appear"

let kAlredaySubscribe = "You have already subscribed to this plan.".localized()
let kSubscribeDegrate = "You can not degrade your subscription.".localized()

let kRegretAction = "Regret Action".localized()
let kRegretMessage = "Ohh shoot - need to go back and redo ? Upgrade your plan.".localized()

let kRegretRunningOut = "Regret run out".localized()

let kRegretContinue = "CONTINUE".localized()

let kProlongChat = "Prolong Chat".localized()

let kHeadlineProlong = "Prolong Chat".localized()

let kReactivateProlong = "Reactivate and start chatting with ".localized()
let kagainProlong = " again.".localized()
let kAppleNoCredential = "No credential was found".localized()
let kAppleRevoked = "The Apple ID credential is revoked".localized()

let kSELECTMEDIA = "SELECT MEDIA".localized()
let kGALLERY = "GALLERY".localized()
let kCAMERA = "CAMERA".localized()
let kCANCEL = "CANCEL".localized()
let kImageContentChecking = "Image content checking...".localized()
let kConfirmSettings = "Confirm Settings".localized()
let kVerify = "Verify".localized()
let kNewShakes = "New Shakes".localized()
let kInterestedIn = "I'm interested in".localized()
let kEDUCATION = "EDUCATION".localized()
let kCHILDREN = "CHILDREN".localized()
let kHAIRCOLOR = "HAIR COLOR".localized()
let kNonewmatch = "No new match found.".localized()

let kActiveChats = "Active Chats".localized()
let kInactiveChats = "Inactive Chats".localized()

let kTapandHold = "Tap and Hold on profile picture to check time left.".localized()
let kShakesLeft = "shakes left".localized()
let kShakeLeft = "Shake left.".localized()
let kShakeYourPhone = "Shake your phone".localized()
let kSubtext = "Subtext".localized()
let kGetNow = "Get Now".localized()
let kRESTORE = "RESTORE".localized()
let kHangoutImahe = "HANGOUT IMAGE".localized()
let kHangouttype = "HANGOUT TYPE".localized()
let kHeading = "HEADING".localized()
let kRunsFor = "RUNS FOR".localized()
let kDate = "DATE".localized()
let kTime = "TIME".localized()
let kPlace = "PLACE".localized()
let kAdditional = "ADDITIONAL DESCRIPTION".localized()
let kLooking = "LOOKING FOR".localized()
let kAge = "AGE".localized()
let ksocial = "SOCIAL".localized()
let ktravel = "TRAVEL".localized()
let ksport = "SPORTS".localized()
let kbusiness = "BUSINESS".localized()
let ksort = "Sort".localized()
let kShakeSubtext = "Shake your phone for 2 seconds and reveal your profile for potential matches within a radius of 150 meters.".localized()

let kWelcometoFlazhed = "Passed that special someone in real life? Or let others know you are HERE! Shake your phone for 2 seconds and reveal your profile for potential matches within a radius of 150 meters. Or find your true match based on personality by browsing through all profiles made anonymous.".localized()

let kWriteAMessage = "Write a message".localized()

let kShakeSentMessageMatch = "Your shake has been sent to potential matches nearby.Those who like your profile can be seen in Shake.Until then, do you want to browse anonymous profiles?".localized()

let kAddMinimum2Pic = "Please add minimum 2 pictures of yourself.".localized()
let kWeDonotShow = "We don’t show your birthday. Only your age.".localized()
let kBrowseAnonymous = "Browse Anonymous".localized()
