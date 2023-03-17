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
import SkeletonView

class MobileVerificationVC: BaseVC {
    
    //MARK: - All outlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    //MARK: - All Variable
    
    let countryPickerView = CountryPickerView()
    var countryCode=kCurrentCountryCode
    let manager = CLLocationManager()
    var locationMenualy = false
    //MARK: - View Lifecycle   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        txtPhoneNumber.text? = ""
        validationNexButton()
        
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
       // manager.startMonitoringSignificantLocationChanges()
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
    
    //MARK: - backBtnAction

    @IBAction func backBtnAction(_ sender: UIButton) {
     
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Select country button action
    
    @IBAction func selectCountryCodeAct(_ sender: UIButton)
    {
        countryPickerView.setCountryByPhoneCode(self.countryCode)
        countryPickerView.showCountriesList(from: self)
    }
    
    //MARK: - send OTP button action 
    
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
                self.showLoader()
                self.callApiForPhoneLogin(data: data)
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
    
    //MARK: - Setup UI method
    
    func setUpUI()
    {
        lblOtpSent.makeBoldText(withString: kVerificationSend, boldString: kOneTimePassword, normalfont: UIFont.CustomFont.regular.fontWithSize(size: 16), boldfont: UIFont.CustomFont.bold.fontWithSize(size: 16))
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string:kPhoneNumber, attributes:[NSAttributedString.Key.foregroundColor: PLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .normal)
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .selected)

    }

    
    // MARK: - Private Functions
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
    
    func showLoader()
    {

 Indicator.sharedInstance.showIndicator3(views: [self.viewPhone,self.btnContinue])

    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.viewPhone,self.btnContinue])
    }
    //MARK: - validationNexButton
    
    func validationNexButton(count:Int=0)
    {
        debugPrint("text count = \(count)")
        if count < 8//validateData() != nil || count == 0
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

// MARK: - send OTP Api Calls

extension MobileVerificationVC
{
    func callApiForPhoneLogin(data:JSONDictionary)
    {
        OnBoardingVM.shared.callApiForSendOTPAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                
                self.hideLoader()
                let vc = VerificationVC.instantiate(fromAppStoryboard: .Main)
                vc.mobileNumber=self.txtPhoneNumber.text!
                vc.countryCode=self.lblCountryCode.text!
                vc.forTesting="no"
               // vc.SentOTP=(OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

//MARK: - textfield delegate method 

extension MobileVerificationVC:UITextFieldDelegate {
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
       
        let maxLength = 15
        let currentString: NSString = textField.text! as NSString
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

//MARK: - Select country method

extension MobileVerificationVC: CountryPickerViewDelegate, CountryPickerViewDataSource
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    {
        // let code = (country.phoneCode).count
        
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
//MARK: - Get current location 

extension MobileVerificationVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
            
            self.fetchCityAndCountry(from: location) { (Country, PhoneCode, error) in
                let code = PhoneCode ?? "45"
                let country = Country ?? "Denmark"
                let phoneCode = self.getCountryCallingCode(countryRegionCode: code)
                
                self.countryCode = "+"+phoneCode
                if self.locationMenualy == false
                {
                    DataManager.countryPhoneCode=self.countryCode
                    DataManager.countryName = country
                    self.countryPickerView.setCountryByPhoneCode(self.countryCode)
                }
                
                debugPrint(self.countryCode)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        debugPrint("Failed to find user's location: \(error.localizedDescription)")
    }
}
