//
//  StoriesVC.swift
//  Flazhed
//
//  Created by IOS20 on 05/01/21.
//

import UIKit
import GoogleMobileAds
import CoreLocation
import AVKit
import AVFoundation

class StoriesVC: BaseVC {

    //MARK:- All outlets  🍎
    
    @IBOutlet weak var tableStory: UITableView!
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var lblNoFound: UILabel!
    
    //MARK:- All Variable  🍎
    var storyTableCell:StoryTCell?
    var videoCell:StoryTCell?
    var view_user_id = "1"
    var post_id = "1"
    var page = 0
    var currentPage = 0
    let locationmanager = CLLocationManager()
    var is_liked_by_other_user_id = 0
    var refreshControl = UIRefreshControl()
    var currentIndex = 0
    var StoriesPostData:[StoriesPostDataModel] = []
    var toShowLoader=true
    var isVideoMute = true
    
    //MARK:- View Lifecycle   🍎
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoFound.isHidden=true
        self.page = 0
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableStory.addSubview(refreshControl)
        setUpTable()
        self.page = 0
        StoriesVM.shared.page=0
        self.StoriesPostData.removeAll()
        self.tableStory.remembersLastFocusedIndexPath = true
        
      
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        self.viewSort.isHidden=false
  
        DataManager.audioMute=true
        
        ASVideoPlayerController.sharedVideoPlayer.mute=true
        if DataManager.comeFrom != kViewProfile
        {
            self.page = 0
            self.currentIndex=0
            StoriesVM.shared.page=0
            self.StoriesPostData.removeAll()
            self.callGetStoriesApi(page: self.page)
        }
        else
        {
            DataManager.comeFrom = ""
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    
        MusicPlayer.instance.pause()
        pausePlayeVideos()
        NotificationCenter.default.post(name: Notification.Name("StopVideo"), object: nil)

        ASVideoPlayerController.sharedVideoPlayer.mute=true
        

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.viewSort.isHidden=true
        self.toShowLoader=false
        StoriesVM.shared.page=0
        self.StoriesPostData.removeAll()
  
        self.callGetStoriesApi(page: 0)
    }
}

//MARK:- Tableview setup and show story and ads data 🍎

extension StoriesVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = StoriesPostData.count
    
            return count+count/5

        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        let count = self.StoriesPostData.count
        
      
            self.viewSort.isHidden=false
            var cellData:StoriesPostDataModel?
            self.tableStory.isScrollEnabled=true
            if indexPath.row % 5 == 0
            {
                if indexPath.row == 0
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTCell") as! StoryTCell
                 
                    if self.StoriesPostData.count>0//StoriesVM.shared.StoriesPostData.count>0
                    {
                        cellData = self.StoriesPostData[0]//StoriesVM.shared.StoriesPostData[0]
                    }
                    cell.btnProfile.tag=0
                    cell.btnThreeDot.tag=0
                    cell.btnHearVoice.tag=0
                    cell.btnLikeProfile.tag=0
                    cell.btnPlay.tag=0
                    cell.btnMute.tag=0
                    cell.lblUsername.text = (cellData?.profile_data?.username)?.capitalized

                    
                    if cellData?.post_details?.user_id == DataManager.Id
                    {
                        cell.btnThreeDot.isHidden=false
                        cell.viewLike.isHidden=true
                        cell.stackLeftConst.constant=SCREENWIDTH/2
                    }
                    else
                    {
                        cell.btnThreeDot.isHidden=false
                        cell.viewLike.isHidden=false
                        cell.stackLeftConst.constant=24
                    }
                  
                        
                   
                    if cellData?.profile_data?.images?.count ?? 0>0
                        {
                          if let img = cellData?.profile_data?.images?[0].image
                          {
                            let url = URL(string: img)!
                            DispatchQueue.main.async {
                            cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                            }
                          }
                        }
               
                    if cellData?.post_details?.file_type==kVideo
                    {
                        
                        if let img = cellData?.post_details?.thumbnail
                            {
                     
                            //    let url = URL(string: img)!

                            cell.imgStory.isHidden=false
                            
                            let video = cellData?.post_details?.file_name ?? ""
                            let urlVideo = URL(string: video)!
                            cell.btnMute.isHidden=false
                            cell.configureCell(imageUrl: img, description: "Video", videoUrl: video)
                         
                            }
                        
                     
                        
                        cell.btnPlay.isHidden=false
                        if ASVideoPlayerController.sharedVideoPlayer.mute//isVideoMute == true
                        {
                          
                            cell.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
                        }
                        else
                        {
                        
                            cell.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
                        }
                    }
                    else
                    {
                        cell.btnPlay.isHidden=true
                        cell.imgStory.isHidden=false
                        cell.btnMute.isHidden=true
                        if let img = cellData?.post_details?.file_name
                            {
                                let url = URL(string: img)!

                            DispatchQueue.main.async {
                                cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                            }
                            }
                    }
                    if let post_date_time = cellData?.post_details?.post_date_time
                        {
                        let time = post_date_time.dateFromString(format: .NewISO, type: .utc)
                        cell.lblTime.text = time.string(format: .date12HourTime, type: .local)
                        
                       }
                    
                    
                    
                      cell.txtViewDesc.text = cellData?.post_details?.post_text
                  
                    if cellData?.is_liked_by_self_user == 1 && cellData?.is_liked_by_other_user_id == 1
                    {
                        cell.imgHeart.image = UIImage(named: "Message")
                        cell.lblLike.text = kMessage
                        cell.lblLike.textColor = LINECOLOR
                    }
                   else if cellData?.is_liked_by_self_user == 1
                    {
                        cell.imgHeart.image = UIImage(named: "redLike3")
                        cell.lblLike.text = kLikeProfile//kDislikeProfile
                        cell.lblLike.textColor = LIKECOLOR
                    }
                    else
                    {
                        cell.imgHeart.image = UIImage(named: "BlackLike")
                        cell.lblLike.text = kLikeProfile
                        cell.lblLike.textColor = UIColor.black
                    }
                   
                    
                    
                        cell.btnThreeDot.addTarget(self, action: #selector(ThreeDotAct), for: .touchUpInside)
                        cell.btnProfile.addTarget(self, action: #selector(viewProfileAct), for: .touchUpInside)
                    
                    cell.btnHearVoice.addTarget(self, action: #selector(hearVoiceAct), for: .touchUpInside)
                    cell.btnLikeProfile.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
                    
                    cell.btnMute.addTarget(self, action: #selector(muteAct), for: .touchUpInside)
                    
                    cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
                    self.storyTableCell=cell
                    self.videoCell=cell
                    return cell
                }
                else
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "StoryAdsTCell") as! StoryAdsTCell
                    DispatchQueue.main.async {
                     let bannerView = StoryAdsTCell.cellBannerView(rootVC: self, frame: cell.bounds)
                
                     for subview in cell.viewAds.subviews {
                       subview.removeFromSuperview()
                     }
                   //  bannerView.delegate = self
                 cell.addSubview(bannerView)//.addSubview(bannerView)
                    self.tableStory.isScrollEnabled=true
                   
                    }
                    
                     return cell
                  
                }
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTCell") as! StoryTCell
                
                   var tag = 1

                if indexPath.row > (indexPath.row/5)
                {
                    tag=indexPath.row-(indexPath.row/5)
                }
                else
                {
                    tag = indexPath.row
                }
                if self.self.StoriesPostData.count>tag
                {
                cellData = self.StoriesPostData[tag]
                }
                else
                {
                    if self.StoriesPostData.count>0
                    {
                    cellData = self.StoriesPostData[0]
                    }
                }
                cell.btnProfile.tag=tag
                cell.btnThreeDot.tag=tag
                cell.btnHearVoice.tag=tag
                cell.btnLikeProfile.tag=tag
                cell.btnPlay.tag=tag
                cell.btnMute.tag=tag
                cell.lblUsername.text = (cellData?.profile_data?.username)?.capitalized

                
                if cellData?.post_details?.user_id == DataManager.Id
                {
                    cell.btnThreeDot.isHidden=false
                    cell.viewLike.isHidden=true
                    cell.stackLeftConst.constant=SCREENWIDTH/2
                }
                else
                {
                    cell.btnThreeDot.isHidden=false
                    cell.viewLike.isHidden=false
                    cell.stackLeftConst.constant=24
                }
                
                if cellData?.profile_data?.images?.count ?? 0>0
                    {
                      if let img = cellData?.profile_data?.images?[0].image
                      {
                        DispatchQueue.main.async {
                        let url = URL(string: img)!
                        cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                      }
                        }
                
                if cellData?.post_details?.file_type==kVideo
                {
                  
                    if let img = cellData?.post_details?.thumbnail
                        {
                     
                            //let url = URL(string: img)!
                      
                        cell.btnMute.isHidden=false
                        let video = cellData?.post_details?.file_name ?? ""
                        cell.configureCell(imageUrl: img, description: "Video", videoUrl: video)
                     
                        }
                    if ASVideoPlayerController.sharedVideoPlayer.mute//isVideoMute == true
                    {
                      
                        cell.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
                    }
                    else
                    {
                    
                        cell.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
                    }
            
                    cell.btnPlay.isHidden=false
                }
                else
                {
                    cell.btnMute.isHidden=true
                    cell.imgStory.isHidden=false
                    cell.btnPlay.isHidden=true
                    cell.imgStory.image =  UIImage(named: "placeholderImage")
                    if let img = cellData?.post_details?.file_name
                        {
                        DispatchQueue.main.async {
                            let url = URL(string: img)!
                            cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                        }
                }
                if let post_date_time = cellData?.post_details?.post_date_time
                    {
                    let time = post_date_time.dateFromString(format: .NewISO, type: .utc)
                    cell.lblTime.text = time.string(format: .date12HourTime, type: .local)
                    
                   }
    
                  cell.txtViewDesc.text = cellData?.post_details?.post_text
               
                if cellData?.is_liked_by_self_user == 1 && cellData?.is_liked_by_other_user_id == 1
                {
                    cell.imgHeart.image = UIImage(named: "Message")
                    cell.lblLike.text = kMessage
                    cell.lblLike.textColor = LINECOLOR
                }
               else if cellData?.is_liked_by_self_user == 1
                {
                    cell.imgHeart.image = UIImage(named: "redLike3")
                    cell.lblLike.text = kLikeProfile//kDislikeProfile
                cell.lblLike.textColor = LIKECOLOR
                }
                else
                {
                    cell.imgHeart.image = UIImage(named: "BlackLike")
                    cell.lblLike.text = kLikeProfile
                    cell.lblLike.textColor = UIColor.black
                }
                
                
                
                    cell.btnThreeDot.addTarget(self, action: #selector(ThreeDotAct), for: .touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(viewProfileAct), for: .touchUpInside)
                
                cell.btnHearVoice.addTarget(self, action: #selector(hearVoiceAct), for: .touchUpInside)
                cell.btnLikeProfile.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
                
                
                cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
                cell.btnMute.addTarget(self, action: #selector(muteAct), for: .touchUpInside)
                
             
                
                
               
                
                self.storyTableCell=cell
                self.videoCell=cell
                return cell
            }
    }
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
           guard let videoCell = (cell as? StoryTCell) else { return };
        /*
        var cellData:StoriesPostDataModel?
        
        if self.StoriesPostData.count>indexPath.row
        {
            cellData = self.StoriesPostData[indexPath.row]
        }
        if let img = cellData?.post_details?.thumbnail
            {
           // DispatchQueue.main.async {
                let url = URL(string: img)!
            videoCell.imgVideo.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
           // }
            }
        else
        {
            videoCell.imgVideo.image = UIImage(named: "placeholderImage")
        }
        for indexVisible in self.tableStory.indexPathsForVisibleRows ?? []
        {
                 let cellRect = self.tableStory.rectForRow(at: indexVisible)
                 let isVisible = self.tableStory.bounds.contains(cellRect)
                 
                 if isVisible {
    
                     print("Fully visible index = \(indexVisible)")
                    MusicPlayer.instance.pause()
                    videoCell.viewPlayer?.player?.play()
                 }
               else
                 {
                    videoCell.viewPlayer?.player?.pause()
                 }
        }
        
        if isVideoMute == true
        {
           videoCell.viewPlayer?.player?.volume = 0.0
            videoCell.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
        }
        else
        {
            videoCell.viewPlayer?.player?.volume = 1.0
            videoCell.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
        }
        */
        
      
        /*
        
           let visibleCells = tableView.visibleCells;
           let minIndex = visibleCells.startIndex;
       // if tableView.visibleCells.firstIndex(of: cell) == minIndex {
        var cellData:StoriesPostDataModel?
        if self.StoriesPostData.count>indexPath.row
        {
            cellData = self.StoriesPostData[indexPath.row]
        }
        print(isVideoMute)
        if DataManager.audioMute==true//isVideoMute == true
        {
           videoCell.viewPlayer?.player?.volume = 0.0
            videoCell.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
        }
        else
        {
            videoCell.viewPlayer?.player?.volume = 1.0
            videoCell.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
        }
        
        if let img = cellData?.post_details?.thumbnail
            {
           // DispatchQueue.main.async {
                let url = URL(string: img)!


            videoCell.imgVideo.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
           // }
            }
        else
        {
            videoCell.imgVideo.image = UIImage(named: "placeholderImage")
        }
        MusicPlayer.instance.pause()
           // videoCell.viewPlayer.player?.volume=0.0
           
            
            if videoCell.viewPlayer?.player?.ready == false
            {

                videoCell.imgVideo.isHidden=false
            }
            else
            {
                videoCell.imgVideo.isHidden=true
            }
        
        for indexVisible in self.tableStory.indexPathsForVisibleRows ?? []
             {
           
                 let cellRect = self.tableStory.rectForRow(at: indexVisible)
                 let isVisible = self.tableStory.bounds.contains(cellRect)
                 
                 if isVisible {
                     //you can also add rows if you dont want full indexPath.
                     //[arr addObject:[NSString stringWithFormat:@"%ld",(long)indexVisible.row]];
                     print("Fully visible index = \(indexVisible)")
                    videoCell.viewPlayer.player?.play();
                 }
            else
                 {
                    print("Not fully visible index = \(indexVisible)")
                    videoCell.viewPlayer.player?.pause();
                   // videoCell.viewPlayer.player?.play();
                 }
        }
        */
    
        
        
        videoCell.btnPlay.isHidden=true
        self.videoCell=videoCell
      
       }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
   
    
    func pausePlayeVideos(){
       
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tableStory)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: self.tableStory, appEnteredFromBackground: true)
    }
    
    /*
     func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         guard let videoCell = cell as? StoryTCell else { return };
        videoCell.viewPlayer.player?.isMuted=true
        videoCell.viewPlayer.player?.pause();
        //videoCell.viewPlayer.player?.volume=0.0
         videoCell.viewPlayer.player = nil;
        if  DataManager.audioMute==true//isVideoMute == true
        {
            //videoCell.viewPlayer?.player?.volume = 0.0
            videoCell.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
        }
        else
        {
            //videoCell.viewPlayer?.player?.volume = 1.0
            videoCell.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
        }
     
       }
    */
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.row%5==0
        {
            if indexPath.row == 0
            {
                return UITableView.automaticDimension
            }
            else
            {
                return 500
            }
            
           
        }
        else
        {
            return UITableView.automaticDimension
        }
  
    }
    //MARK:- Table Button action 🍎
    
    @objc func ThreeDotAct(_ sender:UIButton)
    {
        MusicPlayer.instance.pause()
        self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
        MusicPlayer.instance.pause()
        
        self.storyTableCell?.btnHearVoice.isSelected=false
        
        if self.StoriesPostData.count>sender.tag
        {
            if self.StoriesPostData[sender.tag].post_details?.user_id == DataManager.Id
            {
            
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
                destVC.delegate=self
           
                self.post_id=self.StoriesPostData[sender.tag].post_details?._id ?? ""
                destVC.type = .deleteStory
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
            }
            else
            {
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
                destVC.delegate=self
                
                  self.view_user_id = self.StoriesPostData[sender.tag].user_id ?? ""
                   destVC.post_id = self.StoriesPostData[sender.tag].post_details?._id ?? ""
                    destVC.user_name = self.StoriesPostData[sender.tag].profile_data?.username?.capitalized ?? ""
                
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                 self.present(destVC, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func viewProfileAct(_ sender:UIButton)
    {
        MusicPlayer.instance.pause()
        if self.StoriesPostData.count>sender.tag
        {
        if self.StoriesPostData[sender.tag].post_details?.user_id == DataManager.Id
        {

            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=4
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        else
        {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = self.StoriesPostData[sender.tag].user_id ?? ""
            DataManager.comeFrom=kStory
             self.navigationController?.pushViewController(vc, animated: true)
        }
        }
      
        
        
     
    }
    
    
    
    @objc func hearVoiceAct(_ sender:UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("StopVideo"), object: nil)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableStory)
        let indexPath = self.tableStory.indexPathForRow(at:buttonPosition)
        let cell = self.tableStory.cellForRow(at: indexPath ?? IndexPath(item: 0, section: 0)) as! StoryTCell
        print("click indexpath = \(String(describing: indexPath))")
        self.storyTableCell = cell
        
      
        if self.StoriesPostData.count>sender.tag
        {
        if let voiceUrl = self.StoriesPostData[sender.tag].profile_data?.voice
        {
            MusicPlayer.instance.initPlayer(url:voiceUrl, tag: 12)
            if sender.isSelected
            {
                sender.isSelected=false
                self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
                MusicPlayer.instance.pause()
            }
            else
            {
                sender.isSelected=true
                self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"//"STOP VOICE"
                
                MusicPlayer.instance.play()
            }
         
        }
        }

    }
    @objc func likeBtnAct(_ sender:UIButton)
    {
        MusicPlayer.instance.pause()
        if self.StoriesPostData.count>sender.tag
        {
            let modelHangout = self.StoriesPostData[sender.tag]
            
            
            if modelHangout.is_liked_by_self_user == 1 && modelHangout.is_liked_by_other_user_id == 1
            {
                               
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                let cellData = modelHangout
                vc.view_user_id=cellData.user_id ?? ""
                vc.profileName=(cellData.profile_data?.username ?? "").capitalized
                
                if cellData.profile_data?.images?.count ?? 0>0
                    {
                    if let img = cellData.profile_data?.images?[0].image
                      {
                   vc.profileImage=img
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if modelHangout.is_liked_by_other_user_id == 1
            {
               
                self.StoriesPostData[sender.tag].is_liked_by_self_user = modelHangout.is_liked_by_self_user == 1 ? 0 : 1
                for (index, model) in self.StoriesPostData.enumerated()
                {
                    if model.user_id == modelHangout.user_id
                    {
                        self.StoriesPostData[index].is_liked_by_self_user = self.StoriesPostData[sender.tag].is_liked_by_self_user
                    }
                }
                
                  
                tableStory.reloadData()
                    
                    
                let likeSelfId = modelHangout.is_liked_by_self_user ?? 0
                    
                let valueLike = String(likeSelfId + 1)
                self.likeUnlikeAPI(other_user_id: modelHangout.user_id!, action: valueLike, like_mode: "Shake", type: "Shake")
                
                if valueLike == "1"
                {
                    let imag = modelHangout.profile_data?.images
                    let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                    if imag?.count ?? 0>0
                    {
                        vc.user2Image=imag?[0].image ?? ""
                    }
    //                vc.profileImage=self.other_user_image
    //                vc.view_user_id=self.other_user_id
    //                vc.profileName=(self.UserData?.profile_data?.username ?? "").capitalized
                  //  self.navigationController?.present(vc, animated: true, completion: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
              
                }
            }

            else
            {
            
            
            self.StoriesPostData[sender.tag].is_liked_by_self_user = modelHangout.is_liked_by_self_user == 1 ? 0 : 1
            for (index, model) in self.StoriesPostData.enumerated()
            {
                if model.user_id == modelHangout.user_id
                {
                    self.StoriesPostData[index].is_liked_by_self_user = self.StoriesPostData[sender.tag].is_liked_by_self_user
                }
            }
            
              
            tableStory.reloadData()
                
                
            let likeSelfId = modelHangout.is_liked_by_self_user ?? 0
                
            let valueLike = String(likeSelfId + 1)
            self.likeUnlikeAPI(other_user_id: modelHangout.user_id!, action: valueLike, like_mode: "Shake", type: "Shake")
            }
        }
    }
    
    @objc func playAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
//        if self.StoriesPostData.count>sender.tag
//        {
//
//        if  let url = self.StoriesPostData[sender.tag].post_details?.file_name
//        {
//            DataManager.comeFrom = kViewProfile
//            self.storyTableCell?.imgStory.playVideoOnImage(URL(string: url)!, VC: self)
//        }
//        }
      
    }
    
    
    @objc func muteAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        
//        if self.isVideoMute
//        {
//            self.isVideoMute = false
//        }
//        else
//        {
//            self.isVideoMute = true
//        }
//        self.tableStory.reloadData()
        
        if self.StoriesPostData.count>sender.tag
        {
        
//            let buttonPosition = sender.convert(CGPoint.zero, to: self.tableStory)
//            let indexPath = self.tableStory.indexPathForRow(at:buttonPosition)
//            let cell = self.tableStory.cellForRow(at: indexPath ?? IndexPath(item: 0, section: 0)) as! StoryTCell
//            print("click indexpath = \(String(describing: indexPath))")
//            self.storyTableCell = cell
//
//            if sender.isSelected
//            {
//
//                sender.isSelected=false
//                self.isVideoMute = true
//                DataManager.audioMute=true
//               // self.storyTableCell?.viewPlayer.player?.volume=0.0
//                self.storyTableCell?.btnMute.setImage(UIImage(named: "muteSound")?.tinted(color: UIColor.white), for: .normal)
//            }
//            else
//            {
//                sender.isSelected=true
//                self.isVideoMute = false
//                DataManager.audioMute=false
//               // self.storyTableCell?.viewPlayer.player?.volume=1.0
//                self.storyTableCell?.btnMute.setImage(UIImage(named: "playSound")?.tinted(color: UIColor.white), for: .normal)
//            }
//
            
            if ASVideoPlayerController.sharedVideoPlayer.mute
            {
                ASVideoPlayerController.sharedVideoPlayer.mute = false
            
            }
            else
            {
                ASVideoPlayerController.sharedVideoPlayer.mute = true
           
            }
            self.tableStory.reloadData()
//            UIView.setAnimationsEnabled(false)
          //  self.tableStory.beginUpdates()
//            self.tableStory.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableView.RowAnimation.none)
//            UIView.performWithoutAnimation {
//                self.tableStory.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
//            }
          //  self.tableStory.reloadData()

           
        }
        
        
      
    }
    //MARK:- Sort Button action 🍎
    
    @IBAction func SortAct(_ sender:UIButton)
    {
        MusicPlayer.instance.pause()
     
        let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "StorySortPopupVC") as!  StorySortPopupVC
        destVC.delegate=self
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        self.present(destVC, animated: true, completion: nil)
    }
   
    //MARK:- Scroll action 🍎
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {

        self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
        MusicPlayer.instance.pause()

        self.storyTableCell?.btnHearVoice.isSelected=false
    }
    
    @objc func storyAudioStopedReceivedNotification(notification: Notification)
    {
        print("Audio finish")
        self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
        MusicPlayer.instance.pause()
        
        self.storyTableCell?.btnHearVoice.isSelected=false
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
   
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

            if ((tableStory.contentOffset.y + tableStory.frame.size.height) >= tableStory.contentSize.height-50)
            {
                if self.StoriesPostData.count<StoriesVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    self.callGetStoriesApi(page: self.page)
                }
                
            }
        if !decelerate {
            pausePlayeVideos()
        }
       
    }
    

    
}


extension StoriesVC:threeDotMenuDelegate,storySortDelegate,DiscardDelegate
{
    
    
    func ClickNameAction(name: String)
    {
        if name == kReportPost
        {
            self.dismiss(animated:true) {
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "BlockReportPopUpVC") as!  BlockReportPopUpVC
                //destVC.delegate=self
                
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.navigationController?.pushViewController(destVC, animated: false)
                
            }
           
        }
        else  if name == kViewProfile
        {
    
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = self.view_user_id
            
           DataManager.comeFrom=kStory
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else  if name == kDelete
        {
            self.callDeletePostApi(postId: self.post_id)
        }
        
    }
    
    func selectedOption()
    {
        self.page = 0
        self.currentIndex=0
        StoriesVM.shared.page=0
        self.StoriesPostData.removeAll()
     
        self.callGetStoriesApi(page: self.page)
        
    }
    
}
//MARK:- Get current location 🍎

extension StoriesVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first
           {
               print("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
          
           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
       {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
}


//MARK:- get story and like dislike profile, delete story api call 🍎

extension StoriesVC
{
    
    func callGetStoriesApi(page: Int)
    {
        var data = JSONDictionary()

        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        
      
        
        if DataManager.storyAllPostSelected == ""
        {
            data[ApiKey.kfilter_all_post] = "1"
        }
        else
        {
            data[ApiKey.kfilter_all_post] = DataManager.storyAllPostSelected
        }
       
        
        if DataManager.storyImageSelected == ""
        {
            data[ApiKey.kfilter_img] = "1"
        }
        else
        {
            data[ApiKey.kfilter_img] = DataManager.storyImageSelected
        }
        
        if DataManager.storyVideoSelected == ""
        {
            data[ApiKey.kfilter_video] = "1"
        }
        else
        {
            data[ApiKey.kfilter_video] = DataManager.storyVideoSelected
        }
        data[ApiKey.kfilter_my_post] = DataManager.storyMyPostSelected
        data[ApiKey.kfilter_matched_profile] = DataManager.storyMatchSelected
       
            
            if Connectivity.isConnectedToInternet {
                
                self.callApiForGetStories(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForGetStories(data:JSONDictionary)
    {
        StoriesVM.shared.callApiGetStories(data: data, response: { (message, error) in
        
            if error != nil
            {
                self.viewSort.isHidden=false
                self.showErrorMessage(error: error)
            }
            else{
                self.viewSort.isHidden=false
                Indicator.sharedInstance.showIndicator()
                for dict in StoriesVM.shared.StoriesPostData
                {
                    
                    self.StoriesPostData.append(dict)
            
                }
                if self.StoriesPostData.count>0
                {
                    self.lblNoFound.isHidden=true
                }
                else
                {
                    self.lblNoFound.isHidden=false
                }
                
                self.tableStory.reloadData()
                self.viewSort.isHidden=false
                Indicator.sharedInstance.hideIndicator()
                self.refreshControl.endRefreshing()
                StoriesVM.shared.page=self.page
                           
                        self.page = self.StoriesPostData.count
                                    
                
            }

         
        })
    }
    
    
    //MARK:-  user like,dislike
    
    func likeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kOther_user_id] = other_user_id
        data[ApiKey.kAction] = action
        data[ApiKey.kLike_mode] = like_mode
        data[ApiKey.kTimezone] = TIMEZONE
        
            if Connectivity.isConnectedToInternet {
              
                self.callApiForLikeUnlike(data: data,type: type)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String)
    {
      
        HomeVM.shared.callApiForLikeUnlikeUser(showIndiacter: false, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
       
              
            }

         
        })
    }
    
    
    func callDeletePostApi(postId: String)
    {
        var data = JSONDictionary()

        data[ApiKey.kPost_id] = postId
        
       if Connectivity.isConnectedToInternet {
                
                self.callApiForDeletePost(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    
    func callApiForDeletePost(data:JSONDictionary)
    {
        StoriesVM.shared.callApiDeletePost(data: data, response: { (message, error) in
         
            if error != nil
            {
               
                self.showErrorMessage(error: error)
            }
            else{
                 
                StoriesVM.shared.page=0
                self.StoriesPostData.removeAll()
          
                self.callGetStoriesApi(page: 0)
            }

         
        })
    }
    
    
}
//MARK:- Ads setup 🍎

extension StoriesVC:GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        Indicator.sharedInstance.hideIndicator()
        
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError)
    {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        Indicator.sharedInstance.hideIndicator()
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
