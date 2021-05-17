//
//  MatchVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit

class MatchVC: BaseVC {

    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    var comeFrom = 0
    @IBOutlet weak var imgUser2: UIImageView!
    
    @IBOutlet weak var imgUser1: UIImageView!
    var user2Image = ""
    var profileImage=""
    var profileName = ""
    var view_user_id = ""
    var comefrom = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if self.getDeviceModel() == "iPhone 6"
//        {
//            self.topConst.constant = CGFloat(STATUSBARHEIGHT+8)
//        }
//        else if self.getDeviceModel() == "iPhone 8+"
//        {
//            self.topConst.constant = TOPSPACING
//        }
//        else
//        {
//            self.topConst.constant = TOPSPACING
//        }
        
        self.topConst.constant = CGFloat(STATUSBARHEIGHT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if DataManager.userImage != ""
        {
            let url = URL(string: DataManager.userImage)!
          
            self.imgUser1.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)

        }
        if user2Image != ""
        {
            let url = URL(string: user2Image)!
          
            self.imgUser2.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)

        }
        
    }
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func startChatingAct(_ sender: UIButton)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        vc.appdel=comefrom
        vc.profileName=self.profileName
        vc.profileImage=self.profileImage
        vc.view_user_id=self.view_user_id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
