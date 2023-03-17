//
//  VerificationVC.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import SkeletonView

class VerificationVC: BaseVC {
    //MARK: - All outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var textViewPhone: UILabel!
    @IBOutlet weak var btnChangeNumber: UIButton!
    @IBOutlet weak var viewOTPSuccess: UIView!
    @IBOutlet weak var btnResed: UIButton!
    @IBOutlet weak var viewResend: UIView!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var txtOTPNumber: UITextField!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    //MARK: - All Variable
    
    var countryCode = "+91"
    var mobileNumber = "8699047111"
    var forTesting = ""
   
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewOTPSuccess.isHidden = true
        txtOTPNumber.text = ""
        self.validationNexButton()
        if self.forTesting.equalsIgnoreCase(string: "yes")
        {
           
            txtOTPNumber.becomeFirstResponder()
        }
        else
        {
            txtOTPNumber.becomeFirstResponder()
        }
        
        self.viewResend.isHidden = false
        self.viewOTPSuccess.isHidden = true
        if #available(iOS 12.0, *) {
            txtOTPNumber.textContentType = .oneTimeCode
    
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
    //MARK: - Setup UI method
    
    func setUpUI()
    {
        let number = "\(countryCode)" + " " + "\(mobileNumber)"
  
        textViewPhone.text = number
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        
        txtOTPNumber.attributedPlaceholder = NSAttributedString(string:"0000", attributes:[NSAttributedString.Key.foregroundColor: OTPCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
        self.btnResed.underline()
        self.btnChangeNumber.underline()
        self.txtOTPNumber.delegate=self
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")
        
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .normal)
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .selected)

    }
    //MARK: - backBtnAction

    @IBAction func backBtnAction(_ sender: UIButton) {
     
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Phone number button action
    @IBAction func ChangePhoneAct(_ sender: UIButton)
    {
    self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Resend OTP button action
    
    @IBAction func ResendAct(_ sender: UIButton)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kPhoneNumber] = mobileNumber
        data[ApiKey.kCountryCode] = countryCode
        if Connectivity.isConnectedToInternet {
            self.showLoader()
            self.ResendOTPApi(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    //MARK: - Send OTP button action
    
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
            data[ApiKey.kOtp] = self.txtOTPNumber.text ?? kEmptyString
            data[ApiKey.kDevicetype] = kDeviceType
            data[ApiKey.KDeviceToken] =  AppDelegate.DeviceToken
            data[ApiKey.KVoip_device_token] = AppDelegate.VOIPDeviceToken
            if Connectivity.isConnectedToInternet {
                self.showLoader()
                self.OtpVerifyApi(data: data)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
            
        }
    }
    
    //MARK: - Keyboard method
    
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
    
    
    // MARK: - Private Functions
    private func validateData () -> String?
    {
        if self.txtOTPNumber.isEmpty
        {
            return kEmptyOTPAlert
        }
        else if (self.txtOTPNumber.text?.count ?? 0)<4
        {
            return kOTPValidAlert
        }
        
        return nil
    }
    

    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.viewPhone,viewResend,btnResed,btnChangeNumber,btnContinue])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.viewPhone,viewResend,btnResed,btnChangeNumber,btnContinue])
    
    }
    //MARK: - validationNexButton
    
    func validationNexButton(count:Int=0)
    {
        debugPrint("text count = \(validateData()) \(count)")
        if count < 4//validateData() != nil || count == 0
        {
            self.btnContinue.isEnabled=false
            self.btnContinue.backgroundColor = DISABLECOLOR
        }
        
        else
        {
            self.btnContinue.backgroundColor = ENABLECOLOR
            self.btnContinue.isEnabled=true
        }
    }
}
//MARK: - textfield delegate method

extension VerificationVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        self.validationNexButton(count: newString.length)
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0
        {
            return false
        }
        else
        {
            return newString.length <= maxLength
        }
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
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                //let characters = Array((OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? ""))
                let characters = (OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? "")

                debugPrint(characters)
                self.viewResend.isHidden = false
                self.viewOTPSuccess.isHidden = true
   
            }
        })
    }
    
    func OtpVerifyApi(data:JSONDictionary)
    {
        OnBoardingVM.shared.callApiForVerifyOTPAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
            
                self.hideLoader()
                if (OnBoardingVM.shared.loginUserDetail?.profile_data?.username != nil)
                {
                    /*
                    if (OnBoardingVM.shared.loginUserDetail?.more_profile_details?.bio == nil)
                     {
                        DataManager.comeFromTag=5
                        DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                        DataManager.isProfileCompelete=true
                        DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                        
                        if let img = OnBoardingVM.shared.loginUserDetail?.profile_data?.image
                        {
                           
                            DataManager.userImage=img
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
                        */
                     
                    
                        
                        DataManager.isEditProfile=true
                        DataManager.comeFromTag=5
                        DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                        DataManager.isProfileCompelete=true
                        DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                        let active = OnBoardingVM.shared.Shake_Subsription_Data?.subscription_is_active ?? 0
                        
                        if active == 1
                        {
                           DataManager.purchasePlan=true
                        }
                        else
                        {
                            DataManager.purchasePlan=false
                        }
                        
                        if let img = OnBoardingVM.shared.loginUserDetail?.profile_data?.image
                        {
                            DataManager.userImage=img
                        }
                        self.goToShake()
                  //  }
                    
                  
                }
                else
                {
                    let vc = ProfilePicVC.instantiate(fromAppStoryboard: .Main)
                    DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                    DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        })
    }
}


//MARK: - Custom function

extension VerificationVC
{
   
}
