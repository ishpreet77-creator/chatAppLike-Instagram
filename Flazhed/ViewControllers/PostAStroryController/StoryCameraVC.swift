//
//  CameraVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//

/*
import UIKit
import AVFoundation
import SDWebImage
import AVKit

class StoryCameraVC: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
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
        
        self.imgPost.isHidden=true
        
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgPost.isHidden=true
        setNeedsStatusBarAppearanceUpdate()
       // self.topConst.constant = STATUSBARHEIGHT
        
        
        
        setupCirle()
                // Animate the drawing of the circle over the course of 1 second
                
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.view.endEditing(true)
        autoreleasepool {
       captureButton.delegate = self
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
                let imageSize1: Int = dataImage1.count
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
                    // debugPrint(data)
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
}


*/
