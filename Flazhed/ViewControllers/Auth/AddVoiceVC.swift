//
//  AddVoiceVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import CoreLocation
import SkeletonView

class AddVoiceVC: BaseVC {
    //MARK: - All outlets
    @IBOutlet weak var imgBackground: UIImageView!

    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var imgWave: UIImageView!
    @IBOutlet weak var imagePause: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnAudio: UIButton!
    @IBOutlet weak var viewAudioWave: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var lblHold: UILabel!
    @IBOutlet weak var viewRound: RoundedShadowView!
    //MARK: - All Variable
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    var audioData = Data()
    var mp4AudioUrl:URL?
    var imageArray1:[UIImage] = []
    var userName=""
    var userDOB=""
    var userGender=""
    let manager = CLLocationManager()
    var counter = 5
    var duration = 0
    var timer:Timer?
    var permissionCheck:Bool = false
    var permissionLocationCheck:Bool = false
    var comeFrom = ""
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.audioPlayer?.volume = 500
        self.btnFinish.isEnabled=false
        self.btnFinish.backgroundColor = DISABLECOLOR
        
        switch AVAudioSession.sharedInstance().recordPermission {
            
        case AVAudioSession.RecordPermission.granted:
            permissionCheck = true
            
        case AVAudioSession.RecordPermission.denied:
            permissionCheck = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted
                {
                    self.permissionCheck = true
                } else {
                    self.permissionCheck = false
                }
            })
        default:
            break
        }
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                debugPrint("No access")
                self.permissionLocationCheck=false
                //self.openSettings(message: kLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                debugPrint("Access")
                self.permissionLocationCheck=true
            @unknown default:
                break
            }
        } else {
            debugPrint("Location services are not enabled")
            self.permissionLocationCheck=false
            self.openSettings(message: PermissonType.kLocationEnable)
        }
        
        if let url = audioRecorder?.url
        {
            
            btnPlay.isEnabled=true
            btnDelete.isEnabled=true
            btnFinish.isEnabled=true
            btnAudio.isEnabled=false

            self.btnFinish.backgroundColor = ENABLECOLOR
            
            self.imgWave.image = UIImage(named: "wavepause")
            self.btnPlay.setTitleColor(PLAYCOLOR, for: .normal)
            self.btnDelete.setTitleColor(DELETECOLOR, for: .normal)
            
        }
        else
        {
            self.btnPlay.setTitleColor(PLAYDISABLECOLOR, for: .normal)
            self.btnDelete.setTitleColor(PLAYDISABLECOLOR, for: .normal)
            self.imagePause.image = UIImage(named: "wavepause")
            self.imgWave.isHidden=true
            self.imagePause.isHidden=false
            btnPlay.isEnabled=false
            btnDelete.isEnabled=false
            btnFinish.isEnabled=false
            btnAudio.isEnabled=true
            self.btnFinish.backgroundColor = DISABLECOLOR
        }
        
        self.lblTimer.isHidden=true
        
        setUpUI()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")

        self.tabBarController?.tabBar.isHidden = true
        manager.requestAlwaysAuthorization()
        manager.delegate = self
        manager.requestLocation()
        // manager.startMonitoringSignificantLocationChanges()        self.view.endEditing(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                debugPrint("No access")
                self.permissionLocationCheck=false
                //self.openSettings(message: kLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                debugPrint("Access")
                self.permissionLocationCheck=true
            @unknown default:
                break
            }
        } else {
            debugPrint("Location services are not enabled")
            self.permissionLocationCheck=false
            //self.openSettings(message: kLocation)
        }
        if self.permissionLocationCheck==false
        {
            self.openSettings(message: PermissonType.kLocationEnable)
        }
        
        
        
        if  self.mp4AudioUrl != nil
        {
            btnFinish.isEnabled = true
            self.btnFinish.backgroundColor = ENABLECOLOR
            self.audioPlayer?.stop()
            self.imgWave.isHidden=true
            self.imagePause.isHidden=false
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.audioPlayer?.stop()
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    //MARK: - backBtnAction
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -Delete audio action
    
    @IBAction func deleteAct(_ sender: UIButton)
    {
        self.audioPlayer?.stop()
        self.btnFinish.backgroundColor = ENABLECOLOR
        self.btnFinish.isEnabled=true
        self.imgWave.isHidden=true
        self.imagePause.isHidden=false
        
        let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
        vc.comeFrom = kAudio
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
    
    //MARK: - Record audio action
    
    @IBAction func recordAct(_ sender: UIButton)
    {
        self.lblTimer.isHidden=true
        debugPrint("Audio duration = \(duration)")
        self.convertCafToMP3()
        debugPrint("Stop recording")
        if self.duration>2
        {
            self.timer?.invalidate()
            audioRecorder?.stop()
            if  self.imagePause.image == UIImage(named: "wavepause")
            {
                
                
                if audioRecorder?.isRecording == false{
                    btnPlay.isEnabled=true
                    btnDelete.isEnabled=true
                    btnFinish.isEnabled=true
                    self.btnFinish.backgroundColor = ENABLECOLOR
                    btnAudio.isEnabled=false
                    self.imgWave.image = UIImage(named: "wavepause")
                    self.btnPlay.setTitleColor(PLAYCOLOR, for: .normal)
                    self.btnDelete.setTitleColor(DELETECOLOR, for: .normal)
                    audioRecorder?.stop()
                }
            }
        }
        else
        {
            self.timer?.invalidate()
            audioRecorder?.stop()
        }
    }
    //MARK: - Record audio action
    
    @IBAction func touchDownRecordAct(_ sender: UIButton) {
        
        if permissionCheck
        {
            self.audioSetup()
            debugPrint("Start recording")
            
            self.lblTimer.text = "00"+":05"
            self.lblTimer.isHidden=false
            self.duration=1
            self.counter=5
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            audioRecorder?.record()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                self.audioRecorder?.stop()
            }
        }
        else
        {
            self.openSettings(message: PermissonType.kMicrophoneEnable)//"Please enable the audio permission from the settings.")
        }
    }
    
    //MARK: - Stop audio action
    
    @IBAction func touchDragExitRecordAct(_ sender: UIButton) {
        debugPrint("Stop recording")
        self.convertCafToMP3()
        debugPrint("Audio duration = \(duration)")
        self.lblTimer.isHidden=true
        self.timer?.invalidate()
        
        audioRecorder?.stop()
        if self.duration>2
        {
            
            if  self.imgWave.image == UIImage(named: "wavepause")
            {
                
                
                if audioRecorder?.isRecording == false{
                    btnPlay.isEnabled=true
                    btnDelete.isEnabled=true
                    btnFinish.isEnabled=true
                    self.btnFinish.backgroundColor = ENABLECOLOR
                    btnAudio.isEnabled=false
                    self.imgWave.image = UIImage(named: "wavepause")
                    self.btnPlay.setTitleColor(PLAYCOLOR, for: .normal)
                    self.btnDelete.setTitleColor(DELETECOLOR, for: .normal)
                    audioRecorder?.stop()
                }
            }
        }
    }
    
    //MARK: - Play audio action
    @IBAction func playAct(_ sender: UIButton)
    {
        sender.isUserInteractionEnabled=false
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
        
        autoreleasepool {
            
            self.imgWave.contentMode = .scaleToFill
    
            self.audioRecorder?.stop()
            if audioRecorder?.isRecording == false
            {
                
                var error : NSError?
                do {
                    let player = try AVAudioPlayer(contentsOf: audioRecorder!.url)
                    self.audioPlayer = player
                    
                } catch {
                    sender.isUserInteractionEnabled=true
                    debugPrint(error)
                }
                
                
                
                
                self.audioPlayer?.delegate = self
                
                if let err = error{
                    debugPrint("audioPlayer error: \(err.localizedDescription)")
                    sender.isUserInteractionEnabled=true
                }else{
                    
                    self.audioPlayer?.play()
                    
                    imgWave.loadingGif(gifName: "wave-GIF")
                    self.imgWave.isHidden=false
                    self.imagePause.isHidden=true
                    sender.isUserInteractionEnabled=true
                }
            }
        }
    }
    
    //MARK: - Call api and move other screen action
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        
        
        self.audioPlayer?.stop()
        self.btnFinish.isEnabled = true
        self.btnFinish.backgroundColor = ENABLECOLOR
        self.imgWave.isHidden=true
        self.imagePause.isHidden=false
        
        if self.comeFrom.equalsIgnoreCase(string: kEditProfile)
        {
            
            if let url = self.mp4AudioUrl
            {
                DataManager.audioURL=url.absoluteString
            }
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            var data = JSONDictionary()
            data[ApiKey.kDOB] = self.userDOB
            data[ApiKey.kTimezone] = TIMEZONE
            
            data[ApiKey.kLatitude] = "\(CURRENTLAT)"
            data[ApiKey.kLongitude] = "\(CURRENTLONG)"
            data[ApiKey.kUsername] = self.userName
            data[ApiKey.kGender] = self.userGender
            //images
            //voice
            
            debugPrint("Paramets = \(data)")
            var imageDataArray = [Data]()
            var audioData = Data()
            if let url = self.mp4AudioUrl//audioRecorder?.url
            {
                
                do{
                    
                    audioData = try Data(contentsOf: url)
                    
                    
                }catch{
                    debugPrint("Unable to load audioData: \(error)")
                }
            }
            
            
            
            if CLLocationManager.locationServicesEnabled()
            {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    debugPrint("No access")
                    self.permissionLocationCheck=false
                    //self.openSettings(message: kLocation)
                case .authorizedAlways, .authorizedWhenInUse:
                    debugPrint("Access")
                    self.permissionLocationCheck=true
                @unknown default:
                    break
                }
            } else {
                debugPrint("Location services are not enabled")
                self.permissionLocationCheck=false
                //self.openSettings(message: kLocation)
            }
            
            
            
            
            
            if self.permissionLocationCheck==false
            {
                self.openSettings(message: PermissonType.kLocationEnable)
            }
            else
            {
                
                for image in self.imageArray1 {
                    imageDataArray.append(image.jpegData(compressionQuality: 0.7)!)
                }
                if Connectivity.isConnectedToInternet {
                    self.showLoader()
                    self.uploadApi(image: imageDataArray, data: data, AudioData: audioData)
                    
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
                
                
            }
        }
    }
    //MARK: - Stop Recording
    
    @objc func StopRecording()
    {
        debugPrint(#function)
        
        audioRecorder?.stop()
        if  self.imgWave.image == UIImage(named: "wavepause")
        {
            
            
            if audioRecorder?.isRecording == false{
                btnPlay.isEnabled=true
                btnDelete.isEnabled=true
                btnFinish.isEnabled=true
                btnAudio.isEnabled=false
                self.imgWave.image = UIImage(named: "wavepause")
                self.btnPlay.setTitleColor(PLAYCOLOR, for: .normal)
                self.btnDelete.setTitleColor(DELETECOLOR, for: .normal)
                
                
                audioRecorder?.stop()
            }
        }
    }
    
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        if self.getDeviceModel() == "iPhone 6"
        {
            sendButtonConst.constant = keyboardHeight+26
        }
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+20
        }
        
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
    }
    
    //MARK: - Timer show
    
    @objc func updateCounter() {
        
        if counter > 0 {
            debugPrint("\(counter) seconds")
            counter -= 1
            self.duration += 1
            self.lblTimer.text = "00:0"+"\(counter)"//+"0"
        }
        else
        {
            self.lblTimer.text = "00:00"
            self.timer?.invalidate()
            audioRecorder?.stop()
            if  self.imagePause.image == UIImage(named: "wavepause")
            {
                if audioRecorder?.isRecording == false{
                    btnPlay.isEnabled=true
                    btnDelete.isEnabled=true
                    btnFinish.isEnabled=true
                    btnAudio.isEnabled=false
                    self.imgWave.image = UIImage(named: "wavepause")
                    self.btnPlay.setTitleColor(PLAYCOLOR, for: .normal)
                    self.btnDelete.setTitleColor(DELETECOLOR, for: .normal)
                    audioRecorder?.stop()
                }
            }
            self.lblTimer.isHidden=true
            self.timer?.invalidate()
            self.audioRecorder?.stop()
            if  self.imgWave.image == UIImage(named: "wavepause")
            {
                
                
                if audioRecorder?.isRecording == false{
                    
                    btnPlay.isEnabled=true
                    btnDelete.isEnabled=true
                    btnFinish.isEnabled=true
                    btnAudio.isEnabled=false
                    self.imgWave.image = UIImage(named: "wavepause")
                    self.btnPlay.setTitleColor(PLAYCOLOR, for: .normal)
                    self.btnDelete.setTitleColor(DELETECOLOR, for: .normal)
                    audioRecorder?.stop()
                }
            }
        }
        
    }
    
    //MARK: - Setup UI
    
    func setUpUI()
    {
        btnFinish.isEnabled=false
        btnAudio.isEnabled=true
        self.btnFinish.setTitle(self.btnFinish.titleLabel?.text?.uppercased(), for: .normal)
        self.btnFinish.setTitle(self.btnFinish.titleLabel?.text?.uppercased(), for: .selected)
    }
    
    func showLoader()
    {
        
        Indicator.sharedInstance.showIndicator3(views: [self.viewAudioWave,self.btnPlay,self.btnDelete,self.viewRound,self.btnFinish,self.lblHold])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.viewAudioWave,self.btnPlay,self.btnDelete,self.viewRound,self.btnFinish,self.lblHold])
        
    }
    
    //MARK: - Setup Audio
    
    func audioSetup()
    {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docDir = dirPath[0]
        let soundFilePath = (docDir as NSString).appendingPathComponent("sound.caf")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        debugPrint(soundFilePath)
        
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                                   AVEncoderBitRateKey: 16,
                                AVNumberOfChannelsKey : 2,
                                       AVSampleRateKey: 44100.0] as [String : Any] as [String : Any] as [String : Any] as [String : Any]
        var error : NSError?
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            
            try? audioSession.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
            
            
            
            audioRecorder = try AVAudioRecorder(url: soundFileURL as URL, settings: recordSettings as [String : AnyObject])
            
            audioRecorder?.record(forDuration: 6)
            
            
        } catch _ {
            debugPrint("Error")
        }
        
        if let err = error {
            debugPrint("audioSession error: \(err.localizedDescription)")
        }else{
            audioRecorder?.prepareToRecord()
        }
    }
    //MARK: - Convert Audio to Mp3
    
    func convertCafToMP3()
    {
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                       in: .userDomainMask)
        
        let outputUrl = dirPaths[0].appendingPathComponent("audiosound.mp4")
        
        if let url = audioRecorder?.url
        {
            let asset = AVAsset.init(url: url)
            
            let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)
            
            // remove file if already exits
            let fileManager = FileManager.default
            do{
                try? fileManager.removeItem(at: outputUrl)
                
            }catch{
                debugPrint("can't")
            }
            
            
            exportSession?.outputFileType = .mp4
            
            exportSession?.outputURL = outputUrl
            
            exportSession?.metadata = asset.metadata
            
            exportSession?.exportAsynchronously(completionHandler: {
                if (exportSession?.status == .completed)
                {
                    debugPrint("AV export succeeded.")
                    self.mp4AudioUrl=outputUrl
                    // outputUrl to post Audio on server
                    
                    debugPrint("mp3 url = \(outputUrl)")
                }
                else if (exportSession?.status == .cancelled)
                {
                    debugPrint("AV export cancelled.")
                }
                else
                {
                    print ("Error is \(String(describing: exportSession?.error))")
                    
                }
            })
        }
    }
    
    
    
}

//MARK: - Complete profile Api Call  

extension AddVoiceVC
{
    func uploadApi(image : [Data], data: JSONDictionary,AudioData:Data)
    {
        Indicator.sharedInstance.showIndicator()
        
        let urlString =  BASE_URL.appending("complete-profile")
        
        let headers: HTTPHeaders = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in data {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
                    
                    if let temp = value as? Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                        
                    }
                    
                    if let temp = value as? NSArray
                    {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                if  !AudioData.isEmpty
                {
                    multipartFormData.append(AudioData, withName: "voice", fileName: "voice.mp3", mimeType: "mp3/mp4")
                }
                
                for img in image
                {
                    multipartFormData.append(img, withName: "images", fileName: "images.png", mimeType: "jpeg/jpg/png")
                }
                
            },
            to: urlString, //URL Here
            method: .post,
            headers: headers)
            .responseJSON { (resp) in
                
                debugPrint("resp is \(resp)")
                if let status = (resp.value as? NSDictionary)?.value(forKey: "status") as? String
                {
                    self.hideLoader()
                    
                    if status.equalsIgnoreCase(string: "success")
                    {
                        Indicator.sharedInstance.hideIndicator()
                        
                        let vc = GetStartedVC.instantiate(fromAppStoryboard: .Main)
                        
                        OnBoardingVM.shared.parseUpdateProfileData(response: resp.value as! JSONDictionary)
                        if let img = OnBoardingVM.shared.loginUserDetail?.profile_data?.image
                        {
                            DataManager.userImage=img
                        }
                        DataManager.isProfileCompelete=true
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        Indicator.sharedInstance.hideIndicator()
                        self.openSimpleAlert(message: (resp.value as? NSDictionary)?.value(forKey: "message") as? String)
                    }
                    
                }
                else
                {
                    self.hideLoader()
                    Indicator.sharedInstance.hideIndicator()
                }
                
            }
    }
    
    
}

extension  AddVoiceVC:deleteAccountDelegate
{
    func deleteAccountFunc(name: String) {
        
        
        if name.equalsIgnoreCase(string: kAudio)
        {
            self.audioRecorder?.stop()
            self.btnPlay.isEnabled=false
            self.btnDelete.isEnabled=false
            self.imgWave.image = UIImage(named: "wavepause")
            self.btnFinish.isEnabled=false
            self.btnFinish.backgroundColor = DISABLECOLOR
            self.btnAudio.isEnabled=true
            self.btnPlay.setTitleColor(PLAYDISABLECOLOR, for: .normal)
            self.btnDelete.setTitleColor(PLAYDISABLECOLOR, for: .normal)
            self.imgWave.isHidden=true
            self.imagePause.isHidden=false
            self.mp4AudioUrl=nil
            
            self.btnPlay.isEnabled=false
            
            
        }
    }
    
}


//MARK: - Audio record delegate method 

extension AddVoiceVC:AVAudioPlayerDelegate, AVAudioRecorderDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        debugPrint("audioPlayerDidFinishPlaying \(player)= \(flag)")
        if  self.mp4AudioUrl != nil
        {
            btnFinish.isEnabled = true
            self.btnFinish.backgroundColor = ENABLECOLOR
            self.imgWave.isHidden=true
            self.imagePause.isHidden=false
        }
        //stopButton.isEnabled = false
    }
    
    private func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!)
    {
        debugPrint("Audio Play Decode Error \(error.localizedDescription)")
        debugPrint(#function)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        debugPrint(#function)
        
        
    }
    
    private func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        debugPrint("Audio Record Encode Error")
        debugPrint("\(error.localizedDescription)")
    }
}

//MARK: - Get current location 

extension AddVoiceVC: CLLocationManagerDelegate
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

