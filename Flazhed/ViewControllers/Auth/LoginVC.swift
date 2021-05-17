//
//  LoginVC.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import UIKit
import GoogleSignIn
import CoreLocation

class LoginVC: BaseVC {
    
    //MARK:- All outlets  🍎
    @IBOutlet weak var viewButtom: UIView!
    
    //MARK:- All Variable  🍎
    
    let manager = CLLocationManager()
    var currentCoutryCode = kCurrentCountryCode
    
    //MARK:- View Lifecycle   🍎
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewButtom.roundCorners(corners: [.topLeft,.topRight], radius: 15)
        
        self.checkgoogleSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
        if self.getDeviceModel() == "iPhone 6"
        {
            
            TOPSPACING = STATUSBARHEIGHT//CGFloat(STATUSBARHEIGHT+8)
        }
        else
        {
            TOPSPACING = CGFloat(STATUSBARHEIGHT)
            
        }
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
            //  self.openSettings(message: kLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
            //  self.openSettings(message: kLocation)
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        GIDSignIn.sharedInstance()?.signOut()
    }
    //MARK:- change status bar tint color 🍎
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    //MARK:- Google login button action 🍎
    
    @IBAction func googleLoginAct(_ sender: Any)
    {
        
        if Connectivity.isConnectedToInternet {
            
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    //MARK:- Facebook login button action 🍎
    
    @IBAction func facebookLoginAct(_ sender: UIButton)
    {
        
        if Connectivity.isConnectedToInternet {
            print("Connected")
            loginWithFb()
        } else {
            print("No Internet")
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    //MARK:- phone number login button action 🍎
    
    @IBAction func phoneLoginAct(_ sender: Any)
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)//Main
        let vc = storyBoard.instantiateViewController(withIdentifier: "MobileVerificationVC") as! MobileVerificationVC//MobileVerificationVC ProfilePicVC AddVoiceVC
       // vc.countryCode = self.currentCoutryCode
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:- Term & condition button action 🍎
    
    @IBAction func termCondtionAct(_ sender: Any)
    {
        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Privacy policy button action 🍎
    
    @IBAction func privacyPolicyAct(_ sender: Any)
    {
        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Login with facebook function 🍎
    
    func loginWithFb()
    {
        let fbSuite = FacebookLoginSuite()
        fbSuite.logout()
        fbSuite.signInWithController(controller: self, success: { (success, response) in
            print(response)
            let dict = self.parseFBData(response: response as! JSONDictionary)
            
            let socialID = dict[ApiKey.kId] as! String
            let email = dict[ApiKey.kEmail] as! String
            let name = dict[kFBName] as? String ?? ""
            let profileImageUrl = dict[ApiKey.kImage] as? URL
            
            var data = JSONDictionary()
            data[ApiKey.kSocial_id] = socialID
            data[ApiKey.kSocial_type] = kFacebook
            data[ApiKey.kEmail] = email
            data[ApiKey.kDevicetype] = kDeviceType
            data[ApiKey.KDeviceToken] =  AppDelegate.DeviceToken
            self.socialLoginApi(data: data, profileName: name, profileImage: profileImageUrl)
            
            print("Api call here")
            
            Indicator.sharedInstance.hideIndicator()
            
        }) { (errorReason, error) in
            Indicator.sharedInstance.hideIndicator()
        }
    }
    //MARK:- check google Setup function 🍎
    
    func checkgoogleSetup()
    {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        NotificationCenter.default.addObserver(self,selector: #selector(userDidSignInGoogle(_:)),name: .signInGoogleCompleted,object: nil)
    }
    
    
    // MARK:- user Did SignIn Google  Notification 🍎
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        if let user = GIDSignIn.sharedInstance()?.currentUser
        {
            
            print(user)
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name ?? ""
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            var pic:URL!
            
            if user.profile.hasImage
            {
                pic = user.profile.imageURL(withDimension: 500)
                print(pic)
            }
            
            print("didSignInFor user details = \(userId) \(idToken) \(givenName) \(fullName) \(familyName) \(email)")
            GIDSignIn.sharedInstance()?.signOut()
            //
            
            var data = JSONDictionary()
            data[ApiKey.kSocial_id] = userId
            data[ApiKey.kSocial_type] = kGoogle
            data[ApiKey.kEmail] = email
            data[ApiKey.kDevicetype] = kDeviceType
            data[ApiKey.KDeviceToken] = AppDelegate.DeviceToken
            
            self.socialLoginApi(data: data, profileName: fullName, profileImage: pic)
            
            print("Api call here")
        }
    }
}

//MARK:- Google facebook signin api 🍎

extension LoginVC
{
    
    func socialLoginApi(data:JSONDictionary,profileName:String,profileImage:URL?)
    {
        OnBoardingVM.shared.callApiSocialLoginAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                if (OnBoardingVM.shared.loginUserDetail?.profile_data?.username != nil)
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
                    DataManager.comeFromTag=5
                    DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                    DataManager.isProfileCompelete=true
                    DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                    DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                    DataManager.userId=OnBoardingVM.shared.loginUserDetail?.profile_data?.username ?? ""
                    DataManager.userName=OnBoardingVM.shared.loginUserDetail?.profile_data?.username ?? ""
                    
                    if OnBoardingVM.shared.loginUserDetail?.profile_data?.images?.count ?? 0>0
                    {
                        let img=OnBoardingVM.shared.loginUserDetail?.profile_data?.images?[0].image
                        
                        DataManager.userImage=img ?? ""
                    }
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicVC") as! ProfilePicVC
                    vc.userProfile=profileImage
                    vc.userName=profileName
                    DataManager.comeFromTag=5
                    DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                    
                    DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
            
        })
    }
    
}
//MARK:- Get current location 🍎

extension LoginVC: CLLocationManagerDelegate
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
                
                self.currentCoutryCode = "+"+phoneCode
                DataManager.countryPhoneCode=self.currentCoutryCode
                DataManager.countryName = code
                print(self.currentCoutryCode)
                
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
