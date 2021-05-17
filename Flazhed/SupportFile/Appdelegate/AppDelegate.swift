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

import Quickblox
import QuickbloxWebRTC

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    var window: UIWindow?
    static var DeviceToken: String = "12335556"
//MARK:- For call
    
    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
        let backgroundTask = UIBackgroundTaskIdentifier.invalid
        return backgroundTask
    }()
    
    
    var isCalling = false {
        didSet {
            if UIApplication.shared.applicationState == .background,
                isCalling == false, CallKitManager.instance.isHasSession() {
                disconnect()
            }
        }
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        GIDSignIn.sharedInstance().clientID = "973725628875-qi4sur8d7055jqukjkeculeitcej9s1q.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
    
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        DataManager.comeFromTag=5
       
        UIApplication.shared.applicationIconBadgeNumber = 0
        NotificationSetup()
        Thread.sleep(forTimeInterval: 3)
      
        GMSPlacesClient.provideAPIKey("AIzaSyAJW8tYVGyKzHGnMWtnuDrJ5_ejLGjnonI")
        GMSServices.provideAPIKey("AIzaSyAJW8tYVGyKzHGnMWtnuDrJ5_ejLGjnonI")
        
        if DataManager.isProfileCompelete
        {
            APPDEL.navigateToHome()
        }
        else
        {
            APPDEL.navigateToLogin()
        }
        clearFilter()
        callKeySetup()
        
      
        return true
    }

    override init()
    {
           super.init()
           UIFont.overrideInitialize()
       }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {

        return GIDSignIn.sharedInstance().handle(url)
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
    
    //MARK:- Get device token
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      
        
        let tokenParts = deviceToken.map { data -> String in
                return String(format: "%02.2hhx", data)
            }
                
            let token = tokenParts.joined()
        
        AppDelegate.DeviceToken = token
        
        print("Device Token = \(token)")
        
        
        
        guard let identifierForVendor = UIDevice.current.identifierForVendor else {
                   return
               }
               let deviceIdentifier = identifierForVendor.uuidString
               let subscription = QBMSubscription()
               subscription.notificationChannel = .APNS
               subscription.deviceUDID = deviceIdentifier
               subscription.deviceToken = deviceToken
               QBRequest.createSubscription(subscription, successBlock: { (response, objects) in
               }, errorBlock: { (response) in
                   debugPrint("[AppDelegate] createSubscription error: \(String(describing: response.error))")
               })
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
        UIApplication.shared.applicationIconBadgeNumber = 0
      
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
         
            if let details = userInfo["sendDetail"] as? JSONDictionary
            {
               let Noti_type = details["noti_type"] as? String ?? ""
            
                    let id = details["from_user_id"] as? String ?? ""
                    print(id)
                    
                  if Noti_type ==  "3" {
                let storyBoard = UIStoryboard.storyboard(storyboard: .Chat)
            
                let vc = storyBoard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                vc.appdel = kAppDelegate
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
                else
                  {
                 
                  let storyBoard = UIStoryboard.storyboard(storyboard: .Home)
                  let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
                  vc.view_user_id = id
                    vc.comeFrom=kAppDelegate
                    
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
        SocketIOManager.shared.disconnectSocket()
    }
    
   
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Check for sign in error
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
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
    
    func clearFilter()
    {
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
    
    func navigateToHome() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
    func navigateToLogin() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
    func navigateToSentShake()
    {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShakeSentVC") as! ShakeSentVC
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
    
    func navigateToStories()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=1
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
    
    func navigateToProfile()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=4
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
    
    func navigateToHangout()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=0
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
    
    func navigateToChat()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        let nav = UINavigationController(rootViewController: vc)
        vc.selectedIndex=3
        nav.navigationBar.isHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

    }
}
//MARK:- For call

extension AppDelegate
{
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Logging in to chat.
        if QBChat.instance.isConnected == true {
            return
        }
        connect { (error) in
            if let error = error {
                debugPrint("Connect error: \(error.localizedDescription)")
                return
            }
            print("Connected")
        }
    }
    
    func callKeySetup()
    {
        //MARK:-   Key setup
        
        QBSettings.applicationID = CredentialsConstant.applicationID;
        QBSettings.authKey = CredentialsConstant.authKey
        QBSettings.authSecret = CredentialsConstant.authSecret
        QBSettings.accountKey = CredentialsConstant.accountKey
        QBSettings.autoReconnectEnabled = true
        QBSettings.logLevel = QBLogLevel.nothing
        QBSettings.disableXMPPLogging()
        QBSettings.disableFileLogging()
        QBRTCConfig.setLogLevel(QBRTCLogLevel.nothing)
        QBRTCConfig.setAnswerTimeInterval(TimeIntervalConstant.answerTimeInterval)
        QBRTCConfig.setDialingTimeInterval(TimeIntervalConstant.dialingTimeInterval)
        
        if AppDelegateConstant.enableStatsReports == 1 {
            QBRTCConfig.setStatsReportTimeInterval(1.0)
        }
    
        QBRTCClient.initializeRTC()
    }
    
    //MARK: - Connect/Disconnect
    func connect(completion: QBChatCompletionBlock? = nil) {
        let currentUser = Profile()
        
        guard currentUser.isFull == true else {
            completion?(NSError(domain: LoginConstant.chatServiceDomain,
                                code: LoginConstant.errorDomaimCode,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "Please enter your login and username."
                ]))
            return
        }
        if QBChat.instance.isConnected == true {
            completion?(nil)
        } else {
            QBSettings.autoReconnectEnabled = true
            QBChat.instance.connect(withUserID: currentUser.ID, password: currentUser.password, completion: completion)
        }
    }
    
    func disconnect(completion: QBChatCompletionBlock? = nil) {
        QBChat.instance.disconnect(completionBlock: completion)
    }
}
