//
//  StoryDiscardVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//

import UIKit


protocol DiscardDelegate
{
    func ClickNameAction(name:String)
    
}
class  StoryDiscardVC: BaseVC {
    
    @IBOutlet weak var stackHeightConst: NSLayoutConstraint!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnfirst: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    var delegate:DiscardDelegate?
    var type: ScreenType = .storyTab
    var comefrom: ScreenType = .storiesScreen
    var comeFromScreen: ScreenType = .storiesScreen
    var User_Id = ""
    var User_Name = ""
    var postType = "Photo"
    var startTime="2021-05-24T04:22:20.282Z"
    var chat_room_id = ""
    var is_hangout_strory=false
    var view_user_id = ""
    var from_user_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if type == .blockRemoveAlert{
            lblMessage.numberOfLines = 1
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
            
            if is_hangout_strory
            {
                lblTitle.text = kEndChatQue
                lblMessage.text = kEndChatMessage
                btnSecond.setTitle(kYESEND, for: .normal)
            }
            else
            {
                lblTitle.text = kRemoveMatchQue
                lblMessage.text = kkRemoveMatchMessage
                btnSecond.setTitle(kYESEMOVE, for: .normal)
            }
            
            btnfirst.setTitle(kCancel.uppercased(), for: .normal)
            
            btnSecond.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
            self.heightConst.constant = 300
            
        }else if type == .continueChat{
            self.backButton.isHidden = false
            self.backButtonImage.isHidden = false
            lblMessage.numberOfLines = 0
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
            
            
            // lblMessage.text = "Your chat with Chelsea has run out of time.\nYou have 5 hours 23 minutes to decide if\n you want to continue."
            
            // let timer  = "".checkHoursTimeDiffrent(startTime: self.startTime)//checkHoursTimeDiffrent2(startTime: self.startTime)
            
            
            
            
            
            let attrs1 = [NSAttributedString.Key.font : UIFont(name: AppFontName.regular, size: 17), NSAttributedString.Key.foregroundColor : UIColor.black]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont(name: AppFontName.bold, size: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
            
            if DataManager.purchaseProlong
            {
                self.stackHeightConst.constant = 50
                lblTitle.text = kEndChatQue
                let attributedString1 = NSMutableAttributedString(string:"\(kYourChatWith) \(User_Name.capitalized) \(kwillBeInactive)", attributes:attrs1)
                
                //  let attributedString2 = NSMutableAttributedString(string:" \(timer) ", attributes:attrs2)
                
                //  let attributedString3 = NSMutableAttributedString(string:"to decide if you want to continue.", attributes:attrs1)
                
                // attributedString1.append(attributedString2)
                // attributedString1.append(attributedString3)
                self.lblMessage.attributedText = attributedString1
                self.heightConst.constant = 250
                // self.lblMessage.addInterlineSpacing(spacingValue: 6)
                
                btnfirst.setTitle(kRegretContinue, for: .normal)
                btnfirst.isHidden=true
                btnSecond.setTitle(kENDCHAT, for: .normal)
                
                btnSecond.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
            }
            else
            {
                var timer = "0 \(kDay)"
                
                self.stackHeightConst.constant = 124
                self.lblTitle.text = kContinueChatQue
                //                var (hourRemanning,_,_)  = "".checkHoursRemaining(startTime: self.startTime)
                //                debugPrint("hourRemanning \(hourRemanning)")
                //
                //                if hourRemanning>=64 && hourRemanning<=72 // 8 hrs
                //                {
                //                    timer = "2 days"
                //                }
                //                else if hourRemanning>=48 && hourRemanning<64 // 16 hr
                //                {
                //                    timer = "1 day"
                //                }
                //                else  if hourRemanning>=24 && hourRemanning<48
                //                {
                //                    hourRemanning = hourRemanning-24
                //
                //                    timer = "\(hourRemanning) hours"
                //                }
                
                
                
                let (hours, minutes, seconds)  = "".checkHoursRemaining(startTime: self.startTime)
                debugPrint("Hours Remaining: \(hours)")
                debugPrint("Minutes Remaining: \(minutes)")
                debugPrint("Seconds Remaining: \(seconds)")
                
                
                if hours>=64 && hours<=72 // 8 hrs
                {
                    timer = "2 \(kDays.lowercased())"
                }
                else if hours>=48 && hours<64 // 16 hr
                {
                    timer = "1 \(kDay)"
                }
                else  if hours>=24 && hours<48
                {
                    
                    let actualHours = hours-24
                    let actualMinutes = minutes
                    let actualSeconds = seconds
                    if actualHours >= 1 {
                        timer = "\(actualHours) \(kHours)"
                    }
                    else if actualMinutes >= 1 {
                        timer = "\(actualMinutes) \(kMinutes)"
                    }
                    else {
                        timer = "\(actualSeconds) \(kSeconds)"
                        if actualSeconds <= 0 {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
                
                btnfirst.isHidden=false
                let attributedString1 = NSMutableAttributedString(string:"\(kYourChatWith) \(User_Name.capitalized) \(kIsAboutTo)", attributes:attrs1)
                
                let attributedString2 = NSMutableAttributedString(string:" \(timer) ", attributes:attrs2)
                
                let attributedString3 = NSMutableAttributedString(string:"\(kToDecide)", attributes:attrs1)
                
                attributedString1.append(attributedString2)
                attributedString1.append(attributedString3)
                self.lblMessage.attributedText = attributedString1
                
                // self.lblMessage.addInterlineSpacing(spacingValue: 6)
                
                btnfirst.setTitle(kRegretContinue, for: .normal)
                btnSecond.setTitle(kENDCHAT, for: .normal)
                
                btnSecond.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
            }
            
            
        }else if type == .delete{
            lblTitle.text = kConfirmDelete
            lblMessage.text = kDeleteThisPost
            
            btnfirst.setTitle(kDeletePost.uppercased(), for: .normal)
            btnSecond.setTitle(kCancel.uppercased(), for: .normal)
            lblMessage.numberOfLines = 1
            self.heightConst.constant = 300
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        else if type == .deleteHangout
        {
            lblTitle.text = kConfirmDelete
            lblMessage.text = kDeleteThisHangout
            
            btnfirst.setTitle(kDeleteHangout, for: .normal)
            btnSecond.setTitle(kCancel.uppercased(), for: .normal)
            lblMessage.numberOfLines = 0
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        
        else if type == .shakeSent
        {
            lblTitle.text = kShakeSent
            lblMessage.text = kShakeSentMessageMatch
            
            btnfirst.setTitle(kBrowseAnonymous, for: .normal)
            btnSecond.setTitle(kCancel, for: .normal)
            lblMessage.numberOfLines = 0
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        
        else if type == .deleteStory{
            
            lblTitle.text = kConfirmDelete
            lblMessage.text = kdeleteThisStory
            
            btnfirst.setTitle(kDELETESTORY, for: .normal)
            btnSecond.setTitle(kCancel.uppercased(), for: .normal)
            lblMessage.numberOfLines = 1
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
            
            self.heightConst.constant = 300
        }
        
        
        
        else if type == .discardPost
        {
            lblTitle.text = "\(kDiscard) \(postType)"
            lblMessage.text = "\(kDiscardThis) \(postType) \(kNotBeenSaved)"
            
            btnfirst.setTitle(kRegretContinue, for: .normal)
            btnSecond.setTitle(kDiscard.uppercased(), for: .normal)
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        else if type == .ShareStory
        {
            lblTitle.text = kStorytToFacebook
            lblMessage.text = kPostOnFacebook
            
            btnfirst.setTitle(kSHAREPOST, for: .normal)
            btnSecond.setTitle(kCancel.uppercased(), for: .normal)
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        
        self.btnfirst.backgroundColor = ENABLECOLOR
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        //self.dismiss(animated: true)
        
        if type  == .delete{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .deleteHangout{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .deleteStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .shakeSent{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .ShareStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        
        else
        {
            delegate?.ClickNameAction(name: kDiscard)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Discard Act
    
    @IBAction func reportAct(_ sender: UIButton)
    {
        if type  == .delete{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .deleteHangout{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .deleteStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .shakeSent{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .ShareStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        
        else if type == .continueChat
        {
            //        self.dismiss(animated: true) {
            //
            //
            //
            //            self.delegate?.ClickNameAction(name: kEndChat)
            //        }
            
            
        
            let destVC = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)

            destVC.comeFrom = kEndChat
            destVC.view_user_id=self.User_Id
            destVC.chat_room_id=self.chat_room_id
            //destVC.delegate=self
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
        else if type  == .blockRemoveAlert{
            // delegate?.ClickNameAction(name: kRemove)
            
            if Connectivity.isConnectedToInternet {
                self.dismiss(animated: true) {
                    self.RemoveMatchAPI(other_user_id: self.User_Id)
                }
                     } else {

                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
            
            
        }
        else
        {
            delegate?.ClickNameAction(name: kDiscard)
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    //MARK: - continue Act
    //Delete post
    
    @IBAction func viewProfileAct(_ sender: UIButton)
    {
        if type  == .delete{
            
            
            if Connectivity.isConnectedToInternet {
                delegate?.ClickNameAction(name: kDeletePost)
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
        else if type  == .deleteHangout{
            
            
            if Connectivity.isConnectedToInternet {
                delegate?.ClickNameAction(name: kDelete)
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        else if type  == .deleteStory{
            
            if Connectivity.isConnectedToInternet {
                delegate?.ClickNameAction(name: kDelete)
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
        else if type  == .ShareStory{
            
            
            if Connectivity.isConnectedToInternet {
                delegate?.ClickNameAction(name: kShare)
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
        else if type == .continueChat
        {
            
            
            if Connectivity.isConnectedToInternet {
                self.dismiss(animated: true) {
                    self.delegate?.ClickNameAction(name: kContinueChat)
                }
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
        else if type == .blockRemoveAlert
        {
            self.dismiss(animated: true, completion: nil)
        }
        
        else
        {
            
            
            
            if Connectivity.isConnectedToInternet {
                delegate?.ClickNameAction(name: kContinue)
                self.dismiss(animated: true, completion: nil)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
    }
}
//MARK: - Api call

extension StoryDiscardVC
{
    //MARK: -  user like
    
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
        
        let dict2 = ["from_user_id":DataManager.Id  ?? "","to_user_id":self.User_Id,"alert_type":"removematch"]
        SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
    }
}
