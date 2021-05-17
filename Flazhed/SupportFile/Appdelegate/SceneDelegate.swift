//
//  SceneDelegate.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


  
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        for family in UIFont.familyNames {
//            print("\(family)")
//
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("\(name)")
//            }
//        }
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
            self.navigateToHome()
        }
        else
        {
            //APPDEL.navigateToLogin()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func navigateToHome() {
            
            let storyBoard = UIStoryboard.storyboard(storyboard: .Main)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
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

