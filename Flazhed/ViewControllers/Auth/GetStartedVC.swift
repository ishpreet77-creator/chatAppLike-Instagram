//
//  GetStartedVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit

class GetStartedVC: BaseVC {
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgMatch: UIImageView!
    @IBOutlet weak var textGetStartedDesc: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var btnContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.topConst.constant = 0
        setupUI()
  
       // self.updateUnit()
    }
    
    //MARK: - Setup UI
    
    func setupUI()
    {
        self.lblTitle.text = kFGetStarted
        self.textGetStartedDesc.text = kWelcometoFlazhed
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")
//        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .normal)
//        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .selected)

    }
    @IBAction func NextAct(_ sender: UIButton)
    {
      
        let vc = PreferencesVC.instantiate(fromAppStoryboard: .Profile)
        vc.comeFrom=kAppDelegate
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
 

}
//MARK: - api call

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
