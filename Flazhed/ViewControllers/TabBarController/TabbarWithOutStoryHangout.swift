//
//  TabbarWithOutStoryHangout.swift
//  Flazhed
//
//  Created by ios2 on 20/04/22.
//

import UIKit

class TabbarWithOutStoryHangout: UITabBarController {

    var shared = BaseVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOManager.shared.initializeSocket()
        selfJoinSocketEmit()
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        self.title = nil
        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundEffect = nil
            // need to set background because it is black in standardAppearance
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
        } else {
            // below ios 13.0
            let image = UIImage()
            tabBar.shadowImage = image
            tabBar.backgroundImage = image
            // background
            tabBar.backgroundColor = .white
        }
      
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        tabBar.layer.shadowOpacity = 0.3
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
       badgeCountIntervalCheckEmit()
        if shared.getDeviceModel() == "iPhone 6"
        {
            
            TOPSPACING = CGFloat(STATUSBARHEIGHT+8)
        }
        else
        {
            TOPSPACING = CGFloat(56)
            
        }
       
            if self.selectedIndex != 0 {
              // self.addRedDotAtTabBarItemIndex(index: 0)
            }
            
        STATUSBARHEIGHT=shared.getStatusBarHeight()
       
        self.navigationController?.isNavigationBarHidden = true
//        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
//        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
//        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
//        myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
//        myTabBarItem4.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//
        //MARK: -Uncomment when done
        
//        APPDEL.timerBudgeCount = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
//          RunLoop.main.add(APPDEL.timerBudgeCount ?? Timer(), forMode: RunLoop.Mode.common)
        
    }
    
    @objc func runTimedCode()
    {
        DispatchQueue.main.async {
            self.selfJoinSocketEmit()
            self.badgeCountIntervalCheckEmit()
            self.badgeCountIntervalCheckON()
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
     
        let indexOfTab = tabBar.items?.firstIndex(of: item)

           if indexOfTab == 1
              {
                print("Selected item removeDotAtTabBarItemIndex")
                 //removeDotAtTabBarItemIndex(index: 1)
               self.tabBar.removeBadge(index: 1)
              }
           
    }
    
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

        
           // self.tabBar.removeBadge(index: 1)
            if let data = data as? JSONArray
            {
                for dict in data
                {

                    let badgeCount =  dict["badgeCount"] as? Int ?? 0
                    if badgeCount > 0
                    {
                       self.tabBar.addBadge(index: 1)
                        
                        //self.addRedDotAtTabBarItemIndex(index: 1)
//
                    }
                    else
                    {
                        //self.removeDotAtTabBarItemIndex(index: 1)
                       self.tabBar.removeBadge(index: 1)
                    }
                }
            }
            else
            {
                //self.removeDotAtTabBarItemIndex(index: 1)
                self.tabBar.removeBadge(index: 1)
            }

            //  debugPrint("receivedBadgeCount = \(data) \(error)")
        })

    }
    
}



extension UITabBar {
    func addBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = "."
            tabItem.badgeColor = .clear
            tabItem.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
        }
    }
    func removeBadge(index:Int) {
        if let tabItems = self.items {
            let tabItem = tabItems[index]
            tabItem.badgeValue = nil
        }
    }
    
 }
