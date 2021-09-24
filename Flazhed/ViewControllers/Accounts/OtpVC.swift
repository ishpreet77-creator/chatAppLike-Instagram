//
//  OtpVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class OtpVC: BaseVC {
    
    //MARK:- Variables
    
    
    //MARK:-  IBOutlets
    @IBOutlet weak var txtFieldOtp: UITextField!
    @IBOutlet weak var verifyBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var countryCode = ""
    var mobileNumber = ""
    var SentOTP = ""
    var forTesting = ""
    
    //MARK:- Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.forTesting.equalsIgnoreCase(string: "yes") 
        {
        self.txtFieldOtp.text=SentOTP
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.endEditing(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setCustomHeader(title: "Verification", showBack: true, showMenuButton: false)
        
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
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    //MARK:-IBActions
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
              
                self.updateMobileApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
      
    }
    
    //MARK:- Functions
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
    
    
    
    // MARK:- Private Functions
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
    
}

extension OtpVC:UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
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
}

// MARK:- Extension Api Calls
extension OtpVC
{

    func updateMobileApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdateMobile(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
             
                let storyBoard = UIStoryboard(name: kAccount, bundle: nil)
        
                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsVC
                vc.comeFromVerify=true
                DataManager.comeFrom = kOTPValidAlert
                self.navigationController?.pushViewController(vc, animated: false)

            }
            
            
        })
    }
}
