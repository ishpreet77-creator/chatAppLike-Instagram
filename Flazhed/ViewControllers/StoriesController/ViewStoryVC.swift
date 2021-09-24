//
//  ViewStoryVC.swift
//  Flazhed
//
//  Created by IOS33 on 08/04/21.
//

import UIKit
import AVFoundation
import SDWebImage
class ViewStoryVC: BaseVC {
    @IBOutlet weak var tableStory: UITableView!
    @IBOutlet weak var topView: UIView!
    var cellData:PostdetailModel?
    var isMute = true
    var player:AVPlayer?
    var cell:StoryTCell?
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
      var StoryId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callGetStoryApi(StoryId: self.StoryId)
        self.setUpTable()
        
//        topView.borderColor=HOMESADOWCOLOR
//        self.topView.addBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Indicator.sharedInstance.hideIndicator()
        self.tableStory.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let player = player{
            
           
            
            if #available(iOS 10.0, *) {
                player.removeObserver(self, forKeyPath: "timeControlStatus")
            } else {
                player.removeObserver(self, forKeyPath: "rate")
            }
        }
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
        self.cell=cell
        cell.imgStory.sd_imageIndicator = SDWebImageActivityIndicator.gray
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
   
        if kVideo.equalsIgnoreCase(string: cellData?.file_type ?? "") //kVideo
        {
            
            if let img = cellData?.thumbnail
                {
            
                    let url = URL(string: img)!
                cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
                
                cell.imgStory.isHidden=false
                
                let video = cellData?.file_name ?? ""
                let urlVideo = URL(string: video)!
                cell.btnMute.isHidden=false
               // cell.configureCell(imageUrl: img, description: "Video", videoUrl: video)
        
                self.player = AVPlayer(url: urlVideo)
              //  self.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.new.rawValue | NSKeyValueObservingOptions.old.rawValue), context: nil)
                self.setupAVPlayer()
                let playerLayer = AVPlayerLayer(player: player)
               
                playerLayer.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: cell.viewPlayer.frame.height)
                playerLayer.videoGravity = .resizeAspectFill
                cell.imgStory.layer.addSublayer(playerLayer)
                cell.imgStory.backgroundColor = UIColor.black
                if #available(iOS 10.0, *) {
                    player?.playImmediately(atRate: 1.0)
                } else {
                    player?.play()
                }
                
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
                    self?.player?.seek(to: CMTime.zero)
                    self?.player?.play()
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
            
            
           

            actInd.center = cell.imgStory.center
            actInd.style = UIActivityIndicatorView.Style.white
           // cell.imgStory.addSubview(actInd)
           
            
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
                
                var cellFrame = cell.frame.size
               

                cell.imgStory.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in
                    
                    if theImage != nil
                    {
                    //cell.imgHeightConst.constant  = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                        let height = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                        print("Height = \(height)")
                        if height>600
                        {
                            cell.imgHeightConst.constant  = 390//height-120
                            cell.imgStory.contentMode = .scaleAspectFill
                        }
                    else
                        {
                            cell.imgHeightConst.constant  = 390//height
                            cell.imgStory.contentMode = .scaleAspectFill
                        }
                        
                    }
                    else
                    {
                        cell.imgHeightConst.constant = 390
                        cell.imgStory.contentMode = .scaleAspectFill
                    }

                        })

                /*
                DispatchQueue.main.async
                {
                    cell.imgStory.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                }
                
                let size = cell.imgStory.image?.getImageSizeWithURL(url: img)
                
                let height = size?.height ?? 375
                if height > SCREENHEIGHT
                {
                    let per = (height*kLongImagePercent)/100
                    
                    cell.imgHeightConst.constant = SCREENHEIGHT-120//height-per
                }
                
                else if height > 700
                {
                    let per = (height*kImagePercent)/100
                    
                    cell.imgHeightConst.constant = height-per
                }
                else
                {
                    cell.imgHeightConst.constant = size?.height ?? 390
                }
                */
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
        
        if self.isMute
              {
                
                  self.cell?.btnMute.setImage(UIImage(named: "muteSound"), for: .normal)
                  self.player?.isMuted=true
                  self.player?.volume = 0
              }
              else
              {
              
                  self.cell?.btnMute.setImage(UIImage(named: "playSound"), for: .normal)
                  self.player?.isMuted=false
                  self.player?.volume = 1
              }
        
           // self.tableStory.reloadData()
    }

    
    private func setupAVPlayer() {
        if #available(iOS 10.0, *) {
            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === player {
            if keyPath == "status" {
                if player?.status == .readyToPlay
                {
                    //player?.play()
                    
                    if #available(iOS 10.0, *) {
                        player?.playImmediately(atRate: 1.0)
                    } else {
                        player?.play()
                    }
                }
            } else if keyPath == "timeControlStatus" {
                if #available(iOS 10.0, *) {
                    if player?.timeControlStatus == .playing {
                        //Indicator.sharedInstance.hideIndicator()
                        self.actInd.stopAnimating()
                        print("Playing...")
                      
                       // self.cell?.imgStory.isHidden=true
                    } else {
                        
                       // Indicator.sharedInstance.showIndicator()
                        print("Not Playing...")
                        self.actInd.startAnimating()
                        //self.cell?.imgStory.isHidden=false
                    }
                }
            } else if keyPath == "rate" {
                if player?.rate ?? 0 > 0 {
                    print("Playing...")
                    self.actInd.stopAnimating()
                    //self.cell?.imgStory.isHidden=true
                    //Indicator.sharedInstance.hideIndicator()
                } else {
                    //Indicator.sharedInstance.showIndicator()
                    print("Not Playing...")
                    self.actInd.startAnimating()
                   // self.cell?.imgStory.isHidden=false
                }
            }
        }
    }
}
extension ViewStoryVC:FeedbackAlertDelegate
{
    
    func callGetStoryApi(StoryId: String)
    {
        var data = JSONDictionary()

        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kStoryId] = StoryId

            
            if Connectivity.isConnectedToInternet {
                
                self.callApiForStoryDetails(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForStoryDetails(data:JSONDictionary)
    {
        StoriesVM.shared.callApiGetStoryDetail(showIndiacter:true, data: data, response: { (message, error) in
        
            if error != nil
            {
                
                self.showErrorMessage2(error: error)
            }
            else
            {
                self.cellData=StoriesVM.shared.singleStory?.post_details
                
                self.tableStory.reloadData()
            }

         
        })
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
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.errorCode=code
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
                
              
            }
           else
            {
      
                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.delegate=self
                destVC.errorCode=1000
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
                
            }
        
    }
    
            func FeedbackAlertOkFunc(name: String)
            {
             if name == kStory
             {
                DataManager.comeFrom = kViewProfile
                self.navigationController?.popViewController(animated: true)
             }
            
            }
        
}

