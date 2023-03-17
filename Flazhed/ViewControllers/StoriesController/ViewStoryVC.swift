//
//  ViewStoryVC.swift
//  Flazhed
//
//  Created by IOS33 on 08/04/21.
//

import UIKit
import AVFoundation
import SDWebImage
import SkeletonView

class ViewStoryVC: BaseVC {
    @IBOutlet weak var tableStory: UITableView!
    @IBOutlet weak var topView: UIView!
    var cellData:SinglePostDataModel?
    var isMute = true
    var player:AVPlayer?
    var cell:StoryTCell?
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
      var StoryId = ""
    @IBOutlet weak var btnThreeDot: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpTable()
        
        
//        topView.borderColor=HOMESADOWCOLOR
//        self.topView.addBottomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Indicator.sharedInstance.hideIndicator()
        
        if Connectivity.isConnectedToInternet {
            self.callGetStoryApi(StoryId: self.StoryId)
                 } else {

                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
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
    
    @IBAction func ThreeDotAct(_ sender:UIButton)
    {
       
        
        let destVC = StoryMenuPopUpVC.instantiate(fromAppStoryboard: .Stories)

        destVC.type = .ViewPostStory
        destVC.comeFromScreen = .ViewPostStory
            destVC.delegate=self
            //self.view_user_id = cellData?.user_id ?? ""
            destVC.post_id = self.StoryId
        destVC.user_name = cellData?.profile_data?.username?.capitalized ?? ""
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
        if let tab = self.tabBarController
        {
            tab.present(destVC, animated: true, completion: nil)
        }
        else
        {
            self.present(destVC, animated: true, completion: nil)
        }
        
        
    }
}
extension ViewStoryVC:UITableViewDelegate,UITableViewDataSource,SkeletonTableViewDataSource
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
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "StoryTCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "StoryTCell") as! StoryTCell
        return cell
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
        cell.stackBtn.isHidden=true
        cell.topViewHeightConst.constant = 0
        cell.constDescTop.constant = 16
        cell.btnProfile.tag=0
        cell.btnThreeDot.tag=0
        cell.btnHearVoice.tag=0
        cell.btnLikeProfile.tag=0
        cell.btnPlay.tag=0
        cell.btnMute.tag=0
        if kVideo.equalsIgnoreCase(string: cellData?.file_type ?? "") //kVideo
        {
            
            if let img = cellData?.thumbnail
                {
 
                cell.imgStory.setImage(imageName: img, isStory:true)
                cell.imgStory.isHidden=false
                
                let video = cellData?.file_name ?? ""
                let urlVideo = URL(string: video)!
                cell.btnMute.isHidden=false
 
                self.player = AVPlayer(url: urlVideo)
 
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
                self.setupAVPlayer()
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
     
                cell.imgHeightConst.constant = kListImageHeight
                cell.imgStory.contentMode = .scaleAspectFill
                cell.imgStory.setImage(imageName: img, isStory: true)

            }
        }
        if let post_date_time = cellData?.post_date_time
            {
            //let time = post_date_time.dateFromString(format: .NewISO, type: .utc)
            cell.lblTime.text = kEmptyString.checkTimeAgo(startTime: post_date_time)//time.string(format: .date12HourTime, type: .local)
            
           }
        
        
        
          cell.txtViewDesc.text = cellData?.post_text
        
        cell.txtViewDesc.TextSpacing(text: cell.txtViewDesc.text ?? kEmptyString)
        cell.btnPlay.isHidden=true

        cell.btnMute.addTarget(self, action: #selector(muteAct), for: .touchUpInside)

       
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
                        debugPrint("Playing...")
                      
                       // self.cell?.imgStory.isHidden=true
                    } else {
                        
                       // Indicator.sharedInstance.showIndicator()
                        debugPrint("Not Playing...")
                        self.actInd.startAnimating()
                        //self.cell?.imgStory.isHidden=false
                    }
                }
            } else if keyPath == "rate" {
                if player?.rate ?? 0 > 0 {
                    debugPrint("Playing...")
                    self.actInd.stopAnimating()
                    //self.cell?.imgStory.isHidden=true
                    //Indicator.sharedInstance.hideIndicator()
                } else {
                    //Indicator.sharedInstance.showIndicator()
                    debugPrint("Not Playing...")
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
        self.showLoader()
        StoriesVM.shared.callApiGetStoryDetail(showIndiacter:true, data: data, response: { (message, error) in
        
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage2(error: error)
            }
            else
            {
                self.hideLoader()
                self.cellData=StoriesVM.shared.singleStory
                
                let id = StoriesVM.shared.singleStory?.user_id
                
                if id == DataManager.Id
                {
                    self.btnThreeDot.isHidden = true
                }
                else
                {
                    self.btnThreeDot.isHidden = false
                }
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
            
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)

                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.errorCode=code
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                if let tab = self.tabBarController
                {
                    tab.present(destVC, animated: true, completion: nil)
                }
                else
                {
                    self.present(destVC, animated: true, completion: nil)
                }
              
            }
           else
            {
      
                let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)

                destVC.type = .BlockReportError
                destVC.user_name=message
                destVC.delegate=self
                destVC.errorCode=1000
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                if let tab = self.tabBarController
                {
                    tab.present(destVC, animated: true, completion: nil)
                }
                else
                {
                    self.present(destVC, animated: true, completion: nil)
                }
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
extension ViewStoryVC:threeDotMenuDelegate
{
    func ClickNameAction(name: String)
    {
       
        
        if name.equalsIgnoreCase(string: kReportPost)
        {
            self.dismiss(animated:true) {
            
                let destVC = BlockReportPopUpVC.instantiate(fromAppStoryboard: .Stories)
                destVC.comeFromScreen = .ViewPostStory
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                self.navigationController?.pushViewController(destVC, animated: false)
                
            }
            
        }
      
    }
}

extension ViewStoryVC {
    func showLoader() {
        self.tableStory.isSkeletonable = true
        
        self.tableStory.showAnimatedSkeleton()
    }
    
    func hideLoader() {
        self.tableStory.hideSkeleton()
    }
}
