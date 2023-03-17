//
//  AccountsVC.swift
//  Flazhed
//
//  Created by IOS20 on 07/01/21.
//

import UIKit
import CoreData
import CoreLocation
import MessageUI

class AccountsVC: BaseVC {
    @IBOutlet weak var lblMobileText: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDeleteAccount: UILabel!
    @IBOutlet weak var lbllogout: UILabel!
    @IBOutlet weak var lblTermserv: UILabel!
    @IBOutlet weak var lblGdrp: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblUnitText: UILabel!
    @IBOutlet weak var stakDelete: UIStackView!
    
    @IBOutlet weak var stackMobile: UIStackView!
    @IBOutlet weak var viewSubscription: UIView!
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblMobileNumer: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    var comeFromVerify = false
    var mobileNumber = ""
    var countryCode = kCurrentCountryCode
    var countryName = "Denmark"
    
    let manager = CLLocationManager()
    
    var offlinePhone:String?
    var offlineUnit:String?
    var userData:UserListModel?
    var comeFrom = kHome
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("app version = \(Bundle.main.releaseVersionNumberPretty)")
        lblAppVersion.text = Bundle.main.releaseVersionNumberPretty
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
        // manager.startMonitoringSignificantLocationChanges()
        super.viewWillAppear(true)
        self.topConst.constant = 0
        if DataManager.comeFrom != kViewProfile
        {
            if self.comeFrom.equalsIgnoreCase(string: kProfile)
            {
                self.comeFrom=kEmptyString
                self.setData()
            }
            else
            {
                if Connectivity.isConnectedToInternet {
                    
                    self.getUserDetails()
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
            }
        }
        
        
    }
    
    func setUpUI()
    {
        self.lblTitle.text = kAccount.capitalized
        self.lblMobileText.text = kMOBILENUMBER
        self.lblUnitText.text = kUNITS
        self.lblNotification.text = kNOTIFICATIONS
        self.lbllogout.text = kLogout
        self.lblTermserv.text = kTermOfService
        self.lblGdrp.text = kGDPRGuidelines
        
        self.lblContactUs.text = kCONTACTUS
        self.lblDeleteAccount.text = kDeleteAccount
    }
    
    //MARK: -IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        if comeFromVerify
        {
            
            self.goToProfile()
            
        }
        else
        {
            if DataManager.comeFrom == kOTPValidAlert
            {
                DataManager.comeFrom = kEmptyString
            }
            else
            {
                DataManager.comeFrom = kViewProfile
            }
            
            
            //
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func btnActions(_ sender: UIButton) {
        
        if sender.tag == 0  {
            let vc = MobileNumberVC.instantiate(fromAppStoryboard: .Account)
            vc.mobileNumber=self.mobileNumber
            vc.countryCode=self.countryCode
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else if sender.tag == 1
        {
            let vc = UnitsVC.instantiate(fromAppStoryboard: .Account)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.tag == 2
        {
            let vc = NotificationVC.instantiate(fromAppStoryboard: .Account)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else  if sender.tag == 3
        {
            let recipientEmail = APP_ADMIN_EMAIL
            let subject = APP_HELP_SUBJECT
            let body = APP_HELP_MESSAGE
            
            // Show default mail composer
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)
                
                
                
                if let tab = self.tabBarController
                {
                    tab.present(mail, animated: true, completion: nil)
                }
                else
                {
                    present(mail, animated: true)
                }
                
            }
            else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body)
            {
                UIApplication.shared.open(emailUrl)
            }
            
        }
        
        else if sender.tag == 4
        {
            let vc = WebVC.instantiate(fromAppStoryboard: .Account)
            vc.pageTitle=kGDPRGuidelines
            vc.pageUrl=Privacy_Policy_URL
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if  sender.tag == 5
        {
            let vc = WebVC.instantiate(fromAppStoryboard: .Account)
            vc.pageTitle=kTermOfService
            vc.pageUrl=TERM_URL
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if sender.tag == 6
        {
    
            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
            vc.comeFrom = kAccount
            vc.delegate=self
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let tab = self.tabBarController
            {
                tab.present(vc, animated: true, completion: nil)
            }
            else
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
        else if sender.tag == 7
        {

            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)

            vc.comeFrom = kDelete
            vc.delegate=self
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if let tab = self.tabBarController
            {
                tab.present(vc, animated: true, completion: nil)
            }
            else
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    @IBAction func getTheMostBtnAction(_ sender: UIButton) {
    
        let vc =  NewPremiumVC.instantiate(fromAppStoryboard: .Account)
        vc.type = .kExtraShakes
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.stakDelete])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.stakDelete])
    }
    
    
}

//MARK: - Extensions deleteAccountDelegate
extension AccountsVC:deleteAccountDelegate
{
    func deleteAccountFunc(name: String)
    {
        if name.equalsIgnoreCase(string: kAccount)
        {
            if Connectivity.isConnectedToInternet
            {
                
                self.LogoutApi()
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
        else if name.equalsIgnoreCase(string: kDelete)
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
        Indicator.sharedInstance.showIndicator2()
        ProfileVM.shared.callApiLogout(response: { (message, error) in
            if error != nil
            {
                Indicator.sharedInstance.hideIndicator2()
                self.showErrorMessage(error: error)
            }
            else{
                APPDEL.timerBudgeCount?.invalidate()
                DataManager.comeFrom = ""
                DataManager.isProfileCompelete = false
                DataManager.accessToken = ""
                DataManager.Id = kEmptyString
                DataManager.userName = ""
                DataManager.currentUnit = ""
                DataManager.ShakeId=""
                DataManager.purchasePlan=false
                DataManager.purchaseProlong=false
                APPDEL.timerBudgeCount?.invalidate()
                self.ClearMemory()
                // self.ClearCoreAllData()
                Indicator.sharedInstance.hideIndicator2()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                
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
        Indicator.sharedInstance.showIndicator2()
        ProfileVM.shared.callApiDeleteAccount(response: { (message, error) in
            if error != nil
            {
                Indicator.sharedInstance.hideIndicator2()
                self.showErrorMessage(error: error)
            }
            else{
                APPDEL.timerBudgeCount?.invalidate()
                DataManager.comeFrom = ""
                DataManager.isProfileCompelete = false
                DataManager.accessToken = ""
                DataManager.Id = kEmptyString
                DataManager.ShakeId=""
                DataManager.userName = ""
                DataManager.isPrefrenceSet = false
                DataManager.isEditProfile=false
                DataManager.purchasePlan=false
                DataManager.purchaseProlong=false
                APPDEL.timerBudgeCount?.invalidate()
                self.ClearMemory()
                self.ClearCoreAllData()
                Indicator.sharedInstance.hideIndicator2()
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            
                
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToLogin()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToLogin()
                }
                
            }
            
            
        })
    }
    
    
    //MARK: - Get user details
    
    func getUserDetails()
    {
        
        
        if Connectivity.isConnectedToInternet {
            self.showLoader()
            self.getProfileApi()
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func getProfileApi()
    {
        ProfileVM.shared.callApiEditProfile(response: { (message, error) in
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.userData = ProfileVM.shared.viewProfileUserDetail
                self.hideLoader()
                self.setData()
                
            }
        })
    }
    
    func setData()
    {
        self.hideLoader()
        if let UserData = self.userData
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
                self.lblUnit.text = kCentimeters
                CURRENTUNIT=self.lblUnit.text ?? kCentimeters
                DataManager.currentUnit=kCentimeters
            }
        }
    }
    /*
     func getProfileApi()
     {
     ProfileVM.shared.callApiOnlyProfileDetail(response: { (message, error) in
     if error != nil
     {
     self.hideLoader()
     self.showErrorMessage(error: error)
     }
     else{
     self.hideLoader()
     if let UserData = ProfileVM.shared.onlyProfileDetail
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
     self.lblUnit.text = kCentimeters
     CURRENTUNIT=self.lblUnit.text ?? kCentimeters
     DataManager.currentUnit=kCentimeters
     }
     }
     
     }
     
     
     })
     }
     
     */
    
    func fetchUserData()
    {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ApiKey.kOwnProfile)
        do {
            let context = CoreDataManager.getContext()
            let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
            //  result = try managedContext.fetch(fetchRequest)
            for data in result!
            {
                if let kPhoneNumber = data.value(forKey:  ApiKey.kPhoneNumber) as? String{
                    self.lblMobileNumer.text  = kPhoneNumber
                }
                
                if let kUnit = data.value(forKey:  ApiKey.kUnit) as? String{
                    self.lblUnit.text  = kUnit
                }
                
            }
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
extension AccountsVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.first
        {
            debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
            
            
            
            
            self.fetchCityAndCountry(from: location) { (city, coutry, error) in
                
                // debugPrint("code = \(city)")
                // debugPrint("country = \(coutry)")
                // debugPrint("error = \(error)")
                let code = coutry ?? ""
                let countryName = city ?? "Denmark"
                self.countryName = countryName
                let phoneCode = self.getCountryCallingCode(countryRegionCode: code)
                
                self.countryCode = "+"+phoneCode
                debugPrint(self.countryCode)
                
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        debugPrint("Failed to find user's location: \(error.localizedDescription)")
    }
}
extension AccountsVC:MFMailComposeViewControllerDelegate
{
    private func createEmailUrl(to: String, subject: String, body: String) -> URL?
    {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
