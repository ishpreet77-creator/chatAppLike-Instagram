//
//  MobileNumberVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit
import CountryPickerView
import IQKeyboardManagerSwift
import CoreLocation

class MobileNumberVC: BaseVC {
    
    //MARK: -  IBOutlets
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContryCodeText: UILabel!
    @IBOutlet weak var lblMobileNumberText: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var lblOtpsent: UILabel!
    @IBOutlet weak var viewMobile: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var verifyBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtFieldMobile: UITextField!
    @IBOutlet weak var textFieldCountry: UITextField!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    //MARK: - Variables
    let countryPickerView = CountryPickerView()
    
    var countryCode = kCurrentCountryCode
    var countryName = "Denmark"
    var mobileNumber = ""
    var locationMenualy = false
    let manager = CLLocationManager()
    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        self.txtFieldMobile.text = self.mobileNumber
        
        textFieldCountry.attributedPlaceholder = NSAttributedString(string:"Country", attributes:[NSAttributedString.Key.foregroundColor: PLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
        
        // Do any additional setup after loading the view.
        lblNumber.text = txtFieldMobile.text
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true

        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
       // manager.startMonitoringSignificantLocationChanges()
        if (DataManager.countryPhoneCode != "") && (DataManager.countryName != "")
        {
            
            countryCode=DataManager.countryPhoneCode
            self.countryName = DataManager.countryName
        }
        else
        {
            countryCode=kCurrentCountryCode
            countryName = "Denmark"
        }
        
        self.textFieldCountry.text = "(\(self.countryCode))  \(countryName.uppercased())"
        
        
        self.view.endEditing(true)
        
      //  self.setCustomHeader(title: "Verification", showBack: true, showMenuButton: false)

        if self.getDeviceModel() == "iPhone 6"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+48
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+48
        }
        else
        {
            self.topConst.constant = TOPSPACING+48
        }
        //self.topConst.constant = 48
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    func setUpUI()
    {
        self.lblTitle.text = kMOBILENUMBER.capitalized
        self.lblContryCodeText.text = kCOUNTRYCODE
        self.lblMobileNumberText.text = kMOBILENUMBER
        self.lblOtpsent.text = kVerificationOTP
        self.btnVerify.setTitle(kVerify, for: .normal)
        self.btnVerify.setTitle(kVerify, for: .selected)
        
        self.btnVerify.backgroundColor = ENABLECOLOR
        
        // color change
        self.lblContryCodeText.textColor = PURPLECOLOR
        self.lblMobileNumberText.textColor = PURPLECOLOR
        
        self.txtFieldMobile.placeholder = kMOBILENUMBER
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        DataManager.comeFrom = kViewProfile
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyBtnAction(_ sender: UIButton) {
      
        txtFieldMobile.resignFirstResponder()
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
        var data = JSONDictionary()
    
        data[ApiKey.kPhoneNumber] = txtFieldMobile.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            data[ApiKey.kCountryCode] = self.countryCode
            
            if Connectivity.isConnectedToInternet {
              
                self.callApiForPhoneLogin(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
            
        }
        
    }
    @IBAction func selectCountryCodeAct(_ sender: UIButton)
    {
       
        countryPickerView.setCountryByPhoneCode(self.countryCode)
        countryPickerView.showCountriesList(from: self)
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        lblNumber.text = txtFieldMobile.text
        
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
     verifyBottomConstraint.constant = keyboardHeight+44
    
     }
     else
     {
     self.verifyBottomConstraint.constant = keyboardHeight+44+20

     }
     
     }
     
     @objc
     func keyboardWillDisappear(notification: NSNotification?) {
     verifyBottomConstraint.constant = 44
     }
    
    // MARK:- Private Functions
    private func validateData () -> String?
    {
        if txtFieldMobile.isEmpty {
            return kEmptyPhoneAlert
        }
        if lblNumber.text?.count == 0
        {
            return  kEmptyCountryCodeAlert
        }
    
        return nil
     }
    
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.viewMobile,self.viewCountry,self.lblNumber,self.viewButtom,self.lblOtpsent])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.viewMobile,self.viewCountry,self.lblNumber,self.viewButtom,self.lblOtpsent])
    }
    
}
//MARK: - Extension
extension MobileNumberVC: CountryPickerViewDelegate, CountryPickerViewDataSource
{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    {
        
        self.locationMenualy=true
        let code = country.phoneCode
        //  self.imgCountry.roundedImageWithBorder()
        let name =  country.name
        self.countryCode=code
        //        self.textFieldCountry.text = "( "+ \(code) + ")" + " " + name
        self.textFieldCountry.text = "(\(code))  \(name.uppercased())"
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
}


//MARK: - Extension  UITextFieldDelegate
extension MobileNumberVC:UITextFieldDelegate {

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
// MARK:- Extension Api Calls
extension MobileNumberVC
{
    func callApiForPhoneLogin(data:JSONDictionary)
    {
        OnBoardingVM.shared.callApiForSendOTPAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
            
                let vc = OtpVC.instantiate(fromAppStoryboard: .Account)
                vc.mobileNumber=self.txtFieldMobile.text!
                vc.countryCode=self.countryCode
               vc.forTesting="no"
                vc.SentOTP=(OnBoardingVM.shared.sendOTPData[ApiKey.kOtp] as? String ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
        
            }

         
        })
    }
}
extension MobileNumberVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
           if let location = locations.first
           {
               debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
        

            
            
            self.fetchCityAndCountry(from: location) { (Country, PhoneCode, error) in
                
                debugPrint("code = \(String(describing: PhoneCode))")
                debugPrint("country = \(String(describing: Country))")
                debugPrint("error = \(String(describing: error))")
                let countryName = Country ?? "Denmark"
                let code = PhoneCode ?? ""
                
                let phoneCode = self.getCountryCallingCode(countryRegionCode: code)
                
                self.countryCode = "+"+phoneCode
                if self.locationMenualy == false
                {
                    DataManager.countryPhoneCode=self.countryCode
                    self.countryPickerView.setCountryByPhoneCode(self.countryCode)
                    self.countryName = countryName
                    DataManager.countryName = countryName
                    self.textFieldCountry.text = "(\(self.countryCode))  \(countryName.uppercased())"
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
