//
//  VideoCallingVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit
import AgoraRtcKit
import AgoraRtmKit
import CallKit
import PushKit

class VideoCallingVC: BaseVC {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var backBUtton: UIButton!
    @IBOutlet weak var decliineButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    @IBOutlet weak var viewRemote: UIView!
    @IBOutlet weak var viewLocal: UIView!
    
    let dateFromatter = DateFormatter()
    var userName = ""
    var profileImageUrl = ""
    var Other_user_id = ""
    var self_user_id = ""
    var comeFrom = ""
    var agoraChannelName = ""
    var agoraChannelUID = ""
    var agoraToken = ""
    var chat_room_id = ""
    var from_user_id = ""
    var view_user_id = ""
    var Agora_Rtm_Token = ""
    var fromDeclienCall=false
    
    var localView: UIView!
    var remoteView: UIView!
    var agoraKit: AgoraRtcEngineKit?
    var agoraRtmKit: AgoraRtmKit?
    // CallKit components
    var callKitProvider: CXProvider?
    var callKitCallController: CXCallController?
    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
    var userInitiatedDisconnect: Bool = false
    
    var accessToken = ""
    
    var timer: Timer?
    var totalTime = 0

    
    var callUuid = UUID()
    
    var callManager: CallKitManager?
    
    // var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    var callConnected = false
    
    var isOutgoingCall = false
    
    var needToPrepareLocalMedia = false
    
    var onRenderCallParticipant = {
        
    }
    private var soundId = SystemSoundID()

    private lazy var appleCallKit = CallCenter(delegate: self)
    private var ringStatus: Operation = .off {
        didSet {
            guard oldValue != ringStatus else {
                return
            }
            
            switch ringStatus {
            case .on:  startPlayRing()
            case .off: stopPlayRing()
            }
        }
    }
    var callTimer:Timer?
    var uid_publish = ""
    var uid_subscriber = ""
    var call_max_duration=30
    var alreadySentMessage=false
    var alreadyPop=false

    var totalSecond = Double()
    var timerCallDuration:Timer?
    var callDuration=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decliineButton.isEnabled=false
        self.UISetup()

        
        if self.comeFrom.equalsIgnoreCase(string: kMessage)
        {
           
            if Connectivity.isConnectedToInternet {
                
                self.lblTitle.text = kCalling
                self.callApiToSendVideocallNotification()
                
                callTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                totalTime = 1
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
            
            
        }
        else
        {
            
            if Connectivity.isConnectedToInternet {
               
                    
                    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                        // Already Authorized
                        self.initializeAgoraEngine()
                        callTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                        totalTime = 1
                    } else {
                        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                           if granted == true {
                               // User granted
                            self.initializeAgoraEngine()
                            self.callTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                            self.totalTime = 1
                           } else {
                               // User rejected
                            self.openSettings(message: kCameraAndMicrophonePermission)
                           }
                       })
                    }
                   
               
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.CallDisconnectedNotification(notification:)), name: Notification.Name("CallDisconnectedNotification"), object: nil)
        
        dateFromatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        dateFromatter.calendar = CALENDER
        dateFromatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
       // dateFromatter.timeZone = TimeZone.current
       // dateFromatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            debugPrint("Date \(Date())")
            self.decliineButton.isEnabled=true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.alreadySentMessage=false
    
            self.alreadyPop=false
       
        self.callConnected = false
        self.speakerButton.isSelected=true
        self.lblUserName.text=userName
        // self.imgUser.image=userImage
        self.backBUtton.isHidden=false
        self.fromDeclienCall=false
        
        //self.decliineButton.isEnabled=true
        
        if self.profileImageUrl != ""
        {
            
            let url = URL(string: self.profileImageUrl)!
            self.imgUser.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
            
        }
        
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height/2
        self.imgUser.contentMode = .scaleAspectFill
        self.lblUserName.isHidden=false
        self.imgUser.isHidden=false
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
       
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
               if granted == true {
                   // User granted
              
               } else {
                   // User rejected
                self.openSettings(message: kCameraAndMicrophonePermission)
               }
           })
        }
        
        self.tabBarController?.tabBar.isHidden = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        AgoraRtcEngineKit.destroy()
        self.leaveChannel()
        self.timerCallDuration?.invalidate()
        ringStatus = .off
        self.tabBarController?.tabBar.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        
    }
    
    func UISetup()
    {
        self.videoCallButton.layer.cornerRadius = self.videoCallButton.frame.height/2
        self.muteButton.layer.cornerRadius = self.muteButton.frame.height/2
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: getStatusBarHeight()))
        statusView.backgroundColor = UIColor.white
         self.view.addSubview(statusView)
        
        //  NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedCallEndNotification(notification:)), name: Notification.Name("CallEndNotificationIdentifier"), object: nil)
        self.muteButton.isSelected=true
        self.videoCallButton.isSelected=true
        self.agoraKit?.muteLocalVideoStream(true)
        
        self.muteButton.backgroundColor = PURPLECOLOR//LINECOLOR
        self.videoCallButton.backgroundColor = PURPLECOLOR//LINECOLOR
    }
  
    
  
    func initializeAgoraEngine()
    {
       self.agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AGORA_APP_ID, delegate: self)
        setupLocalVideo()
        joinChannel()
    }
    
    func setupLocalVideo() {
        // Enables the video module
        self.agoraKit?.enableVideo()
        //agoraKit?.adjustAudioMixingPlayoutVolume(80)
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            videoCanvas.view = self.viewLocal
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
               if granted == true {
                   // User granted
                videoCanvas.view = self.viewLocal
               } else {
                   // User rejected
               // self.openSettings(message: "Please enable the microphone permission from the settings.")
               }
           })
        }
        //localView
        // Sets the local video view
        
        self.agoraKit?.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,frameRate: .fps15,bitrate: AgoraVideoBitrateStandard,orientationMode: .adaptative))
        
        self.agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    func joinChannel()
    {
        
        debugPrint("Agora details = ")
        debugPrint("AGORA_APP_ID ", AGORA_APP_ID)
        debugPrint("AGORA_TOKEN",agoraToken)
        debugPrint("AGORA_CHANEL_NAME",agoraChannelName)
        debugPrint("AGORA_CHANEL_UID",agoraChannelUID)
        
        self.agoraKit?.joinChannel(byToken: agoraToken, channelId: agoraChannelName, info: nil, uid: UInt(agoraChannelUID) ?? 0, joinSuccess: { [weak self] (channel, uid, elapsed) in
            
            debugPrint("Join chanel \(channel) \(uid) \(elapsed)")
            if let weakSelf = self {
                weakSelf.agoraKit?.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled = true
            }
        })
    }
    
    @objc func update()
    {
        
        self.totalTime = self.totalTime+1
        debugPrint("Total time = \(self.totalTime)")
        if self.comeFrom.equalsIgnoreCase(string: kMessage)
        {
           
            if self.totalTime>30
            {
                if self.callConnected==false
                {
                   
                    
                    let message = "\(kCallTry) video call \(userName.capitalized) at \(Date().CurrentTimeString())"
                    self.sendMessage(message: message)
                    
                }
                self.backAct()
            }
        }
        else{
            if self.totalTime>1
            {
               // self.backAct()
            }
        }
        
        
    }
    

    @objc func countdown() {
//        var hours: Int
//        var minutes: Int
//        var seconds: Int
        
        if totalSecond == 0.0 {
            timer?.invalidate()
        }
        totalSecond = totalSecond + 1.0
      //  hours = totalSecond / 3600.0
       // minutes = (totalSecond % 3600.0) / 60.0
       // seconds = (totalSecond % 3600.0) % 60.0
        self.callDuration = totalSecond.printSecondsToHoursMinutesSeconds()
        
        //MARK: - For testing purpose
        /*
        if ((Double(totalSecond)) >= Double((self.call_max_duration*60))) //((Double(totalSecond)) >= Double((2*60))) //
        {
            if self.comeFrom.equalsIgnoreCase(string: kMessage)  && self.callConnected==false
            {
                let message = "\(kCallTry) video call \(userName.capitalized) at \(Date().CurrentTimeString())"
                self.sendMessage(message: message)
                self.backAct()
            }
            else if self.callConnected
            {
                let message = "\(kVideoSession) \(userName.capitalized) at \(Date().CurrentTimeString()) for \(self.callDuration)"

                self.sendMessage(message: message)
                self.backAct()
            }
            else
            {
                self.backAct()
            }
        }
        
        */
        
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.callTimer?.invalidate()
        DataManager.comeFrom = kViewProfile
        
        if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
        {
            
//            let vc = OldTapControllerVC.instantiate(fromAppStoryboard: .Main)
//            vc.selectedIndex=3
//            DataManager.comeFrom = kEmptyString
//            if !self.alreadyPop
//            {
//                self.alreadyPop=true
//                self.navigationController?.popViewController(animated: true)
//            }
            self.goToChat()
        }
        else
        {
            if !self.alreadyPop
            {
                self.alreadyPop=true
                self.navigationController?.popViewController(animated: true)
            }
           
        }
    }
    
    @IBAction func declineCallButtonAction(_ sender: UIButton) {
        self.fromDeclienCall=true
        self.decliineButton.isEnabled=false
        
        if self.comeFrom.equalsIgnoreCase(string: kMessage)  && self.callConnected==false
        {
            let message = "\(kCallTry) video call \(userName.capitalized) at \(Date().CurrentTimeString())"
            self.sendMessage(message: message)
            self.backAct()
        }
        else if self.callConnected
        {
            let message = "\(kVideoSession) \(userName.capitalized) at \(Date().CurrentTimeString()) for \(self.callDuration)"

            self.sendMessage(message: message)
            self.backAct()
        }
        else
        {
            self.backAct()
        }
        
    
       
        
       
    }
    
    @IBAction func speakerBtnAct(_ sender: UIButton)
    {
        sender.isSelected.toggle()
        self.agoraKit?.switchCamera()
        
        /*
         if sender.isSelected
         {
         sender.isSelected=false
         
         self.agoraKit?.setVolumeOfEffect(.zero, withVolume: 0)
         
         //self.speakerButton.backgroundColor = UIColor.lightGray
         self.speakerButton.setBackgroundImage(nil, for: .normal)
         }
         else
         {
         sender.isSelected=true
         self.agoraKit?.adjustRecordingSignalVolume(1)
         self.agoraKit?.setVolumeOfEffect(.max, withVolume: 100)
         //self.speakerButton.backgroundColor = LINECOLOR
         
         self.speakerButton.setBackgroundImage(UIImage(named: "speaker"), for: .selected)
         }
         
         do {
         
         let audioSession = AVAudioSession.sharedInstance()
         
         if(sender.isSelected) {
         try audioSession.setMode(AVAudioSession.Mode.videoChat)
         } else {
         try audioSession.setMode(AVAudioSession.Mode.voiceChat)
         }
         
         } catch {
         debugPrint("Fail: \(error.localizedDescription)")
         }
         
         */
    }
    
    @IBAction func VideoCallAct(_ sender: UIButton)
    {
        
        self.agoraKit?.muteLocalVideoStream(sender.isSelected)
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            self.videoCallButton.backgroundColor = PURPLECOLOR//LINECOLOR
            self.viewLocal.isHidden=false
        }
        else
        {
            self.videoCallButton.backgroundColor = UIColor.clear
            self.viewLocal.isHidden=true
        }
        
    }
    @IBAction func mutAct(_ sender: UIButton)
    {
        
        self.agoraKit?.muteLocalAudioStream(sender.isSelected)
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            self.muteButton.backgroundColor = PURPLECOLOR//LINECOLOR
        }
        else
        {
            self.muteButton.backgroundColor = UIColor.clear
        }
        
        
    }
    
  
    
    func backAct()
    {
       
        self.ringStatus = .off
        self.view.makeToast(kCallDisConnected, point: CGPoint(x: SCREENWIDTH/2, y: SCREENHEIGHT/2), title: nil, image: nil) { _ in
            DataManager.comeFrom = kViewProfile
            if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
            {
                
//                let vc = OldTapControllerVC.instantiate(fromAppStoryboard: .Main)
//
//                vc.selectedIndex=3
//                DataManager.comeFrom = kEmptyString
//                self.navigationController?.pushViewController(vc, animated: false)
                self.goToChat()
            }
            else
            {
                self.navigationController?.popViewController(animated: false)
            }
       }
        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }
        
        inviter.cancelLastOutgoingInvitation()
        inviter.refuseLastIncomingInvitation {  [weak self] (error) in
           // self?.openSimpleAlert(message: error.localizedDescription)
            debugPrint(error.localizedDescription)
        }
       
        self.leaveChannel()
        self.callTimer?.invalidate()
        self.timerCallDuration?.invalidate()

        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

       
        
    }
    
    @objc func CallDisconnectedNotification(notification: Notification) {
        debugPrint("RTM notification call \(notification)")
        
        if self.comeFrom.equalsIgnoreCase(string: kMessage) && fromDeclienCall==false
        {
        
        if self.comeFrom.equalsIgnoreCase(string: kMessage)  && self.callConnected==false
        {
            let message = "\(kCallTry) video call \(userName.capitalized) at \(Date().CurrentTimeString())"
            self.sendMessage(message: message)
            self.backAct()
        }
        else if self.callConnected
        {
            let message = "\(kVideoSession) \(userName.capitalized) at \(Date().CurrentTimeString()) for \(self.callDuration)"

            self.sendMessage(message: message)
            self.backAct()
        }
        else
        {
            self.backAct()
        }
        }
        else
        {
            self.backAct()
        }
        
        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

    }
}




// In ViewController.swift, ensure that you add the following code outside class ViewController: UIViewController
extension VideoCallingVC: AgoraRtcEngineDelegate
{
    // Monitors the didJoinedOfUid callback
    // The SDK triggers the callback when a remote user joins the channel
    
    
    //MARK: - Other user join
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int)
    {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.renderMode = .hidden
//        videoCanvas.view = self.viewRemote//remoteView
//        // Sets the remote video view
//        self.agoraKit?.setupRemoteVideo(videoCanvas)
//
//        self.lblUserName.isHidden=true
//        self.imgUser.isHidden=true
//        ringStatus = .off
//        self.callConnected=true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
//        self.lblTitle.text = kEmptyString
//        self.backBUtton.isHidden=true
//        }
//        self.callTimer?.invalidate()
//
        debugPrint(#function)
        debugPrint("didJoinedOfUid = \(uid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int)
    {
        
        self.timerCallDuration = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        debugPrint(#function)
        debugPrint("firstRemoteVideoDecodedOfUid uid = \(uid)")
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = self.viewRemote//remoteView
        // Sets the remote video view
        self.agoraKit?.setupRemoteVideo(videoCanvas)
        
        self.lblUserName.isHidden=true
        self.imgUser.isHidden=true
        ringStatus = .off
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.callConnected=true
        self.lblTitle.text = kEmptyString
        self.backBUtton.isHidden=true
        }
        self.callTimer?.invalidate()
        self.lblTitle.text = kEmptyString
        self.backBUtton.isHidden=true
        debugPrint(#function)
        debugPrint("didJoinedOfUid = \(uid)")
       
        
    
        self.showToastMessage(kCallConnected)
    }
    
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        debugPrint(#function)
        debugPrint("stat = \(stats)")
        
        self.lblUserName.isHidden=false
        self.imgUser.isHidden=false
       // self.showToastMessage(kCallDisConnected)
        self.backAct()
        
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        debugPrint(#function)
        debugPrint("AgoraUserOfflineReason = \(reason.rawValue)")
       
        
        
        if self.callConnected
       {
           let message = "\(kVideoSession) \(userName.capitalized) at \(Date().CurrentTimeString()) for \(self.callDuration)"
           
           self.sendMessage(message: message)
       }
//        let sub = Int(self.uid_subscriber) ?? 0
//        let pub = Int(self.uid_publish) ?? 0
//        debugPrint("uid list  1 = \(self.uid_subscriber)  2=== \(self.uid_publish) 3==== \(uid)")
        self.backAct()
        
//        if ((uid == sub) || (uid == pub))
//       {
//            self.backAct()
//       }
    
    }
    
    
    func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineTranscodingUpdated(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    func rtcEngineCameraDidReady(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    func rtcEngineVideoDidStop(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
        debugPrint("callConnected = \(self.callConnected)")
        
        if self.callConnected == false
        {
            ringStatus = .off
            if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
            {
                
//                let vc = OldTapControllerVC.instantiate(fromAppStoryboard: .Main)
//
//                vc.selectedIndex=3
//                DataManager.comeFrom = kEmptyString
//                self.navigationController?.pushViewController(vc, animated: true)
                self.goToChat()
            }
            else
            {
                self.navigationController?.popViewController(animated: true)
            }
            DataManager.comeFrom = kViewProfile
            
        }
        
    }
    func rtcEngineConnectionDidBanned(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineMediaEngineDidLoaded(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineMediaEngineDidStartCall(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineLocalAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineRemoteAudioMixingDidStart(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    
    func rtcEngineRemoteAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine)")
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine) \(enabled)")
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine) \(speakerUid)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        debugPrint(#function)
        //        self.initializeAgoraEngine()
        debugPrint("\(engine) = \(engine) \(errorCode.rawValue)")
        debugPrint("didOccurError error code = \(errorCode.rawValue)")
    
        
//        if errorCode.rawValue == 17
//        {
//            self.backAct()
//        }
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine) \(muted) \(uid)")
        if muted
        {
            self.lblUserName.isHidden=false
            self.imgUser.isHidden=false
            self.viewRemote.isHidden=true
        }
        else
        {
            self.lblUserName.isHidden=true
            self.imgUser.isHidden=true
            self.viewRemote.isHidden=false
        }
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRegisteredLocalUser userAccount: String, withUid uid: UInt) {
        debugPrint(#function)
        debugPrint("\(engine) = \(engine) \(userAccount)")
    }
    
    // ViewController.swift
    
    func leaveChannel() {
        self.agoraKit?.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
        self.agoraKit = nil
        ringStatus = .off
    }
    
    
}



// MARK:- Extension Api Calls
extension VideoCallingVC
{
    
    func callApiToSendVideocallNotification()
    {
        //Call sender = publisher, call receiver = kSubscriber
        
        var data = JSONDictionary()
        data[ApiKey.kTo_user_id] = self.Other_user_id
        data[ApiKey.kCall_type] = kVideo
        data[ApiKey.kRole_type] = kPublisher//kPublisher//kSubscriber
        if Connectivity.isConnectedToInternet {
            
            self.sendNotificationApi(data: data, ShowIndicator: false)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }
    func sendNotificationApi(data:JSONDictionary,ShowIndicator: Bool)
    {
        ChatVM.shared.callApiAudioVideoCallNotification(ShowIndicator: ShowIndicator,data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage2(error: error)
            }
            else
            {
                if self.comeFrom.equalsIgnoreCase(string: kMessage)
                {
                    self.ringStatus = .on
                }
                
                self.agoraToken=ChatVM.shared.Audio_video_calling_data?.rtc_token_publish ?? ""
                self.agoraChannelName = ChatVM.shared.Audio_video_calling_data?.chanel_name ?? ""
                self.agoraChannelUID = ChatVM.shared.Audio_video_calling_data?.uid_publish ?? "0"
                
                self.Agora_Rtm_Token = ChatVM.shared.Audio_video_calling_data?.rtmToken_publisher ?? ""
                
                debugPrint("RTM token = \(self.Agora_Rtm_Token)")

                self.Agora_RTM_Setup()
                
                self.initializeAgoraEngine()
            }
            
        })
    }
    
    //MARK: - AGORA RTM setup
    
    func Agora_RTM_Setup()
    {
       // agoraRtmKit = AgoraRtmKit.init(appId: AGORA_APP_ID, delegate: self)
      
        let rtm = AgoraRtm.shared()
      //  let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/rtm.log"
       // rtm.setLogPath(path)
        rtm.inviterDelegate = self
        guard let kit = AgoraRtm.shared().kit else {
            
           // self.openSimpleAlert(message: "AgoraRtmKit nil")
            return
        }
        debugPrint("self.from_user_id = \(self.self_user_id)")
        kit.login(account: self.self_user_id, token: self.Agora_Rtm_Token) { [unowned self] (error) in
        
            debugPrint("Rtm login error \(error)")
            
//            if let inviter = AgoraRtm.shared().inviter  {
//                inviter.sendInvitation(peer: self.Other_user_id)
//            }
            
           // self.openSimpleAlert(message: error.localizedDescription)
            
        }
        if let inviter = AgoraRtm.shared().inviter  {
            inviter.sendInvitation(peer: self.Other_user_id)
        }
       
    }
    
    func getTokenApi()
    {
        ChatVM.shared.callApi_RTM_Token_Generate(response: { (message, error) in
            if error != nil
            {
                //self.showErrorMessage(error: error)
            }
            else
            {
                let rtmToken = ChatVM.shared.Rtm_token
                
                debugPrint("RTM token = \(rtmToken)")
                self.agoraRtmKit?.login(byToken: rtmToken, user: self.self_user_id, completion: { (error) in
                    debugPrint("Error in login \(error.rawValue)")
                })
                
                
                self.initializeAgoraEngine()
            }
            
        })
    }
    
    
}

extension VideoCallingVC:AgoraRtmDelegate{
    
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason)
    {
        debugPrint(#function)
        debugPrint("\(reason) = \(state)")
    }
    
    func rtmKit(_ kit: AgoraRtmKit, peersOnlineStatusChanged onlineStatus: [AgoraRtmPeerOnlineStatus])
    {
        debugPrint(#function)
        debugPrint(" = \(onlineStatus)")
    }
}
extension VideoCallingVC
{
    
    func startPlayRing() {
        if let path = Bundle.main.path(forResource: "ring", ofType: "mp3")
        {
            let url = URL.init(fileURLWithPath: path)
            AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
            
            AudioServicesAddSystemSoundCompletion(soundId,
                                                  CFRunLoopGetMain(),
                                                  nil, { (soundId, context) in
                                                    AudioServicesPlaySystemSound(soundId)
                                                  }, nil)
            
            AudioServicesPlaySystemSound(soundId)
        }
    }
    
    func stopPlayRing() {
        AudioServicesDisposeSystemSoundID(soundId)
        AudioServicesRemoveSystemSoundCompletion(soundId)
    }
}
enum Operation {
    case on, off
}
//MARK: - Send message

extension VideoCallingVC
{
    
    func sendMessage(message:String=Date().CurrentTimeString())
    {
        if Connectivity.isConnectedToInternet {
            
           if  !self.alreadySentMessage
            {
            let now = Date()
            let dateInString = dateFromatter.string(from: now)
           // \(Date().CurrentTimeString()
            
               self.alreadySentMessage=true
            
            let dict2 = ["timezone":TIMEZONE,"chat_room_id":self.chat_room_id,"to_user_id":self.view_user_id,"message":message,"from_user_id":self.from_user_id,"messageTime":dateInString,"message_type":kVideo]
            //,"buffer_img":gif
            SocketIOManager.shared.sendChatMessage(MessageChatDict: dict2)
            
            var data = JSONDictionary()
            data["call_from_user_id"] = self.from_user_id
            data["call_to_user_id"] = self.view_user_id
            data["call_duration"] = self.totalSecond
            data["call_type"] = kVideo
            data[ApiKey.kTimezone] = TIMEZONE
            
               if message.contains(kVideoSession)
               {
                   self.SaveCallRecoardApi(data: data, loaderShow: false, startLoad: false)
               }
           
           }
            
        }
    }
   
}

extension VideoCallingVC: AgoraRtmInvitertDelegate {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation) {
        debugPrint(#function)
        debugPrint("didReceivedIncoming")

    }

    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        debugPrint("remoteDidCancelIncoming")
        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

    }
}
//MARK: - CallCenterDelegate

extension VideoCallingVC: CallCenterDelegate {
    func callCenter(_ callCenter: CallCenter, answerCall session: String) {
        debugPrint("callCenter answerCall")
                
        if let inviter = AgoraRtm.shared().inviter {
            inviter.accpetLastIncomingInvitation()
        }

    }
    
    func callCenter(_ callCenter: CallCenter, declineCall session: String) {
        debugPrint("callCenter declineCall")
        
        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }
        
        inviter.refuseLastIncomingInvitation {  [weak self] (error) in
            //self?.openSimpleAlert(message: error.localizedDescription)
            debugPrint(error.localizedDescription)
        }
    }
    
    func callCenter(_ callCenter: CallCenter, startCall session: String) {
        debugPrint("callCenter startCall")
        
        guard let kit = AgoraRtm.shared().kit else {
            fatalError("rtm kit nil")
        }

        guard let inviter = AgoraRtm.shared().inviter else {
            fatalError("rtm inviter nil")
        }

        
        let vc = VideoCallingVC.instantiate(fromAppStoryboard: .Chat)

        let remoteNumber = session
        
        // rtm query online status
        kit.queryPeerOnline(remoteNumber, success: { [weak vc] (onlineStatus) in
            switch onlineStatus {
            case .online:      sendInvitation(remote: remoteNumber, callingVC: vc!)
            case .offline:     vc?.close(.remoteReject(remoteNumber))
            case .unreachable: vc?.close(.remoteReject(remoteNumber))
            @unknown default:  fatalError("queryPeerOnline")
            }
        }) { [weak vc] (error) in
            vc?.close(.error(error))
        }
        
        // rtm send invitation
        func sendInvitation(remote: String, callingVC: VideoCallingVC) {
            let channel = "\(self.self_user_id)-\(self.Other_user_id)-\(Date().timeIntervalSinceReferenceDate)"
            
            inviter.sendInvitation(peer: remoteNumber, extraContent: channel, accepted: { [weak self, weak vc] in
                vc?.close(.toVideoChat)
                
                self?.appleCallKit.setCallConnected(of: remote)
                
                guard let remote = UInt(remoteNumber) else {
                    fatalError("string to int fail")
                }
                
                var data: (channel: String, remote: UInt)
                data.channel = channel
                data.remote = remote
                self?.performSegue(withIdentifier: "DialToVideoChat", sender: data)
                
            }, refused: { [weak vc] in
                vc?.close(.remoteReject(remoteNumber))
            }) { [weak vc] (error) in
                vc?.close(.error(error))
            }
        }
    }
    
    func callCenter(_ callCenter: CallCenter, muteCall muted: Bool, session: String) {
        debugPrint("callCenter muteCall")
    }
    
    func callCenter(_ callCenter: CallCenter, endCall session: String) {
        debugPrint("callCenter endCall")
     //   self.prepareToVideoChat = nil
    }
    
    func callCenterDidActiveAudioSession(_ callCenter: CallCenter) {
        debugPrint("callCenter didActiveAudioSession")
        
        // Incoming call
//        if let prepare = self.prepareToVideoChat {
//            prepare()
//        }
    }
    
    func close(_ reason: HungupReason) {
       // animationStatus = .off
        ringStatus = .off
        //delegate?.callingVC(self, didHungup: reason)
    }
}
extension VideoCallingVC
{
    func SaveCallRecoardApi(data:JSONDictionary,loaderShow:Bool,startLoad:Bool)
    {
        
        debugPrint(#function)
        
        ChatVM.shared.callApiSaveCallRecoard(showIndiacter: loaderShow,data: data, response: { (message, error) in
            if error != nil
            {
//                self.hideLoader()
               // self.showErrorMessage(error: error)
            }
            else
            {
                
            }
        }
            )
        }
    
 
                                        
}
extension VideoCallingVC:FeedbackAlertDelegate
{
    func FeedbackAlertOkFunc(name: String)
    {
        
        debugPrint(#function)
        debugPrint(name)
     if name == kStory
     {
         if !self.alreadyPop
         {
             self.alreadyPop=true
            // self.navigationController?.popViewController(animated: true)
             
             if #available(iOS 13.0, *) {
                 SCENEDEL?.navigateToChat()
             } else {
                 // Fallback on earlier versions
                 APPDEL.navigateToChat()
             }

         }
     }
    
    }
    func showErrorMessage2(error: Error?) {
        /*
         STATUS CODES:
         200: Success (If request sucessfully done and data is also come in response)
         204: No Content (If request successfully done and no data is available for response)
         401: Unauthorized (If token got expired)
         451: Block (If User blocked by admin)/delete by admin
         403: Delete (If User deleted by admin)
         406: Not Acceptable (If user is registered with the application but not verified)
         */
        let message = (error! as NSError).userInfo[ApiKey.kMessage] as? String ?? kSomethingWentWrong
        
            //ok button action
            let code = (error! as NSError).code
            if  code == 401 || code == 451
            {
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
           else
            {
      
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.delegate=self
                destVC.errorCode=1000
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
}

