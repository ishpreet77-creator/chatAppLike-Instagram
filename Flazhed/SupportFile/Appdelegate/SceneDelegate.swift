//
//  SceneDelegate.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        UIApplication.shared.windows.forEach { window in
                   //here you can switch between the dark and light
            if #available(iOS 13.0, *)
            {
                window.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
               }
        
        if DataManager.isProfileCompelete
        {
            if DataManager.isPrefrenceSet == false
            {
               
                self.navigateToPrefrence()
            }
          else if DataManager.isEditProfile == false
            {
               
                self.navigateToEditProfile()
            }
            else
            {
                self.navigateToHome(userId: "")
            }
        }
        else
        {
            //APPDEL.navigateToLogin()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
  
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
      func navigateToHome(userId:String = "") {
            
            let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        vc.selectedIndex=2
        if userId != ""
        {
        DataManager.HomeRefresh=true
        DataManager.OtherUserId = userId
        DataManager.comeFromTag=6
        }
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
           // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

            UIApplication.shared.windows.first?.rootViewController = nav
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }
    
    func navigateToLogin() {
            
            let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
           // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

            UIApplication.shared.windows.first?.rootViewController = nav
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }
    
    func navigateToSentShake()
    {

        let storyBoard = UIStoryboard.storyboard(storyboard: .Home)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShakeSentVC") as! ShakeSentVC
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    func navigateToHangout()
    {
    
        let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        vc.selectedIndex=0
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    
    func navigateToStories()
    {
    
        let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        vc.selectedIndex=1
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    func navigateToChat()
    {
    
        let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        vc.selectedIndex=3
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }


    func navigateToProfile()
    {
    
        let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        vc.selectedIndex=4
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func navigateToPrefrence()
    {
    
        let storyBoard = UIStoryboard.storyboard(storyboard: .Profile)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PreferencesVC") as! PreferencesVC
        vc.comeFrom=kAppDelegate
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func navigateToEditProfile()
    {
    
        let storyBoard = UIStoryboard.storyboard(storyboard: .Profile)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.comeFrom=kAppDelegate
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }

    
    func navigateToAudioCall(sendDetail:JSONDictionary)
    {
       let details = sendDetail["object_data"] as? JSONDictionary ?? [:]
        
        let storyBoard = UIStoryboard.storyboard(storyboard: .Chat)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AudioCallingVC") as! AudioCallingVC
        vc.comeFrom=kAppDelegate
        vc.agoraChannelName = details["chanel_name"] as? String ?? ""
        vc.agoraToken = details["rtc_token_subscriber"] as? String ?? ""
        vc.agoraChannelUID = details["uid_subscriber"] as? String ?? ""
        vc.profileImageUrl = details["profile_image"] as? String ?? ""
        vc.userName = sendDetail["from_user_name"] as? String ?? ""
        
        vc.uid_publish = details["uid_publish"] as? String ?? ""
        vc.uid_subscriber = details["uid_subscriber"] as? String ?? ""
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    func navigateToVideoCall(sendDetail:JSONDictionary)
    {
       let details = sendDetail["object_data"] as? JSONDictionary ?? [:]
        
        let storyBoard = UIStoryboard.storyboard(storyboard: .Chat)
        let vc = storyBoard.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
        vc.comeFrom=kAppDelegate
        vc.agoraChannelName = details["chanel_name"] as? String ?? ""
        vc.agoraToken = details["rtc_token_subscriber"] as? String ?? ""
        vc.agoraChannelUID = details["uid_subscriber"] as? String ?? ""
        vc.profileImageUrl = details["profile_image"] as? String ?? ""
        vc.userName = sendDetail["from_user_name"] as? String ?? ""
        
        vc.uid_publish = details["uid_publish"] as? String ?? ""
        vc.uid_subscriber = details["uid_subscriber"] as? String ?? ""
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
       // UIApplication.shared.windows.first?.layer.add(self.transition, forKey: kCATransition)

        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
      

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

