//
//  BaseVC.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//


import UIKit
import Photos
import MobileCoreServices
import CoreTelephony
import SDWebImage
import IQKeyboardManagerSwift

@objc protocol PickerDelegate {
    @objc optional func didSelectItem(at index: Int, item: String)
    @objc optional func didSelectDate(date: Date)
    @objc optional func didPickDocument(url: URL)
}

enum ScreenType: String{
    
    case sendFeedback = "sendFeedback"
    case feedbackScreen = "feedbackScreen"
    case messageScreen = "messageScreen"
    case chatScreen = "chatScreen"
    case storiesScreen = "storyScreen"
    case blockRemoveAlert = "blockRemoveAlert"
    case continueChat = "continueChat"
    case storyTab = "storyTab"
    case delete = "delete"
    case deleteHangout = "delete hangout"
    case discardPost = "discard Post"
    
    case deleteStory = "delete story"
    
    case shakeSent = "Shake Sent"
    case ShareStory = "Share story"
    
    case BlockReportError = "Block Report Error"
    case GrayOut = "User time gray out"
    case GrayOut48Hrs = "User time gray out after 48 hrs"
    case onceContinue = "One user cotinue chat"
    case ViewProfile = "View Profile"
    case ViewPostHangout = "View Post Hangout"
    case ListHangout = "Hangout Listing"
    case ViewPostStory = "View Post Story"
}

class BaseVC: UIViewController {
    
    //MARK: - Variables
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var pickerView = UIPickerView()
    var datePickerView = UIDatePicker()
    var pickerTextfield : UITextField!
    var pickerDelegate: PickerDelegate?
    var pickerArray = [String]()
    
    var startDate: Date?
    var startShaking = CFAbsoluteTimeGetCurrent()


    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.shared.initializeSocket()
        selfJoinSocketEmit()
        datePickerView.locale = Locale(identifier: "en_US_POSIX")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      //  NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        
     //   NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged2), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        if !DataManager.isViewProfile
        {
            DataManager.isViewProfile=true
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ViewProfileNotification"), object: nil)
        }
       // self.selfJoinSocketEmit2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.updateLocationAPI()
        let naviHeight = self.navigationController?.navigationBar.frame.height ?? 44
        NAVIHEIGHT = naviHeight
        STATUSBARHEIGHT = getStatusBarHeight()
        self.becomeFirstResponder()
        badgeCountIntervalCheckEmit()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("********** MEMORY WARNING **********")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    func showToastMessage(_ ToastMessage:String=kSucess)
    {
        debugPrint("Toast call  = \(ToastMessage)")
        var style = ToastStyle()
        style.messageColor = .white
        self.view.makeToast(ToastMessage, duration: 2.0, position: .center, style: style)

    }
    
    func ClearMemory()
    {
        debugPrint("********** MEMORY Clear **********")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    func ClearCoreAllData()
    {
        
        DispatchQueue.main.async {

            for name in ApiKey.kCoreDataEnLtityArray
            {
                CoreDataManager.deleteRecords(entityName: name)
            }
        
        }
    }
    
    func enbleIQKeyboard()
    {
        IQKeyboardManager.shared.enableAutoToolbar = true
       
    }
    func disableIQKeyboard()
    {
        IQKeyboardManager.shared.enableAutoToolbar = false
    
    }
    
    func goToProfile()
    {
        if #available(iOS 13.0, *)
        {
            SCENEDEL?.navigateToHome(selectedIndex: 0)
        }
        else
        {
          
            APPDEL.navigateToHome(selectedIndex: 0)
        }
    }
    func goToChat()
    {
        if #available(iOS 13.0, *)
        {
            SCENEDEL?.navigateToHome(selectedIndex: 1)
        }
        else
        {
          
            APPDEL.navigateToHome(selectedIndex: 1)
        }
    }
    func goToShake()
    {
        if #available(iOS 13.0, *)
        {
            SCENEDEL?.navigateToHome(selectedIndex: 2)
        }
        else
        {
          
            APPDEL.navigateToHome(selectedIndex: 2)
        }
    }
    func goToAnonymous()
    {
        if #available(iOS 13.0, *)
        {
            SCENEDEL?.navigateToHome(selectedIndex: 3)
        }
        else
        {
          
            APPDEL.navigateToHome(selectedIndex: 3)
        }
    }
    
    func goToHangout()
    {
        if #available(iOS 13.0, *)
        {
            SCENEDEL?.navigateToHome(selectedIndex: 4)
        }
        else
        {
          
            APPDEL.navigateToHome(selectedIndex: 4)
        }
    }
    func goToStory()
    {
        if #available(iOS 13.0, *)
        {
            SCENEDEL?.navigateToHome(selectedIndex: 5)
        }
        else
        {
          
            APPDEL.navigateToHome(selectedIndex: 5)
        }
    }
}

//MARK: - Navigation Methods
extension BaseVC {
    
    func hideNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBar?.backgroundColor = UIColor.clear
        
    }
    
    //MARK: Empty Screen Implementation
//     func showEmptyScreen(belowSubview subview: UIView? = nil, superView:UIView? = nil) {
//         let baseView: UIView = superView ?? self.view
//         emptyview.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
//         if let subview = subview {
//             baseView.insertSubview(emptyview, belowSubview: subview)
//         }
//         else {
//             baseView.addSubview(emptyview)
//         }
//     }
     
//     func hideEmptyScreen() {
//         emptyview.removeFromSuperview()
//     }
//
    //MARK: - Navigation Title
    func setCustomHeader(title:String, showBack: Bool = true, showMenuButton:Bool = false,color:UIColor = .white)
    {
        let naviHeight = self.navigationController?.navigationBar.frame.height ?? 44
        NAVIHEIGHT = naviHeight
        STATUSBARHEIGHT = getStatusBarHeight()
        
        let viewHeader = UIView()
        
        viewHeader.frame = CGRect(x: 0, y: TOPSPACING, width: SCREENWIDTH, height: naviHeight)
        viewHeader.backgroundColor = color
        let titleButton = UIButton(frame: CGRect(x: SCREENWIDTH/2-125, y:0, width:250, height:naviHeight))
        titleButton.titleLabel?.textAlignment = .left
        titleButton.setTitle(title, for: .normal)
        titleButton.isUserInteractionEnabled = false
        titleButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 7, right: 0)
        titleButton.setTitleColor(UIColor.black, for: .normal)
        titleButton.titleLabel?.font = UIFont.CustomFont.bold.fontWithSize(size: 28.0)
        
        viewHeader.addSubview(titleButton)
        
        if showBack
        {
            let backButton = UIButton()
          
            let backImage = UIImageView()
            
            backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
            backImage.frame = CGRect(x: 40, y: naviHeight/2-13, width: 18, height: 18)
            backImage.image = #imageLiteral(resourceName: "BackArrow")
            backImage.contentMode = .scaleAspectFit
            backImage.clipsToBounds = true
            //backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: UIControl.State.normal)
            backButton.addSubview(backImage)
            
            backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
            backButton.contentEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
            let leftBarButton = UIBarButtonItem()
            leftBarButton.title = ""
            leftBarButton.customView = backButton
            viewHeader.addSubview(backButton)
        }
        
        self.view.addSubview(viewHeader)
    }
    
    
    
    
    
    
    func setHeader(title:String, showBack: Bool = true, showMenuButton:Bool = false) {
        
        
    UIApplication.shared.statusBarStyle = .lightContent
    UIApplication.shared.isStatusBarHidden = false
    self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.navigationBar.barStyle = .black
    self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white//.AppColor.navBarColor.color()
    self.navigationController?.navigationBar.isTranslucent = false
self.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .any, barMetrics: .default)
    self.navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()
    let titleButton = UIButton(frame: CGRect(x: 50, y:0, width:110, height:30))
    titleButton.titleLabel?.textAlignment = .center
    titleButton.setTitle(title, for: .normal)
    titleButton.isUserInteractionEnabled = false
    titleButton.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 7, right: 0)
    titleButton.setTitleColor(UIColor.black, for: .normal)
    titleButton.titleLabel?.font = UIFont.CustomFont.regular.fontWithSize(size: 28.0)
    
    self.navigationItem.titleView = titleButton
    
    //Hide back button
    
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)


        
        if showBack {
            self.setBackButton()
        }
        else {
            self.navigationItem.hidesBackButton = true
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
        if showMenuButton {
            self.setMenuButton()
        }
        
        
    }
    func getStatusBarHeight() -> CGFloat {
       var statusBarHeight: CGFloat = 0
       if #available(iOS 13.0, *) {
           let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       } else {
           statusBarHeight = UIApplication.shared.statusBarFrame.height
       }
       return statusBarHeight
   }
    
    func logout () {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        let navigationController = UINavigationController(rootViewController: vc)
//        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
    //MARK: - Back Button
    func setBackButton()
    {
        let backButton = UIButton()
        let backImage = UIImageView()
        
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backImage.frame = CGRect(x: 8, y: 8, width: 18, height: 18)
        backImage.image = #imageLiteral(resourceName: "BackArrow")
        backImage.contentMode = .scaleAspectFit
        backImage.clipsToBounds = true
        //backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: UIControl.State.normal)
        backButton.addSubview(backImage)
        
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: -10, left: -15, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = ""
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
       
    }
    
    //MARK: - setMenuButton Button
    func setMenuButton(){
        let backButton = UIButton()
        let backImage = UIImageView()
        
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backImage.frame = CGRect(x: 8, y: 8, width: 20, height: 20)
        backImage.image = UIImage(named: "white-filter-icon")
        backImage.contentMode = .scaleAspectFit
        backImage.clipsToBounds = true
        //backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: UIControl.State.normal)
        backButton.addSubview(backImage)
        
        backButton.addTarget(self, action: #selector(self.menuButtonAction), for: UIControl.Event.touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: -10, left: -15, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = backButton
        self.navigationItem.rightBarButtonItem = leftBarButton
    }
    
    
    @objc func backButtonAction() {
        self.view.endEditing(true)
    
        
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 1 {
                let backDone = self.navigationController?.popViewController(animated: true)
                if backDone == nil {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }

    }
}
    
    @objc func menuButtonAction()
    {
//        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
//        let vc = mainStoryboard.instantiateViewController(withIdentifier: "FilterEmployeeVC") as! FilterEmployeeVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    //MARK: Right Buttton
    func setRightButton(image: UIImage? = nil, title: String? = nil){
        
        let backButton = UIButton() //Custom back Button
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        if title != nil {
            backButton.setTitle(title, for: .normal)
            backButton.setTitleColor(UIColor.black, for: .normal)
            //backButton.titleLabel?.font = UIFont.CustomFont.regular.font()
        }
        else {
            backButton.setImage(image, for: .normal)
        }
        backButton.addTarget(self, action: #selector(self.rightButtonAction(sender:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = backButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10;
        self.navigationItem.setRightBarButtonItems([rightBarButton, negativeSpacer], animated: false)
    }
    
    @objc func rightButtonAction(sender: UIButton) {
        
    }
    
    
    func getDeviceModel() -> String
    {
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.nativeBounds.height {
                case 1136:
                    debugPrint("iPhone 5 or 5S or 5C")
                     return "iPhone 6"
                    
                case 1334:
                    debugPrint("iPhone 6/6S/7/8")
                    return "iPhone 6"
                case 1920, 2208:
                    debugPrint("iPhone 6+/6S+/7+/8+")
                    return "iPhone 8+"
                case 2436:
                    debugPrint("iPhone X/XS/11 Pro")
                    return "iPhone 10"
                case 2688:
                    debugPrint("iPhone XS Max/11 Pro Max")
                    return "iPhone 11"
                  
                case 1792:
                    debugPrint("iPhone XR/ 11 ")
                    return "iPhone 12"
                default:
                    debugPrint("Unknown")
                }
            }
        return "iPhone 8+"
    }
    
    
    
    func getCountryCallingCode(countryRegionCode:String)->String{

            let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
            let countryDialingCode = prefixCodes[countryRegionCode]
            return countryDialingCode ?? "45"

    }
    
    @objc func reachabilityChanged2(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            debugPrint("Message Network available via Cellular Data.")
            self.view.makeToast(kOnlineMessage, point: CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT/2), title: nil, image: nil) { _ in
            }
            break
        case .wifi:
            debugPrint("Message Network available via WiFi.")
            self.view.makeToast(kOnlineMessage, point: CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT/2), title: nil, image: nil) { _ in
            }
            break
        case .unavailable:
            debugPrint("Message Network is not available.")
            self.view.makeToast(kOfflieMessage, point: CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT/2), title: nil, image: nil) { _ in
            }
            break
        case .none:
            self.view.makeToast(kOfflieMessage, point: CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT/2), title: nil, image: nil) { _ in
            }
            break
        }
      }
    
    
//    func setTwoRightButtons(image1: UIImage? = nil, title1: String? = nil,image2: UIImage? = nil, title2: String? = nil){
//        let right1 = UIButton() //Custom back Button
//        right1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        if title1 != nil {
//            right1.setTitle(title1, for: .normal)
//            right1.setTitleColor(UIColor.black, for: .normal)
//            //backButton.titleLabel?.font = UIFont.CustomFont.regular.font()
//        }
//        else {
//            right1.setImage(image1, for: .normal)
//        }
//
//        let right2 = UIButton() //Custom back Button
//        right2.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        if title2 != nil {
//            right2.setTitle(title2, for: .normal)
//            right2.setTitleColor(UIColor.black, for: .normal)
//            //backButton.titleLabel?.font = UIFont.CustomFont.regular.font()
//        }
//        else {
//            right2.setImage(image2, for: .normal)
//        }
//
//        right1.addTarget(self, action: #selector(self.rightButton1Action(sender:)), for: .touchUpInside)
//        right2.addTarget(self, action: #selector(self.rightButton2Action(sender:)), for: .touchUpInside)
//        let rightBarButton1 = UIBarButtonItem()
//        rightBarButton1.customView = right1
//        self.navigationItem.rightBarButtonItem = rightBarButton1
//        let rightBarButton2 = UIBarButtonItem()
//        rightBarButton2.customView = right2
//        self.navigationItem.rightBarButtonItem = rightBarButton2
//
//        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = -10;
//        self.navigationItem.setRightBarButtonItems([rightBarButton1, rightBarButton2,negativeSpacer], animated: false)
//    }
//
//
//    @objc func rightButton1Action(sender: UIButton) {
//
//    }
//
//    @objc func rightButton2Action(sender: UIButton) {
//
//    }
    
   
}

//MARK: - Custom Alert Methods
extension BaseVC {
//    func showAlert(image:UIImage? = nil ,title:String? = nil, message: String?, cancelTitle: String? = nil,  cancelAction: ButtonAction? = nil, okayTitle: String = kOkay, _ okayAction: ButtonAction? = nil) {
//
//        let customAlert = CustomAlert(image:image, title: title, message: message, cancelButtonTitle:cancelTitle, doneButtonTitle:okayTitle)
//
//        customAlert.cancelButton.addTarget {
//            cancelAction?()
//            customAlert.remove()
//        }
//        customAlert.doneButton.addTarget {
//            okayAction?()
//            customAlert.remove()
//        }
//
//       customAlert.show()
//    }
    

       
}



//MARK: - UIApplication
extension UIApplication {
    var statusBar: UIView? {
        if responds(to: Selector(("statusBar")))
        {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension BaseVC {
    
    func showImagePicker(showVideo: Bool = false, showDocument: Bool = false) {
        let alert  = UIAlertController(title: kSELECTMEDIA, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: kGALLERY, style: .default, handler: {action in
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined || photos == .denied || photos == .restricted {
                PHPhotoLibrary.requestAuthorization({status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery, showVideo: showVideo)
                        }
                        else {
                          
                            self.openSettings(message: kLibraryPermission)
                    
                            return
                        }
                    }
                })
            }
            else {
                CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery, showVideo: showVideo)
            }
        }))
        alert.addAction(UIAlertAction(title: kCAMERA, style: .default, handler: {action in
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                DispatchQueue.main.async {
                    if response {
                        CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .camera, showVideo: showVideo)
                    } else {
                        
                        self.openSettings(message: kCameraSetting)
                      
                        return
                    }
                }
            }
        }))
        if showDocument {
            alert.addAction(UIAlertAction(title: "DOCUMENT", style: .default, handler: {action in
                let types = [kUTTypePDF]
                let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
                if #available(iOS 11.0, *) {
                    importMenu.allowsMultipleSelection = false
                } else {
                    // Fallback on earlier versions
                }
                importMenu.delegate = self
                importMenu.modalPresentationStyle = .formSheet
                self.present(importMenu, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: kCANCEL, style: .cancel, handler: nil))
        
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
         {
                // Ipad
            alert.popoverPresentationController?.sourceView = self.view // works for both iPhone & iPad

            self.present(alert, animated: true, completion: nil)
         }
         else
         {
            self.present(alert, animated: true, completion: nil)
         }
      
    }
    
    
    func openGallery() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined || photos == .denied || photos == .restricted {
            PHPhotoLibrary.requestAuthorization({status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery)
                    }
                    else {
                      
                        self.openSettings(message: kLibraryPermission)
                        return
                    }
                }
            })
        }
        else {
            CustomImagePickerView.sharedInstace.pickImageUsing(target: self, mode: .gallery)
        }
    }
    
    func openSettings(message:String = kSettingMessage)
    {
        
        DispatchQueue.main.async {
            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
        vc.comeFrom = kSetting
        vc.messageType=message
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let tab = self.tabBarController
            {
                tab.present(vc, animated: true, completion: nil)
            }
            else
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            debugPrint("*** Error generating thumbnail: \(error.localizedDescription)")
            return #imageLiteral(resourceName: "video")
        }
    }
    
    @objc func shareText(message: String) {
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showErrorMessage(error: Error?,comeFromScreen : ScreenType = .storiesScreen) {
        /*
         STATUS CODES:
         200: Success (If request sucessfully done and data is also come in response)
         204: No Content (If request successfully done and no data is available for response)
         401: Unauthorized (If token got expired)
         451: Block (If User blocked by admin)/delete by admin
         403: Delete (If User deleted by admin)
         406: Not Acceptable (If user is registered with the application but not verified)
         */
       
        let message = (error! as NSError).userInfo[ApiKey.kMessage] as? String ?? kSomethingWentWrong
        
            //ok button action
            let code = (error! as NSError).code
        debugPrint("ERROR CODE \(code)")
        
            if  code == 401 || code == 451
            {
             
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)

                
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.errorCode=code
                destVC.comeFromScreen = comeFromScreen
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                if let tab = self.tabBarController
                {
                    tab.present(destVC, animated: true, completion: nil)
                }
                else
                {
                    self.present(destVC, animated: true, completion: nil)
                }
              
            }
    
           else
            {
                
              //  self.openSimpleAlert(message: message)
               
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)

                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.comeFromScreen = comeFromScreen
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                if let tab = self.tabBarController
                {
                    tab.present(destVC, animated: true, completion: nil)
                }
                else
                {
                    self.present(destVC, animated: true, completion: nil)
                }
            }
        
    }
    
    
    func parseFBData(response: JSONDictionary) -> JSONDictionary {
        var dict = JSONDictionary()
        var url = String()
        if let imageData = response[ApiKey.kPicture] as? JSONDictionary {
            if let data = imageData[ApiKey.kData] as? JSONDictionary {
                url = data[ApiKey.kURL] as? String ?? kEmptyString
            }
        }
        dict[ApiKey.kImage] = URL(string: url)
        dict[ApiKey.kName] = response[ApiKey.kName] as? String ?? kEmptyString
        dict[ApiKey.kEmail] = response[ApiKey.kEmail] as? String ?? kEmptyString
        dict[ApiKey.kId] = response[ApiKey.kId] as? String  ?? kEmptyString
        dict[ApiKey.kBirthday] = response[ApiKey.kBirthday] as? String ?? kEmptyString
        dict[ApiKey.kGender] = response[ApiKey.kGender] as? String ?? kEmptyString
        dict[ApiKey.kSocial_type] = kFacebook
        return dict
    }
    
    func feetToFeetInches(_ value: Double) -> String
    {
      let formatter = MeasurementFormatter()
      formatter.unitOptions = .providedUnit
      formatter.unitStyle = .short

      let rounded = value.rounded(.towardZero)
      let feet = Measurement(value: rounded, unit: UnitLength.feet)
        
      let inches = Measurement(value: value - rounded, unit: UnitLength.feet).converted(to: .inches)
      return ("\(formatter.string(from: feet)) \(formatter.string(from: inches))")
    }
    func showFootAndInchesFromCm(_ cms: Double) -> String {

          let feet = cms * 0.0328084
          let feetShow = Int(floor(feet))
          let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
          let inches = Int(round(feetRest * 12))

          return "\(feetShow)' \(inches)\""
    }
    
    func showFootAndInchesFromCm2(_ cms: Double) -> String {

          let feet = cms * 0.0328084
          let feetShow = Int(floor(feet))
          let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
          let inches = Int(round(feetRest * 12))

          return "\(feetShow).\(inches)"
    }
    
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ())
    {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.country,
                       placemarks?.first?.isoCountryCode,
                       error)
        }
    }
    
    func convertLatLongToAddress(latitude:Double, longitude:Double) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        var labelText = ""
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark != nil {
                if let name = placeMark.name {
                    labelText = name
                }
                if let subThoroughfare = placeMark.subThoroughfare {
                    if (subThoroughfare != placeMark.name) && (labelText != subThoroughfare) {
                        labelText = (labelText != "") ? labelText + "," + subThoroughfare : subThoroughfare
                    }
                }
                if let subLocality = placeMark.subLocality {
                    if (subLocality != placeMark.subThoroughfare) && (labelText != subLocality) {
                        labelText = (labelText != "") ? labelText + "," + subLocality : subLocality
                    }
                }
                if let street = placeMark.thoroughfare {
                    if (street != placeMark.subLocality) && (labelText != street) {
                        labelText = (labelText != "") ? labelText + "," + street : street
                    }
                }
                if let locality = placeMark.locality {
                    if (locality != placeMark.thoroughfare) && (labelText != locality) {
                        labelText = (labelText != "") ? labelText + "," + locality : locality
                    }
                }
                if let city = placeMark.subAdministrativeArea {
                    if (city != placeMark.locality) && (labelText != city) {
                        labelText = (labelText != "") ? labelText + "," + city : city
                    }
                }
                if let state = placeMark.postalCode {
                    if (state != placeMark.subAdministrativeArea) && (labelText != state) {
                        labelText = (labelText != "") ? labelText + "," + state : state
                    }

                }
                if let country = placeMark.country {
                    labelText = (labelText != "") ? labelText + "," + country : country
                }
                // labelText gives you the address of the place
               
            }
        })
        return labelText
    }
    
    //MARK: - Open on notiifcation
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        //let id =  self.HangoutListArray[sender.tag].user_id ?? ""
        var pushed = false
        debugPrint("Pushed = \(pushed)")
        if !pushed
        {
        if let details = notification.userInfo as? [String:Any]
        {
            pushed = true
            if let nav = self.navigationController
            {
                debugPrint("Navi true")
            
                let vc = ViewProfileVC.instantiate(fromAppStoryboard: .Home)

//                    vc.view_user_id = dict["view_user_id"] as? String ?? ""
//                    vc.likeMode=dict["likeMode"] as? String ?? ""
//                vc.story_id=dict["story_id"] as? String ?? ""
//                vc.hangout_id=dict["hangout_id"] as? String ?? ""
                
                
               // let Noti_type = details["noti_type"] as? String ?? ""
                
                DataManager.comeFrom = kEmptyString
                vc.view_user_id  = details["from_user_id"] as? String ?? ""
                
                vc.likeMode = details["like_mode"] as? String ?? ""
                vc.story_id = details["story_id"] as? String ?? ""
                vc.hangout_id = details["hangout_id"] as? String ?? ""
              
                vc.comeFrom = kBaseVC
                nav.pushViewController(vc, animated: true)
            }
            else
            {
                debugPrint("Navi false")
                DataManager.comeFrom = kEmptyString
                APPDEL.openHangoutDetails(details: details)
               
            }
        }
        }
   
    }
}



extension BaseVC: UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count > 0 {
            pickerDelegate?.didPickDocument?(url: urls.last!)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension BaseVC: UIPickerViewDelegate,UIPickerViewDataSource {
    
    //MARK: Custom Picker Methods
    func setPickerView(textField: UITextField, array: [String], selectedIndex: Int = 0) {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerArray = array
        pickerTextfield = textField
        
        //Set Picker View to Textfield
        textField.inputView = pickerView
        textField.text = pickerArray[selectedIndex]
        pickerView.reloadAllComponents()
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
    }
    
    // Delegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerDelegate?.didSelectItem?(at: row, item: pickerArray[row])
       
        self.pickerTextfield.text = pickerArray[row]
        
    }
    
    //MARK: Custom Date Picker
    func setDatePicker(textField: UITextField, datePickerMode: UIDatePicker.Mode = .dateAndTime, maximunDate: Date? = nil, minimumDate: Date? = Date()) {
        textField.inputView = datePickerView
        pickerTextfield = textField
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.backgroundColor = UIColor.lightGray
        datePickerView.maximumDate = maximunDate
        datePickerView.minimumDate = minimumDate
        datePickerView.locale = Locale(identifier: "en_US_POSIX")
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged(sender:)), for: .valueChanged)
        
        
    }
    
    
    @objc func didDatePickerViewValueChanged(sender: UIDatePicker) {
  //  pickerTextfield.text = sender.date.string(format: .dateTime24, type: .local)
       pickerDelegate?.didSelectDate?(date: sender.date)
    }
    
    // DatePicker only for Date
    func setDatePicker2(textField: UITextField, datePickerMode: UIDatePicker.Mode = .dateAndTime, maximunDate: Date? = nil, minimumDate: Date? = Date()) {
        textField.inputView = datePickerView
        pickerTextfield = textField
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        //datePickerView.backgroundColor = UIColor.lightGray
        let currentDate = Date()
        var dateComponents = DateComponents()
        
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = 100
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minimumDate
        pickerTextfield.text = datePickerView.date.string(format: .StoryDateFormat, type: .local)
        
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged2(sender:)), for: .valueChanged)
        
    }
   
    @objc func didDatePickerViewValueChanged2(sender: UIDatePicker) {
        
       pickerTextfield.text = sender.date.string(format: .StoryDateFormat, type: .local)
        pickerDelegate?.didSelectDate?(date: sender.date)
    }
    
    func setDatePicker3(textField: UITextField, datePickerMode: UIDatePicker.Mode = .dateAndTime, maximunDate: Date? = nil, minimumDate: Date? = Date()) {
        textField.inputView = datePickerView
        pickerTextfield = textField
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        //datePickerView.backgroundColor = UIColor.lightGray
        datePickerView.maximumDate = maximunDate
        datePickerView.minimumDate = minimumDate
        pickerTextfield.text = datePickerView.date.string(format: .localTime, type: .local)
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged3(sender:)), for: .valueChanged)
        
    }
   
    @objc func didDatePickerViewValueChanged3(sender: UIDatePicker) {
        
        pickerTextfield.text = sender.date.string(format: .localTime, type: .local)
        pickerDelegate?.didSelectDate?(date: sender.date)
    }
    
    
    func setDatePicker4(textField: UITextField, datePickerMode: UIDatePicker.Mode = .dateAndTime, maximunDate: Date? = nil, minimumDate: Date? = Date()) {
        textField.inputView = datePickerView
        pickerTextfield = textField
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        //datePickerView.backgroundColor = UIColor.lightGray
        let currentDate = Date()
        var dateComponents = DateComponents()
        
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100//110
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        let maxDate = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        
        
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
        pickerTextfield.text = datePickerView.date.string(format: .DOBFormat, type: .local)
        
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged4(sender:)), for: .valueChanged)
        
    }
   
    @objc func didDatePickerViewValueChanged4(sender: UIDatePicker) {
        
        pickerTextfield.text = sender.date.string(format: .DOBFormat, type: .local)
        pickerDelegate?.didSelectDate?(date: sender.date)
    }
}

extension BaseVC {
    /*
    func showAlert(Textfield:String? = nil, TextView: Bool = false,message: String?,wordCount: String?,  cancelAction: Button? = nil, okayTitle: String = kOkay, _ okayAction: Button? = nil, showColorView: Bool = false,showTextView: String?, showCancel: Bool = true) {
        let alert = PopUpView(Textfield: Textfield, Textview: TextView,message: message,wordCount: wordCount, doneButtonTitle: okayTitle, showColorView: showColorView,showTextView: showTextView, showCancel: showCancel)
        alert.cancelButton.add {
            cancelAction?()
            alert.remove()
        }
        alert.DoneButton.add {
            okayAction?()
            alert.remove()
        }
        alert.show()
    }
    */
    
    func parseImageCheckData(response: JSONDictionary) -> ImageCheckDM?{
        var imageData:ImageCheckDM?
        
            if let data = response as? JSONDictionary
            {
                
                    imageData = ImageCheckDM(detail: data)
                
        
            }
        return imageData
    }
}

extension BaseVC {
    
    func createTriangles(parentView: UIView) {
        var path = UIBezierPath()
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0 , y: parentView.frame.width/2))
        path.addLine(to: CGPoint(x: parentView.frame.height, y:0 ))
        
        path.addLine(to: CGPoint(x: parentView.frame.width, y: parentView.frame.height))
        path.close()
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path.cgPath
        shapeLayer1.fillColor = #colorLiteral(red: 0.1895350516, green: 0.7467307448, blue: 0.7134981751, alpha: 1)
        parentView.layer.addSublayer(shapeLayer1)
    }
    
    func createrighttriangle(parentView: UIView) {
        var path = UIBezierPath()
        path = UIBezierPath()
        path.move(to: CGPoint(x:0 , y:0))
        path.addLine(to: CGPoint(x: parentView.frame.size.height, y:parentView.frame.width/2))
        
        path.addLine(to: CGPoint(x: 0, y: parentView.frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path.cgPath
        shapeLayer1.fillColor = #colorLiteral(red: 0.1895350516, green: 0.7467307448, blue: 0.7134981751, alpha: 1)
        parentView.layer.addSublayer(shapeLayer1)
    }
}

extension BaseVC {
    public func calculatePercentage(value:Double,percentageVal:Int)->Double {
        let val = value * Double(percentageVal)
        return (Double(val / 100).roundTo(places: 2))
    }
    
    public func calculateFifteenPercent(value:Double,percentageVal:Int) -> Double {
        let val = value * Double(percentageVal)
        return (Double(val / 100).roundTo(places: 2))
    }
}

extension BaseVC {
        func image(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
            let data1: NSData = image1.pngData()! as NSData
            let data2: NSData = image2.pngData()! as NSData
            return data1.isEqual(data2)
        }
    
    
}



extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}




extension UINavigationBar {
    func setGradientBackground(colors: [Any]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
    

        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        gradient.frame = updatedFrame
        gradient.colors = colors;
        self.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
    }

    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}
//MARK: - Detect shake of device

extension BaseVC
{
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let date = Date()
      debugPrint("Device shaken, Cancel \(motion) \(date)")
        debugPrint("Base vc \(DataManager.isProfileCompelete)")
         if ((DataManager.isProfileCompelete) && (DataManager.isPrefrenceSet) && (DataManager.isEditProfile))
        {
        
        if let startDate = self.startDate {
      let timeInterval = Int(date.timeIntervalSince(startDate))
        
            debugPrint(timeInterval)
            if timeInterval>=1
            {
                UIDevice.vibrate()

                let vc = ShakeSentVC.instantiate(fromAppStoryboard: .Shake)

                if let tab = self.tabBarController
                {
                    tab.present(vc, animated: true, completion: nil)
                }
                else
                {
                    self.present(vc, animated: true, completion: nil)
                }
            }

         }
        }
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       
        
        if Connectivity.isConnectedToInternet {
            if motion == .motionShake
            {
                self.startDate = Date()
                debugPrint("Device shaken = \(motion) \(self.startDate)")
          
            }
         } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            if Connectivity.isConnectedToInternet {
                debugPrint("Base vc \(DataManager.isProfileCompelete)")
            if ((DataManager.isProfileCompelete) && (DataManager.isPrefrenceSet) && (DataManager.isEditProfile))
            {
            
          let date = Date()
            debugPrint("Device shake stop, shake timer stopeed = \(motion) \(date)")
        
            if let startDate = self.startDate {
          let timeInterval = Int(date.timeIntervalSince(startDate))
            
                debugPrint(timeInterval)
                if timeInterval>=1
                {
                    UIDevice.vibrate()
                    let vc = ShakeSentVC.instantiate(fromAppStoryboard: .Shake)

                    if let tab = self.tabBarController
                    {
                        tab.present(vc, animated: true, completion: nil)
                    }
                    else
                    {
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }

             }
            }
        }
            else {
                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
        }
    }
   
}
//MARK: - check image

 extension BaseVC
 {
    func isImageAppropriate(dataImage:Data,successCallback: @escaping JSONDictionaryResponseCallback)
    {
        var isAppropriate=false
        if Connectivity.isConnectedToInternet {

        APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
            
            (responseDict) in
            debugPrint(responseDict)
           
            if kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")//responseDict[ApiKey.kStatus] as? String == kSucess
            {
              
             let data =   self.parseImageCheckData(response: responseDict)
                
                debugPrint(data)
                if data?.weapon ?? 0.0 > kNudityCheck
                {
                    isAppropriate=false
                    successCallback([:])
                    self.openSimpleAlert(message: kImageCkeckAlert)
                }
//                else if  data?.alcohol ?? 0.0 > kNudityCheck
//                {
//                    isAppropriate=false
//                    successCallback([:])
//                    self.openSimpleAlert(message: kImageCkeckAlert)
//                }
                else if  data?.drugs ?? 0.0 > kNudityCheck
                {
                    isAppropriate=false
                    successCallback([:])
                    self.openSimpleAlert(message: kImageCkeckAlert)
                }
                else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
                {
                    isAppropriate=false
                    successCallback([:])
                    self.openSimpleAlert(message: kImageCkeckAlert)
                }
                else
                {
                    isAppropriate=true
                    successCallback(["isAppropriate":"true"])
                }
                
            }
            else
            {
                isAppropriate=false
                successCallback([:])
                let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                self.openSimpleAlert(message: message)
            }
            
            
            
        },  failureCallback: { (errorReason, error) in
            successCallback([:])
            debugPrint(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
            
        })
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
      //  return isAppropriate
    }
    
    
    func getAspectRatioAccordingToiPhones(cellImageFrame:CGSize,downloadedImage: UIImage)->CGFloat {
            let widthOffset = downloadedImage.size.width - cellImageFrame.width
            let widthOffsetPercentage = (widthOffset*100)/downloadedImage.size.width
            let heightOffset = (widthOffsetPercentage * downloadedImage.size.height)/100
            let effectiveHeight = downloadedImage.size.height - heightOffset
            return(effectiveHeight)
        }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? UIImage()
    }
    
    func showImageCheckLoader(vc:UIViewController)
    {
    
    let alert = UIAlertController(title: nil, message: kImageContentChecking, preferredStyle: .alert)
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.isUserInteractionEnabled = false
    activityIndicator.startAnimating()

    alert.view.addSubview(activityIndicator)
    alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true

    activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
    activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true

        vc.present(alert, animated: true)
    }
    
 }

//MARK: -Socket method

extension BaseVC
{
    func selfJoinSocketEmit2()
    {
        if DataManager.Id != kEmptyString
        {
            let JoinDict = ["selfUserId":DataManager.Id]
            SocketIOManager.shared.selfJoinSocket(MessageChatDict: JoinDict)
            self.selfJoinSocketON2()
        }
       
    }
    func selfJoinSocketON2()
    {
        SocketIOManager.shared.socket.on("online", callback: { (data, error) in
            
            debugPrint("online = \(data) \(error)")
        })
        
    }
    
    
}

// MARK: extension for image conversion from data
extension BaseVC {
    func dataToImage(data: Data) -> UIImage {
        var image: UIImage?
        image = UIImage(data: data)
        return image ?? UIImage()
    }
}
//MARK: - APi call

extension BaseVC
{
    func updateLocationAPI()
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.KDeviceToken] = AppDelegate.DeviceToken
        
        if Connectivity.isConnectedToInternet {
            
            self.callApiForUpdateLatLong(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    func callApiForUpdateLatLong(data:JSONDictionary)
    {
        HomeVM.shared.callApiForUpdateUserLatLong(showIndiacter: false, data: data, response: { (message, error) in
    })
}
}
//MARK: - socket call
extension BaseVC
{
    
    func selfJoinSocketEmit()
    {
        
        let JoinDict = ["selfUserId":DataManager.Id]
        SocketIOManager.shared.selfJoinSocket(MessageChatDict: JoinDict)
        
    }
    
    func badgeCountIntervalCheckEmit()
    {
        
        let JoinDict = ["userId":DataManager.Id]
        
        debugPrint("badgeCountIntervalCheckEmit \(JoinDict)")
        SocketIOManager.shared.badgeCountIntervalCheckEmit(MessageChatDict: JoinDict)
        DispatchQueue.main.async {
            self.badgeCountIntervalCheckON()
        }
        
    }
    func badgeCountIntervalCheckON()
    {
        SocketIOManager.shared.socket.on("receivedBadgeCount", callback: { (data, error) in
            debugPrint(#function)
            debugPrint(data)

    
            if let data = data as? JSONArray
            {
                for dict in data
                {

                    let badgeCount =  dict["badgeCount"] as? Int ?? 0
                    if badgeCount > 0
                    {
                       // self.tabBarController?.addRedDotAtTabBarItemIndex(index: 1)//.tabBar.addBadge(index: 1)
               self.tabBarController?.tabBar.addBadge(index: 1)
                    }
                    else
                    {
                        //self.tabBarController?.tabBar.removeBadge(index: 1)
                       // self.tabBarController?.removeDotAtTabBarItemIndex(index: 1)
                        self.tabBarController?.tabBar.removeBadge(index: 1)
                    }
                }
            }
            else
            {
                //self.tabBarController?.removeDotAtTabBarItemIndex(index: 1)
                self.tabBarController?.tabBar.removeBadge(index: 1)
            }

            //  debugPrint("receivedBadgeCount = \(data) \(error)")
        })

    }
}

//extension BaseVC
//{
//    func updateLocationAPI()
//    {
//        var data = JSONDictionary()
//        
//        data[ApiKey.kLatitude] = CURRENTLAT
//        data[ApiKey.kLongitude] = CURRENTLONG
//        
//        if Connectivity.isConnectedToInternet {
//            
//            self.callApiForUpdateLatLong(data: data)
//        } else {
//            
//            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
//        }
//        
//    }
//    
//    func callApiForUpdateLatLong(data:JSONDictionary)
//    {
//        HomeVM.shared.callApiForUpdateUserLatLong(showIndiacter: false, data: data, response: { (message, error) in
//            debugPrint("Location update api = \(message)")
//            
//        })
//    }
//    
//}
