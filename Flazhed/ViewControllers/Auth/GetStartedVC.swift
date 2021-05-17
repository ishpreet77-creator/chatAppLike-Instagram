//
//  GetStartedVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit

class GetStartedVC: BaseVC {
    @IBOutlet weak var imgMatch: UIImageView!
    
    
    @IBOutlet weak var imgSwipe: UIImageView!
    @IBOutlet weak var imgHangout: UIImageView!
    @IBOutlet weak var imgNearby: UIImageView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if self.getDeviceModel() == "iPhone 6"
//        {
//            self.topConst.constant = TOPSPACING
//        }
//        else if self.getDeviceModel() == "iPhone 8+"
//        {
//            self.topConst.constant = TOPSPACING
//        }
//        else
//        {
//            self.topConst.constant = TOPSPACING
//        }
        self.topConst.constant = 0
        
        
        self.imgMatch.image = self.imgMatch.image?.tinted(color: UIColor.lightGray)
        self.imgHangout.image = self.imgHangout.image?.tinted(color: UIColor.lightGray)
        
        self.imgSwipe.image = self.imgSwipe.image?.tinted(color: UIColor.lightGray)
        self.imgNearby.image = self.imgNearby.image?.tinted(color: UIColor.lightGray)
        
        //self.updateUnit()
    }
    @IBAction func NextAct(_ sender: UIButton)
    {
      
        
        let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PreferencesVC") as! PreferencesVC
        vc.comeFrom="Auth"
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func SkipAct(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        DataManager.isProfileCompelete=true
        DataManager.comeFromTag=5
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
//MARK:- api call

extension GetStartedVC
{
    func updateUnit()
    {
    
        var data = JSONDictionary()
    
        data[ApiKey.kUnit] = kCentimeters
            if Connectivity.isConnectedToInternet {
              
                self.updateUnitApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    
    func updateUnitApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdateUnit(data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                DataManager.currentUnit = kCentimeters
                
            }
            
            
        })
    }
}
