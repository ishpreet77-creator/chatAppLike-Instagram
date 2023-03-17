    //
    //  ShareStoryVC.swift
    //  Flazhed
    //
    //  Created by IOS22 on 07/01/21.
    //

    import UIKit
    import AVFoundation
    import IQKeyboardManagerSwift
    import FBSDKLoginKit
    import FBSDKShareKit
    import FBSDKCoreKit
    import SkeletonView

    class ShareStoryVC: BaseVC, DiscardDelegate,UITextViewDelegate {
        
        
        
        @IBOutlet weak var viewTextBack: UIView!
        @IBOutlet weak var heightConst: NSLayoutConstraint!
        @IBOutlet weak var topConst: NSLayoutConstraint!
        @IBOutlet weak var storyImg: UIImageView!
        var img:UIImage!
        var comeFrom = "image"
        var url:URL!
        @IBOutlet weak var btnButtomConst: NSLayoutConstraint!
        @IBOutlet weak var txtShare: UITextView!
        @IBOutlet weak var btnShare: UIButton!
        @IBOutlet weak var btnPlay: UIButton!
        
        var selectedIndex = 2
        var dataImage1 = Data()
        var fromSetting=false
        override func viewDidLoad() {
            DataManager.currentScreen=kShare
            
            super.viewDidLoad()
            
           
            if self.getDeviceModel() == "iPhone 6"
            {
                IQKeyboardManager.shared.enableAutoToolbar = false
                
            }
            else
            {
                IQKeyboardManager.shared.enableAutoToolbar = false
            }
         
            
            
            if self.comeFrom.equalsIgnoreCase(string: "video")
            {
                
                
                self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                    self.storyImg.image = thumbImage
                }
                self.btnPlay.isHidden=false
            }
            else
            {
                self.storyImg.image = img
                self.btnPlay.isHidden=true
            }
            btnShare.isEnabled=false
            txtShare.text = ""
            setNeedsStatusBarAppearanceUpdate()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            self.heightConst.constant = NAVIHEIGHT
            self.topConst.constant = getStatusBarHeight()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            txtShare.delegate=self
            
            if txtShare.text.count>0
            {
                btnShare.isEnabled=true
            }
            else
            {
                btnShare.isEnabled=false
            }
            
           
            txtShare.becomeFirstResponder()
            
            // Get the current authorization state.
            let status = PHPhotoLibrary.authorizationStatus()

            if (status == PHAuthorizationStatus.authorized) {
                // Access has been granted.
            }

            else if (status == PHAuthorizationStatus.denied) {
                // Access has been denied.
                DispatchQueue.main.async {
                    PHPhotoLibrary.requestAuthorization({ (newStatus) in

                        if (newStatus == PHAuthorizationStatus.authorized) {

                        }

                        else {

                        }
                    })
                }
            }

            else if (status == PHAuthorizationStatus.notDetermined) {

                // Access has not been determined.
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
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
            
        }
        override var prefersStatusBarHidden: Bool {
            return false
        }
        
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
        
        @IBAction func backBtnAct(_ sender: UIButton)
        {
            //self.navigationController?.popViewController(animated: true)
            
        
            let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)
            destVC.delegate=self
            destVC.type = .discardPost
            if self.comeFrom.equalsIgnoreCase(string: "video")
            {
            destVC.postType = kVideo
            }
            else
            {
                destVC.postType = "Photo"
            }
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
        
        @IBAction func playAct(_ sender: UIButton)
        {
            if url != nil
            {
                storyImg.playVideoOnImage(url, VC: self)
            }
        }
        
        //MARK: - popup delegate method
        
        func showFacebookInstallPopup()
        {
            let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)

            destVC.delegate=self
            destVC.type = .BlockReportError
            destVC.user_name=kInstallFacebookAlert
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
        
        func ClickNameAction(name: String)
        {
            
            if name.equalsIgnoreCase(string: kDiscard)
            {
                let vc = NewStoryCameraVC.instantiate(fromAppStoryboard: .Stories)

                vc.selectedIndex = self.selectedIndex
                self.navigationController?.pushViewController(vc, animated: false)
            }
            else if name.equalsIgnoreCase(string: kCancel)
            {
                self.dismiss(animated: true) {
//                    if #available(iOS 13.0, *) {
//                        SCENEDEL?.navigateToStories()
//                    } else {
//                        // Fallback on earlier versions
//                        APPDEL.navigateToStories()
//                    }
                    
                    let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

                    vc.selectedIndex=1
                    DataManager.comeFrom=kShare
                    self.appDelegate?.storyVisitCount=0
                    self.navigationController?.pushViewController(vc, animated: true)

                }
                

            }
            else if name.equalsIgnoreCase(string: kShare)
            {
                self.dismiss(animated: true) {
                    if Connectivity.isConnectedToInternet
                    {
                    if self.comeFrom.equalsIgnoreCase(string: "video")
                     {
                        
                            let content: ShareVideoContent = ShareVideoContent()
                        
                        DispatchQueue.main.async {
                            let status = PHPhotoLibrary.authorizationStatus()
                            if (status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.notDetermined || status == PHAuthorizationStatus.restricted) {
                                
                                
                                  debugPrint("Access has been denied.")
                                  DispatchQueue.main.async {
                                      self.openSettings2(message: PermissonType.kLibraryEnable)
                                      PHPhotoLibrary.requestAuthorization({ (newStatus) in

                                          if (newStatus == PHAuthorizationStatus.authorized) {

                                          }

                                          else {

                                          }
                                      })
                                  }
                                
                              }
                            else
                            {
                        
                        self.createAssetURL(url: self.url) { (url) in
                            Indicator.sharedInstance.showIndicator2()
                            let video = ShareVideo()
                            video.videoURL = URL(string: url)//URL(string: url)
                                            content.video = video
                                
                                let videoURLs = self.url!//Bundle.main.url(forResource: "video", withExtension: "mp4")!
                        let shareDialog = ShareDialog(fromViewController: self, content: content, delegate: nil)
                           
                            shareDialog.shareContent = content
                           
                           // shareDialog.delegate = self
                           
                       if (shareDialog.canShow)
                        {
                           shareDialog.delegate=self
                        shareDialog.show()
                        Indicator.sharedInstance.hideIndicator2()
                      
                           
                        }
                            else {
                            Indicator.sharedInstance.hideIndicator2()
                            
                            
                            self.showFacebookInstallPopup()
                            
                                    /*
                                    self.openAlert(title: kAlert,message: kInstallFacebookAlert,alertStyle: .alert,actionTitles: [kOk],actionStyles: [.default],
                                                   actions: [
                                                    {_ in
                                                        
//                                                        if #available(iOS 13.0, *) {
//
//                                                            SCENEDEL?.navigateToStories()
//                                                        } else {
//                                                            // Fallback on earlier versions
//                                                            APPDEL.navigateToStories()
//                                                        }
                                                        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                                                        let vc = storyBoard.instantiateViewController(withIdentifier: "OldTapControllerVC") as! OldTapControllerVC
                                                        vc.selectedIndex=1
                                                        self.navigationController?.pushViewController(vc, animated: true)
                                                    }
                                                    
                                                   ])
                            */
                                }
                                        
                        }
                                
                            }
                          
                            
                        
                    }
                     }
                    else
                    {
                        let photo = SharePhoto(image: self.storyImg.image!, userGenerated: true)
                        
                        let content = SharePhotoContent()
                        photo.caption=self.txtShare.text!
                        
                        content.photos = [photo]
                        
                        let showDialog = ShareDialog(fromViewController: self, content: content, delegate: nil)//(fromViewController: self, content: content, delegate: self)
                        showDialog.delegate=self
                        if (showDialog.canShow) {
                            showDialog.show()
                        } else {
                            self.showFacebookInstallPopup()
                            /*
                            self.openAlert(title: kAlert,message: kInstallFacebookAlert,alertStyle: .alert,actionTitles: [kOk],actionStyles: [.default],
                                           actions: [
                                            {_ in
                                                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                                                let vc = storyBoard.instantiateViewController(withIdentifier: "OldTapControllerVC") as! OldTapControllerVC
                                                vc.selectedIndex=1
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            
                                           ])
                            */
                        }
                    }
                }
                    else {
                      
                      self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                  }
                    
                }
            
            }
            
        }
        
        @IBAction func ShareBtnAct(_ sender: UIButton)
        {
            txtShare.resignFirstResponder()
            
            if let message = validateData()
            {
                self.openSimpleAlert(message: message)
            }
            else
            {
                
                self.callGetStoriesApi()
            }
            
        }
        @objc
        func keyboardWillAppear(notification: NSNotification?) {
            setNeedsStatusBarAppearanceUpdate()
            guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight: CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            debugPrint(keyboardHeight)
            if self.getDeviceModel() == "iPhone 6"
            {
                btnButtomConst.constant = keyboardHeight+26
                
            }
            else
            {
                self.btnButtomConst.constant = keyboardHeight+26+20
            }
         
            
        }
        
        @objc
        func keyboardWillDisappear(notification: NSNotification?) {
            setNeedsStatusBarAppearanceUpdate()
            btnButtomConst.constant = 26
            
        }
        
        func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
            DispatchQueue.global().async { //1
                let asset = AVAsset(url: url) //2
                let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
                avAssetImageGenerator.appliesPreferredTrackTransform = true //4
                let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
                do {
                    let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                    let thumbImage = UIImage(cgImage: cgThumbImage) //7
                    DispatchQueue.main.async { //8
                        completion(thumbImage) //9
                    }
                } catch {
                    debugPrint(error.localizedDescription) //10
                    DispatchQueue.main.async {
                        completion(nil) //11
                    }
                }
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
        {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text).trimmingCharacters(in: .whitespacesAndNewlines)
            let numberOfChars = newText.count
            if numberOfChars>0
            {
                btnShare.isEnabled=true
                btnShare.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                btnShare.setBackgroundImage(#imageLiteral(resourceName: "continueBack"), for: .normal)
            }
            else
            {
                btnShare.isEnabled=false
                btnShare.setTitleColor(#colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1), for: .normal)
                btnShare.setBackgroundImage(#imageLiteral(resourceName: "ShareBtn"), for: .normal)
            }
            
            return numberOfChars <= 370   // 10 Limit Value
        }
        
        // MARK:- Private Functions
        private func validateData () -> String?
        {
            if txtShare.text.count == 0 {
                return kEmptyDescriptionAlert
            }
            return nil
        }
        
        
        
        
        func showLoader()
        {
            Indicator.sharedInstance.showIndicator2()
            /*
            self.viewTextBack.clipsToBounds=true
            self.btnPlay.clipsToBounds=true
            self.btnShare.clipsToBounds=true

            self.viewTextBack.isSkeletonable=true
            self.btnPlay.isSkeletonable=true
            self.btnShare.isSkeletonable=true

            self.viewTextBack.showAnimatedGradientSkeleton()
            self.btnPlay.showAnimatedGradientSkeleton()
            self.btnShare.showAnimatedGradientSkeleton()
            */
            
           // Indicator.sharedInstance.showIndicator2()
            
        }
        func hideLoader()
        {
        
            
          //  Indicator.sharedInstance.hideIndicator2()
            
//            self.viewTextBack.hideSkeleton()
//            self.btnPlay.hideSkeleton()
//            self.btnShare.hideSkeleton()
            
            Indicator.sharedInstance.hideIndicator2()
        }
        
       
        func openSettings2(message:String = kSettingMessage)
        {
            DispatchQueue.main.async {
                let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
                vc.comeFrom = kSetting
                vc.messageType=message
                self.fromSetting=true
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
        
    }
    // MARK:- Extension Api Calls
    extension ShareStoryVC
    {
        
        func callGetStoriesApi()
        {
            var data = JSONDictionary()
            
            data[ApiKey.kFile_type] = self.comeFrom
            data[ApiKey.kPost_text] = self.txtShare.text!
            var imageData = Data()
            var imageData2 = Data()
            if self.comeFrom.equalsIgnoreCase(string: "video")
            {
                self.showLoader()
                
                do{
                    imageData = try Data(contentsOf: url)
                }catch{
                    debugPrint("Unable to load audioData: \(error)")
                }
             //   imageData2 = Data() //self.storyImg.image?.jpegData(compressionQuality: 1) ?? Data()
                
                let dataImage1 =  self.storyImg.image?.jpegData(compressionQuality: 1) ?? Data()
                let imageSize1: Int = dataImage1.count
                let size = Double(imageSize1) / 1000.0
                //var  dataImage = Data()
                /*
                if size>1500
                {
                    imageData2 =  self.storyImg.image?.jpegData(compressionQuality: 0.03) ?? Data()
                }
                else if size>1000
                {
                    imageData2 =  self.storyImg.image?.jpegData(compressionQuality: 0.04) ?? Data()
                }
                
                else if size>500
                {
                    imageData2 =  self.storyImg.image?.jpegData(compressionQuality: 0.05) ?? Data()
                }
              else if size>100
               {
                imageData2 =  self.storyImg.image?.jpegData(compressionQuality: 0.2) ?? Data()
               }
              else if size>50
               {
                imageData2 =  self.storyImg.image?.jpegData(compressionQuality: 0.5) ?? Data()
               }
                else
               {
                imageData2 =  self.storyImg.image?.jpegData(compressionQuality: 0.7) ?? Data()
               }
                */
                if size>500
                {
                    imageData2 =  self.storyImg.image?.jpegData(compressionQuality: kImageCompressGreaterThan500) ?? Data()
                }
                else
                {
                    imageData2 =  self.storyImg.image?.jpegData(compressionQuality: kImageCompressLessThan500) ?? Data()
                }
                
                
                if Connectivity.isConnectedToInternet
                {
                    
                    self.addPostApi(image1: imageData, image2: imageData2, data: data, fileType: self.comeFrom)
                } else {
                    self.hideLoader()
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
            }
            else
            {
                /*
                imageData =  self.storyImg.image?.jpegData(compressionQuality: 1) ?? Data()
                
                let dataImage1 =  self.storyImg.image?.jpegData(compressionQuality: 1) ?? Data()
                var imageSize1: Int = dataImage1.count
                let size = Double(imageSize1) / 1000.0
                //var  dataImage = Data()
                if size>1500
                {
                    imageData =  self.storyImg.image?.jpegData(compressionQuality: 0.03) ?? Data()
                }
                else if size>1000
                {
                    imageData =  self.storyImg.image?.jpegData(compressionQuality: 0.04) ?? Data()
                }
                
                else if size>500
                {
                    imageData =  self.storyImg.image?.jpegData(compressionQuality: 0.05) ?? Data()
                }
              else if size>100
               {
                imageData =  self.storyImg.image?.jpegData(compressionQuality: 0.2) ?? Data()
               }
              else if size>50
               {
                imageData =  self.storyImg.image?.jpegData(compressionQuality: 0.5) ?? Data()
               }
                else
               {
                imageData =  self.storyImg.image?.jpegData(compressionQuality: 0.7) ?? Data()
               }
                
                */
                if Connectivity.isConnectedToInternet
                {
                    self.showLoader()
                    self.addPostApi(image1: self.dataImage1, image2: imageData2, data: data, fileType: self.comeFrom)
                } else {
                    self.hideLoader()
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
            }
            
            
            
        }
        
        
        func addPostApi(image1 : Data,image2 : Data, data: JSONDictionary,fileType:String)
        {
            APIManager.callApiForMultiImages(image1: image1,image2: image2, data: data, imageParaName1: ApiKey.kFile_name, imageParaName2: ApiKey.kThumbnail, api: "post-story",fileType: fileType,successCallback: {
                
                (responseDict) in
                debugPrint(responseDict)
                
                if  kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")
                {
                    self.hideLoader()
                    
                
                    let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)

                    destVC.delegate=self
                   // let cellData = self.MyHangoutData[sender.tag]
                   // self.hangout_id=cellData._id ?? ""
                    destVC.type = .ShareStory
                    destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                    if let tab = self.tabBarController
                    {
                        tab.present(destVC, animated: true, completion: nil)
                    }
                    else
                    {
                        self.present(destVC, animated: true, completion: nil)
                    }                    /*
                    if self.comeFrom == kVideo
                    {
                       
                        
                        /*
                        
                        self.openAlert(title: kAlert,message: kShareFacebookAlert,alertStyle: .alert,actionTitles: [kCancel,kYes],actionStyles: [.default, .default],
                                       actions: [
                                        {_ in
                                            
                                            if #available(iOS 13.0, *) {
                                                SCENEDEL?.navigateToStories()
                                            } else {
                                                // Fallback on earlier versions
                                                APPDEL.navigateToStories()
                                            }
                                        },
                                        { [self]_ in
                                            
                                          
                                            Indicator.sharedInstance.showIndicator()
                                                let content: ShareVideoContent = ShareVideoContent()
                                            
                                            DispatchQueue.main.async {
                                              
                                            self.createAssetURL(url: self.url) { (url) in
                                                Indicator.sharedInstance.showIndicator()
                                                let video = ShareVideo()
                                                video.videoURL = URL(string: url)//URL(string: url)
                                                                content.video = video
                                                    
                                                    let videoURLs = self.url!//Bundle.main.url(forResource: "video", withExtension: "mp4")!
                                                   let shareDialog = ShareDialog(fromViewController: self, content: content, delegate: nil)
                                               
                                                shareDialog.shareContent = content
                                                shareDialog.mode = .native
                                                shareDialog.delegate = self
                                               
                                           if (shareDialog.canShow)
                                            {
                                             
                                                    shareDialog.show()
                                            Indicator.sharedInstance.hideIndicator()
                                          
                                               
                                            } else {
                                                Indicator.sharedInstance.hideIndicator()
                                                        
                                                        self.openAlert(title: kAlert,message: kInstallFacebookAlert,alertStyle: .alert,actionTitles: [kOk],actionStyles: [.default],
                                                                       actions: [
                                                                        {_ in
                                                                            
                                                                            if #available(iOS 13.0, *) {
                                                                                
                                                                                SCENEDEL?.navigateToStories()
                                                                            } else {
                                                                                // Fallback on earlier versions
                                                                                APPDEL.navigateToStories()
                                                                            }
                                                                        }
                                                                        
                                                                       ])
                                                    }
                                                            
                                            }
                                            
                                        }

                                        }
                                       ])
                        
                        
                        
                        */
                        
                    }
                    else
                    {
                        self.openAlert(title: kAlert,message: kShareFacebookAlert,alertStyle: .alert,actionTitles: [kCancel,kYes],actionStyles: [.default, .default],
                                       actions: [
                                        {_ in
                                            
                                            if #available(iOS 13.0, *) {
                                                SCENEDEL?.navigateToStories()
                                            } else {
                                                // Fallback on earlier versions
                                                APPDEL.navigateToStories()
                                            }
                                        },
                                        { [self]_ in
                                            
                                            debugPrint("Yes click")
                                            let photo = SharePhoto(image: self.storyImg.image!, userGenerated: true)
                                            
                                            let content = SharePhotoContent()
                                            photo.caption=self.txtShare.text!
                                            
                                            content.photos = [photo]
                                            
                                            let showDialog = ShareDialog(fromViewController: self, content: content, delegate: nil)//(fromViewController: self, content: content, delegate: self)
                                            showDialog.delegate=self
                                            if (showDialog.canShow) {
                                                showDialog.show()
                                            } else {
                                                
                                                
                                                self.openAlert(title: kAlert,message: kInstallFacebookAlert,alertStyle: .alert,actionTitles: [kOk],actionStyles: [.default],
                                                               actions: [
                                                                {_ in
                                                                    
                                                                    if #available(iOS 13.0, *) {
                                                                        
                                                                        SCENEDEL?.navigateToStories()
                                                                    } else {
                                                                        // Fallback on earlier versions
                                                                        APPDEL.navigateToStories()
                                                                    }
                                                                }
                                                                
                                                               ])
                                            }
                                            
                                        }
                                       ])
                        
                        
                    }
                    
                    */
                }
                else
                {
                    self.hideLoader()
                    let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                    self.dismiss(animated: true) {
                   // self.openSimpleAlert(message: message)
                        
                        self.showNewErrorMessage(error: message)
                    }
                }
                
                
                
            },  failureCallback: { (errorReason, error) in
                self.dismiss(animated: true) {
                    self.hideLoader()
                    debugPrint(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                    self.navigationController?.popViewController(animated: true)
                }
               
            })
        }
        
    }
    extension ShareStoryVC:SharingDelegate
    {
        func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any])
        {
            debugPrint(#function)
            debugPrint(results)
            
//            if #available(iOS 13.0, *) {
//
//                SCENEDEL?.navigateToStories()
//            } else {
//                // Fallback on earlier versions
//                APPDEL.navigateToStories()
//            }
            self.hideLoader()
            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

            vc.selectedIndex=1
            DataManager.comeFrom=kShare
            self.appDelegate?.storyVisitCount=0
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        func sharer(_ sharer: Sharing, didFailWithError error: Error)
        {
            debugPrint(#function)
            
            debugPrint(error.localizedDescription)
//            if #available(iOS 13.0, *) {
//
//                SCENEDEL?.navigateToStories()
//            } else {
//                // Fallback on earlier versions
//                APPDEL.navigateToStories()
//            }
            
            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

            vc.selectedIndex=1
            DataManager.comeFrom=kShare
            self.appDelegate?.storyVisitCount=0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func sharerDidCancel(_ sharer: Sharing)
        {
            debugPrint(#function)
            
//            if #available(iOS 13.0, *) {
//
//                SCENEDEL?.navigateToStories()
//            } else {
//                // Fallback on earlier versions
//                APPDEL.navigateToStories()
//            }
            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

            vc.selectedIndex=1
            DataManager.comeFrom=kShare
            self.appDelegate?.storyVisitCount=0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func createAssetURL(url: URL, completion: @escaping (String) -> Void) {
         
           
    
                  let photoLibrary = PHPhotoLibrary.shared()
                  var videoAssetPlaceholder:PHObjectPlaceholder!
            DispatchQueue.main.async {
                  photoLibrary.performChanges({
                      Indicator.sharedInstance.showIndicator2()
                      let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                      videoAssetPlaceholder = request!.placeholderForCreatedAsset
                    
                  },
                      completionHandler: { success, error in
                          if success {
                            DispatchQueue.main.async {
                              let localID = NSString(string: videoAssetPlaceholder.localIdentifier)
                              let assetID = localID.replacingOccurrences(of: "/.*", with: "", options: NSString.CompareOptions.regularExpression, range: NSRange())
                              let ext = "mov"
                              let assetURLStr =
                              "assets-library://asset/asset.\(ext)?id=\(assetID)&ext=\(ext)"

                              completion(assetURLStr)
                                Indicator.sharedInstance.hideIndicator2()
                            }
                          }
                      
                        else
                          {
                              
                            Indicator.sharedInstance.hideIndicator2()
                          }
                  })
            }
              }
        
        
        
    }
    
extension ShareStoryVC:FeedbackAlertDelegate,deleteAccountDelegate
    {
        func FeedbackAlertOkFunc(name: String)
        {
            if name == kInstallFacebookAlert
         {
             
                let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

            vc.selectedIndex=1
             DataManager.comeFrom=kShare
                self.appDelegate?.storyVisitCount=0
            self.navigationController?.pushViewController(vc, animated: true)
         }
           
        
        }
    
    func showNewErrorMessage(error:String)
    {

        
        if error.contains(kRunningOut)
        {
           
            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
            vc.comeFrom = kRunningOut
            vc.message=error
            vc.messageTitle=kNumberofStories
            self.fromSetting=false
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
        else
        {
            self.openSimpleAlert(message: error)
        }
        
       
    }
    
    func deleteAccountFunc(name: String) {
        
        
        if name.equalsIgnoreCase(string: kRunningOut)
        {
        
            let destVC = NewPremiumVC.instantiate(fromAppStoryboard: .Account)
            destVC.type = .Story
            destVC.subscription_type=kStory
            destVC.popupShowIndex=2
          //  destVC.delegate=self
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
        else  if name == kCancel || self.fromSetting
        {
            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

            vc.selectedIndex=1
             DataManager.comeFrom=kShare
            self.appDelegate?.storyVisitCount=0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    }
