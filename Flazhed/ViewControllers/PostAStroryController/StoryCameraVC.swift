//
//  CameraVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//


import SwiftyCam
import UIKit
import AVFoundation

class StoryCameraVC: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
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
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.lblTimer.isHidden=true
        
        self.heightConst.constant = NAVIHEIGHT
        self.topConst.constant = STATUSBARHEIGHT
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 7.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashButton.setImage(UIImage(named: "flashauto"), for: UIControl.State())
        flashMode = .auto
        captureButton.buttonEnabled = false
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNeedsStatusBarAppearanceUpdate()
       // self.topConst.constant = STATUSBARHEIGHT
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       captureButton.delegate = self
    }
    
    @IBAction func backBtnAct(_ sender: UIButton)
    {
      //  self.navigationController?.popViewController(animated: false)
        
                        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
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
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
       
        captureButton.buttonEnabled = false
    }
    

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {

        if self.takeImages == false
        {
           
        
            let dataImage =  photo.jpegData(compressionQuality: 0.7) ?? Data()
            
             APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
                 
                 (responseDict) in
                 print(responseDict)
                let data =   self.parseImageCheckData(response: responseDict)
                 if responseDict[ApiKey.kStatus] as? String == kSucess
                 {
                   
                
                     
                     print(data)
                     if data?.weapon ?? 0.0 > kNudityCheck
                     {
                         self.openSimpleAlert(message: kImageCkeckAlert)
                     }
//                     else if  data?.alcohol ?? 0.0 > kNudityCheck
//                     {
//                         self.openSimpleAlert(message: kImageCkeckAlert)
//                     }
                     else if  data?.drugs ?? 0.0 > kNudityCheck
                     {
                         self.openSimpleAlert(message: kImageCkeckAlert)
                     }
                     else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
                     {
                         self.openSimpleAlert(message: kImageCkeckAlert)
                     }
                     else
                     {
                        self.takeImages=true
                        let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "ShareStoryVC") as! ShareStoryVC
                        vc.img = photo
                        vc.selectedIndex=self.selectedIndex
                        self.navigationController?.pushViewController(vc, animated: true)
                            
                           
                     }
                     
                 }
                 else
                 {
                    let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                   if  data?.error?.message != ""
                   {
                      
                       self.openSimpleAlert(message:  data?.error?.message)
                   }
                   else
                   {
                       self.openSimpleAlert(message: message)
                   }
                 }
                 
                 
                 
             },  failureCallback: { (errorReason, error) in
                 print(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                 
             })
            
            
            
        }
        
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        counter = 7
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        self.lblTimer.text = "00"+":07"
        self.lblTimer.isHidden=false
        self.duration=1
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
       
        captureButton.shrinkButton()
        showButtons()
        self.lblTimer.text = "00:00"
        self.lblTimer.isHidden=true
        self.timer?.invalidate()
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
//        let newVC = VideoViewController(videoURL: url)
//        self.present(newVC, animated: true, completion: nil)
       
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
            self.lblTimer.text = "00:00"
            self.lblTimer.isHidden=true
            self.timer?.invalidate()
   
            self.openSimpleAlert(message: kMinStoryAlert)
            
        }
       
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }

    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    @IBAction func toggleFlashTapped(_ sender: Any) {
        //flashEnabled = !flashEnabled
        toggleFlashAnimation()
    }
    @objc func updateCounter() {
        
        //example functionality
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter -= 1
            self.duration += 1
            self.lblTimer.text = "00:0"+"\(counter)"//+"0"
            self.lblTimer.isHidden=false
            
            
        }
        else
        {
            self.lblTimer.text = "00:00"
            self.lblTimer.isHidden=true
            self.timer?.invalidate()
        }
    }
    
    //MARK:- Back Button
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
    
    @objc func backButtonAction() {
        self.view.endEditing(true)
    
        
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 1 {
                let backDone = self.navigationController?.popViewController(animated: true)
                if backDone == nil {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
      
    
    }
 
}


// UI Animations
extension StoryCameraVC {
    
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
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
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
}


