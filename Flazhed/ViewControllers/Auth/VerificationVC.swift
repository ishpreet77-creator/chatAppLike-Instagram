//
//  VerificationVC.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//

import UIKit
import IQKeyboardManagerSwift

class VerificationVC: BaseVC {
    //MARK:- All outlets  
    
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var txt1: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var viewOTPSuccess: UIView!
    @IBOutlet weak var btnResed: UIButton!
    @IBOutlet weak var viewResend: UIView!
    @IBOutlet weak var scrollHeightConst: NSLayoutConstraint!
    @IBOutlet weak var topScrollConst: NSLayoutConstraint!
    @IBOutlet weak var txtDPOTPView: DPOTPView!

    //MARK:- All Variable  
    
    var countryCode = ""
    var mobileNumber = ""
    var SentOTP = ""
    var forTesting = ""
   
    //MARK:- View Lifecycle   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        txt1.text = ""
        txt2.text = ""
        txt3.text = ""
        txt4.text = ""
        
        let characters = Array(SentOTP)
        print(characters)
        if self.forTesting.equalsIgnoreCase(string: "yes")
        {
            if characters.count>0
            {
                self.txt1.text = "\(characters[0])"
            }
            if characters.count>1
            {
                self.txt2.text =  "\(characters[1])"
            }
            if characters.count>2
            {
                self.txt3.text =  "\(characters[2])"
            }
            if characters.count>3
            {
                self.txt4.text =  "\(characters[3])"
            }
            txt4.becomeFirstResponder()
        }
        else
        {
            txt1.becomeFirstResponder()
        }
        
        self.viewResend.isHidden = false
        self.viewOTPSuccess.isHidden = true
        if #available(iOS 12.0, *) {
            txt1.textContentType = .oneTimeCode
            txt2.textContentType = .oneTimeCode
            txt3.textContentType = .oneTimeCode
            txt4.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    //MARK:- Resend OTP button action 
    
    @IBAction func ResendAct(_ sender: UIButton)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kPhoneNumber] = mobileNumber
        data[ApiKey.kCountryCode] = countryCode
        if Connectivity.isConnectedToInternet {
            
            self.ResendOTPApi(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    //MARK:- Send OTP button action 
    
    @IBAction func sendAct(_ sender: UIButton)
    {
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            var data = JSONDictionary()
            data[ApiKey.kPhoneNumber] = mobileNumber
            data[ApiKey.kCountryCode] = countryCode
            data[ApiKey.kOtp] = self.SentOTP//txt1.text! + txt2.text! + txt3.text! + txt4.text!
            data[ApiKey.kDevicetype] = kDeviceType
            data[ApiKey.KDeviceToken] =  AppDelegate.DeviceToken
            data[ApiKey.KVoip_device_token] = AppDelegate.VOIPDeviceToken
            if Connectivity.isConnectedToInternet {
                
                self.OtpVerifyApi(data: data)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
            
        }
    }
    
    //MARK:- Keyboard method 
    
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
            sendButtonConst.constant = keyboardHeight+26
            
        }
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+20
        }
        
        
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
        
    }
    
    
    // MARK:- Private Functions
    private func validateData () -> String?
    {
        if self.SentOTP.count==0//txt1.isEmpty && txt2.isEmpty && txt3.isEmpty && txt4.isEmpty
        {
            return kEmptyOTPAlert
        }
        else if self.SentOTP.count<4//txt1.isEmpty || txt2.isEmpty || txt3.isEmpty || txt4.isEmpty
        {
            return kOTPValidAlert
        }
        
        
        return nil
    }
    
    //MARK:- Setup UI method 
    
    func setUpUI()
    {
        let number = "\(countryCode)" + " " + "\(mobileNumber)"
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "\(kOTPsent)  \(number)")
        attributedString.setColorForText(textForAttribute: kOTPsent, withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "\(number)", withColor:UIColor(named: "AppTextColor")!)
        lblOtpSent.attributedText = attributedString
        self.setCustomHeader(title: kVerification, showBack: true, showMenuButton: false)
        
        if self.getDeviceModel() == "iPhone 6"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+TOPLABELSAPACING
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+TOPLABELSAPACING
        }
        else
        {
            self.topConst.constant = TOPSPACING+TOPLABELSAPACING
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        txt1.delegate = self
        txt2.delegate = self
        txt3.delegate = self
        txt4.delegate = self
        
        txt1.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txt2.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txt3.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txt4.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        txt1.attributedPlaceholder = NSAttributedString(string:"0", attributes:[NSAttributedString.Key.foregroundColor: OTPCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 35)!])
        txt2.attributedPlaceholder = NSAttributedString(string:"0", attributes:[NSAttributedString.Key.foregroundColor: OTPCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 35)!])
        txt3.attributedPlaceholder = NSAttributedString(string:"0", attributes:[NSAttributedString.Key.foregroundColor: OTPCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 35)!])
        txt4.attributedPlaceholder = NSAttributedString(string:"0", attributes:[NSAttributedString.Key.foregroundColor: OTPCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 35)!])
       // let attributedStringX = NSMutableAttributedString(string: "0000")
      //  attributedStringX.addAttribute(NSAttributedString.Key.kern, value: CGFloat(50.0), range: NSRange(location: 0, length: attributedString.length))
          // txt1.attributedText = attributedStringX
        
            // let att = NSAttributedString(attributedString: attributedStringX)
        
     
        self.btnResed.underline()
        
        txtDPOTPView.becomeFirstResponder()
        txtDPOTPView.dpOTPViewDelegate = self
        txtDPOTPView.fontTextField = UIFont(name: AppFontName.regular, size: 35)!
        txtDPOTPView.placeholderTextColor=OTPCOLOR
        txtDPOTPView.textEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        txtDPOTPView.editingTextEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}
//MARK:- textfield delegate method 

extension VerificationVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0
        {
            return false
        }
        else
        {
            return newString.length <= maxLength
        }
    }
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text ?? ""
        let count = text.utf16.count
        
//        let attributedString = NSMutableAttributedString(string: textField.text!)
//        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(50.0), range: NSRange(location: 0, length: attributedString.length))
//           txt1.attributedText = attributedString
        
        if count >= 1{
            switch textField
            {
            case txt1:
                txt2.becomeFirstResponder()
            case txt2:
                txt3.becomeFirstResponder()
            case txt3:
                txt4.becomeFirstResponder()
            case txt4:
                txt4.resignFirstResponder()
                
            default:
                break
            }
        }else{
            switch textField
            {
            case txt1:
                txt1.resignFirstResponder()
            case txt2:
                txt1.becomeFirstResponder()
            case txt3:
                txt2.becomeFirstResponder()
            case txt4:
                txt3.becomeFirstResponder()
                
            default:
                break
            }
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField)
    }
}
// MARK:- Resend OTP and Verify Api Calls

extension VerificationVC
{
    func ResendOTPApi(data:JSONDictionary)
    {
        OnBoardingVM.shared.callApiForSendOTPAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                //let characters = Array((OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? ""))
                let characters = (OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? "")

                print(characters)
                self.viewResend.isHidden = true
                self.viewOTPSuccess.isHidden = false
              //  self.txtDPOTPView.text=characters
              //  self.SentOTP=characters
                /*
                if self.forTesting=="yes"
                {
                   self.txtDPOTPView.text=characters
                   self.SentOTP=characters
                    if characters.count>0
                    {
                        self.txt1.text = "\(characters[0])"
                    }
                    if characters.count>1
                    {
                        self.txt2.text =  "\(characters[1])"
                    }
                    if characters.count>2
                    {
                        self.txt3.text =  "\(characters[2])"
                    }
                    if characters.count>3
                    {
                        self.txt4.text =  "\(characters[3])"
                    }
                }
                else
                {
                    self.txt1.text=""
                    self.txt2.text=""
                    self.txt3.text=""
                    self.txt4.text=""
                }
                */
            }
        })
    }
    
    func OtpVerifyApi(data:JSONDictionary)
    {
        OnBoardingVM.shared.callApiForVerifyOTPAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                
               
                
                
                
                if (OnBoardingVM.shared.loginUserDetail?.profile_data?.username != nil)
                {
                    
                    if (OnBoardingVM.shared.loginUserDetail?.more_profile_details?.bio == nil)
                     {
                        DataManager.comeFromTag=5
                        DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                        DataManager.isProfileCompelete=true
                        DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                        
                        if OnBoardingVM.shared.loginUserDetail?.profile_data?.images?.count ?? 0>0
                        {
                            let img=OnBoardingVM.shared.loginUserDetail?.profile_data?.images?[0].image
                            
                            DataManager.userImage=img ?? ""
                        }
                        DataManager.isEditProfile=false
                                 if #available(iOS 13.0, *) {
                                     SCENEDEL?.navigateToEditProfile()
                                 } else {
                                     // Fallback on earlier versions
                                     APPDEL.navigateToEditProfile()
                                 }
                     }
                else
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
                        DataManager.isEditProfile=true
                        DataManager.comeFromTag=5
                        DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                        DataManager.isProfileCompelete=true
                        DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                        let active = OnBoardingVM.shared.Swiping_Subsription_Data?.subscription_is_active ?? 0
                        
                        if active == 1
                        {
                           DataManager.purchasePlan=true
                        }
                        else
                        {
                            DataManager.purchasePlan=false
                        }
                        
                        if OnBoardingVM.shared.loginUserDetail?.profile_data?.images?.count ?? 0>0
                        {
                            let img=OnBoardingVM.shared.loginUserDetail?.profile_data?.images?[0].image
                            
                            DataManager.userImage=img ?? ""
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                  
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicVC") as! ProfilePicVC
                    DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                    DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        })
    }
}

extension VerificationVC : DPOTPViewDelegate {
    func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
        
        self.SentOTP=text
        
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
        self.SentOTP=text
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder()
    {
        
    }
    func dpOTPViewResignFirstResponder()
    {
        
    }
}
