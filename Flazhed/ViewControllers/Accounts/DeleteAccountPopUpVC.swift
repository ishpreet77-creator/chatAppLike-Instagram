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
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    //MARK:-  IBOutlets
    @IBOutlet weak var Lbldelete: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Variables
    var comeFrom = ""
    var delegate:deleteAccountDelegate?
    var view_user_id = ""
    var post_id = ""
    var user_name = ""
    var chat_room_id = ""
    var from_user_id = ""
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK:- Class Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.comeFrom.equalsIgnoreCase(string: kChat)  || self.comeFrom.equalsIgnoreCase(string: kEndChat)
        {
            lblMessage.isHidden=true
            lblTitle.text = "Are You Sure?"
            Lbldelete.text = "YES"
            self.heightConst.constant = 240
            self.topConst.constant = 40
        }
        else if self.comeFrom.equalsIgnoreCase(string: kImage)
        {
            lblMessage.isHidden=false
            lblMessage.text=kDeleteImageAlert
            lblTitle.text = "Confirm Delete"
            Lbldelete.text = "DELETE IMAGE"
            self.heightConst.constant = 280
        }
        else if self.comeFrom.equalsIgnoreCase(string: kAudio)
        {
            lblMessage.isHidden=false
            lblMessage.text=kDeleteAudioAlert
            lblTitle.text = "Confirm Delete"
            Lbldelete.text = "DELETE RECORDING"
            self.heightConst.constant = 280
        }
        
    
        else if self.comeFrom.equalsIgnoreCase(string: kAccount)
        {
            lblMessage.isHidden=false
            lblMessage.text=kLogoutMessage
            lblTitle.text = "Confirm Logout"
            Lbldelete.text = "YES"
            self.heightConst.constant = 280
        }
        else if self.comeFrom.equalsIgnoreCase(string: kSetting) 
        {
            lblMessage.isHidden=false
            lblMessage.text=kSettingMessage
            lblTitle.text = "Confirm Setting"
            Lbldelete.text = kSetting
            self.heightConst.constant = 280
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
    //MARK:-IBActions
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
                                print("Settings opened: \(success)") // Prints true
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
                self.dismiss(animated: true, completion: nil)
            }
        }
        else
        
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension DeleteAccountPopUpVC
{
    //MARK:-  user like
    
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
        print("sendSMS ")
    
        let dict2 = ["from_user_id":DataManager.Id ?? "","to_user_id":self.view_user_id,"alert_type":"removematch"]
        SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
    }
    
    
}
