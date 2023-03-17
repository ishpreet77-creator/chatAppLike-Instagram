//
//  MusicPlayer.swift
//  Flazhed
//
//  Created by IOS32 on 28/01/21.
//

import Foundation
import AVKit

class MusicPlayer:UIViewController {
    public static var instance = MusicPlayer()
    var isplaying=false
    var player = AVAudioPlayer()
    var currentTag = 0
    
    func initPlayer(url: String,tag:Int) {
      
        do {
            var url2 = url
//            if (!url.contains("file:///")) {
//               url2 = url
//            }else{
            
                if !url.contains(kHttps) &&  !url.contains(kHttp) && !url.contains("file:///")
            {
                url2 = IMAGE_BASE_URL+url
            }
        
            
            let songData = try Data(contentsOf: URL(string: url2)!, options: NSData.ReadingOptions.mappedIfSafe)

            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
               try AVAudioSession.sharedInstance().setActive(true)
            self.player = try AVAudioPlayer(data: songData, fileTypeHint: AVFileType.mp3.rawValue)
            self.player.delegate=self
            self.player.prepareToPlay()
            self.player.play()
            self.isplaying=true
            
            } catch {
                debugPrint(error)
            }
        
        if tag == 10 || tag == 11 || tag == 12
        {
            currentTag=tag

        }
      
    }

    func isPlaying()->Bool
    {
       return isplaying
    }
    
    func pause(){
        
        if isplaying
        {
            player.pause()
            isplaying=false
        }
        
    }
    
    func play() {
        isplaying=true
        player.play()
    }

}
extension MusicPlayer:AVAudioPlayerDelegate
{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           if flag {
               // After successfully finish song playing will stop audio player and remove from memory
               debugPrint("Audio player finished playing")
            self.isplaying=false
            self.player.stop()
            if self.currentTag == 10
            {
            NotificationCenter.default.post(name: Notification.Name("profileAudioStoped"), object: nil)
            }
            if self.currentTag == 12
            {
            NotificationCenter.default.post(name: Notification.Name("StoryAudioStoped"), object: nil)
            }
            else
            {
                NotificationCenter.default.post(name: Notification.Name("editProfileAudioStoped"), object: nil)
            }
           }
       }
    
}
 


