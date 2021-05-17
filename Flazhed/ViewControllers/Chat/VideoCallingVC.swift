//
//  VideoCallingVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit
import Quickblox
import QuickbloxWebRTC
import PushKit

class VideoCallingVC: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var backBUtton: UIButton!
    @IBOutlet weak var decliineButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    
    //MARK:- Call setup
    //MARK: - Properties
    lazy private var dataSource: UsersDataSource = {
        let dataSource = UsersDataSource()
        return dataSource
    }()
    
    lazy private var navViewController: UINavigationController = {
        let navViewController = UINavigationController()
        return navViewController
        
    }()
    private var answerTimer: Timer?
    private var sessionID: String?
    private var isUpdatedPayload = true
    private weak var session: QBRTCSession?
    private var voipRegistry: PKPushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    private var callUUID: UUID?
    
    var newUser2:QBUUser?
    
    
    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
        let backgroundTask = UIBackgroundTaskIdentifier.invalid
        return backgroundTask
    }()
    
    
    
    //MARK: - Properties
    weak var usersDataSource: UsersDataSource?
    
    //MARK: - Internal Properties
    private var timeDuration: TimeInterval = 0.0
    
    private var callTimer: Timer?
    private var beepTimer: Timer?
    
    //Camera
   // var session: QBRTCSession?
    
    var sessionConferenceType: QBRTCConferenceType = QBRTCConferenceType.audio
    //var callUUID: UUID?
    lazy private var cameraCapture: QBRTCCameraCapture = {
       // let settings = Settings()
        var videoFormat = QBRTCVideoFormat.default()
     
        let cameraCapture = QBRTCCameraCapture(videoFormat: videoFormat,
                                               position: .front)
       // cameraCapture.startSession(nil)
        return cameraCapture
    }()
    
 

    //Containers
    private var users = [User]()
    private var videoViews = [UInt: UIView]()
    private var statsUserID: UInt?
    private var disconnectedUsers = [UInt]()
    

    
    //States
    private var shouldGetStats = false
    private var didStartPlayAndRecord = false
    private var muteVideo = false {
        didSet {
            session?.localMediaStream.videoTrack.isEnabled = !muteVideo
        }
    }
    
    private var state = CallViewControllerState.connected {
        didSet {
            switch state {
            case .disconnected:
                title = CallStateConstant.disconnected
            case .connecting:
                title = CallStateConstant.connecting
            case .connected:
                title = CallStateConstant.connected
            case .disconnecting:
                title = CallStateConstant.disconnecting
            }
        }
    }
    
    
    var videoCapture: QBRTCCameraCapture?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
 
        QBRTCClient.instance().add(self as QBRTCClientDelegate)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       self.startCall()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func declineCallButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
/*
//MARK:- Video call setup
extension VideoCallingVC: QBRTCClientDelegate {
        // MARK: QBRTCClientDelegate
        func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil)
        {
            print(#function)
        }
        
        func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
            print(#function)
        }
        
        func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
            print(#function)
        }
        
        func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
            print(#function)
        }
        
        func sessionDidClose(_ session: QBRTCSession) {
            print(#function)
        }
    
        
        // MARK: QBRTCBaseClientDelegate
        func session(_ session: QBRTCBaseSession, didChange state: QBRTCSessionState) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, updatedStatsReport report: QBRTCStatsReport, forUserID userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, receivedRemoteAudioTrack audioTrack: QBRTCAudioTrack, fromUser userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack, fromUser userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, startedConnectingToUser userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
        }
        
        func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, connectionFailedForUser userID: NSNumber) {
            print(#function)
        }
        
        func session(_ session: QBRTCBaseSession, didChange state: QBRTCConnectionState, forUser userID: NSNumber) {
            print(#function)
        }
    }

*/

extension VideoCallingVC:QBRTCClientDelegate
{
    
   func startCall()
   {
    CallPermissions.check(with: .video) { granted in
        if granted {
            debugPrint("\(self) granted!")
        } else {
            debugPrint("\(self) granted canceled!")
        }
    }
    call(with: QBRTCConferenceType.video)
    
   }
    private func call(with conferenceType: QBRTCConferenceType) {
        
        if session != nil {
            return
        }
        
        if hasConnectivity()
        {
            CallPermissions.check(with: conferenceType) { granted in
                if granted {
                    let opponentsIDs: [NSNumber] = [NSNumber(value: self.newUser2!.id)]//self.dataSource.ids(forUsers: [self.newUser2.!])
                    let opponentsNames: [String] = [self.newUser2!.fullName ?? ""]//self.dataSource.selectedUsers.compactMap({ $0.fullName ?? $0.login })
                    
                    //Create new session
                    let session = QBRTCClient.instance().createNewSession(withOpponents: opponentsIDs, with: conferenceType)
                    if session.id.isEmpty == false {
                        self.session = session
                        self.sessionID = session.id
                        guard let uuid = UUID(uuidString: session.id) else {
                            return
                        }
                        self.callUUID = uuid
                        let profile = Profile()
                        guard profile.isFull == true else {
                            return
                        }
                        
                        CallKitManager.instance.startCall(withUserIDs: opponentsIDs, session: session, uuid: uuid)
                        print("user data = \(opponentsIDs) \(session) \(uuid)")
                        
                        print("Session = \(session)")
                        
                        
//                        if let callViewController = self.storyboard?.instantiateViewController(withIdentifier: UsersSegueConstant.call) as? CallViewController
//                        {
//                            callViewController.session = self.session
//                            callViewController.usersDataSource = self.dataSource
//                            callViewController.callUUID = uuid
//                            callViewController.sessionConferenceType = conferenceType
//                            let nav = UINavigationController(rootViewController: callViewController)
//                            nav.modalTransitionStyle = .crossDissolve
//                            nav.modalPresentationStyle = .fullScreen
//                            self.present(nav , animated: false)
//                            //self.audioCallButton.isEnabled = false
//                            self.videoCallButton.isEnabled = false
//                            self.navViewController = nav
//                        }
//
                        self.startCallView()
                        
                        let opponentsNamesString = opponentsNames.joined(separator: ",")
                        let allUsersNamesString = "\(profile.fullName)," + opponentsNamesString
                        let arrayUserIDs = opponentsIDs.map({"\($0)"})
                        let usersIDsString = arrayUserIDs.joined(separator: ",")
                        let allUsersIDsString = "\(profile.ID)," + usersIDsString
                        let opponentName = profile.fullName
                        let conferenceTypeString = conferenceType == .video ? "1" : "2"
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let timeStamp = formatter.string(from: Date())
                        let payload = ["message": "\(opponentName) is calling you.",
                            "ios_voip": "1",
                            UsersConstant.voipEvent: "1",
                            "sessionID": session.id,
                            "opponentsIDs": allUsersIDsString,
                            "contactIdentifier": allUsersNamesString,
                            "conferenceType" : conferenceTypeString,
                            "timestamp" : timeStamp
                        ]
                        let data = try? JSONSerialization.data(withJSONObject: payload,
                                                               options: .prettyPrinted)
                        var message = ""
                        if let data = data {
                            message = String(data: data, encoding: .utf8) ?? ""
                        }
                        let event = QBMEvent()
                        event.notificationType = QBMNotificationType.push
                        event.usersIDs = usersIDsString
                        event.type = QBMEventType.oneShot
                        event.message = message
                        QBRequest.createEvent(event, successBlock: { response, events in
                            
                            print("createEvent response \(response) \(events)")
                            
                            debugPrint("[UsersViewController] Send voip push - Success")
                        }, errorBlock: { response in
                            print("createEvent error response \(response)")
                            debugPrint("[UsersViewController] Send voip push - Error")
                        })
                    } else {
                        self.openSimpleAlert(message: UsersAlertConstant.shouldLogin)
                        
                    }
                }
            }
        }
    }
    
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        print(userInfo)
        print(session)
       if self.session != nil {
        
           // we already have a video/audio call session, so we reject another one
           // userInfo - the custom user information dictionary for the call from caller. May be nil.
           let userInfo = ["key":"value"] // optional
           session.rejectCall(userInfo)
           return
       }
       // saving session instance here
       self.session = session
    }
    
    
    // MARK: - Internal Methods
    private func hasConnectivity() -> Bool {
        let status = Reachability.instance.networkConnectionStatus()
        guard status != NetworkConnectionStatus.notConnection else
        {
    
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            
            if CallKitManager.instance.isCallStarted() == false
            {
                CallKitManager.instance.endCall(with: callUUID) {
                    debugPrint("[UsersViewController] endCall func hasConnectivity")
                }
            }
            return false
        }
        return true
    }
    
    func startCallView()
    {
        QBRTCClient.instance().add(self as QBRTCClientDelegate)
                
                let videoFormat = QBRTCVideoFormat()
                videoFormat.frameRate = 30
                videoFormat.pixelFormat = .format420f
                videoFormat.width = 640
                videoFormat.height = 480
                
                // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
                self.videoCapture = QBRTCCameraCapture(videoFormat: videoFormat, position: .front)
                
                // add video capture to session's local media stream
                self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
                
                self.videoCapture?.previewLayer.frame = self.viewBack.bounds
                self.videoCapture?.startSession()
                
        self.viewBack.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)
    }
    
}



