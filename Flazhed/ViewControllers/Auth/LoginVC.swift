//
//  LoginVC.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import UIKit
import GoogleSignIn
import CoreLocation
import AVKit
import SkeletonView
import AuthenticationServices
import ListPlaceholder
class LoginVC: BaseVC {
    
    //MARK: - All outlets
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var stackLogin: UIStackView!
    @IBOutlet weak var lblContinue: UITextView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var viewAppleLogin: UIView!
    @IBOutlet weak var viewPT: UIView!
   
    //MARK: - All Variable
    
    let manager = CLLocationManager()
    var currentCoutryCode = kCurrentCountryCode
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
        // manager.startMonitoringSignificantLocationChanges()
        if self.getDeviceModel() == "iPhone 6"
        {
            
            TOPSPACING = STATUSBARHEIGHT//CGFloat(STATUSBARHEIGHT+8)
        }
        else
        {
            TOPSPACING = CGFloat(STATUSBARHEIGHT)
            
        }
        
        self.hideLoader()
        self.clearLocalData()
        
        //Indicator.sharedInstance.showIndicator2()
    }
    
    //MARK: - Setup UI
    
    func setupUI()
    {
        if #available(iOS 13.0, *)
        {
            self.viewAppleLogin.isHidden=false

        }
        else
        {
            self.viewAppleLogin.isHidden=true  
            
        }
    
        self.lblContinue.isUserInteractionEnabled = true
        self.viewButtom.roundCorners(corners: [.topLeft,.topRight], radius: 15)
        
        self.checkgoogleSetup()
        
        lblContinue.text = kContinuePrivacy
        let text = (lblContinue.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range0 = (text as NSString).range(of: kContinuePrivacy)
        let range1 = (text as NSString).range(of: kTermOfService)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        let range2 = (text as NSString).range(of: kPrivacyPolicy)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.CustomFont.regular.fontWithSize(size: 13), range: range0)
        lblContinue.attributedText = underlineAttriString
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTextView(_:)))
        lblContinue.addGestureRecognizer(tapGesture)
        
        //MARK: - Hide permission
        self.requestPermission()
     
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        GIDSignIn.sharedInstance()?.signOut()
    }
    //MARK: - change status bar tint color
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    func requestPermission()
    {
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                debugPrint("No access")
                //  self.openSettings(message: kLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                debugPrint("Access")
            @unknown default:
                break
            }
        } else {
            debugPrint("Location services are not enabled")
            //  self.openSettings(message: kLocation)
        }
        
        /*
         AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
         
         })
         AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
         
         
         // guard accessGranted == true else { return }
         
         })
         */
    }
    //MARK: - Google login button action
    
    @IBAction func googleLoginAct(_ sender: Any)
    {
        
        if Connectivity.isConnectedToInternet {
            
            GIDSignIn.sharedInstance()?.signIn()
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    //MARK: - Facebook login button action
    
    @IBAction func facebookLoginAct(_ sender: UIButton)
    {
        
        if Connectivity.isConnectedToInternet {
            debugPrint("Connected")
            loginWithFb()
        } else {
            debugPrint("No Internet")
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    @IBAction func AppleLoginAct(_ sender: Any)
    {
        
        if Connectivity.isConnectedToInternet {
            if #available(iOS 13.0, *) {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
            
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    //MARK: - phone number login button action
    
    @IBAction func phoneLoginAct(_ sender: Any)
    {
        let vc = MobileVerificationVC.instantiate(fromAppStoryboard: .Main)
        //MobileVerificationVC ProfilePicVC AddVoiceVC DateOfBirthVC
        //  vc.countryCode = self.currentCoutryCode
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Login with facebook function
    
    func loginWithFb()
    {
        //self.showLoader()
        
        let fbSuite = FacebookLoginSuite()
        fbSuite.logout()
        fbSuite.signInWithController(controller: self, success: { (success, response) in
            debugPrint(response)
            let dict = self.parseFBData(response: response as! JSONDictionary)
            
            let socialID = dict[ApiKey.kId] as! String
            let email = dict[ApiKey.kEmail] as! String
            let birthday = dict[ApiKey.kBirthday] as? String ?? kEmptyString
            let gender = dict[ApiKey.kGender] as? String ?? kEmptyString
            let name = dict[kFBName] as? String ?? kEmptyString
            let profileImageUrl = dict[ApiKey.kImage] as? URL
            
            var data = JSONDictionary()
            data[ApiKey.kSocial_id] = socialID
            data[ApiKey.kSocial_type] = kFacebook
            data[ApiKey.kEmail] = email
            data[ApiKey.kDevicetype] = kDeviceType
            data[ApiKey.KDeviceToken] =  AppDelegate.DeviceToken
            data[ApiKey.KVoip_device_token] = AppDelegate.VOIPDeviceToken
            self.socialLoginApi(data: data, profileName: name, profileImage: profileImageUrl,profileGender:gender,profileBirthday: birthday)

            
            debugPrint("Api call here")
            
            Indicator.sharedInstance.hideIndicator()
            //self.hideLoader()
            
            
        }) { (errorReason, error) in
            debugPrint("errorReason \(errorReason) \(error)")
           // self.hideLoader()
            Indicator.sharedInstance.hideIndicator()
        }
    }
    //MARK: - check google Setup function
    
    func checkgoogleSetup()
    {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        NotificationCenter.default.addObserver(self,selector: #selector(userDidSignInGoogle(_:)),name: .signInGoogleCompleted,object: nil)
    }
    
    
    // MARK:- user Did SignIn Google  Notification
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        if let user = GIDSignIn.sharedInstance()?.currentUser
        {
            
            debugPrint(user)
            let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name ?? ""
            //  let givenName = user.profile.givenName
            // let familyName = user.profile.familyName
            let email = user.profile.email
            
            var pic:URL!
            
            if user.profile.hasImage
            {
                pic = user.profile.imageURL(withDimension: 500)
                // debugPrint(pic)
            }
            
            //debugPrint("didSignInFor user details = \(userId) \(idToken) \(givenName) \(fullName) \(familyName) \(email)")
            GIDSignIn.sharedInstance()?.signOut()
            //
            
            var data = JSONDictionary()
            data[ApiKey.kSocial_id] = userId
            data[ApiKey.kSocial_type] = kGoogle
            data[ApiKey.kEmail] = email
            data[ApiKey.kDevicetype] = kDeviceType
            data[ApiKey.KDeviceToken] = AppDelegate.DeviceToken
            data[ApiKey.KVoip_device_token] = AppDelegate.VOIPDeviceToken
            self.socialLoginApi(data: data, profileName: fullName, profileImage: pic)
            
            debugPrint("Api call here")
        }
    }
    
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator2()
        //Indicator.sharedInstance.showIndicator3(views: [self.stackLogin,self.lblContinue])

    }
    func hideLoader()
    {
       // Indicator.sharedInstance.hideIndicator3(views: [self.stackLogin,self.lblContinue])
        Indicator.sharedInstance.hideIndicator2()
    }
}


//MARK: - Custom function

extension LoginVC
{
    //MARK: - tappedOnLabel
    @objc private final func tapOnTextView(_ tapGesture: UITapGestureRecognizer){

        let point = tapGesture.location(in: self.lblContinue)
      if let detectedWord = getWordAtPosition(point)
      {
debugPrint("tap word \(detectedWord)")
          if kPrivacyPolicy.contains(detectedWord)
          {
              //MARK: - Privacy policy button action

              let vc = WebVC.instantiate(fromAppStoryboard: .Account)
                  vc.pageTitle=kPrivacyPolicy
                  vc.pageUrl=Privacy_Policy_URL
                  self.navigationController?.pushViewController(vc, animated: true)
          }
          else if  kTermOfService.contains(detectedWord)
          {
              //MARK: - Term & condition button action
              let vc = WebVC.instantiate(fromAppStoryboard: .Account)
                  vc.pageTitle=kTermOfService
                  vc.pageUrl=TERM_URL
                  self.navigationController?.pushViewController(vc, animated: true)
          }
      }
    }
    
    private final func getWordAtPosition(_ point: CGPoint) -> String?{
    if let textPosition = self.lblContinue.closestPosition(to: point)
    {
        if let range = self.lblContinue.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection(rawValue: 1))
      {
        return self.lblContinue.text(in: range)
      }
    }
    return nil
        
    }
}

//MARK: - Google facebook signin api

extension LoginVC
{
    
    func clearLocalData()
    {
        DataManager.Selected_Gender=kEmptyString
        DataManager.userNameType=kEmptyString
        
        DataManager.Selected_DateOfBirth=kEmptyString
    }
    
    func socialLoginApi(data:JSONDictionary,profileName:String,profileImage:URL?,profileGender:String=kEmptyString,profileBirthday:String=kEmptyString)
    {
        self.showLoader()
        OnBoardingVM.shared.callApiSocialLoginAPI(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                
                
                if (OnBoardingVM.shared.loginUserDetail?.profile_data?.username != nil)
                {
                    /*
                    
                    if (OnBoardingVM.shared.loginUserDetail?.more_profile_details?.bio == nil)
                    {
                        DataManager.comeFromTag=5
                        DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                        DataManager.isProfileCompelete=true
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                        DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                        DataManager.userId=OnBoardingVM.shared.loginUserDetail?.profile_data?.username ?? ""
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.profile_data?.username ?? ""
                        
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
                        self.hideLoader()
                    }
                    else
                    {
                        */
                  
                        DataManager.comeFromTag=5
                        DataManager.isEditProfile=true
                        DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                        DataManager.isProfileCompelete=true
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.name ?? ""
                        DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                        DataManager.userId=OnBoardingVM.shared.loginUserDetail?.profile_data?.username ?? ""
                        DataManager.userName=OnBoardingVM.shared.loginUserDetail?.profile_data?.username ?? ""
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
                        self.hideLoader()
                    //}
                    
                    
                    
                }
                else
                {
                    
                 
                    let vc = ProfilePicVC.instantiate(fromAppStoryboard: .Main)

                    vc.userProfile=profileImage
                    vc.userName=profileName
                    vc.userGender=profileGender
                    vc.userBirthDay=profileBirthday
                    
                    DataManager.comeFromTag=5
                    DataManager.accessToken=OnBoardingVM.shared.loginUserDetail?.authToken ?? ""
                    DataManager.Id=OnBoardingVM.shared.loginUserDetail?.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.hideLoader()
                }
                
            }
            
            
        })
    }
    
}
//MARK: - Get current location 

extension LoginVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let location = locations.first
        {
            debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
            
            self.fetchCityAndCountry(from: location) { (Country, phoneCode, error) in
                
                let code = phoneCode ?? "45"
                let country = Country ?? "Denmark"
                
                let phoneCode = self.getCountryCallingCode(countryRegionCode: code)
                
                self.currentCoutryCode = "+"+phoneCode
                DataManager.countryPhoneCode=self.currentCoutryCode
                DataManager.countryName = country
                debugPrint(self.currentCoutryCode)
                
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        debugPrint("Failed to find user's location: \(error.localizedDescription)")
    }
}


extension LoginVC:ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding
{
    
    func setupProviderLoginView()
    {
        if #available(iOS 13.0, *) {
            
            
            let appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
            appleLoginBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.viewAppleLogin.addSubview(appleLoginBtn)
            (appleLoginBtn as UIControl).cornerRadius = 15
            
            // Setup Layout Constraints to be in the center of the screen
            appleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                appleLoginBtn.centerXAnchor.constraint(equalTo: self.viewAppleLogin.centerXAnchor),
                appleLoginBtn.centerYAnchor.constraint(equalTo: self.viewAppleLogin.centerYAnchor),
                appleLoginBtn.widthAnchor.constraint(equalToConstant: viewAppleLogin.frame.width-25),
                appleLoginBtn.heightAnchor.constraint(equalToConstant: 55)
            ])
            
            
        }
    }
    
    
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            // self.showLoader()
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
    {
        return self.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        //self.hideLoader()
        debugPrint(error)
    }
    
    //Delegates
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.hideLoader()
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email ?? ""
            let fullName = appleIDCredential.fullName
            
            var name = ""
            if let fullName = fullName, let givenName = fullName.givenName, let familyName = fullName.familyName
            {
                if givenName != ""{
                    name = givenName
                }
                if familyName != ""{
                    name = name == "" ? familyName : "\(name) \(familyName)"
                }
            }
            
            //Save In Keychain
            if name != "" && email != ""{
                appleLoginData = AppleLoginData.init(userIdentifier: userIdentifier, name: name, email: email)
            }
            
            //Check User State
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                
                DispatchQueue.main.async {
                    
                    switch credentialState {
                    case .authorized:
                        
                        //                        var dict = JSONDictionary()
                        //                        dict["login_type"] = LoginType.apple.rawValue
                        //                        dict["id"] = userIdentifier.replacingOccurrences(of: ".", with: "")
                        //                        // The Apple ID credential is valid.
                        //                        if let appleLoginData = appleLoginData, appleLoginData.userIdentifier == userIdentifier{
                        //                            dict["name"] = appleLoginData.name
                        //                            dict["email"] = appleLoginData.email
                        //                        }
                        //                        dict["phone_number"] = ""
                        //                        dict["profile_pic"] = ""
                        //                        dict["password"] = ""
                        //                        self.socialLogin(dict: dict)
                        //
                        
                        var data = JSONDictionary()
                        data[ApiKey.kSocial_id] = userIdentifier.replacingOccurrences(of: ".", with: "")
                        data[ApiKey.kSocial_type] = kGoogle
                        
                        if let appleLoginData = appleLoginData, appleLoginData.userIdentifier == userIdentifier
                        {
                            data[ApiKey.kEmail] = appleLoginData.email
                        }
                        else
                        {
                            data[ApiKey.kEmail] = APP_NAME.getRandomEmail()
                        }
                        
                        data[ApiKey.kDevicetype] = kDeviceType
                        data[ApiKey.KDeviceToken] = AppDelegate.DeviceToken
                        data[ApiKey.KVoip_device_token] = AppDelegate.VOIPDeviceToken
                        debugPrint("Apple login detail \(data)")
                        var pic:URL!
                        self.socialLoginApi(data: data, profileName: appleLoginData?.name ?? kEmptyString, profileImage: pic)
                        
                        break
                    case .revoked:
                        self.openSimpleAlert(message: kAppleRevoked)
                        break
                    case .notFound:
                        self.openSimpleAlert(message: kAppleNoCredential)
                        
                        break
                    default:
                        break
                    }
                }
            }
            
        }else{
            DispatchQueue.main.async {
                self.openSimpleAlert(message: kAppleNoCredential)
            }
        }
        
    }
    
    
    @available(iOS 13.0, *)
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
