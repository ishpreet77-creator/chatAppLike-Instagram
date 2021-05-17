//
//  AccountsVC.swift
//  Flazhed
//
//  Created by IOS20 on 07/01/21.
//

import UIKit
import CoreLocation

class AccountsVC: BaseVC {
    

    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblMobileNumer: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    var comeFromVerify = false
    var mobileNumber = ""
    var countryCode = kCurrentCountryCode
    var countryName = "India"
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("app version = \(Bundle.main.releaseVersionNumberPretty)")
        lblAppVersion.text = Bundle.main.releaseVersionNumberPretty
     
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
        
        super.viewWillAppear(true)
        self.topConst.constant = 0
       if DataManager.comeFrom != kViewProfile
       {
        self.getUserDetails()
       }
        
      
    }
    
    //MARK:-IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        if comeFromVerify
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToProfile()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToProfile()
            }
        }
        else
        {
            DataManager.comeFrom = kViewProfile
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        
        if sender.tag == 0  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileNumberVC") as! MobileNumberVC
            vc.mobileNumber=self.mobileNumber
            vc.countryCode=self.countryCode
          
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else if sender.tag == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnitsVC") as! UnitsVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if sender.tag == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.tag == 4 || sender.tag == 5 || sender.tag == 3
        {
            let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.tag == 6
        {

            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteAccountPopUpVC") as! DeleteAccountPopUpVC
            vc.comeFrom = kAccount
            vc.delegate=self
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(vc, animated: true, completion: nil)
            
          
        }
        
        else if sender.tag == 7
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeleteAccountPopUpVC") as! DeleteAccountPopUpVC
            vc.comeFrom = kDelete
            vc.delegate=self
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(vc, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func getTheMostBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegretPopUpVC") as! RegretPopUpVC
        vc.type = .kExtraShakes
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

//MARK:- Extensions deleteAccountDelegate
extension AccountsVC:deleteAccountDelegate
{
    func deleteAccountFunc(name: String)
    {
        if name==kAccount
        {
            if Connectivity.isConnectedToInternet
            {
              
                self.LogoutApi()
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
           
        }
       else if name==kDelete
        {
        if Connectivity.isConnectedToInternet
        {
          
            self.DeleteAccountApi()
         } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        }
    }
    
    
}
// MARK:- Extension Api Calls
extension AccountsVC
{
    func LogoutApi()
    {
        ProfileVM.shared.callApiLogout(response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
     
                    DataManager.comeFrom = ""
                    DataManager.isProfileCompelete = false
                     DataManager.accessToken = ""
                    DataManager.Id = ""
                 DataManager.currentUnit = ""
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToLogin()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToLogin()
                }

            }
            
            
        })
    }
    
    func DeleteAccountApi()
    {
        ProfileVM.shared.callApiDeleteAccount(response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
              
                    DataManager.comeFrom = ""
                    DataManager.isProfileCompelete = false
                     DataManager.accessToken = ""
                    DataManager.Id = ""
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToLogin()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToLogin()
                }

            }
            
            
        })
    }
    
    
    //MARK:- Get user details
    
    func getUserDetails()
    {
     

            if Connectivity.isConnectedToInternet {
              
                self.getProfileApi()
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func getProfileApi()
    {
        ProfileVM.shared.callApiViewProfile(response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
               // if message! == "User get successfully."
               // {
                
                
                if let UserData = ProfileVM.shared.viewProfileUserDetail
                  {
                    if let phone_number = UserData.phone_number
                    {
                        self.lblMobileNumer.text = "\(phone_number)"
                        self.mobileNumber=self.lblMobileNumer.text!
                    }
                    else
                    {
                        self.lblMobileNumer.text = ""
                        self.mobileNumber=self.lblMobileNumer.text!
                    }
                    if let unit = UserData.unit_settings?.unit
                    {
                        self.lblUnit.text = "\(unit)"
                        CURRENTUNIT=self.lblUnit.text ?? kCentimeters
                        DataManager.currentUnit=unit
                    }
                    else
                    {
                        self.lblUnit.text = ""
                    }
                }
 
            }
            
            
        })
    }
}
extension AccountsVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
           if let location = locations.first
           {
               print("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
        

            
            
            self.fetchCityAndCountry(from: location) { (city, coutry, error) in
                
                print("code = \(city)")
                print("country = \(coutry)")
                print("error = \(error)")
                let code = coutry ?? ""
                let countryName = city ?? "India"
                self.countryName = countryName
                let phoneCode = self.getCountryCallingCode(countryRegionCode: code)
                
                self.countryCode = "+"+phoneCode
                print(self.countryCode)
                
            }

           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
       {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
}
