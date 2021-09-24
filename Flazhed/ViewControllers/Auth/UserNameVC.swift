//
//  UserNameVC.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//

import UIKit
import CountryPickerView

class UserNameVC: BaseVC {
    
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewProgress: NSLayoutConstraint!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    var imageArray1:[UIImage] = []
    var userName=""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
       
        
       // self.txtUserName.autocapitalizationType = .words
    }
    
    func setUpUI()
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lblOtpSent.text ?? "")
        attributedString.setColorForText(textForAttribute: kARealName, withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: kTrust, withColor: TEXTCOLOR)
        attributedString.setColorForText(textForAttribute: kYou, withColor: UIColor.black)

        lblOtpSent.attributedText = attributedString
        
        self.setCustomHeader(title: kUsername, showBack: true, showMenuButton: false)
        
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
            self.topConst.constant = TOPSPACING+20
        }
        
    
        txtUserName.attributedPlaceholder = NSAttributedString(string:kName, attributes:[NSAttributedString.Key.foregroundColor: PLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
        txtUserName.delegate=self
        self.txtUserName.text = userName
        if DataManager.userNameType != kEmptyString
        {
            self.txtUserName.text=DataManager.userNameType
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //txtUserName.text = ""
        txtUserName.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    
    }
   
    
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateOfBirthVC") as! DateOfBirthVC
            vc.imageArray1=self.imageArray1
            vc.userName=self.txtUserName.text!
            DataManager.userNameType=self.txtUserName.text!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
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
            sendButtonConst.constant = keyboardHeight+26
            viewProgress.constant = keyboardHeight
        }
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+20+16
            viewProgress.constant = keyboardHeight+16+20
        }
        
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
        viewProgress.constant = 0
    }
   
    
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
        if txtUserName.isEmpty {
            return kEmptyUserNameAlert
        }
        if txtUserName.text?.count ?? 0 < 2 {
            return kMinUserNameAlert
        }
        
        return nil
     }

}
//MARK:- Extension  UITextFieldDelegate
extension UserNameVC:UITextFieldDelegate {
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
      
        
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0
        
        {
            return false
        }
        else
         
        {
            textField.text = currentString.capitalized
            
            return newString.length <= maxLength
        }
        
   
    }
    
    
   
}
