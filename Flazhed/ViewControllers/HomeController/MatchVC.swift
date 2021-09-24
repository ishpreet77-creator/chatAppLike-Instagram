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
    var appdel = ""
    
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
        
        self.navigationController?.navigationBar.isHidden=true
        self.getUserDetails()
        if DataManager.userImage != ""
        {
            let url = URL(string: DataManager.userImage)!
            
            self.imgUser1.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
            
        }
        //        if user2Image != ""
        //        {
        //            let url = URL(string: user2Image)!
        //
        //            self.imgUser2.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
        //
        //        }
        
       
        //
    }
    @IBAction func BackAct(_ sender: UIButton)
    {
        if self.comefrom.equalsIgnoreCase(string: kAppDelegate)
        {
//            if #available(iOS 13.0, *) {
//                SCENEDEL?.navigateToHome()
//            } else {
//                APPDEL.navigateToHome()
//            }
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=2
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func startChatingAct(_ sender: UIButton)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        vc.comfrom=comefrom
        vc.profileName=self.profileName
        vc.profileImage=self.user2Image
        vc.view_user_id=self.view_user_id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK:- get user data api

extension MatchVC
{
    
    func getUserDetails()
    {
        if Connectivity.isConnectedToInternet {
            var data = JSONDictionary()
            
            data[ApiKey.kStoryId] = kEmptyString
            data[ApiKey.kHangout_Id] = kEmptyString
            data[ApiKey.kUser_id] = self.view_user_id
            data[ApiKey.kTimezone] = TIMEZONE
            self.callApiForGetUserDetails(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetUserDetails(data:JSONDictionary)
    {
        HomeVM.shared.callApiGetUserDetails(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                if let UserData = HomeVM.shared.viewProfileUserDetail
                {
                    
                    let image = UserData.profile_data?.images ?? []
                    if image.count>0
                    {
                        let img = UserData.profile_data?.images?[0].image ?? ""
                        
                        if img != ""
                        {
                            let url = URL(string: img)!
                            
                            self.imgUser2.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                            
                        }
                        
                    }
                    
                }
            }
        })
    }
}
