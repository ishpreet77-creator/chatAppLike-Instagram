//
//  VideoObject.swift
//  AutoPlayVideo
//
//  Created by Ashish Singh on 12/4/17.
//  Copyright © 2017 Ashish. All rights reserved.
//

import UIKit
import AVFoundation
class ASVideoContainer {
    var url: String
    var playOn: Bool {
        didSet {
            player.isMuted = ASVideoPlayerController.sharedVideoPlayer.mute
            
//            if player.isMuted
//            {
//                player.volume = 0.0
//            }
//            else
//            {
//                player.volume = 1.0
//                //playOn=true
//            }
           
            playerItem.preferredPeakBitRate = ASVideoPlayerController.sharedVideoPlayer.preferredPeakBitRate
            if playOn && playerItem.status == .readyToPlay {
                
                player.play()
            }
            else{
             
                player.pause()
            }
        }
    }
    
    let player: AVPlayer
    let playerItem: AVPlayerItem
    
    init(player: AVPlayer, item: AVPlayerItem, url: String) {
        self.player = player
        self.playerItem = item
        self.url = url
        playOn = true
         
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.storyAudioStopedReceivedNotification(notification:)), name: Notification.Name("PauseVideo"), object: nil)
        
        player.automaticallyWaitsToMinimizeStalling = false//item.isPlaybackBufferEmpty
    }
    
    @objc func storyAudioStopedReceivedNotification(notification: Notification)
    {
        self.player.pause()
    }
}
