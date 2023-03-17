//
//  AppDelegate.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleSignIn
import UserNotifications
import GoogleMobileAds
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FBSDKLoginKit
import SDWebImage
import PushKit
import CallKit
import Intents
import AgoraRtcKit
import AgoraRtmKit
import CallKit
import PushKit
import Branch
import GoogleAnalytics
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var timerBudgeCount:Timer?
    var timerTimeLeftCheck:Timer?
    var Agora_Rtm_Token = ""
    var window: UIWindow?
     var provider: CXProvider?
    static var i=1;
    var storyVisitCount = 0
    var homeVisitCount = 0
    var hangoutVisitCount = 0
    var profileVisitCount = 0
    var prefrenceVisitCount = 0
    var chatVisitCount = 0

    var agoraKit: AgoraRtcEngineKit?
    var agoraRtmKit: AgoraRtmKit?
    
    static var DeviceToken: String = "12335556"
    static var VOIPDeviceToken: String = "12335556"
    var VOIPDictionary:JSONDictionary = [:]
    
    var agoraChannelName = ""
    var agoraChannelUID = ""
    var agoraToken = ""
    var uuid = UUID()
    var isMessageNoti = false
    private lazy var appleCallKit = CallCenter(delegate: self)
    //MARK: - For call
    
    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
        let backgroundTask = UIBackgroundTaskIdentifier.invalid
        return backgroundTask
    }()
    
    var isChangedConnection = true
    var isCallOngoing = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = isCallOngoing
        }
    }
    
    var callManager = CallKitManager()
    var self_user_id = ""
    var Other_user_id = ""
    var kit = AgoraRtmKit(appId: AGORA_APP_ID, delegate: nil)
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        ApplicationDelegate.initializeSDK(nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
        GoogleMapAdsSetup()
        DataManager.isMessagePageOpen=false
        DataManager.comeFromTag=5
        
        //
        
        Thread.sleep(forTimeInterval: 2)
        callManager.setupCallKit()
        NotificationSetup()
        
      
        if DataManager.isProfileCompelete
        {
            
            if DataManager.isPrefrenceSet == false
            {
                
                APPDEL.navigateToPrefrence()
            }
          else  if DataManager.isEditProfile == false
            {
                
                APPDEL.navigateToEditProfile()
            }
            else
            {
                APPDEL.navigateToHome(userId: "")
            }
            
        }
        else
        {
            APPDEL.navigateToLogin()
        }
        
    
        clearFilter()
        
        
        self.voipRegistration()
       
        
//        let registry = PKPushRegistry(queue: nil)
//        registry.delegate = self
//        registry.desiredPushTypes = [PKPushType.voIP]
//
        Branch.getInstance().setIdentity("ios@deftsoft.info")
        if #available(iOS 13.0, *) {
            BranchScene.shared().initSession(launchOptions: launchOptions, registerDeepLinkHandler: { (params, error, scene) in
                debugPrint("Param =\(String(describing: params))")
                debugPrint("error =\(String(describing: error))")
            })
        } else {
            // Fallback on earlier versions
        }
       
        ConnectionManager.sharedInstance.observeReachability()
        GoogleAnalyticsSetup()
        DataManager.Language = kEmptyString.currentLanguage
        return true
    }
    
    override init()
    {
        super.init()
        UIFont.overrideInitialize()
    }
    // Register for VoIP notifications
     func voipRegistration() {
         
         // Create a push registry object
         let mainQueue = DispatchQueue.main
         let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
         voipRegistry.delegate = self
         voipRegistry.desiredPushTypes = [PKPushType.voIP]
     }
    
    func NotificationSetup()
    {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // If granted comes true you can enabled features based on authorization.
            guard granted else { return }
            
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    //MARK: - Get device token
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        AppDelegate.DeviceToken = token
        
        debugPrint("Device Token = \(token)")
    
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0// UIApplication.shared.applicationIconBadgeNumber+1
        
        debugPrint("willPresent \(notification)")
        if DataManager.isMessagePageOpen
        {
            completionHandler([])
            
        }
        else
        {
            completionHandler([.alert, .badge, .sound])
        }
        
        
    }
   
 
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        debugPrint(#function)
        debugPrint(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0// UIApplication.shared.applicationIconBadgeNumber+1
        

    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint("Do what ever you want")
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let userInfo = response.notification.request.content.userInfo
        debugPrint(userInfo)
        self.isMessageNoti=false
        if let details = userInfo["sendDetail"] as? JSONDictionary
        {
            let Noti_type = details["noti_type"] as? String ?? ""
            
            let id = details["from_user_id"] as? String ?? ""
            
            let likeMode = details["like_mode"] as? String ?? ""
            let story_id = details["story_id"] as? String ?? ""
            let hangout_id = details["hangout_id"] as? String ?? ""
            debugPrint(id)
            
            if Noti_type ==  "3"
            {
                let vc = MatchVC.instantiate(fromAppStoryboard: .Home)

                vc.comefrom = kAppDelegate
                vc.view_user_id = id
                let navvc = UINavigationController(rootViewController: vc)
                
                if UIApplication.shared.keyWindow == nil {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = navvc
                    self.window?.makeKeyAndVisible()
                }else {
                    UIApplication.shared.keyWindow?.rootViewController = navvc
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
             //
            }
            else  if Noti_type == "5"
            {
                self.isMessageNoti=true
                
                let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)//storyBoard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                vc.comfrom = kAppDelegate
                vc.view_user_id=id
                let navvc = UINavigationController(rootViewController: vc)
                
                if UIApplication.shared.keyWindow == nil {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = navvc
                    self.window?.makeKeyAndVisible()
                }else {
                    UIApplication.shared.keyWindow?.rootViewController = navvc
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
               //
            }
            //MARK: - Change notification redirection: Hangout Like: noti_type = "6";  Story Like : let noti_type = "9"; shake = 1, profile like = 2
           
            else if Noti_type == "1" || Noti_type == "6" || Noti_type == "2"
            {
                /*
                let storyBoard = UIStoryboard.storyboard(storyboard: .Home)
                
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                vc.comeFrom = kAppDelegate
            
                vc.view_user_id=id
                vc.likeMode=likeMode
                vc.story_id=story_id
                vc.hangout_id=hangout_id
                let navvc = UINavigationController(rootViewController: vc)
                
                if UIApplication.shared.keyWindow == nil {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = navvc
                    self.window?.makeKeyAndVisible()
                }else {
                    UIApplication.shared.keyWindow?.rootViewController = navvc
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
                */
                self.isMessageNoti=true
                
                let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)//storyBoard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                vc.selectedIndex=2
                let navvc = UINavigationController(rootViewController: vc)
                navvc.navigationBar.isHidden = true
                if UIApplication.shared.keyWindow == nil {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = navvc
                    self.window?.makeKeyAndVisible()
                }else {
                    UIApplication.shared.keyWindow?.rootViewController = navvc
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
          //  self.navigateToHome(selectedIndex: 2)
            }
         
            
            //Hangout update
            
            else if Noti_type == "11"
            {
                let vc = PostHangoutVC.instantiate(fromAppStoryboard: .Hangouts)

                vc.comeFrom = kAppDelegate
            
                vc.view_user_id=id
                vc.hangout_id=hangout_id
                vc.fromEdit=true
                let navvc = UINavigationController(rootViewController: vc)
                
                if UIApplication.shared.keyWindow == nil {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = navvc
                    self.window?.makeKeyAndVisible()
                }else {
                    UIApplication.shared.keyWindow?.rootViewController = navvc
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
            }
            
            else // if Noti_type == "6"
            {
                let state = UIApplication.shared.applicationState
                if state == .active || state == .inactive
                {
                   debugPrint("I'm active")
                    NotificationCenter.default.post(name: Notification.Name("ViewProfileNotification"), object: nil, userInfo:details)
                    //["view_user_id":id,"likeMode":likeMode])
                    
                    
                   // self.navigateToVCOne()
                   //
                }
                else
                {
                    debugPrint("I'm \(state)")
                    DataManager.comeFrom = kEmptyString
                   
                    let vc = ViewProfileVC.instantiate(fromAppStoryboard: .Home)//storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                    vc.comeFrom = kAppDelegate
                    vc.view_user_id=id
                    vc.likeMode=likeMode
                    vc.story_id=story_id
                    vc.hangout_id=hangout_id
                    let navvc = UINavigationController(rootViewController: vc)
                    
                    if UIApplication.shared.keyWindow == nil {
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = navvc
                        self.window?.makeKeyAndVisible()
                    }else {
                        UIApplication.shared.keyWindow?.rootViewController = navvc
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    }
                    
                    /*
                    let storyBoard = UIStoryboard.storyboard(storyboard: .Home)
                    
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                    vc.comeFrom = kAppDelegate
                    //                let hangoutId = details["hangout_id"] as? String ?? ""
                    //                debugPrint(hangoutId)
                    
                    vc.view_user_id=id
                    vc.likeMode=likeMode
                    vc.story_id=story_id
                    vc.hangout_id=hangout_id
                    let navvc = UINavigationController(rootViewController: vc)
                    
                    if UIApplication.shared.keyWindow == nil {
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = navvc
                        self.window?.makeKeyAndVisible()
                    }else {
                        UIApplication.shared.keyWindow?.rootViewController = navvc
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    }
                   //
                     */
                }
                
               
            }
            /*
            else
            {
                    let storyBoard = UIStoryboard.storyboard(storyboard: .Home)
                    
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                    vc.comeFrom = kAppDelegate
                    //                let hangoutId = details["hangout_id"] as? String ?? ""
                    //                debugPrint(hangoutId)
                    
                    vc.view_user_id=id
                    vc.likeMode=likeMode
                vc.story_id=story_id
                vc.hangout_id=hangout_id
                    let navvc = UINavigationController(rootViewController: vc)
                    
                    if UIApplication.shared.keyWindow == nil {
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = navvc
                        self.window?.makeKeyAndVisible()
                    }else {
                        UIApplication.shared.keyWindow?.rootViewController = navvc
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    }
                 //
                
//                else if state == .inactive {
//                   debugPrint("I'm inactive")
//                }
//                else if state == .background {
//                   debugPrint("I'm in background")
//                }
                

                
            }
            
            */
            
            
        }
    }
    
    // [END openurl]
    // [START openurl_new]
    
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        debugPrint("********** MEMORY WARNING **********")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Flazhed")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // SocketIOManager.sharedInstance.establishConnection()
        //SocketIOManager.shared.initializeSocket()
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint(#function)
    
        Indicator.sharedInstance.hideIndicator()
        //        SocketIOManager.shared.disconnectSocket()
        //        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        //        try? AVAudioSession.sharedInstance().setActive(false)
        
    }
    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint(#function)
        APPDEL.timerBudgeCount?.invalidate()
        Indicator.sharedInstance.hideIndicator()
        DataManager.isMessagePageOpen=false
        
        
//        self.provider?.reportCall(with: self.uuid, endedAt: Date(), reason: .remoteEnded)
//
//        self.leaveChannel(sendDetail: self.VOIPDictionary)
        //  SocketIOManager.shared.disconnectSocket()
        //        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        //        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        Indicator.sharedInstance.hideIndicator()
        debugPrint(#function)
    }
    
    
    
    
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                debugPrint("The user has not signed in before or they have since signed out.")
            } else {
                debugPrint("\(error.localizedDescription)")
            }
            return
        }
        
        // Post notification after user successfully sign in
        NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
    }
}

// MARK:- Notification names
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
extension AppDelegate {
    
    
//    func setUpBranchIO()
//    {
//
//
//    }
//
    
    func clearFilter()
    {
        
        self.hangoutVisitCount=0
        DataManager.isViewProfile=false
        DataManager.storyAllPostSelected=""
        DataManager.storyImageSelected=""
        DataManager.storyVideoSelected=""
        
        DataManager.storyMatchSelected="0"
        DataManager.storyMyPostSelected="0"
        
        DataManager.social=""
        DataManager.travel=""
        DataManager.sport=""
        DataManager.business=""
        
        DataManager.men=""
        DataManager.women=""
        
        DataManager.ase=""
        DataManager.desc=""
        
        DataManager.latest=""
        DataManager.oldest=""
        
        DataManager.chatFilter=""
        
    }
    
    func navigateToHome(userId:String = "",selectedIndex:Int = 2) {
     
 
        let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=selectedIndex
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    
    }
    func navigateToLogin() {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
       // let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let vc = storyBoard.instantiateViewController(withIdentifier: "loginNav") as! UINavigationController
        //let nav = UINavigationController(rootViewController: vc)
        vc.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
    }
    func navigateToSentShake()
    {
    
        let vc = ShakeSentVC.instantiate(fromAppStoryboard: .Shake)
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
    func navigateToStories()
    {
      
        
        let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=2
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
  
    
    func navigateToHangout()
    {
       
        let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=0
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
    func navigateToChat()
    {
        let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=3
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
    func navigateToPrefrence()
    {
        let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PreferencesVC") as! PreferencesVC
        let nav = UINavigationController(rootViewController: vc)
        vc.comeFrom=kAppDelegate
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
    func navigateToEditProfile()
    {
        let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        let nav = UINavigationController(rootViewController: vc)
        vc.comeFrom=kAppDelegate
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
  
    
    func navigateToAudioCall(sendDetail:JSONDictionary)
    {
        let details = sendDetail["object_data"] as? JSONDictionary ?? [:]
        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AudioCallingVC") as! AudioCallingVC
        let nav = UINavigationController(rootViewController: vc)
        vc.comeFrom=kAppDelegate
        vc.agoraChannelName = details["chanel_name"] as? String ?? ""
        vc.agoraToken = details["rtc_token_subscriber"] as? String ?? ""
        vc.agoraChannelUID = details["uid_subscriber"] as? String ?? ""
        vc.profileImageUrl = details["profile_image"] as? String ?? ""
        vc.userName = sendDetail["from_user_name"] as? String ?? ""
        
        vc.uid_publish = details["uid_publish"] as? String ?? ""
        vc.uid_subscriber = details["uid_subscriber"] as? String ?? ""
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
    func navigateToVideoCall(sendDetail:JSONDictionary)
    {
        let details = sendDetail["object_data"] as? JSONDictionary ?? [:]
        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
        let nav = UINavigationController(rootViewController: vc)
        vc.comeFrom=kAppDelegate
        vc.agoraChannelName = details["chanel_name"] as? String ?? ""
        vc.agoraToken = details["rtc_token_subscriber"] as? String ?? ""
        vc.agoraChannelUID = details["uid_subscriber"] as? String ?? ""
        vc.profileImageUrl = details["profile_image"] as? String ?? ""
        vc.userName = sendDetail["from_user_name"] as? String ?? ""
        
        vc.uid_publish = details["uid_publish"] as? String ?? ""
        vc.uid_subscriber = details["uid_subscriber"] as? String ?? ""
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    func openHangoutDetails(details:JSONDictionary)
    {
        
     let storyBoard = UIStoryboard.storyboard(storyboard: .Home)
    
    let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
    vc.comeFrom = kAppDelegate
    //                let hangoutId = details["hangout_id"] as? String ?? ""
    //                debugPrint(hangoutId)
    
        vc.view_user_id  = details["from_user_id"] as? String ?? ""
        
        vc.likeMode = details["like_mode"] as? String ?? ""
        vc.story_id = details["story_id"] as? String ?? ""
        vc.hangout_id = details["hangout_id"] as? String ?? ""
    let navvc = UINavigationController(rootViewController: vc)
    
    if UIApplication.shared.keyWindow == nil {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navvc
        self.window?.makeKeyAndVisible()
    }else {
        UIApplication.shared.keyWindow?.rootViewController = navvc
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    }
    
    func navigateToVCOne() {
        
        if let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ViewProfileVC") as? ViewProfileVC {
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: true, completion: nil)
            }
        }
    }

}
//MARK: - For call

extension AppDelegate
{
    
    
    func GoogleMapAdsSetup()
    {
        GIDSignIn.sharedInstance().clientID = "973725628875-qi4sur8d7055jqukjkeculeitcej9s1q.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
//        GMSPlacesClient.provideAPIKey("AIzaSyAJW8tYVGyKzHGnMWtnuDrJ5_ejLGjnonI")
//        GMSServices.provideAPIKey("AIzaSyAJW8tYVGyKzHGnMWtnuDrJ5_ejLGjnonI")
        
        GMSPlacesClient.provideAPIKey("AIzaSyDREAm2iJNFlll4RL65CxC8CoVhgqrDlPE")
        GMSServices.provideAPIKey("AIzaSyDREAm2iJNFlll4RL65CxC8CoVhgqrDlPE")
        
        //AIzaSyCMxGDqHae2l4uLVuAHNNFU5gd_ChoqXmo

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [(kGADSimulatorID as! String)]

    }
    
    
}
//MARK: - Google/facebook Url Methods
extension AppDelegate{
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        
        if GIDSignIn.sharedInstance().handle(url){
            return GIDSignIn.sharedInstance().handle(url)
        }else{
            return ApplicationDelegate.shared.application(
                application,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
    }
    
}

extension AppDelegate:PKPushRegistryDelegate,CXProviderDelegate
{
   

    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
    
        AppDelegate.VOIPDeviceToken = token
        debugPrint("Voip Device Token: \(token)")
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        debugPrint("Payload =\(payload.dictionaryPayload as? [String : Any])")
        self.provider?.reportCall(with: self.uuid, endedAt: Date(), reason: .remoteEnded)
        
        if !isCallOngoing,
            let dict = payload.dictionaryPayload as? [String : Any],
            let sendDetail = dict["sendDetail"] as? JSONDictionary,
            let callerName = sendDetail["from_user_name"] as? String

        {
  
            let rtmToken_subscriber = sendDetail["rtmToken_subscriber"] as? String ?? ""
            self.Agora_Rtm_Token=rtmToken_subscriber
           
            // let from_user_id = sendDetail["from_user_id"] as? String ?? ""
             //callManager.setConfiguration()
             self.VOIPDictionary = sendDetail
             //self.appleCallKit.showIncomingCall(of: callerName)
             
             let uuid = UUID()
             self.uuid = uuid
             
             self.provider = callManager.callKitProvider
             provider?.setDelegate(self, queue: nil)
             if provider == nil {
                 let configuration = CXProviderConfiguration(localizedName: "Flazhed")
                 configuration.maximumCallGroups = 1
                 configuration.maximumCallsPerCallGroup = 1
                 configuration.supportsVideo = true// hasVideo
                 configuration.supportedHandleTypes = [.generic]
                 if let callKitIcon = UIImage(named: "blueheartIcon2") {
                     configuration.iconTemplateImageData = callKitIcon.pngData()
                 }

                 provider = CXProvider.init(configuration: configuration)
             }

             callManager.callKitProvider = provider

             callManager.reportIncomingCall(uuid: self.uuid, callerName: callerName) { (error) in
                 if error == nil {
                     NSLog("Incoming call successfully reported Callback.")
                 } else {
                     NSLog("Failed to report incoming call successfully: \(String(describing: error?.localizedDescription)).")
                 }
             }
//            self.Agora_RTM_Setup()
           
//             if let kit = AgoraRtm.shared().kit {
//                 debugPrint("self.from_user_id = \(DataManager.Id)")
//
//
//                 kit.login(account: DataManager.Id, token: rtmToken_subscriber) { [unowned self] (error) in
//                     debugPrint("App del rtm login error = \(error.localizedDescription)")
//                 }
//             }
             DispatchQueue.main.async {
               completion()
             }
//             DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
//                 self.provider?.reportCall(with: self.uuid, endedAt: Date(), reason: .remoteEnded)
//                }
            
        }

        else {
            debugPrint("else isCallOngoing")
        }
        
        self.getRTMTokenApi()
        
    }
    
    
    func providerDidReset(_ provider: CXProvider)
    {
        debugPrint(#function)
        debugPrint("provider did reset \(provider)")
    }
//MARK: - Answer call
    
        func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
            debugPrint("Answer button tap")
            debugPrint(#function)
            action.fulfill()
            
            let details = self.VOIPDictionary["object_data"] as? JSONDictionary ?? [:]
            let call_type = details["call_type"] as? String ?? ""
            
            if call_type.capitalized == kAudio.capitalized{
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToAudioCall(sendDetail: self.VOIPDictionary)
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToAudioCall(sendDetail: self.VOIPDictionary)
                }
            }
            else
            {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToVideoCall(sendDetail: self.VOIPDictionary)
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToVideoCall(sendDetail: self.VOIPDictionary)
            }
            }
           
            
        }
    //MARK: - Reject call
        func provider(_ provider: CXProvider, perform action: CXEndCallAction)
        {
            if let inviter = AgoraRtm.shared().inviter  {
                debugPrint("inviter =")
                inviter.cancelLastOutgoingInvitation()//sendInvitation(peer: self.Other_user_id)
                
                
                inviter.refuseLastIncomingInvitation {  [weak self] (error) in
                   debugPrint("refuseLastIncomingInvitation =",error.localizedDescription)
                }
            }
           
            self.leaveChannel(sendDetail: self.VOIPDictionary)
          //  NotificationCenter.default.post(name: Notification.Name("CallEndNotificationIdentifier"), object: nil)
            debugPrint("Cancel button tap")
            debugPrint(#function)
            action.fulfill()
        }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        debugPrint("continue userActivity tap")
        guard let viewController = VideoCallingVC()  as? VideoCallingVC, let interaction = userActivity.interaction else {
            return false
        }

        
        var personHandle: INPersonHandle?

        if let startVideoCallIntent = interaction.intent as? INStartVideoCallIntent {
            personHandle = startVideoCallIntent.contacts?[0].personHandle
        } else if let startAudioCallIntent = interaction.intent as? INStartAudioCallIntent {
            personHandle = startAudioCallIntent.contacts?[0].personHandle
        }

        if let personHandle = personHandle {
            callManager.performStartCallAction(uuid: UUID(), callerName: personHandle.value)
        }

        return true
    }
    
    func leaveChannel(sendDetail:JSONDictionary) {
        debugPrint(#function)
        let details = sendDetail["object_data"] as? JSONDictionary ?? [:]
        self.agoraChannelName = details["chanel_name"] as? String ?? ""
        self.agoraToken = details["rtc_token_subscriber"] as? String ?? ""
        self.agoraChannelUID = details["uid_subscriber"] as? String ?? ""
        self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AGORA_APP_ID, delegate: nil)
        
        self.agoraKit?.joinChannel(byToken: agoraToken, channelId: agoraChannelName, info: nil, uid: UInt(agoraChannelUID) ?? 0, joinSuccess: { [weak self] (channel, uid, elapsed) in
            
            debugPrint("Join chanel \(channel) \(uid) \(elapsed)")
            if let weakSelf = self {
              //  weakSelf.agoraKit?.setEnableSpeakerphone(true)
               
                UIApplication.shared.isIdleTimerDisabled = true
                self?.agoraKit?.leaveChannel(nil)
                AgoraRtcEngineKit.destroy()
                debugPrint("leave channel call")
               
                self?.agoraKit = nil
                
            }
        })
  
//        self.agoraKit?.leaveChannel(nil)
//        AgoraRtcEngineKit.destroy()
//        debugPrint("leave channel call")
//
//        self.agoraKit = nil
        
       
    }
    
//    private func handleAudioCall(roomId: String, person: Person, token: String, uuid: UUID) {
//        if let vc = Storyboards.Call.storyboard().instantiateViewController(withIdentifier: VoiceCallVC.className) as? VoiceCallVC  {
//            debugPrint("UUID: setting \(uuid)")
//            vc.callUuid = uuid
//            vc.person = person
//            vc.chatRoomId = roomId
//            vc.accessToken = token
//            vc.callManager = callManager
//            vc.basicSetup()
//
//            callManager.delegate = vc
//
//            callManager.onCallAnswear = {
//                Helpers.mainNavVC().pushViewController(vc, animated: true)
//                self.callManager.onCallAnswear = {}
//            }
//        }
//    }
    
//    private func handleVideoCall(roomId: String, person: Person, token: String, uuid: UUID)
//    {
//        if let vc = Storyboards.Call.storyboard().instantiateViewController(withIdentifier: VideoCallVC.className) as? VideoCallVC  {
//
//            vc.callUuid = uuid
//            vc.person = person
//            vc.chatRoomId = roomId
//            vc.accessToken = token
//            vc.callManager = callManager
//            vc.basicSetup()
//            vc.needToPrepareLocalMedia = true
//
//            callManager.delegate = vc
//
//            callManager.onCallAnswear = {
//                Helpers.mainNavVC().pushViewController(vc, animated: true)
//                self.callManager.onCallAnswear = {}
//            }
//        }
//    }
    
}
//MARK: - CallCenterDelegate

extension AppDelegate: CallCenterDelegate {
    func callCenter(_ callCenter: CallCenter, answerCall session: String) {
        debugPrint("callCenter answerCall")
                
        if let inviter = AgoraRtm.shared().inviter {
            inviter.accpetLastIncomingInvitation()
        }
        let details = self.VOIPDictionary["object_data"] as? JSONDictionary ?? [:]
        let call_type = details["call_type"] as? String ?? ""
        
        if call_type.capitalized == kAudio.capitalized{
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToAudioCall(sendDetail: self.VOIPDictionary)
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToAudioCall(sendDetail: self.VOIPDictionary)
            }
        }
        else
        {
        if #available(iOS 13.0, *) {
            SCENEDEL?.navigateToVideoCall(sendDetail: self.VOIPDictionary)
        } else {
            // Fallback on earlier versions
            APPDEL.navigateToVideoCall(sendDetail: self.VOIPDictionary)
        }
        }

        
        
//        guard let channel = inviter.lastIncomingInvitation?.content else {
//            fatalError("lastIncomingInvitation content nil")
//        }
//
//        guard let remote = UInt(session) else {
//            fatalError("string to int fail")
//        }
        
       
        
        // present VideoChat VC after 'callCenterDidActiveAudioSession'
      //  self.prepareToVideoChat = { [weak self] in
         //   var data: (channel: String, remote: UInt)
         //   data.channel = channel
        //    data.remote = remote
       // debugPrint("Video call")
           // self?.performSegue(withIdentifier: "DialToVideoChat", sender: data)
        //}
    }
    
    func callCenter(_ callCenter: CallCenter, declineCall session: String) {
        debugPrint("callCenter declineCall")
        
        if let inviter = AgoraRtm.shared().inviter  {
            inviter.refuseLastIncomingInvitation {  [weak self] (error) in
                debugPrint(error)
                
            }
        }
        
      
    }
    
    func callCenter(_ callCenter: CallCenter, startCall session: String) {
        debugPrint("callCenter startCall")
        
        guard let kit = AgoraRtm.shared().kit else {
            fatalError("rtm kit nil")
        }
        
//        guard let localNumber = localNumber else {
//            fatalError("localNumber nil")
//        }
        
      
        
//        guard let vc = self.presentedViewController as? VideoCallingVC else {
//            fatalError("CallingViewController nil")
//        }
        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
       
        let remoteNumber = session
        
        // rtm query online status
        kit.queryPeerOnline(remoteNumber, success: { [weak vc] (onlineStatus) in
            switch onlineStatus {
            case .online:      sendInvitation(remote: remoteNumber, callingVC: vc!)
            case .offline:     vc?.close(.remoteReject(remoteNumber))
            case .unreachable: vc?.close(.remoteReject(remoteNumber))
            @unknown default:  fatalError("queryPeerOnline")
            }
        }) { [weak vc] (error) in
            vc?.close(.error(error))
        }
        
        // rtm send invitation
        func sendInvitation(remote: String, callingVC: VideoCallingVC) {
            let channel = "\(self.self_user_id)-\(self.Other_user_id)-\(Date().timeIntervalSinceReferenceDate)"
            if let inviter = AgoraRtm.shared().inviter  {
             
            
            inviter.sendInvitation(peer: remoteNumber, extraContent: channel, accepted: { [weak self, weak vc] in
                vc?.close(.toVideoChat)
                
                self?.appleCallKit.setCallConnected(of: remote)
                
                guard let remote = UInt(remoteNumber) else {
                    fatalError("string to int fail")
                }
                
                var data: (channel: String, remote: UInt)
                data.channel = channel
                data.remote = remote
                
                
            }, refused: { [weak vc] in
                vc?.close(.remoteReject(remoteNumber))
            }) { [weak vc] (error) in
                vc?.close(.error(error))
            }
            }
        }
    }
    
    func callCenter(_ callCenter: CallCenter, muteCall muted: Bool, session: String) {
        debugPrint("callCenter muteCall")
    }
    
    func callCenter(_ callCenter: CallCenter, endCall session: String) {
        debugPrint("callCenter endCall")

    }
    
    func callCenterDidActiveAudioSession(_ callCenter: CallCenter) {
        
        debugPrint("callCenter didActiveAudioSession")

    }
    
    func close(_ reason: HungupReason) {
        debugPrint(#function)
        debugPrint(reason)
    }
    
    //MARK: - AGORA RTM setup
    /*
    func Agora_RTM_Setup()
    {
        self.getRTMTokenApi()
        /*
        agoraRtmKit = AgoraRtmKit.init(appId: AGORA_APP_ID, delegate: self)
        let rtm = AgoraRtm.shared()

        rtm.inviterDelegate = self
        guard let kit = AgoraRtm.shared().kit else {
            
           // self.openSimpleAlert(message: "AgoraRtmKit nil")
            return
        }
        
        
//        kit.logout(completion: { logout in
//            debugPrint("Rtm logout error \(logout.rawValue)")
//        })
        
        debugPrint("self.from_user_id = \(self.self_user_id)")
        
        
        kit.login(account: DataManager.Id, token: self.Agora_Rtm_Token) { [unowned self] (error) in
        
            debugPrint("Rtm login error \(error)")
        }
//        if let inviter = AgoraRtm.shared().inviter  {
//            inviter.sendInvitation(peer: self.Other_user_id)
//        }
       
        */
    }
    
    */
    //MARK: - getRTMTokenApi
    func getRTMTokenApi()
    {
        ChatVM.shared.callApi_RTM_Token_Generate(showIndiacter: false, response: { (message, error) in
            if error != nil
            {
                
            }
            else
            {
                let rtmToken = ChatVM.shared.Rtm_token
                
                debugPrint("RTM token = \(rtmToken)")
                let rtm = AgoraRtm.shared()
                rtm.inviterDelegate = self
                guard let kit = AgoraRtm.shared().kit else {
                    return
                }
                self.kit=kit
                
                kit.login(account: DataManager.Id, token: rtmToken) { [unowned self] (error) in
                    debugPrint("Rtm login on home page error \(error)")
                    
                }
                
                
            }
            
        })
    }
}

extension AppDelegate: AgoraRtmInvitertDelegate {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation) {
        debugPrint(#function)
        debugPrint("didReceivedIncoming")

    }

    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        debugPrint("App del remoteDidCancelIncoming")
        self.provider?.reportCall(with: self.uuid, endedAt: Date(), reason: .remoteEnded)
    }
}
//MARK: - RTM method

extension AppDelegate:AgoraRtmDelegate
{
    func rtmKit(_ kit: AgoraRtmKit, peersOnlineStatusChanged onlineStatus: [AgoraRtmPeerOnlineStatus]) {
        debugPrint(#function ,(onlineStatus))
    }
 
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit)
    {
        debugPrint(#function ,(kit))
    }
    
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        debugPrint(#function)
        debugPrint(reason)
        debugPrint(state)
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        
        debugPrint("\(message.text)")
        debugPrint(#function , (peerId))
        
    }
    
   
}

extension AppDelegate
{
    func GoogleAnalyticsSetup()
    {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        if let gai = GAI.sharedInstance()  {
            gai.tracker(withTrackingId: "YOUR_TRACKING_ID")
            // Optional: automatically report uncaught exceptions.
            gai.trackUncaughtExceptions = true

            // Optional: set Logger to VERBOSE for debug information.
            // Remove before app release.
            gai.logger.logLevel = .verbose;
        }
      
    }
}
