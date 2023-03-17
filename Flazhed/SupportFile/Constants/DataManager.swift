//
//  DataManager.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation

class DataManager {
    
    static var accessToken:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kAccessToken)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAccessToken) ?? kEmptyString
        }
    }
    static var Id:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kId) ?? kEmptyString
        }
    }
    static var ShakeId:String {
        set {
            UserDefaults.standard.set(newValue, forKey: ApiKey.kShakeUser)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: ApiKey.kShakeUser) ?? kEmptyString
        }
    }
    
    static var comeFrom:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kComeFrom  )
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kComeFrom) ?? kEmptyString
        }
    }
    static var HomeRefresh:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "Home")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "Home")
        }
    }
    static var comeFromTag:Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kMatch)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: kMatch)
        }
    }
    static var comeFromPage:Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kShake)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: kShake)
        }
    }
    
    
    static var userImage:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kUserImage)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kUserImage) ?? kEmptyString
        }
    }
    static var userId:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kUserId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kUserId) ?? kEmptyString
        }
    }
    static var userName:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kUserName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kUserName) ?? kEmptyString
        }
    }
    static var OtherUserId:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kOtherUserId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kOtherUserId) ?? kEmptyString
        }
    }
    
    
    static var isProfileCompelete:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kProfileComplete)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kProfileComplete)
        }
    }
    static var isVideoMute:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "Mute")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "Mute")
        }
    }
    static var isMessagePageOpen:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "MessagePageOpen")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "MessagePageOpen")
        }
    }
    
    static var imageCount:Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kImageCount)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.integer(forKey: kImageCount)
        }
    }

    static var storyImageSelected:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kImage)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kImage) ?? ""
        }
    }
    static var storyVideoSelected:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kVideo)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kVideo) ?? ""
        }
    }
    
    static var storyMatchSelected:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kAllMatch)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAllMatch) ?? "0"
        }
    }
    static var storyMyPostSelected:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kMyPost)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kMyPost) ?? "0"
        }
    }
    
    static var storyAllPostSelected:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kAllPost)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAllPost) ?? ""
        }
    }
    static var audioURL:String {
        set {
            UserDefaults.standard.set(newValue, forKey: ApiKey.kVoice)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: ApiKey.kVoice) ?? ""
        }
    }
    
    static var purchasePlan:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: ApiKey.kPurchasePlan)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: ApiKey.kPurchasePlan) 
        }
    }
    static var purchaseProlong:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: ApiKey.kChat_room)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: ApiKey.kChat_room)
        }
    }
    
    static var countryPhoneCode:String {
        set {
            UserDefaults.standard.set(newValue, forKey: "PhoneCode")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "PhoneCode") ?? kEmptyString
        }
    }
    static var countryName:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kCountryName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCountryName) ?? kEmptyString
        }
    }
    
    static var isPrefrenceSet:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kPreference)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kPreference)
        }
    }
    
    static var isEditProfile:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kEdit)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kEdit)
        }
    }
    
    //MARK: - Hangout sort data
    
    
    static var social:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kSocial)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kSocial) ?? ""
        }
    }
    static var travel:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kTravel)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kTravel) ?? ""
        }
    }
    
    static var sport:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kSports)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kSports) ?? ""
        }
    }
    static var business:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kBusiness)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kBusiness) ?? ""
        }
    }
    
    
    static var men:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kMenShort)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kMenShort) ?? ""
        }
    }
    static var women:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kWomen)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kWomen) ?? ""
        }
    }
    
    
    static var latest:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kLatest)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLatest) ?? ""
        }
    }
    static var oldest:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kOldest)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kOldest) ?? ""
        }
    }
    
    static var ase:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kAscending)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAscending) ?? ""
        }
    }
    static var desc:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kDescending)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kDescending) ?? ""
        }
    }
    
    static var fromHangout:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kfromHangout)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kfromHangout) ?? kEmptyString
        }
    }
    
    static var currentUnit:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kCurrentUnit)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCurrentUnit) ?? kEmptyString
        }
    }
    
    static var audioMute:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kMen)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kMen)
        }
    }
    //MARK: - Chat sort data
    
    static var chatFilter:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kClatest)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kClatest) ?? kEmptyString
        }
    }
    
    static var currentScreen:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kMessage)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kMessage) ?? kEmptyString
        }
    }
    static var isViewProfile:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kViewProfile)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kViewProfile)
        }
    }
    
    static var userNameType:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kCalling)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCalling) ?? kEmptyString
        }
    }
    static var Selected_DateOfBirth:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kCallTry)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCallTry) ?? kEmptyString
        }
    }
    static var Selected_Gender:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kText)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kText) ?? kEmptyString
        }
    }
    static var Selected_Audio:String {
        set {
            UserDefaults.standard.set(newValue, forKey: kAudio)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAudio) ?? kEmptyString
        }
    }
    
    static var isInternetAvailble:Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kInternet)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kInternet)
        }
    }
    
    static var Language:String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "Language")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "Language")
          }
      }
}




