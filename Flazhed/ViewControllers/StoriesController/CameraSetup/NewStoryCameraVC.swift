//
//  NewStoryCameraVC.swift
//  Flazhed
//
//  Created by ios2 on 11/10/21.
//

import UIKit
import AVFoundation
import SDWebImage
import AVKit
import Photos
import SkeletonView

class NewStoryCameraVC:UIViewController
{
    
    @IBOutlet weak var takenImage: UIImageView!
    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var cameraButton    : CameraCustomButton!
    @IBOutlet weak var flipCameraButton : UIButton!
    //@IBOutlet weak var aboveButton : UIButton!
    @IBOutlet weak var flashButton      : UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    private var innerCircle: UIView!
    @IBOutlet weak var viewCamera      : UIView!
    var selectedIndex = 2
    private var circleBorder: CALayer!
    var isPosted=false
    var isShareOpen=false
    var fromGetMorePopup=false
    var videoRecordingStarted: Bool = false {
        didSet{
            if videoRecordingStarted {
                self.cameraButton.backgroundColor = UIColor.red
            } else {
                self.cameraButton.backgroundColor = UIColor.white
            }
        }
    }
    var cameraConfig: CameraConfiguration!
    let circleView = CircleView(frame: CGRect.zero)
    var timer:Timer?
    
    var duration = 0
    var counter = 3
    var video_length = 7
    var takeImages = false
    var videoUrl:URL?
    var isPermissionAllow=false
    var currentSubscriptionType=kBasicFree
    
    var total_posted_image_count = 0
    var total_posted_video_count = 0
    
    var total_eligible_image_count = 0
    var total_eligible_video_count = 0
    
    override func viewDidLoad() {
        self.isShareOpen=false
        super.viewDidLoad()
        self.cameraButton.isHidden=true
        self.viewCamera.isUserInteractionEnabled=false
        
        self.flipCameraButton.isUserInteractionEnabled=false
        self.flashButton.isUserInteractionEnabled=false
        
        self.lblTimer.isHidden=true
        
        self.heightConst.constant = NAVIHEIGHT
        self.topConst.constant = STATUSBARHEIGHT
        
        self.cameraConfig = CameraConfiguration()
        
        self.checkPermission(completion: {
            self.cameraConfig.setup { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else
                {
                    self.viewCamera.isUserInteractionEnabled=true
                }
                
                try? self.cameraConfig.displayPreview(self.imgPost)
                self.setupUI()
            }
        })
        
        
        if Connectivity.isConnectedToInternet {
            var data = JSONDictionary()
            data[ApiKey.kTimezone] = TIMEZONE
            
            self.get_post_limit_api(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    func setupUI()
    {
        self.setupCirle()
        registerNotification()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedCamera))
        self.viewCamera.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedCamera))
        self.viewCamera.addGestureRecognizer(longPressRecognizer)
        
        cameraConfig.flashMode = .auto
        self.flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: .normal)
        self.viewCamera.isUserInteractionEnabled=true
        self.flipCameraButton.isUserInteractionEnabled=true
        self.flashButton.isUserInteractionEnabled=true
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.isPosted=false
        if !self.isPermissionAllow
        {
            self.checkPermission(completion: {
            })
            
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.timer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.notDetermined || status == PHAuthorizationStatus.restricted) {
            debugPrint("Access has been denied.")
            DispatchQueue.main.async {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        
                    }
                    
                    else {
                        
                    }
                })
            }
        }
        
        
        
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            DispatchQueue.main.async {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        
                    }
                    
                    else {
                        
                    }
                })
            }
        }
    }
    
    
    @IBAction func backBtnAct(_ sender: UIButton)
    {
        self.backGo()
    }
    
    
    
    //MARK: - To Make video
    
    @objc func longPressedCamera(_ sender: UILongPressGestureRecognizer)
    {
        debugPrint("long gestore")
        debugPrint(self.total_posted_video_count)
        debugPrint(self.total_eligible_video_count)
        
        if self.total_posted_video_count>=self.total_eligible_video_count//self.currentSubscriptionType.equalsIgnoreCase(string: kBasicFree)
        {
            self.showNewErrorMessage()
        }
        else
        {
            
            if self.isPermissionAllow
            {
                if sender.state == .began
                {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.viewCamera.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }) { (finished) in
                        UIView.animate(withDuration: TimeInterval(self.video_length), animations: {
                            self.viewCamera.transform = CGAffineTransform.identity
                        })
                    }
                    
                    debugPrint("Start recording")
                    self.counter = self.video_length
                    if  self.counter ==  self.video_length
                    {
                        self.setupCirle()
                        self.circleView.animateCircle(duration:  TimeInterval(self.video_length))
                        
                        
                        if self.cameraConfig.flashMode == .on
                        {
                            self.toggleTorch(on: true)
                        }
                        else
                        {
                            self.toggleTorch(on: false)
                        }
                        
                        if self.video_length>9
                        {
                            self.lblTimer.text = "00:"+"\(self.video_length)"
                        }
                        else
                        {
                            self.lblTimer.text = "00:0"+"\(self.video_length)"
                        }
                        
                        self.lblTimer.isHidden=false
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
                    }
                    
                    debugPrint("videoRecordingStarted \(self.videoRecordingStarted)")
                    self.cameraConfig.stopRecording { (error) in
                        
                    }
                    self.cameraConfig.recordVideo { (url, error) in
                        guard let url = url else {
                            debugPrint("Video recording error 2= \(String(describing: error))")
                            return
                        }
                        debugPrint("Video url =\(url.path)")
                        self.videoUrl  = url
                        self.finshRecording()
                    }
                    
                    
                }
                else if sender.state == .ended
                {
                    self.viewCamera.layer.removeAllAnimations()
                    
                    self.counter =  self.video_length
                    self.cameraConfig.stopRecording { (error) in
                        
                    }
                    
                }
                
            }
            else
            {
                //self.openSettings()
                
                self.checkPermission(completion: {
                })
            }
        }
    }
    //MARK: - To click image
    
    @objc func tappedCamera(sender: UITapGestureRecognizer)
    {
        if !Connectivity.isConnectedToInternet
        {
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            
        }
        else
        {
            debugPrint("Tap gestore")
            debugPrint(self.total_posted_image_count)
            debugPrint(self.total_eligible_image_count)
            
            if self.total_posted_image_count>=self.total_eligible_image_count//self.currentSubscriptionType.equalsIgnoreCase(string: kBasicFree)
            {
                self.showNewErrorMessage(type: kStoryImage)
            }
            else
            {
                //debugPrint("Photo click")
                if self.isPermissionAllow
                {
                    if self.takeImages == false
                    {
                        self.toggleTorch(on: false)
                        self.takeImages =  true
                        
                        if self.cameraConfig.outputType == .photo {
                            self.cameraConfig.captureImage { (image, error) in
                                guard let image2 = image else {
                                    self.takeImages =  false
                                    print(error ?? "Image capture error")
                                    return
                                }
                                self.takenImage.isHidden=false
                                
                                print("Image capture error \(image2)")
                                
                                //                    AudioServicesPlaySystemSound(1108);
                                //                    if #available(iOS 9.0, *) {
                                //                            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
                                //                        } else {
                                //                            AudioServicesPlaySystemSound(1108)
                                //                        }
                                
                                
                                self.takenImage.image = image2
                                self.showImageCheckLoader(vc: self)
                                var dataImage = Data()
                                var image:UIImage!
                                //   debugPrint("Take images = \(image)")
                                
                                image = image2
                                
                                let dataImage1 =  image.jpegData(compressionQuality: 1) ?? Data()
                                let imageSize1: Int = dataImage1.count
                                let size = Double(imageSize1) / 1000.0
                                //var  dataImage = Data()
                                /*
                                 if size>1500
                                 {
                                 dataImage =  image.jpegData(compressionQuality: 0.03) ?? Data()
                                 }
                                 else if size>1000
                                 {
                                 dataImage =  image.jpegData(compressionQuality: 0.04) ?? Data()
                                 }
                                 
                                 else if size>500
                                 {
                                 dataImage =  image.jpegData(compressionQuality: 0.05) ?? Data()
                                 }
                                 else if size>100
                                 {
                                 dataImage =  image.jpegData(compressionQuality: 0.2) ?? Data()
                                 }
                                 else if size>50
                                 {
                                 dataImage =  image.jpegData(compressionQuality: 0.5) ?? Data()
                                 }
                                 else
                                 {
                                 dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
                                 }
                                 */
                                
                                
                                if size>500
                                {
                                    dataImage =  image.jpegData(compressionQuality: kImageCompressGreaterThan500) ?? Data()
                                }
                                else
                                {
                                    dataImage =  image.jpegData(compressionQuality: kImageCompressLessThan500) ?? Data()
                                }
                                
                                APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
                                    
                                    (responseDict) in
                                    debugPrint("responseDict = \(responseDict)")
                                    let data =   self.parseImageCheckData(response: responseDict)
                                    if  kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")
                                    {
                                        let weapon = data?.weapon ?? 0.0
                                        let drugs = data?.drugs ?? 0.0
                                        let partial = data?.nudity?.partial ?? 0.0
                                        if weapon>kNudityCheck || drugs>kNudityCheck || partial>kNudityCheck
                                        {
                                            self.takenImage.isHidden=true
                                            self.takeImages =  false
                                            self.dismiss(animated: true, completion: nil)
                                            
                                            self.dismiss(animated: true)
                                            {
                                                self.takenImage.isHidden=true
                                                self.takeImages =  false
                                                self.openSimpleAlert(message: kImageCkeckAlert)
                                                
                                            }
                                            
                                        }
                                        /*
                                         if data?.weapon ?? 0.0 > kNudityCheck
                                         {
                                         
                                         self.dismiss(animated: true) {
                                         self.takenImage.isHidden=true
                                         self.takeImages =  false
                                         self.openSimpleAlert(message: kImageCkeckAlert)
                                         
                                         }
                                         
                                         }
                                         //                     else if  data?.alcohol ?? 0.0 > kNudityCheck
                                         //                     {
                                         //  self.dismiss(animated: true) {
                                         // self.openSimpleAlert(message: kImageCkeckAlert)
                                         
                                         //}//                     }
                                         else if  data?.drugs ?? 0.0 > kNudityCheck
                                         {
                                         self.takenImage.isHidden=true
                                         self.takeImages =  false
                                         self.dismiss(animated: true, completion: nil)
                                         
                                         self.dismiss(animated: true) {
                                         self.takenImage.isHidden=true
                                         self.takeImages =  false
                                         self.openSimpleAlert(message: kImageCkeckAlert)
                                         
                                         }
                                         
                                         }
                                         else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
                                         {
                                         self.dismiss(animated: true, completion: nil)
                                         
                                         self.dismiss(animated: true) {
                                         self.takeImages =  false
                                         self.takenImage.isHidden=true
                                         self.openSimpleAlert(message: kImageCkeckAlert)
                                         
                                         
                                         }
                                         
                                         }
                                         */
                                        else
                                        {
                                            self.dismiss(animated: true)
                                            {
                                                self.takeImages =  false
                                                self.takenImage.isHidden=true
                                                self.takeImages=true
                                                
                                                
                                                let vc = ShareStoryVC.instantiate(fromAppStoryboard: .Stories)
                                                
                                                self.isPosted=true
                                                self.isShareOpen=true
                                                vc.img = image
                                                vc.dataImage1=dataImage
                                                vc.selectedIndex=self.selectedIndex
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                                            }
                                        }
                                        
                                    }
                                    else
                                    {
                                        
                                        let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                                        
                                        if  data?.error?.message != ""
                                        {
                                            self.dismiss(animated: true)
                                            {
                                                self.takeImages =  false
                                                self.takenImage.isHidden=true
                                                self.openSimpleAlert(message:  data?.error?.message)
                                            }
                                        }
                                        else
                                        {
                                            self.dismiss(animated: true)
                                            {
                                                self.takeImages =  false
                                                self.takenImage.isHidden=true
                                                self.openSimpleAlert(message: message)
                                            }
                                        }
                                    }
                                    
                                    
                                    
                                },  failureCallback: { (errorReason, error) in
                                    self.dismiss(animated: true, completion: nil)
                                    self.takeImages =  false
                                    self.takenImage.isHidden=true
                                    self.openSimpleAlert(message: errorReason?.localizedDescription)
                                    debugPrint(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                                    
                                })
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                        }
                    }
                    
                }
                else
                {
                    self.takenImage.isHidden=true
                    //self.openSettings()
                    self.checkPermission(completion: {
                    })
                }
                
            }
        }
        
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        if self.isPermissionAllow
        {
            if self.cameraConfig.flashMode == .on
            {
                self.cameraConfig.flashMode = .off
                self.flashButton.setImage(#imageLiteral(resourceName: "flashOutline-1"), for: .normal)
            }
            else if self.cameraConfig.flashMode == .off
            {
                self.cameraConfig.flashMode = .on
                self.flashButton.setImage(#imageLiteral(resourceName: "flash"), for: .normal)
            }
            else if self.cameraConfig.flashMode == .auto
            {
                self.cameraConfig.flashMode = .off
                self.flashButton.setImage(#imageLiteral(resourceName: "flashOutline-1"), for: .normal)
            }
            else
            {
                self.cameraConfig.flashMode = .auto
                self.flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: .normal)
            }
        }
        else
        {
            
            //self.openSettings()
            
            self.checkPermission(completion: {
            })
        }
        
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        checkPermission(completion: {
            do {
                try self.cameraConfig.switchCameras()
            } catch {
                print(error.localizedDescription)
            }}
        )
    }
    
    func openSettings(message:String = kSettingMessage)
    {
        DispatchQueue.main.async {
            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
            vc.comeFrom = kSetting
            vc.messageType=message
            self.fromGetMorePopup=false
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
        // }
        
    }
    
    
    
    
    
    func checkPermission(completion: @escaping ()->Void) {
        
        
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            
            
        })
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            
            if (AVCaptureDevice.authorizationStatus(for: .audio) != .authorized)  && !accessGranted
            {
                self.isPermissionAllow=false
                self.openSettings(message: PermissonType.kMicrophoneCamera)
            }
            else if  (AVCaptureDevice.authorizationStatus(for: .audio) == .authorized) && !accessGranted
            {
                self.isPermissionAllow=false
                self.openSettings(message: PermissonType.kCameraEnable)
            }
            else if  (AVCaptureDevice.authorizationStatus(for: .audio) != .authorized) && accessGranted
            {
                self.isPermissionAllow=false
                self.openSettings(message: PermissonType.kMicrophoneEnable)
            }
            else if (AVCaptureDevice.authorizationStatus(for: .audio) == .authorized) && accessGranted
            {
                self.isPermissionAllow=true
                debugPrint("Permission allow")
                completion()
            }
            
            //            if (AVCaptureDevice.authorizationStatus(for: .audio) == .authorized) && accessGranted
            //            {
            //                self.isPermissionAllow=true
            //                debugPrint("Permission allow")
            //                completion()
            //            }
            //            else
            //            {
            //                self.isPermissionAllow=false
            //                self.openSettings(message: <#T##String#>)
            //                debugPrint("Permission not allow")
            //            }
            
            // guard accessGranted == true else { return }
            
        })
        
        /*
         let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
         switch photoAuthorizationStatus {
         case .authorized:
         debugPrint("Access is granted by user")
         completion()
         case .notDetermined:
         PHPhotoLibrary.requestAuthorization({
         (newStatus) in
         debugPrint("status is \(newStatus)")
         if newStatus ==  PHAuthorizationStatus.authorized {
         /* do stuff here */
         completion()
         print("success")
         }
         })
         debugPrint("It is not determined until now")
         self.openSettings(message: kSettingMessage)
         case .restricted:
         // same same
         debugPrint("User do not have access to photo album.")
         self.openSettings(message: kSettingMessage)
         case .denied:
         // same same
         debugPrint("User has denied the permission.")
         self.openSettings(message: kSettingMessage)
         case .limited:
         debugPrint("User has denied the permission.")
         self.openSettings(message: kSettingMessage)
         
         }
         
         */
    }
    
    fileprivate func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name(rawValue: "App is going background"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if videoRecordingStarted {
            videoRecordingStarted = false
            self.cameraConfig.stopRecording { (error) in
                print(error ?? "Video recording error")
            }
        }
    }
    
    @objc func appCameToForeground() {
        print("app enters foreground")
    }
    
    func setupCirle()
    {
        
        self.viewCamera.addSubview(self.circleView)
        self.circleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.circleView.centerXAnchor.constraint(equalTo: self.viewCamera.centerXAnchor).isActive = true
        self.circleView.centerYAnchor.constraint(equalTo: self.viewCamera.centerYAnchor).isActive = true
        self.circleView.widthAnchor.constraint(equalToConstant: self.viewCamera.frame.width*1.4).isActive = true
        self.circleView.heightAnchor.constraint(equalToConstant: self.viewCamera.frame.width*1.4).isActive = true
        
        
    }
    
    @objc func updateCounter() {
        
        if counter > 0 {
            debugPrint("\(counter) seconds duration")
            counter -= 1
            self.duration += 1
            
            
            if self.counter>9
            {
                self.lblTimer.text = "00:"+"\(counter)"
            }
            else
            {
                self.lblTimer.text = "00:0"+"\(counter)"
            }
            self.lblTimer.isHidden=false
            
            if self.counter == 0
            {
                self.cameraConfig.stopRecording { (error) in
                }
                self.lblTimer.isHidden=true
            }
        }
        else
        {
            
            self.timer?.invalidate()
        }
    }
    
    func finshRecording()
    {
        self.viewCamera.transform = CGAffineTransform.identity
        self.toggleTorch(on: false)
        if self.duration>=3
        {
            if let url = self.videoUrl
            {
                let vc = ShareStoryVC.instantiate(fromAppStoryboard: .Stories)
                vc.comeFrom = "video"
                vc.selectedIndex=self.selectedIndex
                self.isPosted=true
                self.isShareOpen=true
                vc.url = url
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            //timer hide
            // self.lblTimer.text = "00:00"
            self.lblTimer.isHidden=true
            self.timer?.invalidate()
            circleView.removeFromSuperview()
            self.openSimpleAlert(message: kMinStoryAlert)
            
        }
    }
    
    func showImageCheckLoader(vc:UIViewController)
    {
        
        let alert = UIAlertController(title: nil, message: kImageContentChecking, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        
        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
        
        vc.present(alert, animated: true)
    }
    
    func parseImageCheckData(response: JSONDictionary) -> ImageCheckDM?{
        var imageData:ImageCheckDM?
        
        if let data = response as? JSONDictionary
        {
            
            imageData = ImageCheckDM(detail: data)
        }
        return imageData
    }
    
    
    func backGo()
    {
        
        
        if  DataManager.currentScreen==kShare
        {
//            DataManager.currentScreen=kShare
//            let vc = OldTapControllerVC.instantiate(fromAppStoryboard: .Main)
//            vc.selectedIndex=self.selectedIndex
//            DataManager.comeFromTag=5
//            self.navigationController?.pushViewController(vc, animated: true)
            if #available(iOS 13.0, *)
            {
                SCENEDEL?.navigateToHome(selectedIndex: 1)
            }
            else
            {
              
                APPDEL.navigateToHome(selectedIndex: 1)
            }
        }
        else
        {
            if self.selectedIndex == 1 && self.isPosted
            {
                DataManager.comeFrom = kEmptyString
            }
            else
            {
                if self.selectedIndex==2
                {
                    DataManager.HomeRefresh=false
                }
                DataManager.comeFrom = kViewProfile
            }
            debugPrint("self.selectedIndex \(self.selectedIndex)")
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func showLoader()
    {
        
        Indicator.sharedInstance.showIndicator2()
        /*
         self.cameraButton.isHidden=false
         self.cameraButton.cornerRadius=self.cameraButton.frame.height/2
         self.flashButton.cornerRadius=self.flashButton.frame.height/2
         self.flipCameraButton.cornerRadius=self.flipCameraButton.frame.height/2
         self.lblTimer.clipsToBounds=true
         self.flashButton.clipsToBounds=true
         self.cameraButton.clipsToBounds=true
         
         self.flipCameraButton.clipsToBounds=true
         
         
         
         self.lblTimer.isSkeletonable=true
         self.flashButton.isSkeletonable=true
         self.cameraButton.isSkeletonable=true
         // self.aboveButton.isSkeletonable=true
         self.flipCameraButton.isSkeletonable=true
         
         self.lblTimer.isUserInteractionDisabledWhenSkeletonIsActive=false
         self.flashButton.isUserInteractionDisabledWhenSkeletonIsActive=false
         self.cameraButton.isUserInteractionDisabledWhenSkeletonIsActive=false
         self.flipCameraButton.isUserInteractionDisabledWhenSkeletonIsActive=false
         
         
         self.lblTimer.showAnimatedGradientSkeleton()
         self.flashButton.showAnimatedGradientSkeleton()
         self.cameraButton.showAnimatedGradientSkeleton()
         self.flipCameraButton.showAnimatedGradientSkeleton()
         
         */
        
        
    }
    func hideLoader()
    {
        //        self.cameraButton.isHidden=true
        //        self.lblTimer.hideSkeleton()
        //        self.flashButton.hideSkeleton()
        //        self.cameraButton.hideSkeleton()
        //        self.flipCameraButton.hideSkeleton()
        //
        Indicator.sharedInstance.hideIndicator2()
        
    }
    
    
    func toggleTorch(on: Bool) {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    
}
extension NewStoryCameraVC:deleteAccountDelegate,paymentScreenOpenFrom
{
    
    
    
    
    
    func showNewErrorMessage(type:String=kStoryVideo)
    {
        
        let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
        vc.comeFrom = kRunningOut
        vc.message=type
        vc.messageTitle=kNumberofStories
        self.fromGetMorePopup=true
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
    
    
    func deleteAccountFunc(name: String)
    {
        if name == kCancel && !self.fromGetMorePopup
        {
            self.backGo()
        }
        else if name.equalsIgnoreCase(string: kRunningOut)
        {
            
            let destVC = NewPremiumVC.instantiate(fromAppStoryboard: .Account)
            destVC.type = .Story
            destVC.subscription_type=kStory
            destVC.popupShowIndex=2
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
    }
    
    func FromScreenName(name: String, ActiveDay: Int)
    {
        if Connectivity.isConnectedToInternet {
            var data = JSONDictionary()
            data[ApiKey.kTimezone] = TIMEZONE
            self.get_post_limit_api(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }
    
    
    func get_post_limit_api(data:JSONDictionary)
    {
        self.showLoader()
        
        AccountVM.shared.callApi_check_post_limit(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.takeImages=false
                self.hideLoader()
                //self.showErrorMessage(error: error)
            }
            else{
                self.takeImages=false
                self.takenImage.isHidden=true
                self.hideLoader()
                self.total_posted_image_count = AccountVM.shared.Post_count_Subsription_Data?.total_image_count ?? 0
                
                self.total_posted_video_count = AccountVM.shared.Post_count_Subsription_Data?.total_video_count ?? 0
                
                
                self.video_length = AccountVM.shared.Post_Subsription_Data?.video_length ?? 5
                self.currentSubscriptionType = AccountVM.shared.Story_Subsription_Data?.name ?? kBasicFree
                
                self.total_eligible_image_count = AccountVM.shared.Post_Subsription_Data?.picture_per_day ?? 0
                self.total_eligible_video_count = AccountVM.shared.Post_Subsription_Data?.video_per_day ?? 0
            }
        })
        
    }
    
    
}



/*
 class NewStoryCameraVC:UIViewController, AVCaptureFileOutputRecordingDelegate
 {
 func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?)
 {
 debugPrint(error)
 
 }
 
 @IBOutlet weak var imgPost: UIImageView!
 
 @IBOutlet weak var captureButton    : SwiftyRecordButton!
 @IBOutlet weak var flipCameraButton : UIButton!
 @IBOutlet weak var flashButton      : UIButton!
 @IBOutlet weak var lblTimer: UILabel!
 @IBOutlet weak var heightConst: NSLayoutConstraint!
 @IBOutlet weak var topConst: NSLayoutConstraint!
 var timer:Timer?
 var selectedIndex = 2
 var duration = 0
 var counter = 7
 var takeImages = false
 let circleView = CircleView(frame: CGRect.zero)
 var imagePicker: UIImagePickerController!
 
 
 //  var captureSession = AVCaptureSession()
 var sessionOutput = AVCaptureStillImageOutput()
 var movieOutput = AVCaptureMovieFileOutput()
 // var previewLayer = AVCaptureVideoPreviewLayer()
 
 
 private var captureSession: AVCaptureSession!
 private weak var previewLayer: CALayer!
 private weak var captureCamera: AVCaptureDevice!
 private weak var audioDevice: AVCaptureDevice!
 private weak var videoOutput: AVCaptureMovieFileOutput!
 private var isFlashlightOn = false
 private var isRecording = false
 private var isFrontCamera = false
 private weak var flashlightCameraButton: UIImageView!
 private weak var recordingCameraButton: UIImageView!
 private weak var switchCamerasCameraButton: UIImageView!
 
 
 /// The URL of the challenge video
 var challengeVideoURL: URL?
 
 override func viewDidLoad() {
 
 super.viewDidLoad()
 
 
 self.lblTimer.isHidden=true
 
 self.heightConst.constant = NAVIHEIGHT
 self.topConst.constant = STATUSBARHEIGHT
 //        shouldPrompToAppSettings = true
 //        cameraDelegate = self
 //        maximumVideoDuration = 7.0
 //        shouldUseDeviceOrientation = true
 //        allowAutoRotate = true
 //audioEnabled = true
 flashButton.setImage(UIImage(named: "flashauto"), for: UIControl.State())
 //        flashMode = .auto
 captureButton.buttonEnabled = false
 
 self.imgPost.isHidden=true
 self.setUp()
 }
 
 override var prefersStatusBarHidden: Bool {
 return false
 }
 
 
 override func viewWillDisappear(_ animated: Bool) {
 super.viewWillDisappear(animated)
 if isRecording {
 videoOutput.stopRecording()
 }
 }
 
 private func setUp() {
 setUpMainView()
 setUpCamera()
 setUpCameraButtons()
 }
 
 private func setUpMainView() {
 let appWindow = UIApplication.shared.keyWindow
 guard let window = appWindow else { return }
 view = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height-200))
 }
 
 private func setUpCamera() {
 let captureSession = AVCaptureSession()
 self.captureSession = captureSession
 captureSession.sessionPreset = .iFrame1280x720
 setUpCameraSide(front: isFrontCamera)
 let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
 self.previewLayer = previewLayer
 view.layer.addSublayer(previewLayer)
 previewLayer.frame = view.layer.frame
 let videoOutput = AVCaptureMovieFileOutput()
 if captureSession.canAddOutput(videoOutput) {
 captureSession.addOutput(videoOutput)
 }
 captureSession.startRunning()
 }
 
 private func setUpCameraSide(front: Bool) {
 captureSession.beginConfiguration()
 if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
 for input in inputs {
 self.captureSession.removeInput(input)
 }
 }
 guard let availableDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: front ? .front : .back) else { return }
 // Prepare visual
 self.captureCamera = availableDevice
 do {
 let captureDeviceInput = try AVCaptureDeviceInput(device: captureCamera)
 captureSession.addInput(captureDeviceInput)
 } catch let error {
 // - TODO: display the error
 }
 // Prepare audio
 guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
 self.audioDevice = audioDevice
 do {
 let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
 captureSession.addInput(audioDeviceInput)
 } catch let error {
 // - TODO: display the error
 }
 
 captureSession.commitConfiguration()
 }
 
 private func setUpCameraButtons() {
 let flashlightCameraButton = UIImageView()
 self.flashlightCameraButton = flashlightCameraButton
 view.addSubview(flashlightCameraButton)
 flashlightCameraButton.image = UIImage(named: "flashauto")
 let flashlightTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(turnOnFlashlight))
 flashlightCameraButton.isUserInteractionEnabled = true
 flashlightCameraButton.addGestureRecognizer(flashlightTapGestureRecognizer)
 //        flashlightCameraButton.snp.makeConstraints { make in
 //            make.left.equalToSuperview().inset(25)
 //            make.bottom.equalToSuperview().inset(25)
 //            make.height.width.equalTo(50)
 //        }
 
 let recordingCameraButton = UIImageView()
 self.recordingCameraButton = recordingCameraButton
 view.addSubview(recordingCameraButton)
 recordingCameraButton.image = UIImage(named: "camera_record")
 let recordingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(recording))
 recordingCameraButton.isUserInteractionEnabled = true
 recordingCameraButton.addGestureRecognizer(recordingTapGestureRecognizer)
 //        recordingCameraButton.snp.makeConstraints { make in
 //            make.centerX.equalToSuperview()
 //            make.bottom.equalToSuperview().inset(25)
 //            make.height.width.equalTo(70)
 //        }
 
 let switchCamerasCameraButton = UIImageView()
 self.switchCamerasCameraButton = switchCamerasCameraButton
 view.addSubview(switchCamerasCameraButton)
 switchCamerasCameraButton.image = UIImage(named: "camera_switch_camera")
 let switchCameraTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchCamera))
 switchCamerasCameraButton.isUserInteractionEnabled = true
 switchCamerasCameraButton.addGestureRecognizer(switchCameraTapGestureRecognizer)
 //        switchCamerasCameraButton.snp.makeConstraints { make in
 //            make.right.equalToSuperview().inset(25)
 //            make.bottom.equalToSuperview().inset(25)
 //            make.height.width.equalTo(50)
 //        }
 }
 
 @objc private func turnOnFlashlight() {
 isFlashlightOn = !isFlashlightOn
 if !isRecording {
 if !isFrontCamera, captureCamera.hasTorch {
 do {
 try captureCamera.lockForConfiguration()
 captureCamera.torchMode = captureCamera.isTorchActive ? .on : .off
 captureCamera.unlockForConfiguration()
 } catch let error {
 // - TODO: handle error here
 }
 }
 }
 }
 
 @objc private func recording() {
 if !isRecording {
 // delegate?.didStartRecording(self)
 //     NotificationCenter.default.post(name: .avr, object: nil)
 if !captureSession.isRunning {
 return
 }
 let paths = FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask)
 let fileURL = paths[0].appendingPathComponent("challenge.mov")
 try? FileManager.default.removeItem(at: fileURL)
 challengeVideoURL = fileURL
 videoOutput.startRecording(to: fileURL, recordingDelegate: self)
 } else {
 videoOutput.stopRecording()
 }
 isRecording = !isRecording
 }
 
 @objc private func switchCamera() {
 isFrontCamera = !isFrontCamera
 setUpCameraSide(front: isFrontCamera)
 }
 
 private func setUpTimer() {
 
 }
 
 
 //    override func viewWillAppear(_ animated: Bool) {
 //        super.viewWillAppear(animated)
 //        self.imgPost.isHidden=true
 //        setNeedsStatusBarAppearanceUpdate()
 //       // self.topConst.constant = STATUSBARHEIGHT
 //
 //
 //
 //        setupCirle()
 //                // Animate the drawing of the circle over the course of 1 second
 //
 //    }
 //
 /*
  
  override func viewWillAppear(_ animated: Bool) {
  // self.cameraView = self.view
  
  self.imgPost.isHidden=true
  setNeedsStatusBarAppearanceUpdate()
  // self.topConst.constant = STATUSBARHEIGHT
  
  setupCirle()
  
  let devices = AVCaptureDevice.devices(for: AVMediaType.video)
  for device in devices
  {
  if (device as AnyObject).position == AVCaptureDevice.Position.front{
  
  
  do{
  
  let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
  
  if captureSession.canAddInput(input){
  
  captureSession.addInput(input)
  sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
  
  if captureSession.canAddOutput(sessionOutput){
  
  captureSession.addOutput(sessionOutput)
  
  previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
  previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
  previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
  self.view.layer.addSublayer(previewLayer)
  
  previewLayer.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
  previewLayer.bounds = view.frame
  
  
  }
  
  captureSession.addOutput(movieOutput)
  
  captureSession.startRunning()
  
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  let fileUrl = paths[0].appendingPathComponent("output.mov")
  try? FileManager.default.removeItem(at: fileUrl)
  movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
  
  let delayTime = DispatchTime.now() + 5
  DispatchQueue.main.asyncAfter(deadline: delayTime) {
  print("stopping")
  self.movieOutput.stopRecording()
  }
  }
  
  }
  catch{
  
  print("Error")
  }
  
  }
  }
  
  }
  
  
  //MARK: AVCaptureFileOutputRecordingDelegate Methods
  
  func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
  
  }
  
  func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
  print("FINISHED \(error)")
  // save video to camera roll
  if error == nil {
  
  print("Video FINISHED \(outputFileURL.path)")
  UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
  }
  }
  
  
  */
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 debugPrint("********** MEMORY WARNING **********")
 URLCache.shared.removeAllCachedResponses()
 URLCache.shared.memoryCapacity = 0
 URLCache.shared.diskCapacity = 0
 SDImageCache.shared.clearMemory()
 SDImageCache.shared.clearDisk()
 }
 override var preferredStatusBarStyle: UIStatusBarStyle {
 .lightContent
 }
 override func viewDidAppear(_ animated: Bool) {
 
 super.viewDidAppear(animated)
 self.view.endEditing(true)
 autoreleasepool {
 // captureButton.delegate = self
 }
 }
 
 
 func setupCirle()
 {
 captureButton.addSubview(circleView)
 circleView.translatesAutoresizingMaskIntoConstraints = false
 
 circleView.centerXAnchor.constraint(equalTo: captureButton.centerXAnchor).isActive = true
 circleView.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor).isActive = true
 circleView.widthAnchor.constraint(equalToConstant: captureButton.frame.width*1.85).isActive = true
 circleView.heightAnchor.constraint(equalToConstant: captureButton.frame.width*1.85).isActive = true
 }
 
 @IBAction func backBtnAct(_ sender: UIButton)
 {
 //  self.navigationController?.popViewController(animated: false)
 
 
 let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
 let vc = storyBoard.instantiateViewController(withIdentifier: "OldTapControllerVC") as! OldTapControllerVC
 vc.selectedIndex=self.selectedIndex
 DataManager.comeFromTag=5
 self.navigationController?.pushViewController(vc, animated: true)
 }
 
 @IBAction func nextAct(_ sender: UIButton)
 {
 //        let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
 //        let vc = storyBoard.instantiateViewController(withIdentifier: "ShareStoryVC") as! ShareStoryVC
 //        vc.img = photo
 //        vc.selectedIndex=self.selectedIndex
 //        self.navigationController?.pushViewController(vc, animated: false)
 }
 /*
  
  func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
  debugPrint("Session did start running")
  
  
  captureButton.buttonEnabled = true
  }
  
  func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
  debugPrint("Session did stop running")
  
  
  captureButton.buttonEnabled = false
  }
  
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
  
  self.imgPost.image = photo
  self.imgPost.isHidden=false
  AudioServicesPlaySystemSound(1108);
  if #available(iOS 9.0, *) {
  AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
  } else {
  AudioServicesPlaySystemSound(1108)
  }
  
  if self.takeImages == false
  {
  if Connectivity.isConnectedToInternet {
  
  self.showImageCheckLoader(vc: self)
  var dataImage = Data()
  var image:UIImage!
  debugPrint("Take images = \(photo)")
  
  image = photo
  
  let dataImage1 =  image.jpegData(compressionQuality: 1) ?? Data()
  var imageSize1: Int = dataImage1.count
  let size = Double(imageSize1) / 1000.0
  //var  dataImage = Data()
  if size>1500
  {
  dataImage =  image.jpegData(compressionQuality: 0.03) ?? Data()
  }
  else if size>1000
  {
  dataImage =  image.jpegData(compressionQuality: 0.04) ?? Data()
  }
  
  else if size>500
  {
  dataImage =  image.jpegData(compressionQuality: 0.05) ?? Data()
  }
  else if size>100
  {
  dataImage =  image.jpegData(compressionQuality: 0.2) ?? Data()
  }
  else if size>50
  {
  dataImage =  image.jpegData(compressionQuality: 0.5) ?? Data()
  }
  else
  {
  dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
  }
  
  
  
  
  
  //            image =  self.cropToBounds(image: photo, width: Double(SCREENWIDTH), height: Double(SCREENHEIGHT-240))
  //
  //           if image != nil
  //           {
  //            debugPrint("Image details 2: = \(image)")
  //             dataImage =  image.jpegData(compressionQuality: 1) ?? Data()
  //           }
  //            else
  //           {
  // dataImage =  photo.jpegData(compressionQuality: 1) ?? Data()
  //            debugPrint("Image details 3: = \(image)")
  //           }
  
  
  //            self.takeImages=true
  //            let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
  //            let vc = storyBoard.instantiateViewController(withIdentifier: "ShareStoryVC") as! ShareStoryVC
  //            vc.img = image
  //            vc.selectedIndex=self.selectedIndex
  //            self.navigationController?.pushViewController(vc, animated: true)
  
  
  //
  
  
  APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
  
  (responseDict) in
  debugPrint("responseDict = \(responseDict)")
  let data =   self.parseImageCheckData(response: responseDict)
  if  kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")
  {
  debugPrint(data)
  if data?.weapon ?? 0.0 > kNudityCheck
  {
  
  self.dismiss(animated: true) {
  
  self.openSimpleAlert(message: kImageCkeckAlert)
  self.imgPost.isHidden=true
  }                     }
  //                     else if  data?.alcohol ?? 0.0 > kNudityCheck
  //                     {
  //  self.dismiss(animated: true) {
  // self.openSimpleAlert(message: kImageCkeckAlert)
  
  //}//                     }
  else if  data?.drugs ?? 0.0 > kNudityCheck
  {
  self.dismiss(animated: true, completion: nil)
  
  self.dismiss(animated: true) {
  
  self.openSimpleAlert(message: kImageCkeckAlert)
  self.imgPost.isHidden=true
  }                     }
  else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
  {
  self.dismiss(animated: true, completion: nil)
  
  self.dismiss(animated: true) {
  
  self.openSimpleAlert(message: kImageCkeckAlert)
  self.imgPost.isHidden=true
  
  }                     }
  else
  {
  self.dismiss(animated: true)
  {
  self.takeImages=true
  let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
  let vc = storyBoard.instantiateViewController(withIdentifier: "ShareStoryVC") as! ShareStoryVC
  vc.img = photo
  vc.selectedIndex=self.selectedIndex
  self.navigationController?.pushViewController(vc, animated: true)
  
  }
  }
  
  }
  else
  {
  self.imgPost.isHidden=true
  let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
  
  if  data?.error?.message != ""
  {
  self.dismiss(animated: true)
  {
  self.openSimpleAlert(message:  data?.error?.message)
  }
  }
  else
  {
  self.dismiss(animated: true)
  {
  self.openSimpleAlert(message: message)
  }
  }
  }
  
  
  
  },  failureCallback: { (errorReason, error) in
  self.dismiss(animated: true, completion: nil)
  
  self.openSimpleAlert(message: errorReason?.localizedDescription)
  debugPrint(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
  
  })
  
  } else {
  
  self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
  }
  
  
  
  
  }
  
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
  setupCirle()
  circleView.animateCircle(duration: 7.0)
  self.imgPost.isHidden=true
  counter = 7
  timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
  //timer hide
  // self.lblTimer.text = "00"+":07"
  //        self.lblTimer.isHidden=false
  
  self.lblTimer.isHidden=true
  
  self.duration=1
  debugPrint("Did Begin Recording")
  captureButton.growButton()
  hideButtons()
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
  debugPrint("Did finish Recording")
  self.imgPost.isHidden=true
  circleView.removeFromSuperview()
  
  captureButton.shrinkButton()
  showButtons()
  //timer hide
  // self.lblTimer.text = "00:00"
  self.lblTimer.isHidden=true
  self.timer?.invalidate()
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
  //        let newVC = VideoViewController(videoURL: url)
  //        self.present(newVC, animated: true, completion: nil)
  self.imgPost.isHidden=true
  if self.duration>=4
  {
  let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
  let vc = storyBoard.instantiateViewController(withIdentifier: "ShareStoryVC") as! ShareStoryVC
  vc.comeFrom = "video"
  vc.selectedIndex=self.selectedIndex
  vc.url = url
  self.navigationController?.pushViewController(vc, animated: true)
  }
  else{
  //timer hide
  // self.lblTimer.text = "00:00"
  self.lblTimer.isHidden=true
  self.timer?.invalidate()
  circleView.removeFromSuperview()
  self.openSimpleAlert(message: kMinStoryAlert)
  
  }
  
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
  debugPrint("Did focus at point: \(point)")
  focusAnimationAt(point)
  }
  
  func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
  let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
  let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
  alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
  present(alertController, animated: true, completion: nil)
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
  debugPrint("Zoom level did change. Level: \(zoom)")
  debugPrint(zoom)
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
  debugPrint("Camera did change to \(camera.rawValue)")
  debugPrint(camera)
  }
  
  func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
  debugPrint(error)
  }
  */
 
 @IBAction func cameraSwitchTapped(_ sender: Any) {
 // switchCamera()
 }
 
 @IBAction func toggleFlashTapped(_ sender: Any) {
 //flashEnabled = !flashEnabled
 // toggleFlashAnimation()
 }
 @objc func updateCounter() {
 
 //example functionality
 if counter > 0 {
 debugPrint("\(counter) seconds to the end of the world")
 counter -= 1
 self.duration += 1
 //timer hide
 // self.lblTimer.text = "00:0"+"\(counter)"//+"0"
 //self.lblTimer.isHidden=false
 
 self.lblTimer.isHidden=true
 
 }
 else
 {
 //timer hide
 //  self.lblTimer.text = "00:00"
 self.lblTimer.isHidden=true
 self.timer?.invalidate()
 }
 }
 /*
  //MARK: - Back Button
  func setBackButton()
  {
  let backButton = UIButton()
  let backImage = UIImageView()
  
  backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
  backImage.frame = CGRect(x: 8, y: 8, width: 18, height: 18)
  backImage.image = #imageLiteral(resourceName: "backWhite")
  backImage.contentMode = .scaleAspectFit
  backImage.clipsToBounds = true
  //backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: UIControl.State.normal)
  backButton.addSubview(backImage)
  
  backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
  backButton.contentEdgeInsets = UIEdgeInsets(top: -10, left: -15, bottom: 0, right: 0)
  let leftBarButton = UIBarButtonItem()
  leftBarButton.title = ""
  leftBarButton.customView = backButton
  self.navigationItem.leftBarButtonItem = leftBarButton
  
  }
  */
 
 //    @objc func backButtonAction() {
 //        self.view.endEditing(true)
 //
 //
 //        if let viewControllers = self.navigationController?.viewControllers {
 //            if viewControllers.count > 1 {
 //                let backDone = self.navigationController?.popViewController(animated: true)
 //                if backDone == nil {
 //                    self.navigationController?.dismiss(animated: true, completion: nil)
 //                }
 //            }
 //
 //        }
 //
 //
 //    }
 
 }
 extension NewStoryCameraVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate
 {
 func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
 debugPrint("i've got an image");
 }
 
 }
 
 // UI Animations
 extension NewStoryCameraVC {
 
 fileprivate func hideButtons() {
 UIView.animate(withDuration: 0.25) {
 self.flashButton.alpha = 0.0
 self.flipCameraButton.alpha = 0.0
 }
 }
 
 fileprivate func showButtons() {
 UIView.animate(withDuration: 0.25) {
 self.flashButton.alpha = 1.0
 self.flipCameraButton.alpha = 1.0
 }
 }
 
 fileprivate func focusAnimationAt(_ point: CGPoint) {
 let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
 focusView.center = point
 focusView.alpha = 0.0
 view.addSubview(focusView)
 
 UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
 focusView.alpha = 1.0
 focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
 
 // focusView.transform = CGAffineTransform(scaleX: 2, y: 2)
 
 }) { (success) in
 UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
 focusView.alpha = 0.0
 focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
 }) { (success) in
 focusView.removeFromSuperview()
 }
 }
 }
 /*
  fileprivate func toggleFlashAnimation() {
  //flashEnabled = !flashEnabled
  if flashMode == .auto
  {
  flashMode = .on
  flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
  //flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
  flashButton.setImage(UIImage(named: "flash"), for: UIControl.State())
  }else if flashMode == .on{
  flashMode = .off
  //    flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
  
  flashButton.setImage(UIImage(named: "flashOutline-1"), for: UIControl.State())
  }else if flashMode == .off{
  flashMode = .auto
  flashButton.setImage(UIImage(named: "flashauto"), for: UIControl.State())
  //flashButton.setImage(UIImage(string: #imageLiteral(resourceName: "flashauto"), for: UIControl.State())
  }
  else
  {
  flashMode = .auto
  flashButton.setImage(UIImage(named: "flashauto"), for: UIControl.State())
  //flashButton.setImage(UIImage(string: #imageLiteral(resourceName: "flashauto"), for: UIControl.State())
  }
  }
  
  func parseImageCheckData(response: JSONDictionary) -> ImageCheckDM?{
  var imageData:ImageCheckDM?
  
  if let data = response as? JSONDictionary
  {
  
  imageData = ImageCheckDM(detail: data)
  }
  return imageData
  }
  
  func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
  let size = image.size
  
  let widthRatio  = targetSize.width  / size.width
  let heightRatio = targetSize.height / size.height
  
  // Figure out what our orientation is, and use that to form the rectangle
  var newSize: CGSize
  if(widthRatio > heightRatio) {
  newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
  } else {
  newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
  }
  
  // This is the rect that we've calculated out and this is what is actually used below
  let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
  
  // Actually do the resizing to the rect using the ImageContext stuff
  UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
  image.draw(in: rect)
  let newImage = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  
  return newImage ?? UIImage()
  }
  
  func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
  
  let cgimage = image.cgImage!
  let contextImage: UIImage = UIImage(cgImage: cgimage)
  let contextSize: CGSize = contextImage.size
  var posX: CGFloat = 0.0
  var posY: CGFloat = 0.0
  var cgwidth: CGFloat = CGFloat(width)
  var cgheight: CGFloat = CGFloat(height)
  
  // See what size is longer and create the center off of that
  if contextSize.width > contextSize.height {
  posX = ((contextSize.width - contextSize.height) / 2)
  posY = 0
  cgwidth = contextSize.height
  cgheight = contextSize.height
  } else {
  posX = 0
  posY = ((contextSize.height - contextSize.width) / 2)
  cgwidth = contextSize.width
  cgheight = contextSize.width
  }
  
  let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
  
  // Create bitmap image from context using the rect
  let imageRef: CGImage = cgimage.cropping(to: rect)!
  
  // Create a new image based on the imageRef and rotate back to the original orientation
  let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
  
  return image
  }
  
  func showImageCheckLoader(vc:UIViewController)
  {
  
  let alert = UIAlertController(title: nil, message: "Image content checking...", preferredStyle: .alert)
  let activityIndicator = UIActivityIndicatorView(style: .gray)
  activityIndicator.translatesAutoresizingMaskIntoConstraints = false
  activityIndicator.isUserInteractionEnabled = false
  activityIndicator.startAnimating()
  
  alert.view.addSubview(activityIndicator)
  alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
  
  activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
  activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
  
  vc.present(alert, animated: true)
  }
  */
 }
 
 
 */
