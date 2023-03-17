//
//  PlayerUIView.swift
//  Flazhed
//
//  Created by IOS33 on 12/03/21.
//


import UIKit
import AVKit;
import AVFoundation;

class PlayerUIView: UIImageView{//UIView {
    
   
    public static var instance = PlayerUIView()
    
    var playerOn:AVPlayer?
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            playerOn=playerLayer.player
            playerLayer.videoGravity = .resizeAspectFill
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
            playerOn=playerLayer.player
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func StopPlayer()  {
        
        if self.playerOn != nil
        {
            self.playerOn?.pause()
        }
    }
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
extension AVPlayer {
    var ready:Bool {
        let timeRange = currentItem?.loadedTimeRanges.first as? CMTimeRange
        guard let duration = timeRange?.duration else { return false }
        let timeLoaded = Int(duration.value) / Int(duration.timescale) // value/timescale = seconds
        let loaded = timeLoaded > 0

        return status == .readyToPlay && loaded
    }
}
