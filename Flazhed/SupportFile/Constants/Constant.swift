//
//  Constant.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation
import UIKit


let SCREENHEIGHT =  UIScreen.main.bounds.height
let SCREENWIDTH =  UIScreen.main.bounds.width
let APPSTATE = UIApplication.shared.applicationState

let TIMEZONE = TimeZone.current.identifier
var CALENDER = Calendar.current
let ADSWIDTH = CGFloat(300)//250//500
var checkIsOnGoing = false
// 300 x 600
//336 x 280
//300 x 250
var TOPSPACING =  CGFloat(22)
var NAVIHEIGHT =  CGFloat(44)
var STATUSBARHEIGHT =  CGFloat(20)
var TOPLABELSAPACING =  CGFloat(21)
var BLUR_ALPHA:CGFloat =  0.95

var CURRENTLAT =  30.69951335
var CURRENTLONG =  76.69104083
var BOTTOMSPACING:CGFloat =  159+45
let kNudityCheck = 0.3
let kImagePercent:CGFloat = 45.0
let kLongImagePercent:CGFloat = 65.0

let kImageCompressLessThan500:CGFloat = 1.0
let kImageCompressGreaterThan500:CGFloat = 0.5//0.05

let kMinAge = 18
let kMaxAge = 100
let kTimeRing48 = 72

let kTimeRing = 4320
let kTimeRing24 = 1440

let kTimeLeft48 = 2880
let kButtonDisableSec = 0.5
let kButtonLikeDuration = 0.2
let kBioCount = 500//150

let kListImageHeight = CGFloat(350)//150 // 390 // 375




let kCurrentCountryCode = "+45"

var COUNTRYCODE =  Locale.current.regionCode

var LANG_CODE_EN =  "en"
var LANG_CODE_DA =  "da"

var CURRENTUNIT =  "Centimeters"
let FEMALECOLOR = UIColor.init(red: 178/255, green: 29/255, blue: 184/255, alpha: 1)
let MALECOLOR = UIColor.init(red: 0/255, green: 156/255, blue: 193/255, alpha: 1)

let APPCOLOR = UIColor.init(red: 29/255, green: 121/255, blue: 255/255, alpha: 1) //

let APPCOLORX = UIColor.init(red: 46/255, green: 129/255, blue: 250/255, alpha: 1)

let COMMENTCOLOR = UIColor.init(red: 29/255, green: 121/255, blue: 255/255, alpha: 0.7)
let COMMENTCOLOR2 = UIColor.init(red: 29/255, green: 121/255, blue: 255/255, alpha: 2)

let APPCOLOR2 = UIColor.init(red: 5/255, green: 112/255, blue: 178/255, alpha: 1)
let APPCOLOR3 = UIColor.init(red: 0/255, green: 105/255, blue: 162/255, alpha: 1)
let PLACEHOLDERCOLOR = UIColor.init(red: 171/255, green: 185/255, blue: 197/255, alpha: 1)
let OTPCOLOR = UIColor.init(red: 240/255, green: 243/255, blue: 245/255, alpha: 1)
let TEXTFILEDPLACEHOLDERCOLOR = UIColor.init(red: 176/255, green: 185/255, blue: 200/255, alpha: 1)

let SEEKERCOLOR = UIColor.init(red: 243/255, green: 244/255, blue: 245/255, alpha: 1)

//NEW APP color
let LINECOLOR = UIColor.init(red: 0/255, green: 104/255, blue: 255/255, alpha: 1) //

let NOTPLAYCOLOR = UIColor.init(red: 250/255, green: 251/255, blue: 252/255, alpha: 1) //

let CHATINACTIVECOLOR = UIColor.init(red: 100/255, green: 122/255, blue: 155/255, alpha: 1)

let TIMEACTIVECOLOR = UIColor.init(red: 176/255, green: 185/255, blue: 200/255, alpha: 1)

let HOMESADOWCOLOR = UIColor.init(red: 17/255, green: 83/255, blue: 97/255, alpha: 0.16)

let SADOWCOLOR = UIColor.init(red: 55/255, green: 91/255, blue: 132/255, alpha: 0.15)

let LIKECOLOR = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.5) //

//999999

let TEXTCOLOR = UIColor.init(red: 0/255, green: 104/255, blue: 255/255, alpha: 1)
//6b6b6b

let DETAILSCOLOR = UIColor.init(red: 188/255, green: 187/255, blue: 187/255, alpha: 1)
//999999

let TAB_UNSELECTED_COLOR = UIColor.init(red: 78/255, green: 153/255, blue: 198/255, alpha: 1)


let DIDNOT = UIColor.init(red: 175/255, green: 175/255, blue: 175/255, alpha: 1) //979797
let RESENDNOW = UIColor.init(red: 0/255, green: 73/255, blue: 119/255, alpha: 1) //004977

let PLAYDISABLECOLOR = UIColor.init(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
let PLAYCOLOR = UIColor.init(red: 3/255, green: 3/255, blue: 3/255, alpha: 1)
let DELETECOLOR = UIColor.init(red: 242/255, green: 74/255, blue: 74/255, alpha: 1)

//HANGOUT TYPE
let SOCAILBACK = UIColor.init(red: 245/255, green: 249/255, blue: 252/255, alpha: 1)
let SOCAILTEXRT = UIColor.init(red: 166/255, green: 199/255, blue: 234/255, alpha: 1)

let TRAVELBACK = UIColor.init(red: 254/255, green: 244/255, blue: 245/255, alpha: 1)
let TRAVELTEXRT = UIColor.init(red: 245/255, green: 149/255, blue: 152/255, alpha: 1)

let SPORTBACK = UIColor.init(red: 255/255, green: 248/255, blue: 242/255, alpha: 1)
let SPORTTEXRT = UIColor.init(red: 254/255, green: 189/255, blue: 125/255, alpha: 1)

let BUSSINESSBACK = UIColor.init(red: 248/255, green: 252/255, blue: 247/255, alpha: 1)
let BUSSINESSTEXRT = UIColor.init(red: 187/255, green: 220/255, blue: 173/255, alpha: 1)

let WAVECOLOR = UIColor.init(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)

//MARK: - New color
let ENABLECOLOR = UIColor.black.withAlphaComponent(1)
let DISABLECOLOR = UIColor.black.withAlphaComponent(0.5)
let PURPLECOLOR = UIColor.colorWithHexString(hex: "712CA7")
let LESSPURPLECOLOR = UIColor.colorWithHexString(hex: "CEBFDA")







let APPDEL = UIApplication.shared.delegate as! AppDelegate

@available(iOS 13.0, *)
let SCENEDEL =  UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate


struct PermissonType
{
    static let kLocationEnable="Location Enable"
    static let kCameraEnable="Camera Enable"
    static let kMicrophoneEnable="Microphone Enable"
    static let kLibraryEnable="Library Enable"
    static let kMicrophoneCamera="Microphone Camera"
}
