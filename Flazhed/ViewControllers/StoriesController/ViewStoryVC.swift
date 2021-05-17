//
//  ViewStoryVC.swift
//  Flazhed
//
//  Created by IOS33 on 08/04/21.
//

import UIKit
import AVFoundation

class ViewStoryVC: BaseVC {
    @IBOutlet weak var tableStory: UITableView!
    var cellData:PostdetailModel?
    var isMute = true
    var player:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTable()
    }
    
    
    @IBAction func backAct(_ sender: UIButton)
    {
        DataManager.comeFrom = kViewProfile
            self.navigationController?.popViewController(animated: false)
    }
}
extension ViewStoryVC:UITableViewDelegate,UITableViewDataSource
{
   
    
    func setUpTable()
    {
        self.tableStory.register(UINib(nibName: "StoryTCell", bundle: nil), forCellReuseIdentifier: "StoryTCell")
        
        self.tableStory.register(UINib(nibName: "StoryAdsTCell", bundle: nil), forCellReuseIdentifier: "StoryAdsTCell")
        self.tableStory.rowHeight = 100
        self.tableStory.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableStory.delegate = self
        self.tableStory.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
    return 1

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTCell") as! StoryTCell
     
        cell.viewTop.isHidden=true
        cell.topViewHeightConst.constant = 0
    
        cell.btnProfile.tag=0
        cell.btnThreeDot.tag=0
        cell.btnHearVoice.tag=0
        cell.btnLikeProfile.tag=0
        cell.btnPlay.tag=0
        cell.btnMute.tag=0
        //cell.lblUsername.text = (cellData?.profile_data?.username)?.capitalized

        
//        if cellData?.post_details?.user_id == DataManager.Id
//        {
//            cell.btnThreeDot.isHidden=false
//            cell.viewLike.isHidden=true
//            cell.stackLeftConst.constant=SCREENWIDTH/2
//        }
//        else
//        {
//            cell.btnThreeDot.isHidden=false
//            cell.viewLike.isHidden=false
//            cell.stackLeftConst.constant=24
//        }
      
            
       
//        if cellData?.profile_data?.images?.count ?? 0>0
//            {
//              if let img = cellData?.profile_data?.images?[0].image
//              {
//                let url = URL(string: img)!
//                DispatchQueue.main.async {
//                cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
//                }
//              }
//            }
   
        if cellData?.file_type==kVideo
        {
            
            if let img = cellData?.thumbnail
                {
                cell.imgStory.isHidden=false
                    let url = URL(string: img)!
                cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                
                cell.imgStory.isHidden=false
                
                let video = cellData?.file_name ?? ""
                let urlVideo = URL(string: video)!
                cell.btnMute.isHidden=false
               // cell.configureCell(imageUrl: img, description: "Video", videoUrl: video)
        
                self.player = AVPlayer(url: urlVideo)
            
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.videoGravity = .resizeAspectFill
                playerLayer.frame = cell.imgStory.bounds
                cell.imgStory.layer.addSublayer(playerLayer)
                player?.ready
                player?.play()
               
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
                    self?.player?.seek(to: CMTime.zero)
                    self?.player!.play()
                }
                if self.isMute//isVideoMute == true
                {
                  
                    cell.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
                    self.player?.isMuted=true
                    self.player?.volume = 0
                }
                else
                {
                
                    cell.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
                    self.player?.isMuted=false
                    self.player?.volume = 1
                }
           
                }
            
         
            
            cell.btnPlay.isHidden=false
           
           
        
        }
        else
        {
            cell.imgStory.isHidden=false
            cell.btnPlay.isHidden=true
            cell.imgStory.isHidden=false
            cell.btnMute.isHidden=true
            if let img = cellData?.file_name
                {
                    let url = URL(string: img)!

                DispatchQueue.main.async
                {
                    cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                }
                }
        }
        if let post_date_time = cellData?.post_date_time
            {
            let time = post_date_time.dateFromString(format: .NewISO, type: .utc)
            cell.lblTime.text = time.string(format: .date12HourTime, type: .local)
            
           }
        
        
        
          cell.txtViewDesc.text = cellData?.post_text
        cell.btnPlay.isHidden=true
        
      
//        if cellData?.is_liked_by_self_user == 1 && cellData?.is_liked_by_other_user_id == 1
//        {
//            cell.imgHeart.image = UIImage(named: "Message")
//            cell.lblLike.text = kMessage
//            cell.lblLike.textColor = LINECOLOR
//        }
//       else if cellData?.is_liked_by_self_user == 1
//        {
//            cell.imgHeart.image = UIImage(named: "redLike3")
//            cell.lblLike.text = kLikeProfile//kDislikeProfile
//            cell.lblLike.textColor = LIKECOLOR
//        }
//        else
//        {
//            cell.imgHeart.image = UIImage(named: "BlackLike")
//            cell.lblLike.text = kLikeProfile
//            cell.lblLike.textColor = UIColor.black
//        }
       
        
        
//            cell.btnThreeDot.addTarget(self, action: #selector(ThreeDotAct), for: .touchUpInside)
//            cell.btnProfile.addTarget(self, action: #selector(viewProfileAct), for: .touchUpInside)
//
//        cell.btnHearVoice.addTarget(self, action: #selector(hearVoiceAct), for: .touchUpInside)
//        cell.btnLikeProfile.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
//
        cell.btnMute.addTarget(self, action: #selector(muteAct), for: .touchUpInside)
//
//        cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    @objc func muteAct(_ sender: UIButton)
    {

          if self.isMute
            {
                self.isMute = false
            
            }
            else
            {
                self.isMute = true
           
            }
            self.tableStory.reloadData()
    }
}
