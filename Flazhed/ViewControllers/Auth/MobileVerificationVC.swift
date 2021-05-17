//
//  MobileVerificationVC.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//

import UIKit
import CountryPickerView
import IQKeyboardManagerSwift
import CoreLocation

class MobileVerificationVC: BaseVC {
    
    //MARK:- All outlets  🍎
    
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    //MARK:- All Variable  🍎
    
    let countryPickerView = CountryPickerView()
    var countryCode=kCurrentCountryCode
    let manager = CLLocationManager()
    var locationMenualy = false
    //MARK:- View Lifecycle   🍎
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
        
        if DataManager.countryPhoneCode == ""
        {
            countryCode=kCurrentCountryCode
        }
        else
        {
            countryCode=DataManager.countryPhoneCode
        }
        countryPickerView.setCountryByPhoneCode(self.countryCode)
        txtPhoneNumber.becomeFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        txtPhoneNumber.delegate=self
        self.countryCode=self.lblCountryCode.text ?? kCurrentCountryCode
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.resignFirstResponder()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    //MARK:- Select country button action 🍎
    
    @IBAction func selectCountryCodeAct(_ sender: UIButton)
    {
        countryPickerView.setCountryByPhoneCode(self.countryCode)
        countryPickerView.showCountriesList(from: self)
    }
    
    //MARK:- send OTP button action 🍎
    
    @IBAction func sendOTPAct(_ sender: UIButton)
    {
        txtPhoneNumber.resignFirstResponder()
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            var data = JSONDictionary()
            
            data[ApiKey.kPhoneNumber] = txtPhoneNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            data[ApiKey.kCountryCode] = lblCountryCode.text
            
            if Connectivity.isConnectedToInternet {
                
                self.callApiForPhoneLogin(data: data)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
            
        }
        
    }
    
    //MARK:- Keyboard method 🍎
    
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
    
    //MARK:- Setup UI method 🍎
    
    func setUpUI()
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lblOtpSent.text ?? "")
        attributedString.setColorForText(textForAttribute: "We will send you an  to this mobile to verify.", withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "One Time Password", withColor: TEXTCOLOR)
        attributedString.setColorForText(textForAttribute: " to this mobile to verify.", withColor: UIColor.black)
        
        lblOtpSent.attributedText = attributedString
        
        self.setCustomHeader(title: "Verification", showBack: true, showMenuButton: false)
        
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
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string:"Phone Number", attributes:[NSAttributedString.Key.foregroundColor: PLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
    }
    
    
    
    // MARK:- Private Functions
    private func validateData () -> String?
    {
        if txtPhoneNumber.isEmpty {
            return kEmptyPhoneAlert
        }
        if lblCountryCode.text?.count == 0
        {
            return  kEmptyCountryCodeAlert
        }
        
        return nil
    }
    
}

// MARK:- send OTP Api Calls

extension MobileVerificationVC
{
    func callApiForPhoneLogin(data:JSONDictionary)
    {
        OnBoardingVM.shared.callApiForSendOTPAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
                
                vc.mobileNumber=self.txtPhoneNumber.text!
                vc.countryCode=self.lblCountryCode.text!
                vc.forTesting="no"
                vc.SentOTP=(OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

//MARK:- textfield delegate method 🍎

extension MobileVerificationVC:UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        let maxLength = 15
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

//MARK:- Select country method 🍎

extension MobileVerificationVC: CountryPickerViewDelegate, CountryPickerViewDataSource
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    {
        let code = (country.phoneCode ?? kCurrentCountryCode).count
        
        self.imgCountry.roundedImageWithBorder()
        self.imgCountry.image =  country.flag
        
        self.lblCountryCode.text = country.phoneCode
        
        self.countryCode=self.lblCountryCode.text ?? kCurrentCountryCode
    
        self.locationMenualy = true
    }
    
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
}
//MARK:- Get current location 🍎

extension MobileVerificationVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            print("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
            
            self.fetchCityAndCountry(from: location) { (city, coutry, error) in
                let code = coutry ?? ""
                let phoneCode = self.getCountryCallingCode(countryRegionCode: code)
                
                self.countryCode = "+"+phoneCode
                if self.locationMenualy == false
                {
                    DataManager.countryPhoneCode=self.countryCode
                    DataManager.countryName = code
                    self.countryPickerView.setCountryByPhoneCode(self.countryCode)
                }
                
                print(self.countryCode)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
