//
//  StoryTCell.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit
import AVKit
import AVFoundation

class StoryTCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var topViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var lblHearVoice: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnThreeDot: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var imgStory: UIImageView!
    
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var btnLikeProfile: UIButton!
    
    @IBOutlet weak var btnHearVoice: UIButton!
    
    @IBOutlet weak var imgHeart: UIImageView!
    
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var stackLeftConst: NSLayoutConstraint!
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    var isZooming = false
       var originalImageCenter:CGPoint?
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.imgStory.backgroundColor = UIColor.white
//        self.viewPlayer.backgroundColor = UIColor.white
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("StopVideo"), object: nil)

        
//        viewPlayer.backgroundColor = UIColor(white: 0, alpha: 0.7)
//
//                spinner.translatesAutoresizingMaskIntoConstraints = false
//                spinner.startAnimating()
//            //  viewPlayer.addSubview(spinner)
//
//                spinner.centerXAnchor.constraint(equalTo: viewPlayer.centerXAnchor).isActive = true
//                spinner.centerYAnchor.constraint(equalTo: viewPlayer.centerYAnchor).isActive = true
        //spinner.startAnimating()
        
        
        //MARK:- Video stop
        
//        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.viewPlayer.player?.currentItem, queue: nil) { (_) in
//            self.viewPlayer.player?.seek(to: .zero)
//            self.viewPlayer.player?.play()
//         }
//
        
        
        
//        if (self.viewPlayer.player?.rate != 0 && self.viewPlayer.player?.error == nil) {
//           print("playing")
//            spinner.stopAnimating()
//        }
//        else
//        {
//            spinner.startAnimating()
//        }
        
        // Initialization code
        
        imgStory.layer.cornerRadius = 0
        imgStory.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        imgStory.clipsToBounds = true
        imgStory.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        imgStory.layer.borderWidth = 0.0
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        imgStory.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    override func prepareForReuse() {
        imgStory.imageURL = nil
        super.prepareForReuse()
    }
 
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
      
        self.imgStory.imageURL = imageUrl
        self.videoURL = videoUrl
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
//  @objc  func methodOfReceivedNotification(notification: Notification) {
//      // Take Action on Notification
//    self.viewPlayer.player?.pause()
//
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = self.imgStory.frame//CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(imgStory.frame, from: imgStory)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }

 
}
