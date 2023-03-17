//
//  MatchVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit
import SkeletonView

class MatchVC: BaseVC {
    
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgRed: UIImageView!
    @IBOutlet weak var btnStartCharting: UIButton!
    @IBOutlet weak var imgRound: UIImageView!
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
        setupUI()
        self.topConst.constant = CGFloat(STATUSBARHEIGHT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true

        self.navigationController?.navigationBar.isHidden=true
        self.getUserDetails()
        if DataManager.userImage != ""
        {
        
            self.imgUser1.setImage(imageName: DataManager.userImage)
        }
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    
    
    //MARK: - Setup UI
    
    func setupUI()
    {
      
        self.lblTitle.text = kItAMatch
        self.btnStartCharting.setTitle(kSTARTCHATTING, for: .normal)
        self.btnStartCharting.setTitle(kSTARTCHATTING, for: .selected)

    }
    
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        if self.comefrom.equalsIgnoreCase(string: kAppDelegate)
        {
    
            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

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
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
        vc.comfrom=comefrom
        vc.profileName=self.profileName
        vc.profileImage=self.user2Image
        vc.view_user_id=self.view_user_id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showLoader()
    {
        
        self.imgUser1.clipsToBounds=true
        self.imgUser2.clipsToBounds=true
        self.imgRound.clipsToBounds=true
        self.btnStartCharting.clipsToBounds=true
        self.imgRed.clipsToBounds=true
        
        
        
        self.imgUser1.isSkeletonable=true
        self.imgUser2.isSkeletonable=true
        self.imgRound.isSkeletonable=true
        self.btnStartCharting.isSkeletonable=true
        self.imgRed.isSkeletonable=true
        
        self.imgUser1.showAnimatedGradientSkeleton()
        self.imgUser2.showAnimatedGradientSkeleton()
        self.imgRound.showAnimatedGradientSkeleton()
        self.btnStartCharting.showAnimatedGradientSkeleton()
        self.imgRed.showAnimatedGradientSkeleton()
    }
    func hideLoader()
    {
    
        self.imgRed.hideSkeleton()
        self.imgUser1.hideSkeleton()
        self.imgUser2.hideSkeleton()
        self.imgRound.hideSkeleton()
        self.btnStartCharting.hideSkeleton()
    
    }
    
}
//MARK: - get user data api

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
            self.showLoader()
            self.callApiForGetUserDetails(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetUserDetails(data:JSONDictionary)
    {
        HomeVM.shared.callApiGetUserImageDetails(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                if let UserData = HomeVM.shared.onlyProfileDetail, let img = UserData.profile_data?.image
                {
                    self.imgUser2.setImage(imageName: img)
                }
            }
        })
    }
}
