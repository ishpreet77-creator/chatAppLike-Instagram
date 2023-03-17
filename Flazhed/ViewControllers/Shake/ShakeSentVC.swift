//
//  ShakeSentVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit
import CoreLocation
import SDWebImage

protocol ButtonTapDelegate {
    func buutonName(name:String)
    
}

class ShakeSentVC: UIViewController {
    
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var lblShakeLeft: UILabel!
    @IBOutlet weak var btnGetNow: UIButton!
    @IBOutlet weak var lblShake: UILabel!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgShakeTimer: UIImageView!
    @IBOutlet weak var lblShakeSentText: UILabel!
    @IBOutlet weak var btnCancelShake: UIButton!
    
    let locationmanager = CLLocationManager()
    var delegate:ButtonTapDelegate?
    var count = 4.5
    var gameTimer: Timer?
    var Shaketimer = Timer()
    var comeFrom = ""
    var shakeStart = Date()
    var timerCount:TimeInterval = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Indicator.sharedInstance.hideIndicator()
        
        // Do any additional setup after loading the view.
        circularProgressView.trackClr = .white
        circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
        lblCounter.isHidden=true
        
        self.becomeFirstResponder()
        self.imgShakeTimer.loadingGif(gifName: "shake_timer")
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.btnGetNow.underline()
        //self.callShakeApi()
        if Connectivity.isConnectedToInternet {
            Indicator.sharedInstance.showIndicator2()
            self.callApiTogetShakeCount()
        } else {
            Indicator.sharedInstance.hideIndicator2()
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
        
        lblCounter.text = "3"
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //locationmanager.startMonitoringSignificantLocationChanges()
        circularProgressView.setProgressWithAnimation(duration: 0, value: 0)
        if self.comeFrom != "Home"
        {
            lblCounter.isHidden=true
            lblCounter.text = "3"
            
            circularProgressView.setProgressWithAnimation(duration: timerCount, value:1)
            gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        else
        {
            self.lblShake.text = "Please shake mobile to send a shake."
        }
        self.showTime()
        self.lblCounter.isHidden=true
        self.circularProgressView.isHidden=true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        debugPrint(#function)
        self.Shaketimer.invalidate()
        self.gameTimer?.invalidate()
        self.stopGif()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("********** MEMORY WARNING **********")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    //MARK: - Setup UI method
    
    func setUpUI()
    {
        
        self.lblShakeSentText.text = kShakeSent
        self.lblShakeLeft.text = kShakesLeft
        self.btnGetNow.setTitle(kGetMore, for: .normal)
        self.btnCancelShake.setTitle(kCANCELSHAKE, for: .normal)
    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
            
        }
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        let date = Date()
        debugPrint("Device shaken, Cancel \(motion) \(date)")
        
        
        if Connectivity.isConnectedToInternet {
            if self.shakeStart  != nil
            {
                let timeInterval = Int(date.timeIntervalSince(self.shakeStart))
                
                debugPrint(timeInterval)
                if timeInterval>1
                {
                    UIDevice.vibrate()
                    UIDevice.vibrate()
                    self.lblCounter.isHidden=true
                    self.imgShakeTimer.loadingGif(gifName: "shake_timer")
                    debugPrint("Device shaken, shake timer started")
                    lblCounter.text = "3"
                    circularProgressView.setProgressWithAnimation(duration: timerCount, value:1)
                    gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    
                }
                
            }
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if Connectivity.isConnectedToInternet {
            if motion == .motionShake
            {
                
                self.shakeStart = Date()
                debugPrint("Device shaken = \(motion) \(self.shakeStart)")
                
            }
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        
        if Connectivity.isConnectedToInternet {
            if motion == .motionShake {
                let date = Date()
                debugPrint("Device shake stop, shake timer stopeed = \(motion) \(date)")
                
                if self.shakeStart != nil
                {
                    let timeInterval = Int(date.timeIntervalSince(self.shakeStart))
                    
                    debugPrint(timeInterval)
                    if timeInterval>=1
                    {
                        self.imgShakeTimer.loadingGif(gifName: "shake_timer")
                        UIDevice.vibrate()
                        self.lblCounter.isHidden=true
                        debugPrint("Device shaken, shake timer started")
                        lblCounter.text = "3"
                        circularProgressView.setProgressWithAnimation(duration: timerCount, value:1)
                        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    }
                    
                }
                
            }
        }
        else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    @objc func turnOffAlarm() {
        if Connectivity.isConnectedToInternet {
            
            debugPrint("Alarm off")
            self.lblShake.text = "Shake Sent."
            UIDevice.vibrate()
            
            self.callShakeApi()
            gameTimer?.invalidate()
            Shaketimer.invalidate()
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    @objc func update() {
        
        lblCounter.isHidden=true
        debugPrint("update count 1 \(count)")
        if(count > 0)
        {
            if count <= 1.0
            {
                if self.comeFrom == "Home"
                {
                    UIDevice.vibrate()
                }
                self.stopGif()
                if Connectivity.isConnectedToInternet {
                    
                    self.showTime()
                    self.Shaketimer.invalidate()
                    self.gameTimer?.invalidate()
                    self.count = -1
                    self.lblShake.text = "Shake Sent."
                    self.callShakeApi()
                   
                } else {
                    self.lblShake.text = "Please shake mobile to send a shake."
                    self.Shaketimer.invalidate()
                    self.gameTimer?.invalidate()
                    self.circularProgressView.setProgressWithAnimation(duration: 0, value: 0)
                    lblCounter.text = kEmptyString
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    self.stopGif()
                }
            }
            else
            {
                count = count-0.5
            }
            
            /*
            if count == 3 ||  count == 4 ||  count == 5
            {
                //circularProgressView.setProgressWithAnimation(duration: 1, value: 0.50)
                lblCounter.text = "2"
                count = count-0.5
            }
            else if count == 2
            {
                //circularProgressView.setProgressWithAnimation(duration: 1, value: 0.50)
                lblCounter.text = "1"
                count = count-0.5
            }
            else
            {
                // circularProgressView.setProgressWithAnimation(duration: 1, value: 1)
                lblCounter.text = "0"
                debugPrint("count 1 \(count)")
                if self.comeFrom == "Home"
                {
                    UIDevice.vibrate()
                }
                self.stopGif()
                if Connectivity.isConnectedToInternet {
                    
                    self.showTime()
                    self.Shaketimer.invalidate()
                    self.gameTimer?.invalidate()
                    self.count = -1
                    self.lblShake.text = "Shake Sent."
                    self.callShakeApi()
                   
                } else {
                    self.lblShake.text = "Please shake mobile to send a shake."
                    self.Shaketimer.invalidate()
                    self.gameTimer?.invalidate()
                    self.circularProgressView.setProgressWithAnimation(duration: 0, value: 0)
                    lblCounter.text = kEmptyString
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    self.stopGif()
                }
            
                
                //
                
            }
             */
            //}
            
        }
        else
        {
            debugPrint("count 2 \(count)")
            lblCounter.text = "0"
            self.gameTimer?.invalidate()
            self.imgShakeTimer.image = nil
            self.stopGif()
        }
        
    }
    
    func showTime()
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = date.dateFormatWithSuffix()
        let currentTime = dateFormatter.string(from: date)
        debugPrint(currentTime)
        
        
        let dateFormatter2 = DateFormatter()
        
        dateFormatter2.dateFormat = "hh:mm a"
        let currentTime2 = dateFormatter2.string(from: date)
        
        // Output for current date: 22nd May 2019
        let time = currentTime2 + " on " + currentTime
        self.lblTime.text = time
        
    }
    
    
    func callShakeApi()
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        
        if Connectivity.isConnectedToInternet {
            Indicator.sharedInstance.showIndicator2()
            self.callApiForShakeSent(data: data)
        } else {
            Indicator.sharedInstance.hideIndicator2()
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    @IBAction func getNowAct(_ sender: UIButton)
    {
        self.stopGif()
        let destVC = NewPremiumVC.instantiate(fromAppStoryboard: .Account)
        destVC.type = .Shake
        destVC.subscription_type=kShake
        destVC.popupShowIndex=3
        destVC.delegate=self
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        if let tab = self.tabBarController
        {
            tab.present(destVC, animated: true, completion: nil)
        }
        else
        {
            self.present(destVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func shakeCountAct(_ sender: UIButton)
    {
        delegate?.buutonName(name: "count")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shakeCancelAct(_ sender: UIButton)
    {
        self.gameTimer?.invalidate()
        self.Shaketimer.invalidate()
        self.stopGif()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func stopGif()
    {
        self.imgShakeTimer.image=UIImage(named: "tick_bg")
        self.imgShakeTimer.image = nil
    }
    
    
}
// MARK: - Extension Api Calls
extension ShakeSentVC
{
    func callApiForShakeSent(data:JSONDictionary)
    {
       
        self.stopGif()
        HomeVM.shared.callApiShakeSent(data: data, response: { (message, error) in
            
            if error != nil
            {
                DataManager.HomeRefresh=false
                Indicator.sharedInstance.hideIndicator2()
                self.showErrorMessage(error: error)
            }
            else{
                Indicator.sharedInstance.hideIndicator2()
                DataManager.HomeRefresh=true
                DataManager.comeFromTag=4
                self.gameTimer?.invalidate()
                self.Shaketimer.invalidate()
                self.dismiss(animated: false) {
                    if #available(iOS 13.0, *) {
                        
                        SCENEDEL?.navigateToHome(selectedIndex: 2)
                    } else {
                        
                        APPDEL.navigateToHome(selectedIndex: 2)
                    }
                    
                }
                
            }
            
            
        })
    }
    
    func showErrorMessage(error: Error?) {
        
        let message = (error! as NSError).userInfo[ApiKey.kMessage] as? String ?? kSomethingWentWrong
        
        //ok button action
        let code = (error! as NSError).code
        
        debugPrint("error code = \(code)")
        if  code == 401
        {
            self.count = 3
            
            let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
            destVC.type = .BlockReportError
            destVC.user_name=message
            destVC.errorCode=code
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
        }
        else if code == 408
        {
            let message = (error! as NSError).userInfo[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
            self.count = 3
            self.lblShake.text = "Please shake mobile to send a shake."
            self.Shaketimer.invalidate()
            self.gameTimer?.invalidate()
            self.circularProgressView.setProgressWithAnimation(duration: 0, value: 0)
            self.lblCounter.text = kEmptyString
            
            
            vc.comeFrom = kRunningOut
            vc.message=message
            vc.messageTitle=kDailyShakes
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
        else if  code == 406
        {
            self.count = 3
            
            
            let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
            
            destVC.type = .BlockReportError
            destVC.user_name=message
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
        }
        
        
        else
        {
            
            let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
            
            destVC.type = .BlockReportError
            destVC.user_name=message
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
        }
        
    }
    
    func callApiTogetShakeCount()
    {
        HomeVM.shared.callApiTogetShakeCount(response: { (message, error) in
            
            if error != nil
            {
                DataManager.HomeRefresh=false
                Indicator.sharedInstance.hideIndicator2()
                self.showErrorMessage(error: error)
            }
            else{
                let totalShakeLeft = HomeVM.shared.userShakeCountDetail?.totalShakeLeft ?? 0
               // if totalShakeLeft>1
               // {
                    self.lblShakeLeft.text = "\(totalShakeLeft) " + kShakesLeft
//                }
//               else
//               {
//                   self.lblShakeLeft.text = "\(totalShakeLeft) " + kShakeLeft
//               }
                Indicator.sharedInstance.hideIndicator2()
            }
        })
    }
}
//MARK: - Get current location

extension ShakeSentVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        debugPrint("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension ShakeSentVC:deleteAccountDelegate,paymentScreenOpenFrom
{
    func deleteAccountFunc(name: String) {
        
        debugPrint("deleteAccountFunc \(name)")
        if name.equalsIgnoreCase(string: kRunningOut)
        {
            
            let destVC = NewPremiumVC.instantiate(fromAppStoryboard: .Account)
            destVC.type = .Hangout
            destVC.subscription_type=kHangout
            destVC.popupShowIndex=3
            destVC.delegate=self
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
            
        }
        else
        {
            self.gameTimer?.invalidate()
            self.Shaketimer.invalidate()
            self.dismiss(animated: false) {
                if #available(iOS 13.0, *) {
                    
                    SCENEDEL?.navigateToHome(selectedIndex: 2)
                } else {
                    
                    APPDEL.navigateToHome(selectedIndex: 2)
                }
                
            }

        }
    }
    
    func FromScreenName(name: String, ActiveDay: Int) {
        
        
        if name.contains(kShake)
        {
            self.stopGif()
            debugPrint("Premium delegate call after perchanse api call \(name) \(ActiveDay)")
            self.callShakeApi()
        }
        
    }
    
    
}
