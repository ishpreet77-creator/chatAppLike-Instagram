//
//  SendFeedbackAlertVC.swift
//  Flazhed
//
//  Created by IOS25 on 09/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import SkeletonView
protocol SendFeedbackDelegate {

    func feedbackText(text:String)
    
}

class SendFeedbackAlertVC: BaseVC {

    @IBOutlet weak var viewSendBtn: UIView!
    @IBOutlet weak var viewTextBack: UIView!
    @IBOutlet weak var txtViewFeedback: UITextView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var btnSendFeedback: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate:SendFeedbackDelegate?
    var comeFrom = ""
    var fromBlock = false
    var blockReason = ""
    var postID = ""
    var user_name = ""
    var type: ScreenType = .storiesScreen
    var comeFromScreen: ScreenType = .storiesScreen
    var UserID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewFeedback.becomeFirstResponder()

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.getDeviceModel() == "iPhone 6"
        {
            self.topConst.constant = 26
        }
        else
        {
            self.topConst.constant = 80
        }
        txtViewFeedback.delegate=self
        txtViewFeedback.text = ""
        txtViewFeedback.becomeFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside=true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         
        self.lblTitle.text = kTellUsMore
        
        self.btnSendFeedback.setTitle(kSENDFEEDBACK, for: .normal)
        self.btnSendFeedback.backgroundColor = ENABLECOLOR
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.shouldResignOnTouchOutside=true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.feedbackText(text: kfromBack)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func sendFeedbackButtonAction(_ sender: UIButton)
    {
        
        txtViewFeedback.resignFirstResponder()
        
//        if let message = validateData()
//        {
//            self.openSimpleAlert(message: message)
//        }
//        else
//        {
//            self.callReportBlockApi(reason: self.txtViewFeedback.text!)
//        }
        
                if let message = validateData()
                {
                    self.openSimpleAlert(message: message)
                }
                else
                {
                    self.showLoader()
                    self.blockReason = self.txtViewFeedback.text ?? ""
                    
                    if type == .messageScreen || type == .ViewProfile
                    {
                        
                        self.call_User_Report_Block_Api(reason: self.blockReason)
                    }
                    else
                    {
                    self.callReportBlockApi(reason: self.blockReason)
                    }
                }
      
       
    }
    
    
    // MARK:- Private Functions
    private func validateData () -> String?
    {
        if txtViewFeedback.text.count == 0 {
            return kEmptyFeedbackAlert
        }
        return nil
     }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        if self.getDeviceModel() == "iPhone 6"
        {
            sendButtonConst.constant = keyboardHeight+26+32
        }
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+20+32
        }
        
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26+32
    }
    
    
    func showLoader()
    {
        
        
        self.viewSendBtn.clipsToBounds=true
        self.viewTextBack.clipsToBounds=true
     
        
        self.viewTextBack.clipsToBounds=true
        self.viewSendBtn.isSkeletonable=true
        self.viewSendBtn.showAnimatedGradientSkeleton()
        self.viewTextBack.showAnimatedGradientSkeleton()

    }
    func hideLoader()
    {
        self.viewTextBack.hideSkeleton()
        self.viewSendBtn.hideSkeleton()
    }
    
}

extension SendFeedbackAlertVC:UITextViewDelegate {
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 120;
    }
    
}
// MARK:- Extension Api Calls
extension SendFeedbackAlertVC
{
   
    func callReportBlockApi(reason:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kPost_id] = self.postID
   
        data[ApiKey.kReason_text] = reason
        
        var urlType:PostType = .story
        if type == .ViewPostHangout || type == .ListHangout
        {
            urlType = .hangout
        }
        else
        {
            urlType = .story
        }
            
            if Connectivity.isConnectedToInternet {
                self.showLoader()
                self.callApiForReportBlock(data: data,type:urlType)
             } else {
                 self.hideLoader()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
        
        
    }
    
    func callApiForReportBlock(data:JSONDictionary,type:PostType = .story)
    {
    
        StoriesVM.shared.callApiReportBlock(data: data,type: type, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                    self.showErrorMessage(error: error)
       
            }
            else{
                self.hideLoader()
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
                    destVC.type = .sendFeedback
                destVC.comeFromScreen = self.comeFromScreen
                   destVC.Alerttype = self.type
                    destVC.user_name=self.user_name
                    destVC.fromBlock="reported"
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

         
        })
        
    }
    
    
    func call_User_Report_Block_Api(reason:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kUser_id] = self.UserID
   
       
            data[ApiKey.kReason_text] = reason
        
            
            if Connectivity.isConnectedToInternet {
                self.showLoader()
                self.call_Api_For_User_Report_Block(data: data)
             } else {
                 self.hideLoader()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func call_Api_For_User_Report_Block(data:JSONDictionary)
    {
    
        ChatVM.shared.callApiReportBlockUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                        self.showErrorMessage(error: error)

                
            }
            else{
                self.hideLoader()
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
                    destVC.type = .sendFeedback
                destVC.comeFromScreen = self.comeFromScreen
                    destVC.Alerttype = .messageScreen
                    destVC.user_name=self.user_name
                if  self.fromBlock
                {
                destVC.fromBlock="blocked"
                }
                else
                {
                    destVC.fromBlock="reported"
                }
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

         
        })
        
    }
    
}
