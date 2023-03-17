//
//  TabbarWithStoryHangout.swift
//  Flazhed
//
//  Created by ios2 on 20/04/22.
//

import UIKit

class TabbarWithStoryHangout: UITabBarController {

    var shared = BaseVC()
    override func viewDidLoad() {
        super.viewDidLoad()
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
       
        if shared.getDeviceModel() == "iPhone 6"
        {
            
            TOPSPACING = CGFloat(STATUSBARHEIGHT+8)
        }
        else
        {
            TOPSPACING = CGFloat(56)
            
        }
        
        STATUSBARHEIGHT=shared.getStatusBarHeight()
       
        self.navigationController?.isNavigationBarHidden = true

        
    }
}
