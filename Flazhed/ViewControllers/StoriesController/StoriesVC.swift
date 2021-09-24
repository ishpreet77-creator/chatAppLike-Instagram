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
import SDWebImage

class StoriesVC: BaseVC {

    //MARK:- All outlets  
    
    @IBOutlet weak var tableStory: UITableView!
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var lblNoFound: UILabel!
    
    //MARK:- All Variable  
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
    var StoriesPostData:[StoriesListTypeModel] = []
    var toShowLoader=true
    var isVideoMute = true
    var hearVoiceIndex = -1
    var adsIndex=4
    var StoryCount = 0
    //MARK:- Video changes
    

    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    
    //MARK:- View Lifecycle   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoFound.isHidden=true
        self.page = 0
        self.StoryCount=0
        self.adsIndex=4
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableStory.addSubview(refreshControl)
        setUpTable()

        StoriesVM.shared.page=0
        self.StoriesPostData.removeAll()
        self.tableStory.remembersLastFocusedIndexPath = true
        
      
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        ASVideoPlayerController.sharedVideoPlayer.mute=true
      //  avpController.delegate=self
        
       // avpController.contentOverlayView!.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)

        


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //locationmanager.startMonitoringSignificantLocationChanges()
        toShowLoader=true
        self.viewSort.isHidden=false
  
        DataManager.audioMute=true
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        

        //ASVideoPlayerController.sharedVideoPlayer.mute = true
       
        
       
      
        if DataManager.comeFrom != kViewProfile
        {
            self.page = 0
            self.currentIndex=0
            self.StoryCount=0
            self.adsIndex=4
            StoriesVM.shared.page=0
            self.StoriesPostData.removeAll()
            self.callGetStoriesApi(page: self.page)
            self.updateLocationAPI()
        }
        else
        {
            DataManager.comeFrom = ""
            if DataManager.isVideoMute == false
            {
                
                ASVideoPlayerController.sharedVideoPlayer.mute=false
            }
            else
            {
                ASVideoPlayerController.sharedVideoPlayer.mute=true
            }
            
          self.tableStory.reloadData()
            
           
            pausePlayeVideos()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.storyAudioStopedReceivedNotification(notification:)), name: Notification.Name("StoryAudioStoped"), object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    
        MusicPlayer.instance.pause()
        pausePlayeVideos()
        NotificationCenter.default.post(name: Notification.Name("StopVideo"), object: nil)
        DataManager.isVideoMute = ASVideoPlayerController.sharedVideoPlayer.mute
        
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
        self.StoryCount=0
        self.adsIndex=4
        self.StoriesPostData.removeAll()
  
        self.callGetStoriesApi(page: 0)
    }
}

//MARK:- Tableview setup and show story and ads data 

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
        
        //let count = StoriesPostData.count
    
        return self.StoriesPostData.count//count+count/5
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cellType:StoriesListTypeModel?
        if self.StoriesPostData.count>indexPath.row
        {
            cellType = self.StoriesPostData[indexPath.row]
        }

        
        if cellType?.type == .storyList
        {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTCell") as! StoryTCell
                var cellData:StoriesPostDataModel?
                cell.imgHeightConst.constant = 375
               let tag = indexPath.row
                if self.self.StoriesPostData.count>tag
                {
                    cellData = self.StoriesPostData[tag].storyData
                }
        
                cell.btnProfile.tag=tag
                cell.btnThreeDot.tag=tag
                cell.btnHearVoice.tag=tag
                cell.btnLikeProfile.tag=tag
                cell.btnPlay.tag=tag
                cell.btnMute.tag=tag
                
                cell.btnShare.tag=tag
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
                
                if kVideo.equalsIgnoreCase(string: cellData?.post_details?.file_type ?? "")
                {
                    //cell.imgStory.isHidden=false
                    cell.imgHeightConst.constant = 390
                    DispatchQueue.main.async {
                        if let img = cellData?.post_details?.thumbnail
                            {
        
                            let video = cellData?.post_details?.file_name ?? ""
                            cell.configureCell(imageUrl: img, description: kVideo, videoUrl: video)
                         
                            }
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
                    cell.btnMute.isHidden=false
                    
                    
                    /*
                    if let img = cellData?.post_details?.thumbnail
                    {
                      let url = URL(string: img)!
                      DispatchQueue.main.async {
                      cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                      }
                    }
                    
                    let video = cellData?.post_details?.file_name ?? ""
                    let urlVideo = URL(string: video)!
                   
//                    var player: AVPlayer!
//                    var avpController = AVPlayerViewController()
                    
                    self.player = AVPlayer(url: urlVideo)
                    self.avpController = AVPlayerViewController()
                    self.avpController.addObserver(self, forKeyPath:"videoBounds" , options: NSKeyValueObservingOptions.new, context: nil)
                    self.avpController.player = player
                   
                    self.avpController.videoGravity = .resizeAspectFill
                   // self.player.pause()
                    avpController.view.frame = cell.imgStory.frame
                    avpController.view.backgroundColor = UIColor.white
                    self.addChild(avpController)
                    cell.imgStory.addSubview(avpController.view)
                    */
                }
                else
                {
                  
                    cell.imgStory.isHidden=false
                    cell.btnPlay.isHidden=true
                    cell.imgStory.image =  UIImage(named: "placeholderImage")
                    if let img = cellData?.post_details?.file_name
                        {
                        cell.imgStory.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.imgHeightConst.constant = 390
                        DispatchQueue.main.async {
                            let url = URL(string: img)!
                            cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
                        
//                        let size = cell.imgStory.image?.getImageSizeWithURL(url: img)
//
//                        let height = size?.height ?? 375
//                        if height > SCREENHEIGHT
//                        {
//                            let per = (height*kLongImagePercent)/100
//
//                            cell.imgHeightConst.constant = SCREENHEIGHT-120//height-per
//                        }
//                        else if height > 700
//                        {
//                            let per = (height*kImagePercent)/100
//
//                            cell.imgHeightConst.constant = height-per
//                        }
////                        else if height < 100
////                        {
////                            cell.imgHeightConst.constant = 100
////                        }
//                        else
//                        {
//                            cell.imgHeightConst.constant = size?.height ?? 390
//                        }
                        
                        var cellFrame = cell.frame.size
                       

                        /*
                        cell.imgStory.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in
                            
                            if theImage != nil
                            {
                           // cell.imgHeightConst.constant  = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                                let height = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                                print("Height = \(height)")
                                if height>600
                                {
                                    cell.imgHeightConst.constant  = height-120
                                    cell.imgStory.contentMode = .scaleAspectFill
                                }
                            else
                                {
                                    cell.imgHeightConst.constant  = height
                                    cell.imgStory.contentMode = .scaleAspectFill
                                }
                                
                            }
                            else
                            {
                                cell.imgHeightConst.constant = 375
                                cell.imgStory.contentMode = .scaleAspectFill
                            }
                                })
                        */
                        
                        cell.configureCell(imageUrl: img, description: "Image", videoUrl: nil)
                        }
                    }
                    
                    cell.btnMute.isHidden=true
                }
                if let post_date_time = cellData?.post_details?.post_date_time
                    {
                    let time = post_date_time.dateFromString(format: .NewISO, type: .utc)
                    cell.lblTime.text = time.string(format: .date12HourTime, type: .local)
                    
                   }
    
                  cell.txtViewDesc.text = cellData?.post_details?.post_text
               
                if cellData?.is_liked_by_self_user == 1 && cellData?.is_liked_by_other_user_id == 1
                {
                    cell.imgHeart.image = UIImage(named: "chat")
                    //cell.imgHeart.image = cell.imgHeart.image?.tinted(color: UIColor.black)
                    cell.lblLike.text = kMessage
                    cell.lblLike.textColor = UIColor.black
                }
//
            else if cellData?.story_like_by_self == 1//.is_liked_by_self_user == 1//story_like_by_self
                {
                    cell.imgHeart.image = UIImage(named: "redLike3")
                    cell.lblLike.text = kLikeProfile//kDislikeProfile //kLikeStory
                cell.lblLike.textColor = LIKECOLOR
                }
                else
                {
                    cell.imgHeart.image = UIImage(named: "BlackLike")
                    cell.lblLike.text = kLikeProfile//kLikeStory
                    cell.lblLike.textColor = UIColor.black
                }
                
                if indexPath.row == self.hearVoiceIndex
                {
                   
                   
                    cell.lblHearVoice.text = "STOP VOICE"
                }
                else
                {
                   
                     //"HEAR VOICE"//
                    
                    cell.lblHearVoice.text = "HEAR VOICE"
                }
                
                    cell.btnThreeDot.addTarget(self, action: #selector(ThreeDotAct), for: .touchUpInside)
                    cell.btnProfile.addTarget(self, action: #selector(viewProfileAct), for: .touchUpInside)
                
                cell.btnHearVoice.addTarget(self, action: #selector(hearVoiceAct), for: .touchUpInside)
                cell.btnLikeProfile.addTarget(self, action: #selector(likeBtnAct), for: .touchUpInside)
                
                
                cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
                cell.btnMute.addTarget(self, action: #selector(muteAct), for: .touchUpInside)
                
                cell.btnShare.addTarget(self, action: #selector(shareAct), for: .touchUpInside)
                
                self.storyTableCell=cell
                self.videoCell=cell
                
                
            
                
                return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryAdsTCell") as! StoryAdsTCell
            DispatchQueue.main.async {
                
                let width = (cell.bounds.width-300)/2
//                let fram = cell.bounds.height
//
                let  frame = CGRect(origin: CGPoint(x: width, y: 0), size: CGSize(width: 300, height: 600))
                
             let bannerView = StoryAdsTCell.cellBannerView(rootVC: self, frame: frame)
        
                     for subview in cell.subviews {
                       subview.removeFromSuperview()
                     }
           //  bannerView.delegate = self
            cell.backgroundColor=UIColor.black
             cell.addSubview(bannerView)//.addSubview(bannerView)
            self.tableStory.isScrollEnabled=true
           
            }
            
             return cell
        }
 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        var cellType:StoriesListTypeModel?
        if self.StoriesPostData.count>indexPath.row
        {
            cellType = self.StoriesPostData[indexPath.row]
        }

        
        if cellType?.type == .storyList
        
        {
            return UITableView.automaticDimension
        }
        else
        {
            return 600//SCREENWIDTH
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
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL
        {
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
    
    
    
  
    
    //MARK:- Table Button action 
    
    @objc func ThreeDotAct(_ sender:UIButton)
    {
        MusicPlayer.instance.pause()
        self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
        MusicPlayer.instance.pause()
        
        self.storyTableCell?.btnHearVoice.isSelected=false
        
        if self.StoriesPostData.count>sender.tag
        {
            self.view_user_id = self.StoriesPostData[sender.tag].storyData?.post_details?.user_id ?? ""
            self.post_id = self.StoriesPostData[sender.tag].storyData?.post_details?._id ?? ""
            if self.StoriesPostData[sender.tag].storyData?.post_details?.user_id == DataManager.Id
            {
            
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
                destVC.delegate=self
           
                self.post_id=self.StoriesPostData[sender.tag].storyData?.post_details?._id ?? ""
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
                
                self.view_user_id = self.StoriesPostData[sender.tag].storyData?.user_id ?? ""
                   destVC.post_id = self.StoriesPostData[sender.tag].storyData?.post_details?._id ?? ""
                    destVC.user_name = self.StoriesPostData[sender.tag].storyData?.profile_data?.username?.capitalized ?? ""
                
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
        if self.StoriesPostData[sender.tag].storyData?.post_details?.user_id == DataManager.Id
        {

            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=4
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        else
        {
            let id = self.StoriesPostData[sender.tag].storyData?.user_id ?? ""
            
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = id
            vc.story_id=self.StoriesPostData[sender.tag].storyData?.post_details?._id ?? ""
            DataManager.comeFrom=kStory
            vc.likeMode=kStory
            vc.isfromStoryListing=true
            
//            vc.view_user_id = self.view_user_id
//            vc.story_id=self.post_id
//            vc.likeMode=kStory
//           DataManager.comeFrom=kStory
             self.navigationController?.pushViewController(vc, animated: true)
//
//
//            if #available(iOS 13.0, *) {
//                SCENEDEL?.navigateToHome(userId: id)
//            } else {
//                // Fallback on earlier versions
//                APPDEL.navigateToHome(userId: id)
//        }
            
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
//            DataManager.HomeRefresh="true"
//            DataManager.OtherUserId = id
//            DataManager.comeFromTag=6
//            vc.selectedIndex=2
//            self.navigationController?.pushViewController(vc, animated: false)
      
        }
        }
        
     
    }
    
    
    
    @objc func hearVoiceAct(_ sender:UIButton)
    {
        //NotificationCenter.default.post(name: Notification.Name("storyAudioStopedReceivedNotification"), object: nil)

        
        
        NotificationCenter.default.post(name: Notification.Name("PauseVideo"), object: nil)
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableStory)
        let indexPath = self.tableStory.indexPathForRow(at:buttonPosition)
        let cell = self.tableStory.cellForRow(at: indexPath ?? IndexPath(item: 0, section: 0)) as! StoryTCell
        print("click indexpath = \(String(describing: indexPath))")
        self.storyTableCell = cell
        self.hearVoiceIndex = sender.tag
      
        if self.StoriesPostData.count>sender.tag
        {
        if let voiceUrl = self.StoriesPostData[sender.tag].storyData?.profile_data?.voice
        {
            MusicPlayer.instance.initPlayer(url:voiceUrl, tag: 12)
            if sender.isSelected
            {
                sender.isSelected=false
                self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
                
                MusicPlayer.instance.pause()
                
                            do{
                                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers])
                                    try AVAudioSession.sharedInstance().setActive(false)
                                }catch{
                                    print("something went wrong")
                                }
            }
            else
            {
                sender.isSelected=true
                self.storyTableCell?.lblHearVoice.text = "STOP VOICE" //"HEAR VOICE"//
                
                MusicPlayer.instance.play()
                            do{
                                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers])
                                    try AVAudioSession.sharedInstance().setActive(true)
                                }catch{
                                    print("something went wrong")
                                }
            }
        }
            

        }

    }
    @objc func likeBtnAct(_ sender:UIButton)
    {
        MusicPlayer.instance.pause()
        //MARK:- Like Profile
    
      /*
        if self.StoriesPostData.count>sender.tag
        {
            let modelHangout = self.StoriesPostData[sender.tag].storyData
            
            
            if modelHangout?.is_liked_by_self_user == 1 && modelHangout?.is_liked_by_other_user_id == 1
            {
                               
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                let cellData = modelHangout
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kStory
                vc.commentTitle=cellData?.post_details?.post_text ?? ""
                let postType = cellData?.post_details?.file_type ?? ""
                
                if  kVideo.equalsIgnoreCase(string: postType)
                {
                vc.commentImage=cellData?.post_details?.thumbnail ?? ""
                }
                else
              {
                vc.commentImage=cellData?.post_details?.file_name ?? ""
              }
                vc.commentImage=cellData?.post_details?.file_name ?? ""
                
                if cellData?.profile_data?.images?.count ?? 0>0
                    {
                    if let img = cellData?.profile_data?.images?[0].image
                      {
                   vc.profileImage=img
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if is_liked_by_other_user_id == 1
            {
               
                self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user = modelHangout?.is_liked_by_self_user == 1 ? 0 : 1
                
        let status =  self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user
                
                for (index, model) in self.StoriesPostData.enumerated()
                {
                    if model.storyData?.user_id == modelHangout?.user_id
                    {
                        self.StoriesPostData[index].storyData?.is_liked_by_self_user = status
                    }
                }
                
                  
                tableStory.reloadData()
                    
                    
                let likeSelfId = modelHangout?.is_liked_by_self_user ?? 0
                    
                let valueLike = String(likeSelfId + 1)

                self.ProfilelikeUnlikeAPI(other_user_id: modelHangout?.user_id ?? "", action: valueLike, like_mode: kStory, type: kStory)
                
                if valueLike == "1"
                {
                    let imag = modelHangout?.profile_data?.images
                    let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                    vc.comefrom=kViewProfile
                    vc.view_user_id=modelHangout?.user_id ?? ""
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
            
            
                self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user = modelHangout?.is_liked_by_self_user == 1 ? 0 : 1
                let statu = self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user
            for (index, model) in self.StoriesPostData.enumerated()
            {
                if model.storyData?.user_id == modelHangout?.user_id
                {

               self.StoriesPostData[index].storyData?.is_liked_by_self_user = statu //self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user


                }
            }
//
              
            tableStory.reloadData()
                
                
                let likeSelfId = modelHangout?.is_liked_by_self_user ?? 0
                
            let valueLike = String(likeSelfId + 1)
                self.ProfilelikeUnlikeAPI(other_user_id: modelHangout?.user_id ?? "", action: valueLike, like_mode: kStory, type: kStory)
            }
        }
        */
        //MARK:- Like story
    
        
        if self.StoriesPostData.count>sender.tag
        {
            let modelHangout = self.StoriesPostData[sender.tag].storyData
            
            
            if modelHangout?.is_liked_by_self_user == 1 && modelHangout?.is_liked_by_other_user_id == 1
            {
                               
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                let cellData = modelHangout
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kStory//kMatch
                vc.commentTitle=cellData?.post_details?.post_text ?? ""
                vc.commentPostId=cellData?.post_details?._id ?? ""
                let postType = cellData?.post_details?.file_type ?? ""

                if  kVideo.equalsIgnoreCase(string: postType)
                {
                vc.commentImage=cellData?.post_details?.thumbnail ?? ""
                }
                else
              {
                vc.commentImage=cellData?.post_details?.file_name ?? ""
              }
               // vc.commentImage=cellData?.post_details?.file_name ?? ""
//
                if cellData?.profile_data?.images?.count ?? 0>0
                    {
                    if let img = cellData?.profile_data?.images?[0].image
                      {
                   vc.profileImage=img
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if modelHangout?.story_like_by_self == 1//is_liked_by_other_user_id == 1
            {
               
                self.StoriesPostData[sender.tag].storyData?.story_like_by_self = modelHangout?.story_like_by_self == 1 ? 0 : 1
                
              //  let status =  self.StoriesPostData[sender.tag].storyData?.story_like_by_self
                
//                for (index, model) in self.StoriesPostData.enumerated()
//                {
//                    if model.storyData?.user_id == modelHangout?.user_id
//                    {
//                        self.StoriesPostData[index].storyData?.is_liked_by_self_user = status //self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user
//                    }
//                }
                
                  
                tableStory.reloadData()
                    
                    
                let likeSelfId = modelHangout?.story_like_by_self ?? 0
                    
                let valueLike = String(likeSelfId + 1)
                self.StoryLikeUnlikeAPI(other_user_id: modelHangout?.post_details?._id ?? "", action: valueLike, like_mode: kStory, type: kStory)
                
                if valueLike == "1"
                {
                    let imag = modelHangout?.profile_data?.images
                    let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                    vc.comefrom=kViewProfile
                    vc.view_user_id=modelHangout?.user_id ?? ""
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
            
            
                self.StoriesPostData[sender.tag].storyData?.story_like_by_self = modelHangout?.story_like_by_self == 1 ? 0 : 1
//                let statu = self.StoriesPostData[sender.tag].storyData?.story_like_by_self
//            for (index, model) in self.StoriesPostData.enumerated()
//            {
//                if model.storyData?.user_id == modelHangout?.user_id
//                {
//                        
//            self.StoriesPostData[index].storyData?.story_like_by_self = statu //self.StoriesPostData[sender.tag].storyData?.is_liked_by_self_user
//             
//                   
//                }
//            }
//            
              
            tableStory.reloadData()
                
                
                let likeSelfId = modelHangout?.story_like_by_self ?? 0
                
            let valueLike = String(likeSelfId + 1)
                self.StoryLikeUnlikeAPI(other_user_id: modelHangout?.post_details?._id ?? "", action: valueLike, like_mode: kStory, type: kStory)
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
            pausePlayeVideos()
            //let indexPath = IndexPath(row: sender.tag, section: 0)
            //self.tableStory.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
            
            
//            UIView.setAnimationsEnabled(false)
          //  self.tableStory.beginUpdates()
//            self.tableStory.reloadSections(NSIndexSet(index: 1) as IndexSet, with: UITableView.RowAnimation.none)
//            UIView.performWithoutAnimation {
//                self.tableStory.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
//            }
          //  self.tableStory.reloadData()

           
        }
        
        
      
    }
    
    @objc func shareAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        let text = ShareHangoutText
        
        // set up activity view controller
        let textToShare = [ShareHangoutText]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
       // activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Sort Button action 
    
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
   
    //MARK:- Scroll action 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {

        self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
        MusicPlayer.instance.pause()

        self.storyTableCell?.btnHearVoice.isSelected=false
        //self.viewSort.isHidden=true
        
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
                 //  print("up")
            self.viewSort.isHidden=false

               }
               else {
                   //print("down")
                self.viewSort.isHidden=true

               }
    }
    

    
    @objc func storyAudioStopedReceivedNotification(notification: Notification)
    {
        print("Audio finish")
        self.storyTableCell?.lblHearVoice.text = "HEAR VOICE"
        MusicPlayer.instance.pause()
       // self.hearVoiceIndex = -1
       // self.tableStory.reloadData()
        self.storyTableCell?.btnHearVoice.isSelected=false
        do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
                print("something went wrong")
            }
        pausePlayeVideos()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
       // self.viewSort.isHidden=false

        
    }
  
   
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

       // self.viewSort.isHidden=false
        
            if ((tableStory.contentOffset.y + tableStory.frame.size.height) >= tableStory.contentSize.height-50)
            {
                if self.StoryCount<StoriesVM.shared.Pagination_Details?.totalCount ?? 0
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
        else  if name.equalsIgnoreCase(string: kViewProfile) 
        {
    
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = self.view_user_id
            vc.story_id=self.post_id
            vc.likeMode=kStory
           DataManager.comeFrom=kStory
            vc.isfromStoryListing=true
            self.navigationController?.pushViewController(vc, animated: false)
            
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
//            DataManager.HomeRefresh="true"
//            DataManager.OtherUserId = self.view_user_id
//            DataManager.comeFromTag=6
//            vc.selectedIndex=2
//            self.navigationController?.pushViewController(vc, animated: false)
//
            
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
        self.StoryCount=0
        self.adsIndex=4
        StoriesVM.shared.page=0
        self.StoriesPostData.removeAll()
     
        self.callGetStoriesApi(page: self.page)
        
    }
    
}
//MARK:- Get current location 

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


//MARK:- get story and like dislike profile, delete story api call 

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
        StoriesVM.shared.callApiGetStories(showIndiacter:self.toShowLoader, data: data, response: { (message, error) in
        
            if error != nil
            {
                self.viewSort.isHidden=false
                self.showErrorMessage(error: error)
            }
            else{
                self.viewSort.isHidden=false
                Indicator.sharedInstance.showIndicator()
                self.StoryCount = self.StoryCount+StoriesVM.shared.StoriesPostData.count
                for dict in StoriesVM.shared.StoriesPostData
                {
                    if self.StoriesPostData.count == self.adsIndex
                    {
                        self.StoriesPostData.append(StoriesListTypeModel.init(type: .ads))
                        self.adsIndex=self.adsIndex+5
                    }
                    self.StoriesPostData.append(StoriesListTypeModel.init(type: .storyList, storyData: dict))
            
                }
                if self.StoryCount>0
                {
                    self.lblNoFound.isHidden=true
                    
                }
                else
                {
                    self.lblNoFound.isHidden=false
                }
                
                self.tableStory.reloadData()
               // if self.StoriesPostData.count <= 10
               // {
                    self.pausePlayeVideos()
               // }
                
                self.viewSort.isHidden=false
               
                self.refreshControl.endRefreshing()
                StoriesVM.shared.page=self.page
                           
                self.page = self.StoryCount
                                    
                Indicator.sharedInstance.hideIndicator()
            }

         
        })
    }
    
    
    
    //MARK:-  user like,dislike
    
    func ProfilelikeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String)
    {
        var data = JSONDictionary()
  
        data[ApiKey.kOther_user_id] = other_user_id
        data[ApiKey.kAction] = action
        data[ApiKey.kLike_mode] = like_mode
        data[ApiKey.kTimezone] = TIMEZONE
        
        
            if Connectivity.isConnectedToInternet {
              
                self.callApiForProfileLikeUnlike(data: data,type: type)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForProfileLikeUnlike(data:JSONDictionary,type:String)
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
    
    //MARK:-  Story like,dislike
    
    func StoryLikeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kStoryId] = other_user_id
        data[ApiKey.kIs_like] = action
        data[ApiKey.kLike_mode] = like_mode
        data[ApiKey.kTimezone] = TIMEZONE
    
        
            if Connectivity.isConnectedToInternet {
              
                self.callApiForStoryLikeUnlike(data: data,type: type)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForStoryLikeUnlike(data:JSONDictionary,type:String)
    {
      
       StoriesVM.shared.callApiLikeStory(showIndiacter: false, data: data, response: { (message, error) in
            
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
                self.StoryCount=0
                self.adsIndex=4
                self.callGetStoriesApi(page: 0)
            }

         
        })
    }
    
    func updateLocationAPI()
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        
        if Connectivity.isConnectedToInternet {
            
            self.callApiForUpdateLatLong(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForUpdateLatLong(data:JSONDictionary)
    {
        HomeVM.shared.callApiForUpdateUserLatLong(showIndiacter: false, data: data, response: { (message, error) in
            print("Location update api = \(message)")
            
        })
    }
    
    
    func RemoveStoryHangoutAPI(listId:String,showIndicator:Bool=true)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kId] = listId
  
        if Connectivity.isConnectedToInternet {
            
            self.callApiForRemoveStoryHangout(data: data,showIndicator:showIndicator)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    func callApiForRemoveStoryHangout(data:JSONDictionary,showIndicator:Bool)
    {
        HomeVM.shared.callApiForRemoveStoryHangout(showIndiacter: showIndicator, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
              
            }
        }
        )
        
    }
    
    
}
//MARK:- Ads setup 

extension StoriesVC:GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
      

    }
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError)
//    {
//        print("adView:didFailToReceiveAdWithError: \(error)")
//
//    }
//
//    /// Tells the delegate that a full-screen view will be presented in response
//    /// to the user clicking on an ad.
//    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//        print("adViewWillPresentScreen")
//    }
//
//    /// Tells the delegate that the full-screen view will be dismissed.
//    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewWillDismissScreen")
//    }
//
//    /// Tells the delegate that the full-screen view has been dismissed.
//    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewDidDismissScreen")
//    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}

//MARK:- Video delegate

extension StoriesVC:AVPlayerViewControllerDelegate
{
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
  
        
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("KeyPath \(keyPath)")
//
//     if keyPath == "videoBounds" {
//         print("New Video Bounds \(change)")
//        DataManager.comeFrom = kViewProfile
//     }
//    }
  
    


 
    
}
