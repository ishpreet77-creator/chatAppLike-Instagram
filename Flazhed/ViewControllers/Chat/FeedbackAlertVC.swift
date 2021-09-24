//
//  FeedbackAlertVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit

protocol FeedbackAlertDelegate {
    func FeedbackAlertOkFunc(name:String)
}

class FeedbackAlertVC: BaseVC {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrptionLbel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    
    @IBOutlet weak var alertHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomContarint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    var type : ScreenType = .feedbackScreen
    var Alerttype : ScreenType = .storiesScreen
    var user_name = ""
    var chat_room_id = ""
    var view_user_id = ""
    var from_user_id = ""
    var fromBlock = "reported"
    var errorCode = 0
    var delegate:FeedbackAlertDelegate?
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .feedbackScreen {
            alertHeightContraint.constant = 249//375
            titleBottomContarint.constant = 32
            doneButton.setTitle("OKAY", for: .normal)
            titleLabel.text = "Uh Oh!"
            descrptionLbel.text = "\(user_name) hasn't accepted your chat request yet."
            buttonView.isHidden = false
            labelBottomConstraints.constant = 32
            
            btnBack.isHidden=true
        }
          else if type == .BlockReportError
            {
          
            titleBottomContarint.constant = 32
            doneButton.setTitle("OKAY", for: .normal)
            titleLabel.text = "Uh Oh!"
            if user_name.count>60
            {
                alertHeightContraint.constant = 300
            }
            else
            {
                alertHeightContraint.constant = 249//375
            }
            
            descrptionLbel.text = user_name
            buttonView.isHidden = false
            labelBottomConstraints.constant = 32
            self.Alerttype=type
            
            btnBack.isHidden=true
          }
          
       
          else if type == .GrayOut
          {
            alertHeightContraint.constant = 249//375
            titleBottomContarint.constant = 32
            doneButton.setTitle("OKAY", for: .normal)
            titleLabel.text = "Uh Oh!"
            descrptionLbel.text = "\(user_name) has left the chat."
            buttonView.isHidden = false
            labelBottomConstraints.constant = 32
            
            btnBack.isHidden=true
            self.Alerttype = .GrayOut
          }
          else if  type == .GrayOut48Hrs
          {
            alertHeightContraint.constant = 249//375
            titleBottomContarint.constant = 32
            doneButton.setTitle("OKAY", for: .normal)
            titleLabel.text = "Uh Oh!"
            descrptionLbel.text = "\(user_name) has left the chat."
            buttonView.isHidden = false
            labelBottomConstraints.constant = 32
            
            btnBack.isHidden=true
            self.Alerttype = .GrayOut48Hrs
          }
          else if  type == .onceContinue
          {
            alertHeightContraint.constant = 249//375
            titleBottomContarint.constant = 32
            doneButton.setTitle("OKAY", for: .normal)
            titleLabel.text = "Uh Oh!"
            descrptionLbel.text = "You are still waiting on \(user_name) to accept the chat 😊."//"\(user_name) hasn't accepted your chat request yet."
            buttonView.isHidden = false
            labelBottomConstraints.constant = 32
            
            btnBack.isHidden=true
            self.Alerttype = .onceContinue
          }
        
        else{
           // Timer.scheduledTimer(withTimeInterval: 2, repeats: false){ (timer) in
                
            btnBack.isHidden=false
               
           // }
            alertHeightContraint.constant = 290
            titleBottomContarint.constant = 75
            titleLabel.text = "Feedback Received"
            if self.Alerttype == .messageScreen
            {
                descrptionLbel.text = "Thank you for your time. \(user_name) has been \(fromBlock)."
            }
            else
            
            {
                descrptionLbel.text = "Thank you for your time. \(user_name) 's post has been \(fromBlock)."
            }
           
            buttonView.isHidden = true
            labelBottomConstraints.constant = -16
        }
  
    }
    
    @IBAction func backbtnAct(_ sender: Any) {
        if self.Alerttype == .messageScreen
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToChat()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToChat()
            }
        }
       else if self.Alerttype == .GrayOut
        {
        self.RemoveMatchAPI(other_user_id: self.view_user_id)
        }
       else if self.Alerttype == .GrayOut48Hrs
        {
        self.callApiActiveToInactiveAPI()
        }
        
       else if self.Alerttype == .BlockReportError
        {
        if errorCode == 1000
        {
            self.dismiss(animated: true) {
                self.delegate?.FeedbackAlertOkFunc(name: kStory)
            }
        }
        else if errorCode != 0
        {
            
            self.dismiss(animated: true) {
                DataManager.ShakeId = ""
                   print("okay click")
                if #available(iOS 13.0, *) {
                    DataManager.comeFrom = ""
                    DataManager.isProfileCompelete = false
                     DataManager.accessToken = ""
                    SCENEDEL?.navigateToLogin()
                } else {
                    // Fallback on earlier versions
                    DataManager.comeFrom = ""
                    DataManager.isProfileCompelete = false
                     DataManager.accessToken = ""
                    APPDEL.navigateToLogin()
                }

            }
         
        }
        else if self.user_name == kInstallFacebookAlert
        {
            self.dismiss(animated: true) {
                self.delegate?.FeedbackAlertOkFunc(name: kInstallFacebookAlert)
            }
          
            
        }
       else
        {
           self.dismiss(animated: true, completion: nil)
        }
        
           
        }
        else
        {
            if self.fromBlock.equalsIgnoreCase(string: "reported")
            {
                if let wind = self.view.window
                {
                    wind.rootViewController?.dismiss(animated: false, completion: nil)
                }
                
                else
                {
                    if #available(iOS 13.0, *) {
                        SCENEDEL?.navigateToStories()
                    } else {
                        // Fallback on earlier versions
                        APPDEL.navigateToStories()
                    }
                }
            }
            else
            {
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToStories()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToStories()
                }
            }
            
          //  self.dismiss(animated: true, completion: nil)
           
        

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
        //self.dismiss(animated: true)
        
        if self.Alerttype == .messageScreen
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToChat()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToChat()
            }
        }
        else if self.Alerttype == .GrayOut
         {
            self.RemoveMatchAPI(other_user_id: self.view_user_id)
         }
        else if self.Alerttype == .GrayOut48Hrs
         {
            self.callApiActiveToInactiveAPI()
         }
        
        else if self.Alerttype == .BlockReportError
         {
            if errorCode == 1000
            {
                self.dismiss(animated: true) {
                    self.delegate?.FeedbackAlertOkFunc(name: kStory)
                }
            }
           else if errorCode != 0
            {
                
                self.dismiss(animated: true) {
                    DataManager.ShakeId = ""
                       print("okay click")
                    if #available(iOS 13.0, *) {
                        DataManager.comeFrom = ""
                        DataManager.isProfileCompelete = false
                         DataManager.accessToken = ""
                        SCENEDEL?.navigateToLogin()
                    } else {
                        // Fallback on earlier versions
                        DataManager.comeFrom = ""
                        DataManager.isProfileCompelete = false
                         DataManager.accessToken = ""
                        APPDEL.navigateToLogin()
                    }

                }
             
            }
            else if self.user_name == kInstallFacebookAlert
            {
                self.dismiss(animated: true) {
                    self.delegate?.FeedbackAlertOkFunc(name: kInstallFacebookAlert)
                }
            }
           else
            {
               self.dismiss(animated: true, completion: nil)
            }
         }
        else
        {
            if self.fromBlock.equalsIgnoreCase(string: "reported")
            {
                if let wind = self.view.window
                {
                    wind.rootViewController?.dismiss(animated: false, completion: nil)
                }
                
                else
                {
                    if #available(iOS 13.0, *) {
                        SCENEDEL?.navigateToStories()
                    } else {
                        // Fallback on earlier versions
                        APPDEL.navigateToStories()
                    }
                }
            }
            else
            {
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToStories()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToStories()
                }
            }
            
          //  self.dismiss(animated: true, completion: nil)
           
            
            

        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any)
    {
       // self.dismiss(animated: true, completion: nil)
        if self.Alerttype == .messageScreen
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToChat()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToChat()
            }
        }
        else if self.Alerttype == .GrayOut
         {
            self.RemoveMatchAPI(other_user_id: self.view_user_id)
         }
        else if self.Alerttype == .GrayOut48Hrs
         {
            self.callApiActiveToInactiveAPI()
         }
       
        else if self.Alerttype == .BlockReportError
         {
            if errorCode == 1000
            {
                self.dismiss(animated: true) {
                    self.delegate?.FeedbackAlertOkFunc(name: kStory)
                }
            }
            else if errorCode != 0
            {
                
                self.dismiss(animated: true) {
                    DataManager.ShakeId = ""
                       print("okay click")
                    if #available(iOS 13.0, *) {
                        DataManager.comeFrom = ""
                        DataManager.isProfileCompelete = false
                         DataManager.accessToken = ""
                        SCENEDEL?.navigateToLogin()
                    } else {
                        // Fallback on earlier versions
                        DataManager.comeFrom = ""
                        DataManager.isProfileCompelete = false
                         DataManager.accessToken = ""
                        APPDEL.navigateToLogin()
                    }

                }
             
            }
            else if self.user_name == kInstallFacebookAlert
            {
                self.dismiss(animated: true) {
                    self.delegate?.FeedbackAlertOkFunc(name: kInstallFacebookAlert)
                }
            }
           else
            {
               self.dismiss(animated: true, completion: nil)
            }
           
         }
        else
        {
            if self.fromBlock.equalsIgnoreCase(string: "reported") 
            {
                if let wind = self.view.window
                {
                    wind.rootViewController?.dismiss(animated: false, completion: nil)
                }
                
                else
                {
                    if #available(iOS 13.0, *) {
                        SCENEDEL?.navigateToStories()
                    } else {
                        // Fallback on earlier versions
                        APPDEL.navigateToStories()
                    }
                }
            }
            else
            {
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToStories()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToStories()
                }
            }
    }
    }
    
    func storyBackAct()
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
        vc.selectedIndex=1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
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
                
                
               // let dict2 = ["alert_type":kRemoveMatch,"to_user_id":self.view_user_id]
                            //,"buffer_img":gif
                          //  SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
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
    
        let dict2 = ["from_user_id":DataManager.Id,"to_user_id":self.view_user_id,"alert_type":"removematch"]
        SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
    }
    
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
}
