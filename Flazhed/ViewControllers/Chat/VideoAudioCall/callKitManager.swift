//
//  callKitManager.swift
//  Flazhed
//
//  Created by IOS33 on 02/06/21.
//

import Foundation
import CallKit
import AVFoundation
import UIKit


enum CallStatuses {
    case connecting
    case calling
    case ongoing
}
enum HungupReason {
    case remoteReject(String), toVideoChat, normaly(String), error(Error)
    
    fileprivate var rawValue: Int {
        switch self {
        case .remoteReject: return 0
        case .toVideoChat:  return 1
        case .normaly:      return 2
        case .error:        return 3
        }
    }
    
    static func==(left: HungupReason, right: HungupReason) -> Bool {
        return left.rawValue == right.rawValue
    }
    
    var description: String {
        switch self {
        case .remoteReject:     return "remote reject"
        case .toVideoChat:      return "start video chat"
        case .normaly:          return "normally hung up"
        case .error(let error): return error.localizedDescription
        }
    }
}

protocol CallKitManagerDelegate: class {
    func userDidEnabledAudioDevice(enable: Bool)
    func userDidBlockAudioDevice()
    func userDidDisconnectFromRoom()
    func userDidCloseCallView()
    func userDidMuteAudio(mute: Bool)
    func userDidHoldCall(hold: Bool)
    func userDidPrepareLocalMedia()
    func userDidDeclineCall(reason: String)
//    func localAudioTrackRequested() -> LocalAudioTrack?
//    func localVideoTrackRequested() -> LocalVideoTrack?
//    func roomDidCreated(newRoom: Room)
    func cleanAndExit()
    func startTimer()
    func incomingCallStarted(uuid: UUID)
    func getCurrentUUID() -> UUID
    func isDelegateReady() -> Bool
}

class CallKitManager: NSObject, CXProviderDelegate {
    
    var onCallAnswear = {
        
    }
    
    // CallKit components
    var callKitProvider: CXProvider?
    var callKitCallController: CXCallController?
    var callKitCompletionHandler: ((Bool)->Swift.Void?)? = nil
    var userInitiatedDisconnect: Bool = false
    
    weak var delegate: CallKitManagerDelegate?
  //  weak var roomDelegate: RoomDelegate?
    
    var personName = "Caller"
    var accessToken = ""
    var hasVideo = false
    var unAnswearedTimer: Timer?
    var answearedTimer: Timer?
    var currentRoomId = ""
    var hangUp = false
    
    func setupCallKit() {
        if callKitProvider == nil {
            let configuration = CXProviderConfiguration(localizedName: "Lengua")
            configuration.maximumCallGroups = 1
            configuration.maximumCallsPerCallGroup = 1
            configuration.supportsVideo = hasVideo
            configuration.supportedHandleTypes = [.generic]
//            if let callKitIcon = UIImage(named: "callKitIcon") {
//                configuration.iconTemplateImageData = callKitIcon.pngData()
//            }
            
            callKitProvider = CXProvider.init(configuration: configuration)
        }
        
        
        callKitCallController = CXCallController()
        
        callKitProvider?.setDelegate(self, queue: nil)
        
    }
    
    func setConfiguration() {
        
        let configuration = CXProviderConfiguration(localizedName: "Lengua")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = hasVideo

        configuration.supportedHandleTypes = [.generic]
//        if let callKitIcon = UIImage(named: "callKitIcon") {
//            configuration.iconTemplateImageData = callKitIcon.pngData()
//        }

        callKitProvider = CXProvider.init(configuration: configuration)
        callKitProvider?.setDelegate(self, queue: nil)
    }
    
    
    func providerDidReset(_ provider: CXProvider) {
        logMessage(messageText: "providerDidReset:")
        
        if let del = delegate {
            del.userDidEnabledAudioDevice(enable: true)
            del.userDidDisconnectFromRoom()
        }
    }
    
    func providerDidBegin(_ provider: CXProvider) {
        logMessage(messageText: "providerDidBegin")
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        logMessage(messageText: "provider:didActivateAudioSession:")
        
        if let del = delegate {
            // Stop the audio unit by setting isEnabled to `false`.
            del.userDidEnabledAudioDevice(enable: true)
        }
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        logMessage(messageText: "provider:didDeactivateAudioSession:")
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        logMessage(messageText: "provider:timedOutPerformingAction:")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        logMessage(messageText: "provider:performStartCallAction:")
        
        /*
         * Configure the audio session, but do not start call audio here, since it must be done once
         * the audio session has been activated by the system after having its priority elevated.
         */
        
        if let del = delegate {
            // Stop the audio unit by setting isEnabled to `false`.
            del.userDidEnabledAudioDevice(enable: false)
            // Configure the AVAudioSession by executign the audio device's `block`.
            del.userDidBlockAudioDevice()
        }
        
        callKitProvider?.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
        
        print("UUID: report \(action.callUUID)")
        
        roomAnswearConnect(action: action, callerName: action.handle.value)
        
        answearedTimer?.invalidate()
        answearedTimer = nil
    }
    
    func roomAnswearConnect(action: CXStartCallAction, callerName: String) {
        
        if let del = delegate,
           !del.isDelegateReady() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.roomAnswearConnect(action: action, callerName: callerName)
            }
            
            return
        }
        
        performRoomConnect(uuid: action.callUUID, callerName: callerName) {(success) in
            if (success) {
                self.callKitProvider?.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
                action.fulfill()
                
                self.unAnswearedTimer = Timer.scheduledTimer(timeInterval: 50.0, target: self, selector: #selector(self.performUnAnswearedCallAction), userInfo: nil, repeats: false)
                
            } else {
                action.fail()
            }
        }
    }
    
    func roomStartConnect(action: CXAnswerCallAction, callerName: String) {
        if let del = delegate,
           !del.isDelegateReady() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.roomStartConnect(action: action, callerName: callerName)
            }
            
            return
        }
        
        performRoomConnect(uuid: action.callUUID, callerName: personName) { (success) in
            if (success) {
                if let del = self.delegate {
                    del.startTimer()
                }
                action.fulfill(withDateConnected: Date())
            } else {
                action.fail()
            }
        }
    }
    
    func remoteUserDidAnswear() {
        self.unAnswearedTimer?.invalidate()
        self.unAnswearedTimer = nil
        
        self.answearedTimer?.invalidate()
        self.answearedTimer = nil
    }
    
    func remoteUserDidDecline() {
        if let del = delegate {
            let uuid = del.getCurrentUUID()
            print("UUID: Decline \(uuid)")
            
            let endCallAction = CXEndCallAction.init(call: uuid)
            let transaction = CXTransaction(action: endCallAction)
            callKitCallController?.request(transaction) { error in
                if let error = error {
                    print("EndCallAction transaction request failed: \(error.localizedDescription).")
                    self.callKitProvider?.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
                    
                    print("EndCallAction transaction request successful")
                    if let del = self.delegate {
                        del.userDidBlockAudioDevice()
                        
                        del.userDidDeclineCall(reason: "Declined")
                    }
                    return
                }
            }
        }
    }
    
    @objc func performUnAnswearedCallAction() {
        remoteUserDidAnswear()
        
        if let del = delegate {
            let uuid = del.getCurrentUUID()
            
            let endCallAction = CXEndCallAction.init(call: uuid)
            let transaction = CXTransaction(action: endCallAction)
            callKitCallController?.request(transaction) { error in
                if let error = error {
                    print("EndCallAction transaction request failed: \(error.localizedDescription).")
                    self.callKitProvider?.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
                    
                    print("EndCallAction transaction request successful")
                    if let del = self.delegate {
                        del.userDidBlockAudioDevice()
                        
                        del.userDidDeclineCall(reason: "No answear")
                    }
                    return
                }
            }
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        logMessage(messageText: "provider:performAnswerCallAction:")
        
        DispatchQueue.main.async {
            if UIApplication.shared.applicationState == .active {
                self.onCallAnswear()
            }
        }
        
        /*
         * Configure the audio session, but do not start call audio here, since it must be done once
         * the audio session has been activated by the system after having its priority elevated.
         */
        
        if let del = delegate {
            // Stop the audio unit by setting isEnabled to `false`.
            del.userDidEnabledAudioDevice(enable: false)
            // Configure the AVAudioSession by executign the audio device's `block`.
            del.userDidBlockAudioDevice()
        }
        
        if let del = delegate {
            del.incomingCallStarted(uuid: action.callUUID)
        }
        
        remoteUserDidAnswear()
        roomStartConnect(action: action, callerName: personName)

    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        NSLog("provider:performEndCallAction:")
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isCallOngoing = false
        }
        
        if let del = self.delegate {
            del.userDidBlockAudioDevice()
            
            del.userDidDeclineCall(reason: "Declined")
        }
        remoteUserDidAnswear()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        NSLog("provier:performSetMutedCallAction:")
        
        if let del = self.delegate {
            del.userDidMuteAudio(mute: action.isMuted)
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        NSLog("provier:performSetHeldCallAction:")
        
        let cxObserver = callKitCallController?.callObserver
        let calls = cxObserver?.calls
        
        guard let call = calls?.first(where:{$0.uuid == action.callUUID}) else {
            action.fail()
            return
        }
        
        if let del = self.delegate {
            del.userDidHoldCall(hold: !call.isOnHold)
        }
        
        action.fulfill()
    }
    
    func logMessage(messageText: String) {
        NSLog(messageText)
        //messageLabel.text = messageText
    }
    
    //MARK: Actions
    func performStartCallAction(uuid: UUID, callerName: String?) {
        let callHandle = CXHandle(type: .generic, value: callerName ?? "")
        let startCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        
        startCallAction.isVideo = false
        
        let transaction = CXTransaction(action: startCallAction)
        
        callKitCallController?.request(transaction)  { error in
            if let error = error {
                NSLog("StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }
            
            if self.hangUp {
                self.hangUp = false
                NSLog("VYDEBUG: performStartCallAction performEnd")
                self.performEndCallAction(uuid: uuid, reason: .unanswered)
            }
            NSLog("StartCallAction transaction request successful")
        }
    }
    
    func reportIncomingCall(uuid: UUID, callerName: String?, completion: ((NSError?) -> Void)? = nil) {
        let callUpdate = CXCallUpdate()
        
        if hasVideo {
            let callHandle = CXHandle(type: .generic, value: callerName ?? "")
            callUpdate.remoteHandle = callHandle
        }
        
        
        callUpdate.localizedCallerName = callerName
        callUpdate.supportsDTMF = false
        callUpdate.supportsHolding = false
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = hasVideo
        
        callKitProvider?.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if error == nil {
                NSLog("Incoming call successfully reported.")
                
                self.answearedTimer = Timer.scheduledTimer(withTimeInterval: 50.0, repeats: false, block: { (timer) in
                    self.performUnAnswearedCallAction()
                })
            } else {
                NSLog("Failed to report incoming call successfully: \(String(describing: error?.localizedDescription)).")
            }
            completion?(error as NSError?)
        }
    }
    
    func performEndCallAction(uuid: UUID, reason: CXCallEndedReason) {
        
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.isCallOngoing = false
            }
        }
        
        
        
        let endCallAction = CXEndCallAction.init(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        callKitCallController?.request(transaction) { error in
            if let error = error {
                print("EndCallAction transaction request failed: \(error.localizedDescription).")
                self.callKitProvider?.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
                
                print("EndCallAction transaction request successful")
                if let del = self.delegate {
                    del.userDidBlockAudioDevice()
                    
                    del.userDidDeclineCall(reason: "Declined")
                    
                    self.remoteUserDidAnswear()
                    
                    if let del = self.delegate {
                        del.userDidDisconnectFromRoom()
                    }
                }
                return
            }
        }
    }
    
    func performRoomConnect(uuid: UUID, callerName: String? , completionHandler: @escaping (Bool) -> Swift.Void) {
        // Configure access token either from server or manually.
        // If the default wasn't changed, try fetching from server.
        
        // Prepare local media which we will share with Room Participants.
        if let del = self.delegate {
            
            del.userDidPrepareLocalMedia()
        }
        
        /*
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = ConnectOptions(token: self.accessToken) { (builder) in
            
            // Use the local media that we prepared earlier.
            if let del = self.delegate,
               let local = del.localAudioTrackRequested() {
                builder.audioTracks = [local]
            } else {
                builder.audioTracks = [LocalAudioTrack]()
            }
            
            if let del = self.delegate,
               let local = del.localVideoTrackRequested() {
                builder.videoTracks = [local]
            } else {
                builder.videoTracks = [LocalVideoTrack]()
            }
            
            
            builder.isDominantSpeakerEnabled = self.hasVideo
            
            // Use the preferred audio codec
            if let preferredAudioCodec = Settings.shared.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = Settings.shared.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = Settings.shared.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // Use the preferred signaling region
            if let signalingRegion = Settings.shared.signalingRegion {
                builder.region = signalingRegion
            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = callerName
            
            // The CallKit UUID to assoicate with this Room.
            builder.uuid = uuid
        }
        
        if self.roomDelegate == nil {
            return
        }
        
        // Connect to the Room using the options we provided.
        let room: Room = TwilioVideoSDK.connect(options: connectOptions, delegate: self.roomDelegate)
        
        
        if let del = self.delegate {
            del.roomDidCreated(newRoom: room)
        }
         */
        
        self.logMessage(messageText: "Attempting to connect to callerName \(String(describing: callerName))")
        
        self.callKitCompletionHandler = completionHandler
    }
}
