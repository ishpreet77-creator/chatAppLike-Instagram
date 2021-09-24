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

class ShakeSentVC: UIViewController {

    @IBOutlet weak var lblShake: UILabel!
    var delegate:ButtonTapDelegate?
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var lblCounter: UILabel!
    var gameTimer: Timer?
    var Shaketimer = Timer()
    @IBOutlet weak var lblTime: UILabel!
    let locationmanager = CLLocationManager()

    var count = 3
    
    var comeFrom = ""
    var shakeStart = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        Indicator.sharedInstance.hideIndicator()
        
        // Do any additional setup after loading the view.
        circularProgressView.trackClr = .white
        circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
        lblCounter.isHidden=true
        
        self.becomeFirstResponder()
      
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblCounter.text = "3"
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //locationmanager.startMonitoringSignificantLocationChanges()
        circularProgressView.setProgressWithAnimation(duration: 0, value: 0)
        if self.comeFrom != "Home"
        {
            lblCounter.isHidden=false
            lblCounter.text = "3"
            
            circularProgressView.setProgressWithAnimation(duration: 3, value:1)
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        else
        {
            self.lblShake.text = "Please shake mobile to send a shake."
        }
        self.showTime()
    //self.openSimpleAlert(message: "Shake your phone.")
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
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {

        let date = Date()
      print("Device shaken, Cancel \(motion) \(date)")
        if self.shakeStart  != nil
        {
            let timeInterval = Int(date.timeIntervalSince(self.shakeStart))
        
            print(timeInterval)
            if timeInterval>1
            {
                UIDevice.vibrate()
                UIDevice.vibrate()
                self.lblCounter.isHidden=false
                print("Device shaken, shake timer started")
                circularProgressView.setProgressWithAnimation(duration: 3, value:1)
                gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                
            }

         }
        
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake
        {
           
            self.shakeStart = Date()
            print("Device shaken = \(motion) \(self.shakeStart)")
      
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       
        
          
            if motion == .motionShake {
              let date = Date()
                print("Device shake stop, shake timer stopeed = \(motion) \(date)")
            
                if self.shakeStart != nil
                {
                 let timeInterval = Int(date.timeIntervalSince(self.shakeStart))
                
                    print(timeInterval)
                    if timeInterval>=1
                    {
                        UIDevice.vibrate()
                        self.lblCounter.isHidden=false
                        print("Device shaken, shake timer started")
                        circularProgressView.setProgressWithAnimation(duration: 3, value:1)
                        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    }

                 }

        }
    }

    @objc func turnOffAlarm() {
        print("Alarm off")
        self.lblShake.text = "Shake Sent."
        UIDevice.vibrate()
        
        self.callShakeApi()
        gameTimer?.invalidate()
        Shaketimer.invalidate()
    }
    
    
    @objc func update() {
        if(count > 0)
        {
 
                if count == 3
                {
                    //circularProgressView.setProgressWithAnimation(duration: 1, value: 0.50)
                    lblCounter.text = "2"
                    count = count-1
                }
            else if count == 2
            {
                //circularProgressView.setProgressWithAnimation(duration: 1, value: 0.50)
                lblCounter.text = "1"
                count = count-1
            }
                else
                {
                   // circularProgressView.setProgressWithAnimation(duration: 1, value: 1)
                    lblCounter.text = "0"
                    if self.comeFrom == "Home"
                    {
                    UIDevice.vibrate()
                    }
                    
                   
//                    let date = Date()
//                    let dateFormatter = DateFormatter()
//
//                    dateFormatter.dateFormat = date.dateFormatWithSuffix()
//                    let currentTime = dateFormatter.string(from: date)
//                    print(currentTime)
//
//
//                    let dateFormatter2 = DateFormatter()
//
//                    dateFormatter2.dateFormat = "hh:mm:a"
//                    let currentTime2 = dateFormatter2.string(from: date)
//
//                    // Output for current date: 22nd May 2019
//                    let time = currentTime2 + " on " + currentTime
//                    self.lblTime.text = time
//
                    self.showTime()
                    self.Shaketimer.invalidate()
                    self.gameTimer?.invalidate()
                    self.count = -1
                    self.lblShake.text = "Shake Sent."
                    self.callShakeApi()
                }
               
            //}
            
        }
        else
        {
            lblCounter.text = "0"
            self.gameTimer?.invalidate()
        }
    }
    
    func showTime()
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = date.dateFormatWithSuffix()
        let currentTime = dateFormatter.string(from: date)
        print(currentTime)
        
    
        let dateFormatter2 = DateFormatter()
        
        dateFormatter2.dateFormat = "hh:mm a"
        let currentTime2 = dateFormatter2.string(from: date)
        
        // Output for current date: 22nd May 2019
        let time = currentTime2 + " on " + currentTime
        self.lblTime.text = time
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print(#function)
        self.Shaketimer.invalidate()
        self.gameTimer?.invalidate()
    }
    
    func callShakeApi()
    {
        var data = JSONDictionary()

        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
            
            if Connectivity.isConnectedToInternet {
              
                self.callApiForShakeSent(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
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
      // self.navigationController?.popViewController(animated: true)
    
//        if #available(iOS 13.0, *) {
//            SCENEDEL?.navigateToHome()
//        } else {
//            // Fallback on earlier versions
//            APPDEL.navigateToHome()
//        }
        
        /*
        
        if  DataManager.comeFromPage==0
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToHangout()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToHangout()
            }
        }
       else if  DataManager.comeFromPage==1
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToStories()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToStories()
            }
        }
       else if  DataManager.comeFromPage==2
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToHome()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToHome()
            }
        }
       else if  DataManager.comeFromPage==3
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToChat()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToChat()
            }
        }
       else if  DataManager.comeFromPage==4
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
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToHome()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToHome()
            }
        }
        
       */
        
        self.dismiss(animated: false, completion: nil)
        
        
    }


}
// MARK:- Extension Api Calls
extension ShakeSentVC
{
    func callApiForShakeSent(data:JSONDictionary)
    {
        HomeVM.shared.callApiShakeSent(data: data, response: { (message, error) in
            
            if error != nil
            {                
               
              self.showErrorMessage(error: error)
            }
            else{
                
                DataManager.comeFromTag=4
                self.gameTimer?.invalidate()
                self.Shaketimer.invalidate()
                self.dismiss(animated: false) {
                    if #available(iOS 13.0, *) {
                        
                        SCENEDEL?.navigateToHome()
                    } else {
                      
                        APPDEL.navigateToHome()
                    }

                }
   
            }

         
        })
    }
    
    func showErrorMessage(error: Error?) {
     
        let message = (error! as NSError).userInfo[ApiKey.kMessage] as? String ?? kSomethingWentWrong
        
            //ok button action
            let code = (error! as NSError).code
        
        print("error code = \(code)")
            if  code == 401
            {
//                self.openAlert(title: kAlert,
//                                         message: message,
//                                         alertStyle: .alert,
//                                         actionTitles: ["Ok"],
//                                         actionStyles: [.default, .default],
//                                         actions: [
//
//                                           { [self]_ in
//
//                                               print("okay click")
//                                            self.dismiss(animated: false) {
//                                                DataManager.ShakeId=""
//                                                if #available(iOS 13.0, *) {
//                                                    DataManager.comeFrom = ""
//                                                    DataManager.isProfileCompelete = false
//                                                     DataManager.accessToken = ""
//                                                    SCENEDEL?.navigateToLogin()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    DataManager.comeFrom = ""
//                                                    DataManager.isProfileCompelete = false
//                                                     DataManager.accessToken = ""
//                                                    APPDEL.navigateToLogin()
//                                                }
//
//                                            }
//
//
//                                             }
//                                        ])
                self.count = 3
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.errorCode=code
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
        
            }
            else if  code == 406
            {
//                self.gameTimer?.invalidate()
//                self.Shaketimer.invalidate()
                
               // self.navigationController?.popViewController(animated: true)
                self.count = 3
             
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
                
                
                
//                self.openAlert(title: kAlert,
//                                         message: message,
//                                         alertStyle: .alert,
//                                         actionTitles: ["Ok"],
//                                         actionStyles: [.default, .default],
//                                         actions: [
//
//                                           { [self]_ in
//
//                                            self.dismiss(animated: false, completion: nil)
//                                            /*
//                                            if  DataManager.comeFromPage==0
//                                            {
//                                                if #available(iOS 13.0, *) {
//                                                    SCENEDEL?.navigateToHangout()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    APPDEL.navigateToHangout()
//                                                }
//                                            }
//                                           else if  DataManager.comeFromPage==1
//                                            {
//                                                if #available(iOS 13.0, *) {
//                                                    SCENEDEL?.navigateToStories()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    APPDEL.navigateToStories()
//                                                }
//                                            }
//                                           else if  DataManager.comeFromPage==2
//                                            {
//                                                if #available(iOS 13.0, *) {
//                                                    SCENEDEL?.navigateToHome()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    APPDEL.navigateToHome()
//                                                }
//                                            }
//                                           else if  DataManager.comeFromPage==3
//                                            {
//                                                if #available(iOS 13.0, *) {
//                                                    SCENEDEL?.navigateToChat()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    APPDEL.navigateToChat()
//                                                }
//                                            }
//                                           else if  DataManager.comeFromPage==4
//                                            {
//                                                if #available(iOS 13.0, *) {
//                                                    SCENEDEL?.navigateToProfile()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    APPDEL.navigateToProfile()
//                                                }
//                                            }
//                                           else
//                                            {
//                                                if #available(iOS 13.0, *) {
//                                                    SCENEDEL?.navigateToHome()
//                                                } else {
//                                                    // Fallback on earlier versions
//                                                    APPDEL.navigateToHome()
//                                                }
//                                            }
//
//                                            */
//
//                                             }
//                                        ])
            }
           else
            {
                
               // self.openSimpleAlert(message: message)
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
               
            }
        
    }
}
//MARK:- Get current location

extension ShakeSentVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            print("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
