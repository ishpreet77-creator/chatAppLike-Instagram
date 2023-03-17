//
//  DeleteAccountPopUpVC.swift
//  Flazhed
//
//  Created by IOS20 on 07/01/21.
//

import UIKit


protocol deleteAccountDelegate {
    func deleteAccountFunc(name:String)
}
class DeleteAccountPopUpVC: BaseVC {

    //MARK: -  IBOutlets
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var constStackHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTerm: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var Lbldelete: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
   
    //MARK: - Variables
    var comeFrom = ""
    var messageType = kSetting
    var delegate:deleteAccountDelegate?
    var view_user_id = ""
    var post_id = ""
    var user_name = ""
    var chat_room_id = ""
    var from_user_id = ""
    var message=""
    var messageTitle=""
    var comeFromScreen: ScreenType = .storiesScreen
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK: - Class Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.lblTitle.text = kConfirmDelete
        self.lblMessage.text = kAreYouSureDelete
        self.Lbldelete.text = kDeleteAccount.uppercased()
        
        self.heightConst.constant = 280
        self.constStackHeight.constant = 106
        self.viewPrice.isHidden = true
        
        self.btnTerm.underline()
        self.btnPrivacy.underline()
     
        self.btnCancel.setTitle(kCANCEL.capitalized, for: .normal)
        self.btnCancel.backgroundColor = ENABLECOLOR
        
        if self.comeFrom.equalsIgnoreCase(string: kChat)  || self.comeFrom.equalsIgnoreCase(string: kEndChat)
        {
            lblMessage.isHidden=true
            lblTitle.text = kAreYouSure
            Lbldelete.text = kYes.uppercased()
            self.heightConst.constant = 240
            self.topConst.constant = 40
        }
        else if self.comeFrom.equalsIgnoreCase(string: kImage)
        {
            lblMessage.isHidden=false
            lblMessage.text=kDeleteImageAlert
            lblTitle.text = kConfirmDelete
            Lbldelete.text = kDELETEIMAGE
            self.heightConst.constant = 280
        }
        else if self.comeFrom.equalsIgnoreCase(string: kAudio)
        {
            lblMessage.isHidden=false
            lblMessage.text=kDeleteAudioAlert
            lblTitle.text = kConfirmDelete
            Lbldelete.text = kDELETERECORDING
            self.heightConst.constant = 280
        }
        
    
        else if self.comeFrom.equalsIgnoreCase(string: kAccount)
        {
            lblMessage.isHidden=false
            lblMessage.text=kLogoutMessage
            lblTitle.text = kConfirmLogout
            Lbldelete.text = kYes
            self.heightConst.constant = 280
        }
        else if self.comeFrom.equalsIgnoreCase(string: kSetting) 
        {
            lblMessage.isHidden=false
            if messageType.equalsIgnoreCase(string: PermissonType.kLocationEnable)
            {
                lblMessage.text=kLocationSetting
            }
           else if messageType.equalsIgnoreCase(string: PermissonType.kMicrophoneEnable)
            {
                lblMessage.text=kMicrophonePermission
            }
            else if messageType.equalsIgnoreCase(string: PermissonType.kCameraEnable)
             {
                 lblMessage.text=kCameraSetting
             }
            
            else if messageType.equalsIgnoreCase(string: PermissonType.kMicrophoneCamera)
             {
                 lblMessage.text=kCameraAndMicrophonePermission
             }
            else if messageType.equalsIgnoreCase(string: PermissonType.kLibraryEnable)
             {
                 lblMessage.text=kLibraryPermission
             }
            else
            {
                lblMessage.text=kSettingMessage
            }
            
            lblTitle.text = kConfirmSettings
            Lbldelete.text = kSetting
            self.heightConst.constant = 280
        }
        
        else if self.comeFrom.equalsIgnoreCase(string: kRunningOut)
        {
            lblMessage.isHidden=false
            lblMessage.text=message
            lblTitle.text = messageTitle
            Lbldelete.text = kGetMore.capitalized
            self.heightConst.constant = 280
        }
        else if self.comeFrom.equalsIgnoreCase(string: kRegretRunningOut)
        {
            lblMessage.isHidden=false
            lblMessage.text=message
            lblTitle.text = messageTitle
            Lbldelete.text = kRegretContinue
            self.heightConst.constant = 280
        }
        else if self.comeFrom.equalsIgnoreCase(string: kProlong)
        {
            lblMessage.isHidden=false
            lblMessage.text=message
            lblTitle.text = messageTitle
            Lbldelete.text = kProlongChat
            self.heightConst.constant = 280+65
            self.constStackHeight.constant = 206-35
            self.viewPrice.isHidden = false
            self.lblPrice.text = self.getProductPrice()
            
        }
         
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: false)
       {
       
           self.delegate?.deleteAccountFunc(name: kCancel)
                          
        }
        //self.dismiss(animated: true)
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: false)
       {
       
           self.delegate?.deleteAccountFunc(name: kCancel)
                          
        }
       // self.dismiss(animated: true)
    }
    //MARK: -IBActions
    @IBAction func btnAction(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            
            
            if comeFrom==kAccount
            {
                
                self.dismiss(animated: true)
                {
                    self.delegate?.deleteAccountFunc(name: kAccount)
                }
            }
            else if comeFrom==kImage
            {
                self.dismiss(animated: true)
                {
                    self.delegate?.deleteAccountFunc(name: kImage)
                }
                
            }
            else if comeFrom==kAudio
            {
                self.dismiss(animated: true)
                {
                    self.delegate?.deleteAccountFunc(name: kAudio)
                }
                
            }
            
            else if comeFrom==kDelete
            {
                self.dismiss(animated: true)
                {
                    self.delegate?.deleteAccountFunc(name: kDelete)
                }
                
            }
            else if comeFrom==kChat
            {
                 self.dismiss(animated: false)
                {
                
                    self.delegate?.deleteAccountFunc(name: kDelete)
                                   
                 }
            }
            
            else if comeFrom==kRunningOut
            {
                 self.dismiss(animated: false)
                {
                
                    self.delegate?.deleteAccountFunc(name: kRunningOut)
                                   
                 }
            }
            else if comeFrom==kRegretRunningOut
            {
                 self.dismiss(animated: false)
                {
                
                    self.delegate?.deleteAccountFunc(name: kRegretRunningOut)
                                   
                 }
            }
            else if comeFrom==kProlong
            {
                 self.dismiss(animated: false)
                {
                
                    self.delegate?.deleteAccountFunc(name: kProlong)
                                   
                 }
            }
            
            
            
            else if comeFrom==kSetting
            {
                 self.dismiss(animated: false)
                {
                
                    DispatchQueue.main.async {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                debugPrint("Settings opened: \(success)") // Prints true
                            })
                        }

                    }
                   // self.delegate?.deleteAccountFunc(name: kDelete)
                 }
            }
           
            else if comeFrom==kEndChat
            {
                self.dismiss(animated: true) {
                  //  self.callApiActiveToInactiveAPI()
                    self.RemoveMatchAPI(other_user_id: self.view_user_id)
                }
            }
            else
            {
                self.dismiss(animated: false)
               {
               
                   self.delegate?.deleteAccountFunc(name: kCancel)
                                  
                }
                //self.dismiss(animated: true, completion: nil)
            }
        }
        else
        
        {
            self.dismiss(animated: false)
           {
           
               self.delegate?.deleteAccountFunc(name: kCancel)
                              
            }
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Term & condition button action
    
    @IBAction func termCondtionAct(_ sender: Any)
    {
 
        let vc = WebVC.instantiate(fromAppStoryboard: .Account)
        vc.pageTitle=kTermOfService
        vc.pageUrl=TERM_URL
       // self.navigationController?.pushViewController(vc, animated: true)
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    //MARK: - Privacy policy button action
    
    @IBAction func privacyPolicyAct(_ sender: Any)
    {
        let vc = WebVC.instantiate(fromAppStoryboard: .Account)
        vc.pageTitle=kPrivacyPolicy
        vc.pageUrl=Privacy_Policy_URL
        //self.navigationController?.pushViewController(vc, animated: true)
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension DeleteAccountPopUpVC
{
    func getProductPrice() -> String
    {
        if IAPHandler.shared.prolongPriceArray.count>0
       {
            return IAPHandler.shared.prolongPriceArray[0].price ?? kEmptyString
       }
        return "$9.99"
    }
}
extension DeleteAccountPopUpVC
{
    //MARK: -  user like
    
    /*
    
    func callApiActiveToInactiveAPI()
    {
        var data = JSONDictionary()

        data["chat_room_id"] = self.chat_room_id
        
            if Connectivity.isConnectedToInternet {
              
                self.callApiActiveToInactiveChat(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiActiveToInactiveChat(data:JSONDictionary)
    {
       
        ChatVM.shared.callApiActiveToInactiveChat(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
               
                            if #available(iOS 13.0, *) {
                                SCENEDEL?.navigateToChat()
                            } else {
                                // Fallback on earlier versions
                                APPDEL.navigateToChat()
                            }
            }

         
        })
    }
    
    */
    
    func RemoveMatchAPI(other_user_id:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kOther_user_id] = other_user_id
            if Connectivity.isConnectedToInternet {
              
                self.callApiForRemoveMatchAPI(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForRemoveMatchAPI(data:JSONDictionary)
    {
       
        ChatVM.shared.callApiRemoveMatch(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                self.sendMatchBlockNoti_Method()
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToChat()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToChat()
                }
              
            }

         
        })
    }
    
    func sendMatchBlockNoti_Method()
    {
        debugPrint("sendSMS ")
    
        let dict2 = ["from_user_id":DataManager.Id,"to_user_id":self.view_user_id,"alert_type":"removematch"]
        SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
    }
    
    
}
