//
//  HomeVC.swift
//  Flazhed
//
//  Created by IOS20 on 05/01/21.
//

import UIKit
import GoogleMobileAds
import AVKit
import CoreLocation
import AgoraRtmKit
import SkeletonView
import GoogleAnalytics
import Firebase
import AppTrackingTransparency
import AdSupport

class HomeVC: BaseVC {
    
    @IBOutlet weak var viewLoaderTop: UIView!
    @IBOutlet weak var view4Loader: UIView!
    @IBOutlet weak var view3Loader: UIView!
    @IBOutlet weak var view2Loader: UIView!
    @IBOutlet weak var view1Loader: UIView!
    @IBOutlet weak var viewLoaderButtom: UIView!
    //MARK: - All outlets
    @IBOutlet weak var viewLoaderBack: UIView!
    @IBOutlet weak var viewLoader: UIView!
    
    @IBOutlet weak var viewTableBack: UIView!
   // @IBOutlet weak var btnLikeCard: UIButton!
    @IBOutlet weak var imgCardLike: UIImageView!
    @IBOutlet weak var viewButtomCard: UIView!
    @IBOutlet weak var shakeView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var addsView: UIView!
    @IBOutlet weak var addsSubView: UIView!
    @IBOutlet weak var imgChangeCard: UIImageView!
    
    @IBOutlet weak var tableAllUser: UITableView!
    @IBOutlet weak var rightConst: NSLayoutConstraint!
    @IBOutlet weak var leftConst: NSLayoutConstraint!
    
    @IBOutlet weak var regretView: UIView!
    @IBOutlet weak var disLikeView: UIView!
    @IBOutlet weak var hearView: UIView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var changeModeView: UIView!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDisLike: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var btnHearVoice: UIButton!
    @IBOutlet weak var imgNewRegret: UIImageView!
    
    @IBOutlet weak var imgNewVoice: UIImageView!
    @IBOutlet weak var imgNewDislike: UIImageView!
    
    @IBOutlet weak var imgNewAno: UIImageView!
    //MARK: - All Variable
    var permissionLocationCheck:Bool = false
    var toShow = ""
    var toShowAno = ""
    var isplayVideo=false
    var isAnoModeOn=true
    var isPagination=false
    var fromRegret=false
    
    var anoCollectionHeight = 50
    var shakeCollectionHeight = 50
    
    var currentPage = ""
    
    var UserData:HomeUserListModel?
    var bannerView: GADBannerView!
    var other_user_id = ""
   
    var is_liked_by_other_user_id = 0
    
    let locationmanager = CLLocationManager()
    var voiceUrl = ""
    
    var currentUserIndex = 0
    var currentUserDetails:HomeUserListModel?
    var AllUserDataArray:[HomeUserListModel] = []
    var page = 0
    
    var fromLikeDisLike=false
    var scrollDown=false
    var postImageData:[PostdetailModel] = []
    var view_user_id = "601a3769db19430c7ea84786"
    var likeViewProfile = false
    var isRegetEnable = false
    var cellHeights = [IndexPath: CGFloat]()
    
     var scrollStart=false
    var lastPoint:CGFloat = 0.0
    var regretPaymentChecked=false
    var cellHeight = SCREENHEIGHT
    var swipeRight = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page = 0
      
        self.BackgroundDataCall()
        SocketIOManager.shared.initializeSocket()
        if DataManager.comeFromTag == 100
        {
            DataManager.comeFrom = ""
            DataManager.HomeRefresh = true
            
        }
       
        
        self.cardView.isHidden=true

        self.shakeView.isHidden=false

        self.addsView.isHidden=true
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //locationmanager.startMonitoringSignificantLocationChanges()
        
        self.adsSetup()
        
        //MARK: - Hide load view
        self.regretView.isHidden=true
        
        
        //self.selfJoinSocketEmit()
       
        self.setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.profileAudioStopedReceivedNotification(notification:)), name: Notification.Name("profileAudioStoped"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideLoader()
        self.viewLoader.isHidden=true
        SocketIOManager.shared.initializeSocket()
       // self.selfJoinSocketEmit()
       
        self.setUpTable()
        
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //  locationmanager.startMonitoringSignificantLocationChanges()
        
//MARK: -  data manager 5- show initial two card, 4- show shake user, 3- Show card anonyous user
        
        debugPrint("current comefrom tag = \(DataManager.comeFromTag)")
        
        
        if DataManager.HomeRefresh//.equalsIgnoreCase(string: "true")
        //self.isplayVideo==false
        {
            self.regretPaymentChecked=false
            self.isRegetEnable=false
            if DataManager.comeFromTag==3
            {
                self.cardView.isHidden=true
                self.shakeView.isHidden=true
                
                self.addsView.isHidden=true
                
                
                self.AllUserDataArray.removeAll()
                self.fromLikeDisLike=true
                
                self.getAnonymousUser(page: 0)
                
                imgChangeCard.image = UIImage(named: "NewPhoneRotate")
                
            }
            
            else if DataManager.comeFromTag==4
            {
                self.cardView.isHidden=true
                self.shakeView.isHidden=true
                
                self.addsView.isHidden=true
                self.shakeView.isHidden=true
                self.adsSetup()
                
                //self.getShakeSentUser()
                DataManager.comeFromTag=0
                let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)
                destVC.delegate=self
                destVC.type = .shakeSent
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
            
            else if DataManager.comeFromTag==5
            {
                //                self.cardView.isHidden=true
                //                self.shakeView.isHidden=true
                //
                //                self.addsView.isHidden=true
                //                self.shakeView.isHidden=false
                //                DataManager.comeFromTag=3
                
                
                
                self.cardView.isHidden=true
                self.addsView.isHidden=true
                self.viewButtomCard.isHidden=true
                self.shakeView.isHidden=true
                
                
                self.AllUserDataArray.removeAll()
                self.getShakeSentUser(page: 0)
                
                
            }
            else if DataManager.comeFromTag==6
            {
                self.view_user_id = DataManager.OtherUserId
                self.cardView.isHidden=false
                self.shakeView.isHidden=true
                self.addsView.isHidden=true
                DataManager.HomeRefresh=false
                DataManager.OtherUserId = ""
                DataManager.comeFromTag=3
                
                if Connectivity.isConnectedToInternet {
                    
                    //self.callApiForProfileDetails(data: self.view_user_id)
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
            }
            
            else
            {
                if toShow == "Card"
                {
                    self.cardView.isHidden=false
                    self.shakeView.isHidden=true
                }
                else
                {
                    self.cardView.isHidden=true
                    self.shakeView.isHidden=false
                 
                }
            }
        }
        else
        {
            self.isplayVideo=false
            DataManager.comeFrom = ""
            DataManager.HomeRefresh = false
        }
        
        if self.getDeviceModel() == "iPhone 6"
        {
            self.leftConst.constant = 48
            rightConst.constant = 48
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            self.leftConst.constant = 48
            rightConst.constant = 48
        }
        else
        {
            
            self.leftConst.constant = 32
            rightConst.constant = 32
        }
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                debugPrint("No access")
                self.permissionLocationCheck=false
            //self.openSettings(message: kLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                debugPrint("Access")
                self.permissionLocationCheck=true
            @unknown default:
                break
            }
        } else {
            debugPrint("Location services are not enabled")
            self.permissionLocationCheck=false
            //self.openSettings(message: kLocation)
        }
        if self.permissionLocationCheck==false
        {
            self.openSettings(message: PermissonType.kLocationEnable)
        }
        
        self.navigationController?.navigationBar.isHidden=true
     //   self.getRTMTokenApi()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
       
        DispatchQueue.global(qos: .background).async {
            if Connectivity.isConnectedToInternet {
                
                debugPrint("self.appDelegate?.homeVisitCount \(self.appDelegate?.homeVisitCount)")
                
                if self.appDelegate?.homeVisitCount == 0 {
                    
                    // var data = JSONDictionary()
                   //
                   //            data[ApiKey.kTimezone] = TIMEZONE
                   //
                   //            if Connectivity.isConnectedToInternet {
                   //
                   //                self.callApiForRegretShake(data: data)
                   //            } else {
                   //
                   //                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                   //            }
                    
                    self.getMySubscriptionApi(MySubscriptiontype: kDidAppear)
                    self.updateLocationAPI()
                }
                self.appDelegate?.homeVisitCount += 1
            }
        }
    }
    //MARK: - Stop audio
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.stopVoice()
       // DispatchQueue.global().suspend()
    }
    

    
    func setUI()
    {
        /*
        self.btnLike.tag = 1
        
        self.btnLike.normalColor = UIColor.black
        self.btnLike.selectedColor = UIColor.red
        self.btnLike.setImage(UIImage(named: "NewLike"), for: .selected)
      //  self.btnLike.setImage(UIImage(named: "BlackLike2"), for: .normal)
        self.btnLike.setSelected(selected: false, animated: true)
        self.btnLike.delegate=self
        
        self.btnDisLike.tag = 2
        self.btnDisLike.normalColor = UIColor.red
        self.btnDisLike.selectedColor = UIColor.red
        self.btnDisLike.setImage(UIImage(named: "crosss"), for: .selected)
       // self.btnDisLike.setImage(UIImage(named: "crosss"), for: .normal)
        self.btnDisLike.setSelected(selected: true, animated: true)
        self.btnDisLike.delegate=self
        self.btnDisLike.setSelected(selected: false, animated: true)
        
        */
    
    }
    
    //MARK: - Message Button action

    @IBAction func messageBtnAct (_ sender:UIButton)
    {
        
            
        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
            vc.screenType = kHome
            DataManager.HomeRefresh = false
            if self.AllUserDataArray.count==1
            {
                self.currentUserDetails = self.AllUserDataArray[0]
            }
            
             self.stopVoice()
       
            
            let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
            let cellData = self.currentUserDetails
              vc.chat_room_id=cellData?.chat_room_details?._id ?? ""
            if kStory.equalsIgnoreCase(string: mode)
            {
                
                
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kStory
                vc.commentTitle=cellData?.Single_Story_Details?.post_text ?? ""
                
                let postType = cellData?.Single_Story_Details?.file_type ?? ""
                
                if  kVideo.equalsIgnoreCase(string: postType)
                {
                vc.commentImage=cellData?.Single_Story_Details?.thumbnail ?? ""
                }
                else
              {
                vc.commentImage=cellData?.Single_Story_Details?.file_name ?? ""
              }
                
                
                vc.commentPostId=cellData?.Single_Story_Details?._id ?? ""
            }
            else if kHangout.equalsIgnoreCase(string: mode)
            {
                
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kHangout
                vc.commentTitle=cellData?.Single_Hangout_Details?.heading ?? ""
                vc.commentImage=cellData?.Single_Hangout_Details?.image ?? ""
                vc.commentPostId=cellData?.Single_Hangout_Details?._id ?? ""
            }
        DataManager.comeFrom = kEmptyString
            
            self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //MARK: - respond ToSwipe Gesture action
    
    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        debugPrint("DataManager.purchasePlan \(DataManager.purchasePlan)")
//        debugPrint("AllUserDataArray.count \(self.AllUserDataArray.count)")
//
        if DataManager.purchasePlan
        {
            self.tableAllUser.isScrollEnabled=true
        }
        else
        {
        if sender.direction == .up
        {
            debugPrint("swipe up")
            self.tableAllUser.isScrollEnabled=true
        }
        else if sender.direction == .down
        {
            debugPrint("swipe down")
            self.tableAllUser.isScrollEnabled=false
        }
        }
        
        
    }
    
    
    //MARK: - Bottom Five (Like , dislike...) Act
    
    
    //MARK: - Regret swipe action
    
    @IBAction func shareAct(_ sender: UIButton)
    {
        //         IAPHandler.shared.validatePurchase(success: { (status) in
        //
        //            debugPrint("Purchase Status = \(status)")
        //
        //        })
        
        //        if 1==1//DataManager.purchasePlan==false
        //        {
        //
        //            var data = JSONDictionary()
        //
        //            data[ApiKey.kTimezone] = TIMEZONE
        //
        //            if Connectivity.isConnectedToInternet {
        //
        //                self.callApiForRegretShake(data: data)
        //            } else {
        //
        //                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        //            }
        //        }
        //        else
        //        {
        //            let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
        //            let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
        //            destVC.type = .Regret
        //            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //
        //            self.present(destVC, animated: true, completion: nil)
        
        //}
        
        //MARK: - For payment check api
        if self.regretPaymentChecked
        {
            let active = AccountVM.shared.Shake_Subsription_Data?.subscription_is_active ?? 0
            
            if active == 1
            {
                var type = kAnonymous
                if self.isAnoModeOn==false
                {
                    type=kShake
                }
               DataManager.purchasePlan=true
     
            
                var data = JSONDictionary()
                
                data[ApiKey.kTimezone] = TIMEZONE
                data[ApiKey.kRegret_type] = type
                
                if Connectivity.isConnectedToInternet {
                    
                    self.callApiForRegretShake(data: data)
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
                
               
            }
            else
            {
                DataManager.purchasePlan=false
//                let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
//                let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
//                destVC.type = .Regret
//                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//                self.present(destVC, animated: true, completion: nil)
//
                
                self.runOutPremiumPopup()
                
                
            }

        }
        else
        {
        
        if Connectivity.isConnectedToInternet {

            self.getMySubscriptionApi()
        } else {

            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        }
        
//        //MARK: - To show popup
//
//        let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
//        let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
//        destVC.type = .Regret
//        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//        self.present(destVC, animated: true, completion: nil)
        
    }
    
    //MARK: - Hear voice action
    
    @IBAction func soundPlayAct(_ sender: UIButton)
    {
        
        debugPrint("Voice url \(self.voiceUrl)")
        self.voiceUrl = self.currentUserDetails?.profile_data?.voice ?? ""
        
        
        if  self.voiceUrl != ""
        {
            MusicPlayer.instance.initPlayer(url:self.voiceUrl, tag: 10)
            if self.btnHearVoice.isSelected
            {
                MusicPlayer.instance.pause()
                self.btnHearVoice.isSelected=false
                self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
            }
            else
            {
                self.imgNewVoice.image = UIImage(named: "NewImgVoiceFill")
                self.btnHearVoice.isSelected=true
                //self.lightUp(imageName: self.imgNewVoice)
                MusicPlayer.instance.play()
               
            }
            
        }
        
        
    }
    
    //MARK: - Dislike user action
    
    @IBAction func DisLikeAct(_ sender: UIButton)
    {
        self.imgNewDislike.image = UIImage(named: "NewImgDislikeFill")
        Timer.scheduledTimer(withTimeInterval: kButtonLikeDuration, repeats: false, block: { _ in
            self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
        })
        

        //self.lightUp(imageName: self.imgNewDislike)
        
        self.regretView.isHidden=false
        //MARK: - tage 0- card, 2- user details, 3- ads
                if self.AllUserDataArray.count==1
                {
                    self.currentUserDetails = self.AllUserDataArray[0]
                }
             
        self.stopVoice()
                self.other_user_id = self.currentUserDetails?.user_id ?? ""
           
        debugPrint("user name Like: = \(String(describing: self.currentUserDetails?.profile_data?.username))")
                
                
                 
        let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                 
                 if list.user_id == self.other_user_id
                 {
                 return true
                 }
                 else
                 {
                 return false
                 }
                 
                 
                 } ?? 0
                 
                 
                 debugPrint("Index at id = \(index)")
                 
                 if (self.AllUserDataArray.count>index)
                 {
                 self.AllUserDataArray.remove(at: index)
                 }
                self.currentUserDetails?.user_id = nil
                
                if self.isAnoModeOn
                {
                    
                    self.imgChangeCard.image = UIImage(named: "NewPhoneRotate")
                    
                    if self.AllUserDataArray.count == 0
                    {
                        self.AllUserDataArray.removeAll()
                        
                        self.getAnonymousUser(page: self.page)
                    }
                    else
                    {
                        tableAllUser.reloadData()
        //                UIView.performWithoutAnimation {
        //
        //                    self.tableAllUser.layoutIfNeeded()
        //                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
        //                    self.tableAllUser.scroll(to: .top, animated: true)
        //                }
                    }
                    self.regretView.isHidden=false
                    self.fromLikeDisLike=false
                 
                   
                    
                    let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                     
                     if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
                     {
                         let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                         
                         self.RemoveStoryHangoutAPI(listId: id)
                     }
                     else
                     {
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
                     }
                   
                }
                else
                {
                    self.regretView.isHidden=false
                    self.imgChangeCard.image = UIImage(named: "NewAnoImg")
                    self.fromLikeDisLike=false
                    
                    if self.AllUserDataArray.count == 0
                    {
                        self.AllUserDataArray.removeAll()
                        
                        self.getShakeSentUser(page: self.page)
                    }
                    else
                    {
                        tableAllUser.reloadData()

                    }
                    
                    
                    let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                     
                     if (kHangout.equalsIgnoreCase(string: mode)) || kStory.equalsIgnoreCase(string: mode)// ||
                     {
                         let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                         
                         self.RemoveStoryHangoutAPI(listId: id)
                     }
                     else
                     {
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kShake, type: kShake,showIndicator: false)
                     }
                
                    

                }
                
        
        
        
        /*
//MARK: - tage 0- card, 2- user details, 3- ads
        if self.AllUserDataArray.count==1
        {
            self.currentUserDetails = self.AllUserDataArray[0]
        }
     
        MusicPlayer.instance.pause()
        self.other_user_id = self.currentUserDetails?.user_id ?? ""
   
        debugPrint("user name Like: = \(String(describing: self.currentUserDetails?.profile_data?.username))")
        
        
         
        let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
         
         if list.user_id == self.other_user_id
         {
         return true
         }
         else
         {
         return false
         }
         
         
         } ?? 0
         
         
         debugPrint("Index at id = \(index)")
         
         if (self.AllUserDataArray.count>index)
         {
         self.AllUserDataArray.remove(at: index)
         }
        self.currentUserDetails?.user_id = nil
        
        if self.isAnoModeOn
        {
            
            self.imgChangeCard.image = UIImage(named: "phoneRotate")
            
            if self.AllUserDataArray.count == 0
            {
                self.AllUserDataArray.removeAll()
                
                self.getAnonymousUser(page: self.page)
            }
            else
            {
                tableAllUser.reloadData()
//                UIView.performWithoutAnimation {
//
//                    self.tableAllUser.layoutIfNeeded()
//                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
//                    self.tableAllUser.scroll(to: .top, animated: true)
//                }
            }
            self.regretView.isHidden=false
            self.fromLikeDisLike=false
         
            
            
            let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
             
             if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
             {
                 let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                 
                 self.RemoveStoryHangoutAPI(listId: id)
             }
             else
             {
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
             }
        
           
        }
        else
        {
            self.regretView.isHidden=false
            self.imgChangeCard.image = UIImage(named: "AnoBack")
            self.fromLikeDisLike=false
            
            if self.AllUserDataArray.count == 0
            {
                self.AllUserDataArray.removeAll()
                
                self.getShakeSentUser(page: self.page)
            }
            else
            {
                tableAllUser.reloadData()

            }
            
            
         
            
            let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
             
             if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
             {
                 let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                 
                 self.RemoveStoryHangoutAPI(listId: id)
             }
             else
             {
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kShake, type: kShake,showIndicator: false)
             }

        }
        
       */
        
    }
    
    //MARK: - Like user action
    
    @IBAction func LikeAct(_ sender: UIButton)
    {
        self.imgCardLike.image = UIImage(named: "NewLikeImg")
        
        Timer.scheduledTimer(withTimeInterval: kButtonLikeDuration, repeats: false, block: { _ in
            self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
        })
        
       
        //self.lightUp(imageName: self.imgCardLike)
         self.regretView.isHidden=false
            if self.AllUserDataArray.count==1
            {
                self.currentUserDetails = self.AllUserDataArray[0]
            }
            
        self.stopVoice()
            self.other_user_id = self.currentUserDetails?.user_id ?? ""
       
            debugPrint("user name Like: = \(String(describing: self.currentUserDetails?.profile_data?.username))")
            
            
             
            let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
             
             if list.user_id == self.other_user_id
             {
             return true
             }
             else
             {
             return false
             }
             
             
             } ?? 0
             
             
             debugPrint("Index at id = \(index)")
             
             if (self.AllUserDataArray.count>index)
             {
             self.AllUserDataArray.remove(at: index)
             }
            self.currentUserDetails?.user_id = nil
            
            if self.isAnoModeOn
            {
                
                self.imgChangeCard.image = UIImage(named: "NewPhoneRotate") //NewPhoneRotate
                
                if self.AllUserDataArray.count == 0
                {
                    self.AllUserDataArray.removeAll()
                    
                    self.getAnonymousUser(page: self.page)
                }
                else
                {
                    tableAllUser.reloadData()
    //                UIView.performWithoutAnimation {
    //
    //                    self.tableAllUser.layoutIfNeeded()
    //                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
    //                    self.tableAllUser.scroll(to: .top, animated: true)
    //                }
                }
                self.regretView.isHidden=false
                self.fromLikeDisLike=false
             
               
                
                let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                 
                 if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
                 {
                     let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                     
                     self.RemoveStoryHangoutAPI(listId: id)
                 }
                 else
                 {
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
                 }
               
            }
            else
            {
                self.regretView.isHidden=false
                self.imgChangeCard.image = UIImage(named: "NewAnoImg")
                self.fromLikeDisLike=false
                
                if self.AllUserDataArray.count == 0
                {
                    self.AllUserDataArray.removeAll()
                    
                    self.getShakeSentUser(page: self.page)
                }
                else
                {
                    tableAllUser.reloadData()
    //                UIView.performWithoutAnimation {
    //
    //                    self.tableAllUser.layoutIfNeeded()
    //                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
    //                    self.tableAllUser.scroll(to: .top, animated: true)
    //                }
                }
                
                
             
                
                
                let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                 
                 if (kHangout.equalsIgnoreCase(string: mode)) //kStory.equalsIgnoreCase(string: mode) ||
                 {
                     let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                     
                     self.RemoveStoryHangoutAPI(listId: id)
                 }
                 else
                 {
                    
                    if kStory.equalsIgnoreCase(string: mode)
                    {
                        let storyId = self.currentUserDetails?.Single_Story_Details?._id ?? ""
                        
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kStory, type: kStory,showIndicator: false,story_id: storyId)
                    }
                    else
                    {
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
                    }
                   
                 }

            }
            
           
             
            /*
            
            
            if self.isAnoModeOn//currentTag == 3
            {
                self.lightUp(button: sender)
                self.fromLikeDisLike=true
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
            }
            else
            {
                self.fromLikeDisLike=true
                self.lightUp(button: sender)
                if likeViewProfile
                {

                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
                }
                else
                {
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
                }


            }
     */
            
            
        
        
        
        
        /*
        if self.AllUserDataArray.count==1
        {
            self.currentUserDetails = self.AllUserDataArray[0]
        }
        self.lightUp(imageName: self.imgCardLike)
        MusicPlayer.instance.pause()
        self.other_user_id = self.currentUserDetails?.user_id ?? ""
   
        debugPrint("user name Like: = \(String(describing: self.currentUserDetails?.profile_data?.username))")
        
        
         
        let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
         
         if list.user_id == self.other_user_id
         {
         return true
         }
         else
         {
         return false
         }
         
         
         } ?? 0
         
         
         debugPrint("Index at id = \(index)")
         
         if (self.AllUserDataArray.count>index)
         {
         self.AllUserDataArray.remove(at: index)
         }
        self.currentUserDetails?.user_id = nil
        
        if self.isAnoModeOn
        {
            
            self.imgChangeCard.image = UIImage(named: "phoneRotate")
            
            if self.AllUserDataArray.count == 0
            {
                self.AllUserDataArray.removeAll()
                
                self.getAnonymousUser(page: self.page)
            }
            else
            {
                tableAllUser.reloadData()
//                UIView.performWithoutAnimation {
//
//                    self.tableAllUser.layoutIfNeeded()
//                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
//                    self.tableAllUser.scroll(to: .top, animated: true)
//                }
            }
            self.regretView.isHidden=false
            self.fromLikeDisLike=false
         
           
            let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
             
             if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
             {
                 let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                 
                 self.RemoveStoryHangoutAPI(listId: id)
             }
             else
             {
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
             }
        }
        else
        {
            self.regretView.isHidden=false
            self.imgChangeCard.image = UIImage(named: "AnoBack")
            self.fromLikeDisLike=false
            
            if self.AllUserDataArray.count == 0
            {
                self.AllUserDataArray.removeAll()
                
                self.getShakeSentUser(page: self.page)
            }
            else
            {
                tableAllUser.reloadData()
//                UIView.performWithoutAnimation {
//
//                    self.tableAllUser.layoutIfNeeded()
//                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
//                    self.tableAllUser.scroll(to: .top, animated: true)
//                }
            }
            
            
         
            
            
            let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
             
             if ( kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
             {
                 let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                 
                 self.RemoveStoryHangoutAPI(listId: id)
             }
             else
             {
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
             }
        }
        
       
         
        /*
        
        
        if self.isAnoModeOn//currentTag == 3
        {
            self.lightUp(button: sender)
            self.fromLikeDisLike=true
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
        }
        else
        {
            self.fromLikeDisLike=true
            self.lightUp(button: sender)
            if likeViewProfile
            {

                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
            }
            else
            {
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
            }


        }
 */
        
        
        */
        
    }
    
    
    //MARK: - Shake send to user action
    
    @IBAction func shakeSendAct(_ sender: UIButton)
    {
        self.stopVoice()
        let vc = ShakeSentVC.instantiate(fromAppStoryboard: .Shake)

        vc.delegate=self
        vc.comeFrom="Home"
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }        // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Show ano user action
    
    @IBAction func playCardAnoAct(_ sender: UIButton)
    {
        
        // self.tableAllUser.isPagingEnabled=true
        self.stopVoice()
        DataManager.comeFromTag=3
        self.AllUserDataArray.removeAll()
        self.fromLikeDisLike=false
        
        self.getAnonymousUser(page: 0)
        self.cardView.isHidden=true
        self.shakeView.isHidden=true
        
        self.addsView.isHidden=true
        
        imgChangeCard.image = UIImage(named: "NewPhoneRotate")
        self.tableAllUser.scrollToTop(animated: false)
      
        
    }
    
    //MARK: - Change mode (Ano,Shake) Show action
    
    @IBAction func playAnoAct(_ sender: UIButton)
    {
        self.stopVoice()
        if sender.tag == 1
        {
            DataManager.comeFromTag=3
            imgChangeCard.image = UIImage(named: "NewPhoneRotate")
            
            self.isAnoModeOn=true
            self.AllUserDataArray.removeAll()
            self.fromLikeDisLike=false
            self.getAnonymousUser(page: 0)
            self.tableAllUser.scrollToTop(animated: false)
        }
        else
        {
            if  self.isAnoModeOn//self.imgChangeCard.image == UIImage(named: "phoneRotate") //DataManager.comeFromTag==3//self.isAnoModeOn//
            {
                self.fromLikeDisLike=false
                self.AllUserDataArray.removeAll()
                self.getShakeSentUser(page: 0)
                self.imgChangeCard.image = UIImage(named: "NewAnoImg")//NewAnoImg //AnoBack
                
                self.tableAllUser.scrollToTop(animated: false)
            }
            else
            {
                self.AllUserDataArray.removeAll()
                self.fromLikeDisLike=false
                self.getAnonymousUser(page: 0)
                imgChangeCard.image = UIImage(named: "NewPhoneRotate")
                self.tableAllUser.scrollToTop(animated: false)
            }
        }
        
        
        
    }
    //MARK: - Close ads action
    
    @IBAction func closeAdsAct(_ sender: UIButton)
    {
        self.stopVoice()
        self.cardView.isHidden=true
        self.shakeView.isHidden=false
    
        
        self.addsView.isHidden=true
    }
    
    
    
    @IBAction func PremiumBtnAct(_ sender: UIButton)
    {
//        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
//
//        let vc = storyBoard.instantiateViewController(withIdentifier: "PremiumVC") as! PremiumVC //RegretPopUpVC
//        vc.type = .kExtraShakes
//        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(vc, animated: true, completion: nil)
//
        
        self.runOutPremiumPopup()
        
    }
    
    
    func showLoader()
    {
        self.viewLoader.isHidden=false
        self.viewLoaderTop.cornerRadius = 10
        self.view1Loader.cornerRadius = self.view1Loader.frame.height/2
        self.view2Loader.cornerRadius = self.view2Loader.frame.height/2
        self.view3Loader.cornerRadius = self.view3Loader.frame.height/2
        self.view4Loader.cornerRadius = self.view4Loader.frame.height/2
    
        self.viewLoaderTop.clipsToBounds=true
        self.view1Loader.clipsToBounds=true
        self.view2Loader.clipsToBounds=true
        self.view3Loader.clipsToBounds=true

        self.view4Loader.clipsToBounds=true

        
        
        self.viewLoader.isSkeletonable=true
        self.viewLoaderBack.isSkeletonable=true
        self.viewLoaderTop.isSkeletonable=true
        self.viewLoaderButtom.isSkeletonable=true
        
        self.view1Loader.isSkeletonable=true
        self.view2Loader.isSkeletonable=true
        self.view3Loader.isSkeletonable=true
        self.view4Loader.isSkeletonable=true
        
        self.viewLoaderBack.showAnimatedGradientSkeleton()
   
        self.viewLoaderTop.showAnimatedGradientSkeleton()
        self.view1Loader.showAnimatedGradientSkeleton()
        
       self.view2Loader.showAnimatedGradientSkeleton()
        self.view3Loader.showAnimatedGradientSkeleton()
        self.view4Loader.showAnimatedGradientSkeleton()

       
    }
    func hideLoader()
    {
        self.viewLoader.isHidden=true

        self.viewLoaderTop.hideSkeleton()
        self.view1Loader.hideSkeleton()
        
       self.view2Loader.hideSkeleton()
        self.view3Loader.hideSkeleton()
        self.view4Loader.hideSkeleton()
//
    }

    
     func stopVoice()
    {
        MusicPlayer.instance.pause()
        self.btnHearVoice.isSelected=false
        self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
    }
}



//MARK: - Table view setup and show data

extension HomeVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
  
    
    func setUpTable()
    {
        
        self.tableAllUser.register(UINib(nibName: "HomeUserTCell", bundle: nil), forCellReuseIdentifier: "HomeUserTCell")
   
        self.tableAllUser.rowHeight = self.tableAllUser.bounds.height//UIScreen.main.bounds.height
        self.tableAllUser.estimatedRowHeight = self.tableAllUser.bounds.height//UIScreen.main.bounds.height
        self.tableAllUser.separatorStyle = .none
        self.tableAllUser.isPagingEnabled = true
        self.tableAllUser.bounces = false
        self.tableAllUser.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        self.tableAllUser.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        self.tableAllUser.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
        self.tableAllUser.sectionFooterHeight = CGFloat.leastNormalMagnitude
        self.tableAllUser.contentInsetAdjustmentBehavior = .never
        self.tableAllUser.delegate = self
        self.tableAllUser.dataSource = self
       

        
     // if  DataManager.purchasePlan==false
     // {
       
        self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.up
        swipeRight.delegate = self
            self.viewTableBack.addGestureRecognizer(swipeRight)
        
       self.swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.delegate = self

        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
            self.viewTableBack.addGestureRecognizer(swipeDown)
      
      // }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if self.AllUserDataArray.count == 1
//        {
//            return 2
//        }
//        else
//        {
            return self.AllUserDataArray.count
        //}
    }
    
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "HomeUserTCell"
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
//        let cell = skeletonView.dequeueReusableCell(withIdentifier: "HomeUserTCell", for: indexPath) as! HomeUserTCell
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUserTCell") as! HomeUserTCell
        
        
        var currentUserDetails:HomeUserListModel?
      
        
        if self.isRegetEnable{
            self.regretView.isHidden=false
        }
        else
        {
            self.regretView.isHidden=true
        }
        
        
        if self.AllUserDataArray.count>indexPath.row
        {
            currentUserDetails = self.AllUserDataArray[indexPath.row]
            
            if self.currentUserDetails?.user_id == nil
            {
                self.currentUserDetails=self.AllUserDataArray[0]
            }
            
        }
       
        if self.isAnoModeOn
        {
            cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: true, VC: self)
        }
        else
        {
            cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: false, VC: self)
        }
        
        if self.AllUserDataArray.count>0
        {
        
            let currentUserDetail=self.AllUserDataArray[0]
            let mode = currentUserDetail.second_table_like_dislike?.by_like_mode ?? ""
            let isMatch = currentUserDetail.like_dislikeData?.is_match ?? 0
            let other_user_inactive_state = currentUserDetail.other_user_inactive_state ?? 0
            
            if (kHangout.equalsIgnoreCase(string: mode)) //kStory.equalsIgnoreCase(string: mode) ||
            {
                self.btnLike.isHidden=true
                self.imgCardLike.isHidden=true
                self.btnMessage.isHidden=false
//                if other_user_inactive_state == 1
//                {
//                    self.btnMessage.isHidden=true
//                    self.likeView.isHidden=true
//                }
//                else
//                {
                    self.btnMessage.isHidden=false
                    self.likeView.isHidden=false
              //  }
            }
            else if isMatch == 1
            {
                self.btnLike.isHidden=true
                self.imgCardLike.isHidden=true
                //self.btnMessage.isHidden=false
                
                if other_user_inactive_state == 1
                {
                    self.btnMessage.isHidden=true
                    self.likeView.isHidden=true
                }
                else
                {
                    self.btnMessage.isHidden=false
                    self.likeView.isHidden=false
                }
            }
            else
            {
                self.imgCardLike.isHidden=false
                self.btnLike.isHidden=false
                self.likeView.isHidden=false
                self.btnMessage.isHidden=true
            }
            
        }
        else
        {
            self.imgCardLike.isHidden=false
            self.btnLike.isHidden=false
            self.btnMessage.isHidden=true
            self.likeView.isHidden=false
        }
        
        return cell
    }
  
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        self.cellHeight = cellHeights[indexPath] ?? self.tableAllUser.frame.height
        
        return cellHeights[indexPath] ?? self.tableAllUser.frame.height//self.tableAllUser.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? self.tableAllUser.frame.height//UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
       // debugPrint(#function)
        self.stopVoice()
        
        var index = 0
        
        
        if scrollView == self.tableAllUser
        {
         
            if let indexPath = self.tableAllUser.indexPathsForVisibleRows?.first {
                
                index = indexPath.row
            }
        }
        
        if self.AllUserDataArray.count>index
        {
            self.currentUserDetails = self.AllUserDataArray[index]
            
        }
        if DataManager.purchasePlan==false
        {
        let translation: CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
             let y = translation.y

            if y > 0 {
                scrollView.isScrollEnabled = false
            } else {
                scrollView.isScrollEnabled = true
            }
        }
       
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        debugPrint(#function)
        if scrollView == self.tableAllUser
        {
            
            if self.AllUserDataArray.count>1
            {
                if targetContentOffset.pointee.y <= scrollView.contentOffset.y {
                    debugPrint(" it's going up")
                    
                    self.scrollDown=false
                }
                else
                {
                   
                    debugPrint(" it's going down")
                    self.scrollDown=true
                   
                }
            }
            else if self.AllUserDataArray.count==1
            {
                if targetContentOffset.pointee.y < scrollView.contentOffset.y {
                    debugPrint(" it's going up")
                    self.scrollDown=false
                }
                else
                {
            
                    debugPrint(" it's going down")
                    self.scrollDown=true
                 
                }
            }
            else
            {
                self.scrollDown=false
            }
            
        }
    
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        debugPrint(#function)
        if scrollView == self.tableAllUser
        {
        
            var index = 0
            
            
            if let indexPath = self.tableAllUser.indexPathsForVisibleRows?.first {
                
                index = indexPath.row
            }
            
            
            if self.AllUserDataArray.count>index//HomeVM.shared.AnonymousUserDataArray.count>index
            {
                self.currentUserDetails = self.AllUserDataArray[index]//HomeVM.shared.AnonymousUserDataArray[index]
                
            }
            
            if self.AllUserDataArray.count>(index-1)
            {
                var user:HomeUserListModel?
                
                if index == 0
                {
                    if self.AllUserDataArray.count>0
                    {
                        user = self.AllUserDataArray[0]
                    }
                }
                else
                {
                    user = self.AllUserDataArray[index-1]
                }
                
                if  self.scrollDown
                {
                    
                    debugPrint("self.scrollDown \(self.scrollDown)")
               
                    if self.isAnoModeOn
                    {
                      
                        
                      /*
                        
                        if self.AllUserDataArray.count == 1
                        {
                            self.AllUserDataArray.removeAll()
                        }
                        
                      else if (self.AllUserDataArray.count>index)
                        {
                        self.AllUserDataArray.remove(at: index)
                       }

                 
                      
                   
                    
                   
                       
                        self.imgChangeCard.image = UIImage(named: "phoneRotate")
                       
                        if self.AllUserDataArray.count == 0
                        {
                            self.AllUserDataArray.removeAll()

                            self.getAnonymousUser(page: self.page)
                        }
                        else
                        {

                            UIView.performWithoutAnimation {
                                tableAllUser.reloadData()
                                self.tableAllUser.layoutIfNeeded()
                              //  self.tableAllUser.setContentOffset(CGPoint.zero, animated: false)
                                self.tableAllUser.scroll(to: .top, animated: false)
                            }
                        }
                        self.fromLikeDisLike=false
                       // self.likeUnlikeAPI(other_user_id: user?.user_id ?? "", action: "2", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
                        
                    
                      */
                        self.isRegetEnable=true
                        self.regretView.isHidden=false
                        
                          if self.AllUserDataArray.count == 1
                        {
                            self.AllUserDataArray.removeAll()
                            self.isPagination=true
                            self.getAnonymousUser(page: 0)
                            self.tableAllUser.reloadData()
                            self.tableAllUser.scrollToTop(animated: false)
                        }
                    }
                    else
                    {
                        
                        
                        let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                            
                            if list.user_id == self.other_user_id
                            {
                                return true
                            }
                            else
                            {
                                return false
                            }
                            
                            
                        } ?? 0
                        self.imgChangeCard.image = UIImage(named: "NewAnoImg")
                        
                        if (self.AllUserDataArray.count>index)
                        {
                        self.AllUserDataArray.remove(at: index)
                         }

                        /*
        
                        if self.AllUserDataArray.count == 0
                        {
                            self.AllUserDataArray.removeAll()

                            self.getShakeSentUser(page: self.page)
                        }
                        else
                        {

                            UIView.performWithoutAnimation {
                                tableAllUser.reloadData()
                                self.tableAllUser.layoutIfNeeded()
                                self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
                                self.tableAllUser.scroll(to: .top, animated: true)
                            }
                        }
                        self.fromLikeDisLike=false
                        */
                        self.isRegetEnable=true
                        
                        self.regretView.isHidden=false
                       let mode = user?.second_table_like_dislike?.by_like_mode ?? ""
                        
                        if (kHangout.equalsIgnoreCase(string: mode)) || kStory.equalsIgnoreCase(string: mode)// ||
                        {
                            let id = user?.second_table_like_dislike?._id ?? ""
                            
                            self.RemoveStoryHangoutAPI(listId: id)
                        }
                        else
                        {
                            self.likeUnlikeAPI(other_user_id: user?.user_id ?? "", action: "2", like_mode: kShake, type: kShake,showIndicator: false)
                        }
                        debugPrint("Shake Array count  = \(AllUserDataArray.count)")
                      
                        if self.AllUserDataArray.count == 0 ||  self.AllUserDataArray.count == 1
                        {
                            self.AllUserDataArray.removeAll()
                            self.isPagination=true
                            self.getShakeSentUser(page: 0)
                        }
                        
                        
        
                    }
                    debugPrint("AllUserDataArray count 1 = \(AllUserDataArray.count)")
                    
                    
                    
                }
                
                
            }
            /*
            
            if ((self.tableAllUser.contentOffset.y + self.tableAllUser.frame.size.height) >= self.tableAllUser.contentSize.height-SCREENHEIGHT*2)
            {
               
                if self.AllUserDataArray.count<HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    if self.isAnoModeOn
                    {
                        self.isPagination=true
                        self.getAnonymousUser(showIndiacter: false, page: self.page)
                    }
                    else
                    {
                        self.isPagination=true
                        self.getShakeSentUser(page: self.page)
                    }

                }
                else if self.AllUserDataArray.count >= HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    if self.isAnoModeOn
                    {
                        self.isPagination=true
                        self.AllUserDataArray.removeAll()
                        self.getAnonymousUser(showIndiacter: true, page: 0)
                        self.tableAllUser.scrollToTop(animated: false)
                    }
                    else
                    {
                        self.AllUserDataArray.removeAll()
                        self.isPagination=true
                        self.getShakeSentUser(page: 0)
                        self.tableAllUser.scrollToTop(animated: false)
                    }
                }
            }
            else
            {
                debugPrint("else")
            }
            
            */
            
//            debugPrint((self.tableAllUser.contentOffset.y + self.tableAllUser.frame.size.height))
//                debugPrint(self.tableAllUser.contentSize.height-50)
            
            if ((self.tableAllUser.contentOffset.y + self.tableAllUser.frame.size.height) >= self.tableAllUser.contentSize.height-50)
            {
                if self.AllUserDataArray.count<HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    if self.isAnoModeOn
                    {
                        self.isPagination=true
                        self.getAnonymousUser(page: self.page)
                    }
                    else
                    {
                        self.isPagination=true
                        self.getShakeSentUser(page: self.page)
                    }

                }
                else if self.AllUserDataArray.count >= HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    if self.isAnoModeOn
                    {
                        self.isPagination=true
                        self.AllUserDataArray.removeAll()
                        self.getAnonymousUser(page: 0)
                        self.tableAllUser.scrollToTop(animated: false)
                    }
                    else
                    {
                        self.AllUserDataArray.removeAll()
                        self.isPagination=true
                        self.getShakeSentUser(page: 0)
                        self.tableAllUser.scrollToTop(animated: false)
                    }
                }
                
//                else
//                {
//                    if self.isAnoModeOn
//                    {
//                        self.isPagination=true
//
//                        self.getAnonymousUser(page: 0)
//                    }
//                    else
//                    {
//
//                        self.isPagination=true
//                        self.getShakeSentUser(page: 0)
//                    }
//                }

            }
            
            
            
        }
    }
    
  
    
    
    
    //
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //
    //        if ((self.tableAllUser.contentOffset.y + self.tableAllUser.frame.size.height) >= self.tableAllUser.contentSize.height-50)
    //            {
    //                if self.AllUserDataArray.count<HomeVM.shared.Pagination_Details?.totalCount ?? 0
    //                {
    //                    if self.isAnoModeOn
    //                    {
    //                        self.isPagination=true
    //                        self.getAnonymousUser(page: self.page)
    //                    }
    //                    else
    //                    {
    //                        self.isPagination=true
    //                        self.getShakeSentUser(page: self.page)
    //                    }
    //
    //                }
    //
    //            }
    //
    //    }
    
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//
//
//        for indexPath in indexPaths {
//            debugPrint("prefetching row of \(indexPath.row)")
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUserTCell") as! HomeUserTCell
//
//
//            var currentUserDetails:UserListModel?
//
//
//            if self.isRegetEnable{
//                self.regretView.isHidden=false
//            }
//            else
//            {
//                self.regretView.isHidden=true
//            }
//
//
//            if self.AllUserDataArray.count>indexPath.row
//            {
//                currentUserDetails = self.AllUserDataArray[indexPath.row]
//
//                if self.currentUserDetails?.user_id == nil
//                {
//                    self.currentUserDetails=self.AllUserDataArray[0]
//                }
//
//            }
//
//            if self.isAnoModeOn
//            {
//                cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: true, VC: self)
//            }
//            else
//            {
//                cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: false, VC: self)
//            }
//           }
//    }
        
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//
//      debugPrint("cancel prefetch row of \(indexPaths)")
//    }
}

extension HomeVC:ButtonTapDelegate
{
    func buutonName(name: String) {
        toShow = "Card"
    }
    
    
}

//MARK: - Ads setup

extension HomeVC:GADBannerViewDelegate
{
    func adsSetup()
    {
        //Indicator.sharedInstance.showIndicator()
        
        
        let bannerView = GADBannerView(frame: self.addsSubView.frame)
        
        bannerView.frame = self.addsSubView.frame
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.adUnitID = APP_ADS_ID
    
        let adSize = GADAdSizeFromCGSize(CGSize(width: SCREENWIDTH, height: SCREENHEIGHT))
        bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
        bannerView.delegate = self
        
        self.addsSubView.addSubview(bannerView)
    
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView)
    {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        for subview in self.addsSubView.subviews {
          subview.removeFromSuperview()
        }
        self.addsSubView.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
            
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
            
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.topAnchor.constraint(equalTo: bannerView.topAnchor)
        ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        debugPrint("adViewDidReceiveAd")
        Indicator.sharedInstance.showIndicator()
        
       
        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            bannerView.alpha = 1
            Indicator.sharedInstance.hideIndicator()
        })
        
    }
    
    
        /// Tells the delegate an ad request failed.

    
        /// Tells the delegate that a full-screen view will be presented in response
        /// to the user clicking on an ad.
        func adViewWillPresentScreen(_ bannerView: GADBannerView) {
            debugPrint("adViewWillPresentScreen")
        }
    
        /// Tells the delegate that the full-screen view will be dismissed.
        func adViewWillDismissScreen(_ bannerView: GADBannerView) {
            debugPrint("adViewWillDismissScreen")
        }
    
        /// Tells the delegate that the full-screen view has been dismissed.
        func adViewDidDismissScreen(_ bannerView: GADBannerView) {
            debugPrint("adViewDidDismissScreen")
        }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        debugPrint("adViewWillLeaveApplication")
    }
}
//MARK: - Fav buttom Action Like /dislike Action

extension HomeVC//:FaveButtonDelegate
{
    @objc func profileAudioStopedReceivedNotification(notification: Notification)
    {
        debugPrint("Home vc")
        self.btnHearVoice.isSelected=false
        self.stopVoice()
       
        self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
    }
    //MARK: - Show like animation
    func lightUp(imageName: UIImageView)
    {
        UIView.transition(with: imageName, duration: 1.30, options: .transitionCrossDissolve, animations: {
            
            if imageName == self.imgCardLike
            {
                self.imgCardLike.image = UIImage(named: "NewLikeImg")
            }
            else if imageName == self.imgNewDislike
            {
                self.imgNewDislike.image = UIImage(named: "NewImgDislikeFill")
            }
            else if imageName == self.imgNewVoice
            {
                self.imgNewVoice.image = UIImage(named: "NewImgVoiceFill")
            }
         
            //button.setImage(UIImage(named: "NewLikeImg"), for: .normal)
        }, completion: {_ in
            UIView.transition(with: imageName, duration: 1.30, options: .transitionCrossDissolve, animations: {
                
            }, completion: { _ in
                
                debugPrint("lightUp done")
                
                 if imageName == self.imgCardLike
                {
                    self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
                }
                else if imageName == self.imgNewDislike
                {
                    self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
                }
            }
            )})
        
        
    }
    
    /*
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
        if Connectivity.isConnectedToInternet {
              
        
        if faveButton == self.btnLike
        {
            self.regretView.isHidden=false
            if self.AllUserDataArray.count==1
            {
                self.currentUserDetails = self.AllUserDataArray[0]
            }
            
            MusicPlayer.instance.pause()
            self.other_user_id = self.currentUserDetails?.user_id ?? ""
       
            debugPrint("user name Like: = \(String(describing: self.currentUserDetails?.profile_data?.username))")
            
            
             
            let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
             
             if list.user_id == self.other_user_id
             {
             return true
             }
             else
             {
             return false
             }
             
             
             } ?? 0
             
             
             debugPrint("Index at id = \(index)")
             
             if (self.AllUserDataArray.count>index)
             {
             self.AllUserDataArray.remove(at: index)
             }
            self.currentUserDetails?.user_id = nil
            
            if self.isAnoModeOn
            {
                
                self.imgChangeCard.image = UIImage(named: "phoneRotate")
                
                if self.AllUserDataArray.count == 0
                {
                    self.AllUserDataArray.removeAll()
                    
                    self.getAnonymousUser(page: self.page)
                }
                else
                {
                    tableAllUser.reloadData()
    //                UIView.performWithoutAnimation {
    //
    //                    self.tableAllUser.layoutIfNeeded()
    //                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
    //                    self.tableAllUser.scroll(to: .top, animated: true)
    //                }
                }
                self.regretView.isHidden=false
                self.fromLikeDisLike=false
             
               
                
                let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                 
                 if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
                 {
                     let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                     
                     self.RemoveStoryHangoutAPI(listId: id)
                 }
                 else
                 {
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
                 }
               
            }
            else
            {
                self.regretView.isHidden=false
                self.imgChangeCard.image = UIImage(named: "AnoBack")
                self.fromLikeDisLike=false
                
                if self.AllUserDataArray.count == 0
                {
                    self.AllUserDataArray.removeAll()
                    
                    self.getShakeSentUser(page: self.page)
                }
                else
                {
                    tableAllUser.reloadData()
    //                UIView.performWithoutAnimation {
    //
    //                    self.tableAllUser.layoutIfNeeded()
    //                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
    //                    self.tableAllUser.scroll(to: .top, animated: true)
    //                }
                }
                
                
             
                
                
                let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                 
                 if (kHangout.equalsIgnoreCase(string: mode)) //kStory.equalsIgnoreCase(string: mode) ||
                 {
                     let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                     
                     self.RemoveStoryHangoutAPI(listId: id)
                 }
                 else
                 {
                    
                    if kStory.equalsIgnoreCase(string: mode)
                    {
                        let storyId = self.currentUserDetails?.Single_Story_Details?._id ?? ""
                        
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kStory, type: kStory,showIndicator: false,story_id: storyId)
                    }
                    else
                    {
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
                    }
                   
                 }

            }
            
           
             
            /*
            
            
            if self.isAnoModeOn//currentTag == 3
            {
                self.lightUp(button: sender)
                self.fromLikeDisLike=true
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
            }
            else
            {
                self.fromLikeDisLike=true
                self.lightUp(button: sender)
                if likeViewProfile
                {

                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
                }
                else
                {
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
                }


            }
     */
            
            
        }
        
      
        else
        {
            self.regretView.isHidden=false
            //MARK: - tage 0- card, 2- user details, 3- ads
                    if self.AllUserDataArray.count==1
                    {
                        self.currentUserDetails = self.AllUserDataArray[0]
                    }
                 
                    MusicPlayer.instance.pause()
                    self.other_user_id = self.currentUserDetails?.user_id ?? ""
               
            debugPrint("user name Like: = \(String(describing: self.currentUserDetails?.profile_data?.username))")
                    
                    
                     
            let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                     
                     if list.user_id == self.other_user_id
                     {
                     return true
                     }
                     else
                     {
                     return false
                     }
                     
                     
                     } ?? 0
                     
                     
                     debugPrint("Index at id = \(index)")
                     
                     if (self.AllUserDataArray.count>index)
                     {
                     self.AllUserDataArray.remove(at: index)
                     }
                    self.currentUserDetails?.user_id = nil
                    
                    if self.isAnoModeOn
                    {
                        
                        self.imgChangeCard.image = UIImage(named: "phoneRotate")
                        
                        if self.AllUserDataArray.count == 0
                        {
                            self.AllUserDataArray.removeAll()
                            
                            self.getAnonymousUser(page: self.page)
                        }
                        else
                        {
                            tableAllUser.reloadData()
            //                UIView.performWithoutAnimation {
            //
            //                    self.tableAllUser.layoutIfNeeded()
            //                    self.tableAllUser.setContentOffset(CGPoint.zero, animated: true)
            //                    self.tableAllUser.scroll(to: .top, animated: true)
            //                }
                        }
                        self.regretView.isHidden=false
                        self.fromLikeDisLike=false
                     
                       
                        
                        let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                         
                         if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
                         {
                             let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                             
                             self.RemoveStoryHangoutAPI(listId: id)
                         }
                         else
                         {
                            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
                         }
                       
                    }
                    else
                    {
                        self.regretView.isHidden=false
                        self.imgChangeCard.image = UIImage(named: "AnoBack")
                        self.fromLikeDisLike=false
                        
                        if self.AllUserDataArray.count == 0
                        {
                            self.AllUserDataArray.removeAll()
                            
                            self.getShakeSentUser(page: self.page)
                        }
                        else
                        {
                            tableAllUser.reloadData()

                        }
                        
                        
                        let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
                         
                         if (kHangout.equalsIgnoreCase(string: mode)) || kStory.equalsIgnoreCase(string: mode)// ||
                         {
                             let id = self.currentUserDetails?.second_table_like_dislike?._id ?? ""
                             
                             self.RemoveStoryHangoutAPI(listId: id)
                         }
                         else
                         {
                            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kShake, type: kShake,showIndicator: false)
                         }
                    
                        

                    }
                    
                   
        }
    }
        else {
            self.btnLike.setImage(UIImage(named: "NewLikeImg"), for: .selected)
            self.btnLike.setSelected(selected: false, animated: true)
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
    }
    
    
    */
}

// MARK: - Extension Api Calls


extension HomeVC
{
    
    
    //MARK: - Get shake user list
    
    func getShakeSentUser(page:Int,ShowIndicator:Bool=true)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        data[ApiKey.kShakeUser] = DataManager.ShakeId
        if Connectivity.isConnectedToInternet {
            
            
            self.callApiForGetShakeSentUser(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetShakeSentUser(data:JSONDictionary)
    {
       // Indicator.sharedInstance.showIndicator2()
        self.showLoader()
        HomeVM.shared.callApiGetShakeUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
                //Indicator.sharedInstance.hideIndicator2()
            }
            else{
              
                
                
              //  self.btnLikeCard.isEnabled=true
                
                if HomeVM.shared.ShakeUserDataArray.count>0
                {
                    self.likeView.isHidden=false
                    self.disLikeView.isHidden=false
                    self.regretView.isHidden=false
                    self.hearView.isHidden=false
                    self.changeModeView.isHidden=false
                    
                    self.cardView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    self.addsView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")//BlackLike/NewLikeImgNotFill
                    self.imgChangeCard.image = UIImage(named: "NewAnoImg")
                    
                   // self.btnLikeCard.setImage(nil, for: .normal)
                    self.viewButtomCard.isHidden=false
                    self.isAnoModeOn=false
                    
                    for dict in HomeVM.shared.ShakeUserDataArray
                    {
                        
                        self.AllUserDataArray.append(dict)
                        
                    }
                    self.page = self.AllUserDataArray.count
                    
                    //                    if  self.fromLikeDisLike==false
                    //                    {
                    //
                    //                        self.tableAllUser.scrollToTop(animated: false)
                    //                    }
                    //                    else
                    //                    {
                    //                        self.tableAllUser.reloadData()
                    //                    }
                    //MARK: - Home page  changes
                    self.currentUserDetails?.user_id = nil
                    
                    self.tableAllUser.reloadData()
                    
                
                    //                    if  self.fromRegret
                    //                    {
                    //
                    //                        self.fromRegret=false
                    //                    }
                    //                    else
                    //                    {
                   
                    //}
                    //  self.tableAllUser.scrollToTop(animated: false)
                    
                    
                   
                    
                    
                    
                }
                else
                {
                    self.cardView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    
                    self.addsView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    self.viewButtomCard.isHidden=true
                    
                    
                }
                
                if self.AllUserDataArray.count>0
                {
                    DataManager.comeFromTag=3
                }
                else
                {
                    if DataManager.comeFromTag==5
                    {
                        self.cardView.isHidden=true
                        self.addsView.isHidden=true
                        self.viewButtomCard.isHidden=true
                        self.shakeView.isHidden=false
                       
                        DataManager.comeFromTag=3
                    }
                }
               // Indicator.sharedInstance.hideIndicator2()
                
                self.hideLoader()
            }
            
            
        })
    }
    
    //MARK: -  user like dislike api
    
    func likeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String,showIndicator:Bool=true,story_id:String=kEmptyString)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kOther_user_id] = other_user_id
        data[ApiKey.kAction] = action
        data[ApiKey.kLike_mode] = like_mode
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kStoryId] = story_id
        
        if Connectivity.isConnectedToInternet {
            
            self.callApiForLikeUnlike(data: data,type: type, action: action,showIndicator:showIndicator)
        } else {
            self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
            self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
   
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String,action:String,showIndicator:Bool)
    {
        HomeVM.shared.callApiForLikeUnlikeUser(showIndiacter: showIndicator, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
                self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
                self.showErrorMessage(error: error)
            }
            else{
                self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
                self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
                let isMatch = HomeVM.shared.like_Dislike_Data?.is_match ?? 0
                self.isRegetEnable=true
                self.regretView.isHidden=false
                self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill") // //BlackLike //NewLikeImgNotFill
               // self.btnLike.setSelected(selected: false, animated: false)
                
                //
                if isMatch == 1
                {
                   
                    let vc = MatchVC.instantiate(fromAppStoryboard: .Home)
                    vc.comefrom = kHomePage
                  
                    vc.view_user_id=self.other_user_id
                    vc.profileName=(self.currentUserDetails?.profile_data?.username ?? "").capitalized
                    DataManager.comeFrom = kEmptyString
                    DataManager.comeFromTag=5
                    DataManager.HomeRefresh = true
                    DataManager.comeFromPage=2
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    
                }
                
               /*
                
                
                
              
                if type == "Shake"
                {
                    if action == "1"
                    {
                        
                        if self.currentUserDetails?.is_liked_by_other_user_id == 1
                        {
                            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                            vc.comefrom = kHomePage
                          
                            vc.view_user_id=self.other_user_id
                            vc.profileName=(self.currentUserDetails?.profile_data?.username ?? "").capitalized
                            DataManager.comeFrom = kEmptyString
                            DataManager.comeFromTag=5
                            DataManager.HomeRefresh = true
                            DataManager.comeFromPage=2
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        /*
                        else
                        {
                            self.imgChangeCard.image = UIImage(named: "AnoBack")
                           
                            let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                                
                                if list.user_id == self.other_user_id
                                {
                                    return true
                                }
                                else
                                {
                                    return false
                                }
                                
                                
                            } ?? 0
                            
                            
                            debugPrint("Index at id = \(index)")
                            if (self.AllUserDataArray.count>index)
                            {
                                self.AllUserDataArray.remove(at: index)
                            }
                            
                            if self.AllUserDataArray.count == 0
                            {
                                self.AllUserDataArray.removeAll()
                                
                                self.getShakeSentUser(page: 0)
                            }
                            else
                            {
                                self.tableAllUser.reloadData1
                                {
                                    self.tableAllUser.scroll(to: .top, animated: false)
                                }
                            }
                            
                            
                        }
                        */
                    }
                    else
                    {
                        /*
                        self.imgChangeCard.image = UIImage(named: "AnoBack")
                        
                      
                        
                        let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                            
                            if list.user_id == self.other_user_id
                            {
                                return true
                            }
                            else
                            {
                                return false
                            }
                            
                            
                        } ?? 0
                        
                        
                        debugPrint("Index at id = \(index)")
                        if (self.AllUserDataArray.count>index)
                        {
                            self.AllUserDataArray.remove(at: index)
                        }
                        
                        if self.AllUserDataArray.count == 0
                        {
                            self.AllUserDataArray.removeAll()
                            
                            self.getShakeSentUser(page: 0)
                        }
                        else
                        {
                            self.tableAllUser.reloadData1
                            {
                                self.tableAllUser.scroll(to: .top, animated: false)
                            }
                        }
                        */
                    }
                    
                }
                //     else if type == kViewProfile
                //                {
                //                    if action == "1"
                //                    {
                //
                //                        if self.currentUserDetails?.is_liked_by_other_user_id == 1
                //                        {
                //                        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                //                        let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                //                        vc.comefrom = kHomePage
                //                        vc.user2Image=self.other_user_image
                //                        vc.view_user_id=self.other_user_id
                //                        vc.profileName=(self.currentUserDetails?.profile_data?.username ?? "").capitalized
                //                        DataManager.comeFrom = kEmptyString
                //                        DataManager.comeFromTag=5
                //                        DataManager.comeFromPage=2
                //                        self.navigationController?.pushViewController(vc, animated: true)
                //                        }
                //                        else
                //                        {
                //                            self.imgChangeCard.image = UIImage(named: "AnoBack")
                //
                //                            self.AllUserDataArray.removeAll()
                //
                //                            self.getShakeSentUser(page: 0)
                //                        }
                //                    }
                //                    else
                //                    {
                //                        self.imgChangeCard.image = UIImage(named: "AnoBack")
                //
                //                        self.AllUserDataArray.removeAll()
                //
                //                        self.getShakeSentUser(page: 0)
                //                    }
                //                }
                else
                {
                    if action == "1"
                    {
                        if self.currentUserDetails?.is_liked_by_other_user_id == 1
                        {
                            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                            vc.comefrom = kHomePage
                           
                            vc.view_user_id=self.other_user_id
                            vc.profileName=(self.currentUserDetails?.profile_data?.username ?? "").capitalized
                            DataManager.HomeRefresh = true
                            DataManager.comeFromTag=3
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                            /*
                            self.imgChangeCard.image = UIImage(named: "phoneRotate")
                            
                            // self.AllUserDataArray.removeAll()
                            // self.getAnonymousUser(showIndiacter: true, page: 0)
                            
                            let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                                
                                if list.user_id == self.other_user_id
                                {
                                    return true
                                }
                                else
                                {
                                    return false
                                }
                                
                                
                            } ?? 0
                            
                            
                            debugPrint("Index at id = \(index)")
                            if (self.AllUserDataArray.count>index)
                            {
                                self.AllUserDataArray.remove(at: index)
                            }
                            
                            if self.AllUserDataArray.count == 0
                            {
                                 self.AllUserDataArray.removeAll()
                                 self.getAnonymousUser(showIndiacter: true, page: 0)
                            }
                            else
                            {
                                self.tableAllUser.reloadData1
                                {
                                    self.tableAllUser.scroll(to: .top, animated: false)
                                }
                            }
                            */
                        }
                    
                    }
                    else
                    {
                        /*
                        self.imgChangeCard.image = UIImage(named: "phoneRotate")
                                                
                        // self.AllUserDataArray.removeAll()
                        // self.getAnonymousUser(showIndiacter: true, page: 0)
                        
                        let index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                            
                            if list.user_id == self.other_user_id
                            {
                                return true
                            }
                            else
                            {
                                return false
                            }
                            
                            
                        } ?? 0
                        
                        
                        debugPrint("Index at id = \(index)")
                        if (self.AllUserDataArray.count>index)
                        {
                            self.AllUserDataArray.remove(at: index)
                        }
                        
                        if self.AllUserDataArray.count == 0
                        {
                             self.AllUserDataArray.removeAll()
                             self.getAnonymousUser(showIndiacter: true, page: 0)
                        }
                        else
                        {
                            self.tableAllUser.reloadData1
                            {
                                self.tableAllUser.scroll(to: .top, animated: false)
                            }
                        }
                        */
                        
                    }
                   
                    
                }
                */
            }
            
            
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
                self.isAnoModeOn=false
                self.isRegetEnable=true
            }
        }
        )
        
    }

    
    //MARK: - Get ano user list
    
    func getAnonymousUser(showIndiacter:Bool=true, page:Int)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        
        if Connectivity.isConnectedToInternet {
            
            
            self.callApiForGetAnonymousUser(showIndiacter:showIndiacter, data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetAnonymousUser(showIndiacter:Bool, data:JSONDictionary)
    {
        self.showLoader()
        HomeVM.shared.callApiGetAnonymousUser(showIndiacter:showIndiacter, data: data, response: { (message, error) in
            
            if error != nil
            {
                //Indicator.sharedInstance.hideIndicator2()
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                
                self.isAnoModeOn=true
               // self.btnLikeCard.isEnabled=true
                self.btnLike.isEnabled=true
                for dict in HomeVM.shared.AnonymousUserDataArray
                {
                    
                  //  if !(self.AllUserDataArray.count >= HomeVM.shared.Pagination_Details?.totalCount ?? 0)
                   // {
                        self.AllUserDataArray.append(dict)
                   // }
                   
                  
                    
                }
                self.page = self.AllUserDataArray.count//self.AllUserDataArray.count
                self.likeView.isHidden=false
                self.disLikeView.isHidden=false
                if self.isRegetEnable{
                    self.regretView.isHidden=false
                }
                else
                {
                    self.regretView.isHidden=true
                }
                
                self.hearView.isHidden=false
                self.changeModeView.isHidden=false
                //MARK: - Home page changes
                
                if self.AllUserDataArray.count>0//HomeVM.shared.AnonymousUserDataArray.count>0
                {
                    self.cardView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    self.addsView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    self.isAnoModeOn=true
                    self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
                    self.imgChangeCard.image = UIImage(named: "NewPhoneRotate")
                    
                    
                   // self.btnLikeCard.setImage(nil, for: .normal)
                   // self.btnLike.setSelected(selected: false, animated: false)
                    self.viewButtomCard.isHidden=false
                    
                    self.cardView.isHidden=false
                    
        
                    self.currentUserDetails?.user_id = nil
                    self.tableAllUser.reloadData()
                  
                
                }
                else
                {
                    self.cardView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    
                    self.addsView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    
                    self.viewButtomCard.isHidden=true
                    
                    
                }
                self.hideLoader()
               // Indicator.sharedInstance.hideIndicator2()
            }
            
            
        })
    }
    
  //  func callApiForProfileDetails(data:String)
//    {
//        HomeVM.shared.callApiGetUserDetails(data: data, response: { (message, error) in
//
//            if error != nil
//            {
//                self.showErrorMessage(error: error)
//            }
//            else{
//
//                self.likeViewProfile=true
//                if let UserData = HomeVM.shared.viewProfileUserDetail
//                {
//                    self.cardView.isHidden=false
//                    self.shakeView.isHidden=true
//
//                    self.addsView.isHidden=true
//                    self.shakeView.isHidden=true
//
//
//                    self.btnLike.setSelected(selected: false, animated: false)
//                   // self.btnLikeCard.setImage(nil, for: .normal)
//                    self.viewButtomCard.isHidden=false
//                    self.isAnoModeOn=false
//
//
//                    let isLike = UserData.is_liked_by_self_user ?? 0
//
//                    if (UserData.is_liked_by_self_user == 1 && UserData.is_liked_by_other_user_id == 1)
//
//                    {
//                        self.likeView.isHidden=true
//                        self.disLikeView.isHidden=true
//                        self.regretView.isHidden=false
//                        self.hearView.isHidden=false
//                        self.changeModeView.isHidden=false
//                    }
//                    else
//                    {
//                        self.likeView.isHidden=false
//                        self.disLikeView.isHidden=false
//                        self.regretView.isHidden=false
//                        self.hearView.isHidden=false
//                        self.changeModeView.isHidden=false
//                    }
//
//
//                    if isLike == 1
//                    {
//                        //self.imgCardLike.image = UIImage(named: "redLike")
//                        self.btnLike.setSelected(selected: true, animated: false)
//                    //    self.btnLikeCard.isEnabled=false
//                    }
//                    else
//                    {
//                        //self.imgCardLike.image = UIImage(named: "BlackLike")
//                        self.btnLike.setSelected(selected: false, animated: false)
//                       // self.btnLikeCard.isEnabled=true
//                    }
//
//                    self.AllUserDataArray.append(UserData)
//
//                    if  self.fromLikeDisLike==false
//                    {
//
//                        self.tableAllUser.scrollToTop(animated: false)
//                    }
//                    else
//                    {
//                        self.tableAllUser.reloadData()
//                    }
//
//                }
//            }
//        })
//    }
    
    func callApiForRegretShake(data:JSONDictionary)
    {
     
        HomeVM.shared.callApiGetRegretuser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                if self.isAnoModeOn
                {
               
                    self.AllUserDataArray.removeAll()
            
                    self.getAnonymousUser(page: 0)
                 
                    
                }
                else
                {
                    self.fromLikeDisLike=false
                    self.AllUserDataArray.removeAll()
                    self.getShakeSentUser(page: 0)
                   // self.imgChangeCard.image = UIImage(named: "AnoBack")
                    
                   // self.tableAllUser.scrollToTop(animated: false)
                }
            }
        }
        )
    }
    
  
    
//    func callApiForUpdateLatLong(data:JSONDictionary)
//    {
//        HomeVM.shared.callApiForUpdateUserLatLong(showIndiacter: false, data: data, response: { (message, error) in
//
//
//            if DataManager.comeFromTag==5
//            {
//
//                //                self.AllUserDataArray.removeAll()
//                //                self.getShakeSentUser(page: 0)
//
//
//            }
//        })
//    }
    
    
    func getMySubscriptionApi(MySubscriptiontype:String=kShake)
    {
        AccountVM.shared.callApiGetMySubscription(response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                self.regretPaymentChecked=true
                let active = AccountVM.shared.Shake_Subsription_Data?.subscription_is_active ?? 0
                
                let active2 = AccountVM.shared.Prolong_Subsription_Data?.subscription_is_active ?? 0
                debugPrint("prolong active =\(active)")
                
            
                if active2 == 1
                {
             
                    DataManager.purchaseProlong=true
                }
                else
                {
                    DataManager.purchaseProlong=false
                }
                
                
                if active == 1
                {
                   DataManager.purchasePlan=true
         
                
                    var type = kAnonymous
                    if self.isAnoModeOn==false
                    {
                        type=kShake
                    }
           
                    if MySubscriptiontype.equalsIgnoreCase(string: kShake)
                    {
                    var data = JSONDictionary()
                    
                    data[ApiKey.kTimezone] = TIMEZONE
                    data[ApiKey.kRegret_type] = type
                    
                    if Connectivity.isConnectedToInternet {
                        
                        
                        self.callApiForRegretShake(data: data)
                    } else {
                        
                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
                    }
                    
                   
                }
                else
                {
                    DataManager.purchasePlan=false
                    if MySubscriptiontype.equalsIgnoreCase(string: kShake)
                    {
                        self.runOutPremiumPopup()
                    }
                   
                    
                    
                }
                
            }
        })
    }
    
    
    

    
    //MARK: - getRTMTokenApi
    func getRTMTokenApi()
    {
        ChatVM.shared.callApi_RTM_Token_Generate(showIndiacter: false, response: { (message, error) in
            if error != nil
            {
                
            }
            else
            {
                let rtmToken = ChatVM.shared.Rtm_token
                
                debugPrint("RTM token = \(rtmToken)")
                let rtm = AgoraRtm.shared()
                rtm.inviterDelegate = self
                guard let kit = AgoraRtm.shared().kit else {
                    return
                }
                kit.login(account: DataManager.Id, token: rtmToken) { [unowned self] (error) in
                    debugPrint("Rtm login on home page error \(error)")
                    
                }
                
                
            }
            
        })
    }
    
}

//MARK: - Get current location

extension HomeVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        debugPrint("Failed to find user's location: \(error.localizedDescription)")
    }
}
//MARK: - Shake  popup

extension HomeVC:DiscardDelegate,deleteAccountDelegate
{
    
    func runOutPremiumPopup()
    {
    
        let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
        vc.comeFrom = kRegretRunningOut
        vc.message=kRegretMessage
        vc.messageTitle=kRegretAction
        vc.delegate=self
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    func showPremiumPopup()
    {
    
        let destVC = NewPremiumVC.instantiate(fromAppStoryboard: .Account)
        destVC.type = .Shake
        destVC.subscription_type=kShake
        destVC.popupShowIndex=3
        destVC.delegate=self
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
    
    
    
    
    
    func deleteAccountFunc(name: String) {
        
        
        if name.equalsIgnoreCase(string: kRegretRunningOut)
        {
            self.showPremiumPopup()
        }
    }
    
    
    
    
    func ClickNameAction(name: String)
    {
        if name.equalsIgnoreCase(string: kCancel)
        {
            
            self.cardView.isHidden=true
            self.shakeView.isHidden=true
            
            self.addsView.isHidden=true
            self.shakeView.isHidden=true
            self.adsSetup()
            
            self.fromLikeDisLike=false
            self.AllUserDataArray.removeAll()
            self.getShakeSentUser(page: 0)
        }
        else
        {
            self.cardView.isHidden=true
            self.shakeView.isHidden=true
            
            self.addsView.isHidden=true
            self.shakeView.isHidden=true
            
            
            DataManager.comeFromTag=3
            imgChangeCard.image = UIImage(named: "NewPhoneRotate")
            self.fromLikeDisLike=false
            self.AllUserDataArray.removeAll()
            self.getAnonymousUser(page: 0)
            self.tableAllUser.scrollToTop(animated: false)
        }
    }
    
    
    func reload(tableView: UITableView)
    {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }
    
}

//MARK: - Socket method

//extension HomeVC
//{
//    func selfJoinSocketEmit()
//    {
//        
//        let JoinDict = ["selfUserId":DataManager.Id]
//        SocketIOManager.shared.selfJoinSocket(MessageChatDict: JoinDict)
//        self.selfJoinSocketON()
//    }
//    func selfJoinSocketON()
//    {
//        SocketIOManager.shared.socket.on("online", callback: { (data, error) in
//            
//            debugPrint("online = \(data) \(error)")
//        })
//        
//    }
//    
//    
//
//}

extension HomeVC:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
            return true
    }
}

extension HomeVC: AgoraRtmInvitertDelegate {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation) {
        debugPrint(#function)
        debugPrint("didReceivedIncoming")

    }

    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        debugPrint("remoteDidCancelIncoming")
        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

    }
}

extension HomeVC:paymentScreenOpenFrom
{
    func FromScreenName(name: String, ActiveDay: Int) {
        if Connectivity.isConnectedToInternet {

            self.getMySubscriptionApi(MySubscriptiontype: kDidAppear)
        } else {

            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            // Fallback on earlier versions
        }
    }
}


extension HomeVC
{
    func BackgroundDataCall()
    {
        DispatchQueue.global(qos: .background).async {
       
            if HangoutVM.shared.hangoutOtherDataArray.count == 0
            {
                self.requestIDFA()
                self.callGetAllHangoutApi()
            }
            
            if StoriesVM.shared.StoriesPostData.count == 0
            {
            
                self.callGetStoriesApi()
            }
        
        }
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
            tracker.set(kGAIScreenName, value: "HomeVC")

            guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
            tracker.send(builder.build() as [NSObject : AnyObject])
     
        
       
    }
}


extension HomeVC
{
    func callGetAllHangoutApi(page: Int=0,fromType:String=kType)
    {
        
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        
        
        data[ApiKey.ksocial] = DataManager.social
        data[ApiKey.ktravel] = DataManager.travel
        data[ApiKey.kbusiness] = DataManager.business
        data[ApiKey.ksport] = DataManager.sport
        
        let men = DataManager.men
        let women = DataManager.women
        
        if ((men=="1") && (women=="1"))
        {
            data[ApiKey.kman] = "0"
            data[ApiKey.kwomen] = "0"
        }
        else
        {
            data[ApiKey.kman] = DataManager.men
            data[ApiKey.kwomen] = DataManager.women
        }
        
        
        
        data[ApiKey.klatest_first] = DataManager.latest
        data[ApiKey.kolder_first] = DataManager.oldest
        data[ApiKey.kascending_age] = DataManager.ase
        data[ApiKey.kdescending_age] = DataManager.desc
        
       
        if Connectivity.isConnectedToInternet {
            
            self.callApiForGetHangout(data: data,fromType:fromType)
        } else {
            self.viewLoader.isHidden=true
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    func callApiForGetHangout(data:JSONDictionary,fromType:String=kType)
    {
        HangoutVM.shared.callApiGetOtherHangout(showIndiacter: false, data: data, response: { (message, error) in
            debugPrint("Hangout  = home")
        })
    }
    
    func callGetStoriesApi(page: Int=0,fromType:String=kType)
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
                
                self.callApiForGetStories(data: data,fromType:fromType)
             } else {
            
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForGetStories(data:JSONDictionary,fromType:String=kType)
    {
        StoriesVM.shared.callApiGetStories(showIndiacter:false, data: data, response: { (message, error) in
            debugPrint("Story  = home")
        })
    }
    
    
}
