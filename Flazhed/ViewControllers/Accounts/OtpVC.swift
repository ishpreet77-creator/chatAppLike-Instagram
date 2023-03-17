//
//  OtpVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class OtpVC: BaseVC {
    
    //MARK: -  IBOutlets
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblOTPText: UILabel!
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var txtFieldOtp: UITextField!
    @IBOutlet weak var verifyBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var countryCode = ""
    var mobileNumber = ""
    var SentOTP = ""
    var forTesting = ""
    
    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.forTesting.equalsIgnoreCase(string: "yes") 
        {
        self.txtFieldOtp.text=SentOTP
        }
  
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.validationPassed()

        self.view.endEditing(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setCustomHeader(title: kMOBILENUMBER, showBack: true, showMenuButton: false)
        
        if self.getDeviceModel() == "iPhone 6"
        {
            self.topConstraint.constant = TOPSPACING+STATUSBARHEIGHT+48
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            self.topConstraint.constant = TOPSPACING+STATUSBARHEIGHT+48
        }
        else
        {
            self.topConstraint.constant = TOPSPACING+48
        }
      //  self.topConstraint.constant = 48
        
        self.txtFieldOtp.delegate=self
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    func setUpUI()
    {
     
        self.lblOTPText.text = kOTP
        self.btnVerify.setTitle(kVerify, for: .normal)
        self.btnVerify.setTitle(kVerify, for: .selected)
        
        self.btnVerify.backgroundColor = ENABLECOLOR

    }
    
    //MARK: -IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyBtnAction(_ sender: UIButton)
    {
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            var data = JSONDictionary()
            data[ApiKey.kPhoneNumber] = self.mobileNumber
            data[ApiKey.kCountryCode] = self.countryCode
            data[ApiKey.kOtp] = self.txtFieldOtp.text!

            if Connectivity.isConnectedToInternet {
                self.showLoader()
                self.updateMobileApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
      
    }
    
    //MARK: - Functions
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
     verifyBottonConstraint.constant = keyboardHeight+44
     }
     else
     {
     self.verifyBottonConstraint.constant = keyboardHeight+44+20
     }
     
     }

     
     @objc
     func keyboardWillDisappear(notification: NSNotification?) {
     verifyBottonConstraint.constant = 44
     }
    
    
    
    // MARK: - Private Functions
    private func validateData () -> String?
    {
        if txtFieldOtp.isEmpty  {
            return kEmptyOTPAlert
        }
        else if txtFieldOtp.isEmpty{
            return kOTPValidAlert
        }
       
        
        return nil
    }
    
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.viewOtp,self.viewButtom])
    
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.viewOtp,self.viewButtom])
    }
    //MARK: - Validate button
    
    func validationPassed(count:Int=0)
    {
        debugPrint("text count = \(count)")
        if validateData() != nil || count == 0
        {
            self.btnVerify.isEnabled=false
            self.btnVerify.backgroundColor = DISABLECOLOR
        }
        
        else
        {
            self.btnVerify.backgroundColor = ENABLECOLOR
            self.btnVerify.isEnabled=true
        }
    }
}

extension OtpVC:UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        self.validationPassed(count: newString.length)

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

// MARK: - Extension Api Calls
extension OtpVC
{

    func updateMobileApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdateMobile(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                
                let vc = AccountsVC.instantiate(fromAppStoryboard: .Account)
                vc.comeFromVerify=true
                DataManager.comeFrom = kOTPValidAlert
                self.navigationController?.pushViewController(vc, animated: false)

            }
            
            
        })
    }
}
