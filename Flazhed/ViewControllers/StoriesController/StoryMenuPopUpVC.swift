//
//  StoryMenuPopUpVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit

protocol threeDotMenuDelegate
{
    func ClickNameAction(name:String)
    
}


class StoryMenuPopUpVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewProfileBUtton: UIButton!
    @IBOutlet weak var reportPostBUtton: UIButton!
    @IBOutlet weak var viewProfileButtonBGImage: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var delegate:threeDotMenuDelegate?
    var type: ScreenType = .storiesScreen
    var comeFromScreen: ScreenType = .storiesScreen
    var view_user_id = ""
    var from_user_id = ""
    var post_id = ""
    var user_name = ""
    var chat_room_id = ""
    var is_hangout_strory = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if type == .messageScreen
        {
            viewProfileBUtton.setTitle(kBLOCKANDREPORT, for: .normal)
            if self.is_hangout_strory
            {
                reportPostBUtton.setTitle(kENDCHAT, for: .normal)
            }
            else
            {
                reportPostBUtton.setTitle(kREMOVEMATCH, for: .normal)
            }
            
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal) //= #colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        }
        else if type == .chatScreen
        {
           
            viewProfileBUtton.setTitle(kPROLONGCHAT, for: .normal)
            reportPostBUtton.setTitle(kDELETECHAT, for: .normal)
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
        }
  
        else if type == .ViewProfile
        {
           
            viewProfileBUtton.setTitle(kBLOCKANDREPORT, for: .normal)
            reportPostBUtton.setTitle(kCancel.uppercased(), for: .normal)
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
        }

        else if type == .ViewPostHangout
        {
            viewProfileBUtton.setTitle(kBLOCKANDREPORTHAGOUT, for: .normal)
            reportPostBUtton.setTitle(kCancel.uppercased(), for: .normal)
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
        }
                    
        else if  type == .ViewPostStory
        {
           
            viewProfileBUtton.setTitle(kBLOCKANDREPORTPOST, for: .normal)
            reportPostBUtton.setTitle(kCancel.uppercased(), for: .normal)
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
        }
        
        else if  type == .ListHangout
        {
           
          
            reportPostBUtton.setTitle(kBLOCKANDREPORTHAGOUT, for: .normal)
        
        }
        else if  type == .storiesScreen
        {
           
    reportPostBUtton.setTitle(kBLOCKANDREPORTPOST, for: .normal)
        
        }
        
        
        
    }
  //MARK: - Setup UI method
    func setUpUI()
    {
   
        self.lblTitle.text = kOptionChoose
//        self.lblShakeLeft.text = kShakesLeft
//        self.btnGetNow.setTitle(kGetMore, for: .normal)
//        self.btnCancelShake.setTitle(kCANCELSHAKE, for: .normal)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
    
    @IBAction func reportAct(_ sender: UIButton)
    {

        if type == .messageScreen
        {

            let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)

            destVC.type = .blockRemoveAlert
            destVC.comefrom = comeFromScreen
            destVC.comeFromScreen = comeFromScreen
            destVC.User_Id=self.view_user_id
            destVC.User_Name=self.user_name
            destVC.is_hangout_strory=self.is_hangout_strory
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
        }
        else if type == .chatScreen
        {
          
            
            let destVC = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)

            destVC.comeFrom = kChat
            destVC.comeFromScreen = comeFromScreen
            destVC.delegate=self
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
        }
        else if type == .ViewProfile ||  type == .ViewPostHangout ||  type == .ViewPostStory
        {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            
            let destVC = BlockReportPopUpVC.instantiate(fromAppStoryboard: .Stories)
            destVC.postID=self.post_id
            destVC.user_name=self.user_name
            destVC.UserID=self.view_user_id
            destVC.from_user_id=self.from_user_id
            destVC.type = type
            destVC.comeFromScreen = comeFromScreen
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
            
        }
        
        
    }
    @IBAction func viewProfileAct(_ sender: UIButton)
    {
        if type == .messageScreen || type == .ViewProfile || type == .ViewPostHangout ||  type == .ViewPostStory
        {
          
            let destVC = BlockReportPopUpVC.instantiate(fromAppStoryboard: .Stories)
            destVC.type = type//.messageScreen
            destVC.UserID=self.view_user_id
            destVC.user_name=self.user_name
            destVC.postID = self.post_id
            destVC.comeFromScreen = comeFromScreen
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
        }else if type == .chatScreen{
           
            let destVC = RegretPopUpVC.instantiate(fromAppStoryboard: .Account)
            destVC.type = .Prolong
            destVC.view_user_id=self.view_user_id
            destVC.comeFromScreen = comeFromScreen
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
            
        }
       
        
        else{
            if Connectivity.isConnectedToInternet {
                self.dismiss(animated: false) {
                    self.delegate?.ClickNameAction(name: kViewProfile)
                }
                     } else {

                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
           
         
        }
        
    }
}
// MARK:- Extension Api Calls
extension StoryMenuPopUpVC:deleteAccountDelegate
{
    func deleteAccountFunc(name: String) {
        if name.equalsIgnoreCase(string: kDelete)
        {
            self.dismiss(animated: false)
            {
                var data = JSONDictionary()

                data[ApiKey.kChat_room_id] = self.chat_room_id
    
               
                    if Connectivity.isConnectedToInternet {
                        self.RemoveMatchAPI(other_user_id: self.view_user_id)
                      
                        //self.callApiForDeleteChat(data: data)
                     } else {
                        
                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
            }
        }
    }
    
    //MARK: -  shake user like
    
    func likeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kOther_user_id] = other_user_id
        data[ApiKey.kAction] = action
        data[ApiKey.kLike_mode] = like_mode
        data[ApiKey.kTimezone] = TIMEZONE
       
            if Connectivity.isConnectedToInternet {
              
                self.callApiForLikeUnlike(data: data,type: type)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String)
    {
        HomeVM.shared.callApiForLikeUnlikeUser(data: data, response: { (message, error) in
            
            if error != nil
            {
               
                self.showErrorMessage(error: error)
               
            }
            else{
              
            }
        })
    }
    /*
    
    func callApiForDeleteChat(data:JSONDictionary)
    {
        ChatVM.shared.callApiDeleteChat(data: data, response: { (message, error) in
            
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
//        data[ApiKey.kAction] = action
//        data[ApiKey.kLike_mode] = like_mode
//        data[ApiKey.kTimezone] = TIMEZONE
        
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
