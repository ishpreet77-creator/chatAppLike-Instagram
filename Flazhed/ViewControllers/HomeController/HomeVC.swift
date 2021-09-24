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
import FaveButton

class HomeVC: BaseVC {
    
    //MARK:- All outlets
    
    @IBOutlet weak var fvBtn: FaveButton!
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
    
    @IBOutlet weak var btnLike: FaveButton!
    @IBOutlet weak var btnDisLike: FaveButton!
    @IBOutlet weak var btnMessage: UIButton!
    
    //MARK:- All Variable
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
    
    var UserData:UserListModel?
    var bannerView: GADBannerView!
    var other_user_id = ""
   
    var is_liked_by_other_user_id = 0
    
    let locationmanager = CLLocationManager()
    var voiceUrl = ""
    
    var currentUserIndex = 0
    var currentUserDetails:UserListModel?
    var AllUserDataArray:[UserListModel] = []
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
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page = 0
        
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
        
        //MARK:- Hide load view
        self.regretView.isHidden=true
        
        
        self.selfJoinSocketEmit()
        self.updateLocationAPI()
        self.setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SocketIOManager.shared.initializeSocket()
        self.selfJoinSocketEmit()
        self.setUpTable()
        
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //  locationmanager.startMonitoringSignificantLocationChanges()
        
//MARK:-  data manager 5- show initial two card, 4- show shake user, 3- Show card anonyous user
        
        print("current comefrom tag = \(DataManager.comeFromTag)")
        
        
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
                
                imgChangeCard.image = UIImage(named: "phoneRotate")
                
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
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
                destVC.delegate=self
                
                destVC.type = .shakeSent
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                self.present(destVC, animated: true, completion: nil)
                
                
                
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
                print("No access")
                self.permissionLocationCheck=false
            //self.openSettings(message: kLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.permissionLocationCheck=true
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
            self.permissionLocationCheck=false
            //self.openSettings(message: kLocation)
        }
        if self.permissionLocationCheck==false
        {
            self.openSettings(message: kLocation)
        }
        
        
     //   self.getRTMTokenApi()
        
    }
    //MARK:- Stop audio
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        MusicPlayer.instance.pause()
        
    }
    
    func setUI()
    {
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
        
    
        
    }
    
    //MARK:- Message Button action

    @IBAction func messageBtnAct (_ sender:UIButton)
    {
        
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
        vc.screenType = kHome
            DataManager.HomeRefresh = false
            if self.AllUserDataArray.count==1
            {
                self.currentUserDetails = self.AllUserDataArray[0]
            }
            
            MusicPlayer.instance.pause()
       
            
            let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
            let cellData = self.currentUserDetails
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
           
            
            self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //MARK:- respond ToSwipe Gesture action
    
    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        print("DataManager.purchasePlan \(DataManager.purchasePlan)")
//        print("AllUserDataArray.count \(self.AllUserDataArray.count)")
//
        if DataManager.purchasePlan
        {
            self.tableAllUser.isScrollEnabled=true
        }
        else
        {
        if sender.direction == .up
        {
            print("swipe up")
            self.tableAllUser.isScrollEnabled=true
        }
        else if sender.direction == .down
        {
            print("swipe down")
            self.tableAllUser.isScrollEnabled=false
        }
        }
        
        
    }
    
    
    //MARK:- Bottom Five (Like , dislike...) Act
    
    
    //MARK:- Regret swipe action
    
    @IBAction func shareAct(_ sender: UIButton)
    {
        //         IAPHandler.shared.validatePurchase(success: { (status) in
        //
        //            print("Purchase Status = \(status)")
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
        
        //MARK:- For payment check api
        if self.regretPaymentChecked
        {
            let active = AccountVM.shared.Swiping_Subsription_Data?.subscription_is_active ?? 0
            
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
                let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
                destVC.type = .Regret
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                self.present(destVC, animated: true, completion: nil)
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
        
//        //MARK:- To show popup
//
//        let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
//        let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
//        destVC.type = .Regret
//        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//        self.present(destVC, animated: true, completion: nil)
        
    }
    
    //MARK:- Hear voice action
    
    @IBAction func soundPlayAct(_ sender: UIButton)
    {
        
        self.voiceUrl = self.currentUserDetails?.profile_data?.voice ?? ""
        
        
        if  self.voiceUrl != ""
        {
            MusicPlayer.instance.initPlayer(url:self.voiceUrl, tag: 0)
            if sender.isSelected
            {
                sender.isSelected=false
                MusicPlayer.instance.pause()
            }
            else
            {
                sender.isSelected=true
                MusicPlayer.instance.play()
            }
            
        }
        
        
    }
    
    //MARK:- Dislike user action
    
    @IBAction func DisLikeAct(_ sender: UIButton)
    {
        
//MARK:- tage 0- card, 2- user details, 3- ads
        if self.AllUserDataArray.count==1
        {
            self.currentUserDetails = self.AllUserDataArray[0]
        }
     
        MusicPlayer.instance.pause()
        self.other_user_id = self.currentUserDetails?.user_id ?? ""
   
        print("user name Like: = \(self.currentUserDetails?.profile_data?.username)")
        
        
         
         var index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
         
         if list.user_id == self.other_user_id
         {
         return true
         }
         else
         {
         return false
         }
         
         
         } ?? 0
         
         
         print("Index at id = \(index)")
         
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
        
       
        
    }
    
    //MARK:- Like user action
    
    @IBAction func LikeAct(_ sender: UIButton)
    {
        if self.AllUserDataArray.count==1
        {
            self.currentUserDetails = self.AllUserDataArray[0]
        }
        self.lightUp(button: sender)
        MusicPlayer.instance.pause()
        self.other_user_id = self.currentUserDetails?.user_id ?? ""
   
        print("user name Like: = \(self.currentUserDetails?.profile_data?.username)")
        
        
         
         var index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
         
         if list.user_id == self.other_user_id
         {
         return true
         }
         else
         {
         return false
         }
         
         
         } ?? 0
         
         
         print("Index at id = \(index)")
         
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
        
        
    }
    
    
    //MARK:- Shake send to user action
    
    @IBAction func shakeSendAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShakeSentVC") as!  ShakeSentVC
        vc.delegate=self
        vc.comeFrom="Home"
        self.present(vc, animated: true, completion: nil)
        // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Show ano user action
    
    @IBAction func playCardAnoAct(_ sender: UIButton)
    {
        
        // self.tableAllUser.isPagingEnabled=true
        MusicPlayer.instance.pause()
        DataManager.comeFromTag=3
        self.AllUserDataArray.removeAll()
        self.fromLikeDisLike=false
        
        self.getAnonymousUser(page: 0)
        self.cardView.isHidden=true
        self.shakeView.isHidden=true
        
        self.addsView.isHidden=true
        
        imgChangeCard.image = UIImage(named: "phoneRotate")
        self.tableAllUser.scrollToTop(animated: false)
      
        
    }
    
    //MARK:- Change mode (Ano,Shake) Show action
    
    @IBAction func playAnoAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        if sender.tag == 1
        {
            DataManager.comeFromTag=3
            imgChangeCard.image = UIImage(named: "phoneRotate")
            
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
                self.imgChangeCard.image = UIImage(named: "AnoBack")
                
                self.tableAllUser.scrollToTop(animated: false)
            }
            else
            {
                self.AllUserDataArray.removeAll()
                self.fromLikeDisLike=false
                self.getAnonymousUser(page: 0)
                imgChangeCard.image = UIImage(named: "phoneRotate")
                self.tableAllUser.scrollToTop(animated: false)
            }
        }
        
        
        
    }
    //MARK:- Close ads action
    
    @IBAction func closeAdsAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        self.cardView.isHidden=true
        self.shakeView.isHidden=false
        
        self.addsView.isHidden=true
    }
    
    
    
    @IBAction func PremiumBtnAct(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard.init(name: "Account", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "PremiumVC") as! PremiumVC //RegretPopUpVC
        vc.type = .kExtraShakes
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
        
    }
    
}



//MARK:- Table view setup and show data

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUserTCell") as! HomeUserTCell
        
        
        var currentUserDetails:UserListModel?
      
        
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
            
            
            if (kHangout.equalsIgnoreCase(string: mode)) //kStory.equalsIgnoreCase(string: mode) ||
            {
                self.btnLike.isHidden=true
                self.btnMessage.isHidden=false
            }
            else if isMatch == 1
            {
                self.btnLike.isHidden=true
                self.btnMessage.isHidden=false
            }
            else
            {
                self.btnLike.isHidden=false
                self.btnMessage.isHidden=true
            }
            
        }
        else
        {
            self.btnLike.isHidden=false
            self.btnMessage.isHidden=true
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
       // print(#function)
        MusicPlayer.instance.pause()
        
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
        print(#function)
        if scrollView == self.tableAllUser
        {
            
            if self.AllUserDataArray.count>1
            {
                if targetContentOffset.pointee.y <= scrollView.contentOffset.y {
                    print(" it's going up")
                    
                    self.scrollDown=false
                }
                else
                {
                   
                    print(" it's going down")
                    self.scrollDown=true
                   
                }
            }
            else if self.AllUserDataArray.count==1
            {
                if targetContentOffset.pointee.y < scrollView.contentOffset.y {
                    print(" it's going up")
                    self.scrollDown=false
                }
                else
                {
            
                    print(" it's going down")
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
        
        print(#function)
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
                var user:UserListModel?
                
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
                    
                    print("self.scrollDown \(self.scrollDown)")
               
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
                        self.imgChangeCard.image = UIImage(named: "AnoBack")
                        
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
                        print("Shake Array count  = \(AllUserDataArray.count)")
                      
                        if self.AllUserDataArray.count == 0 ||  self.AllUserDataArray.count == 1
                        {
                            self.AllUserDataArray.removeAll()
                            self.isPagination=true
                            self.getShakeSentUser(page: 0)
                        }
                        
                        
        
                    }
                    print("AllUserDataArray count 1 = \(AllUserDataArray.count)")
                    
                    
                    
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
                print("else")
            }
            
            */
            
//            print((self.tableAllUser.contentOffset.y + self.tableAllUser.frame.size.height))
//                print(self.tableAllUser.contentSize.height-50)
            
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
//            print("prefetching row of \(indexPath.row)")
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
//      print("cancel prefetch row of \(indexPaths)")
//    }
}

extension HomeVC:ButtonTapDelegate
{
    func buutonName(name: String) {
        toShow = "Card"
    }
    
    
}

//MARK:- Ads setup

extension HomeVC:GADBannerViewDelegate
{
    func adsSetup()
    {
        //Indicator.sharedInstance.showIndicator()
        
        
        let bannerView = GADBannerView(frame: self.addsSubView.frame)
        
        bannerView.frame = self.addsSubView.frame
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        /*
        if self.getDeviceModel() == "iPhone 6"
        {
            let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
            bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
            bannerView.delegate = self
            
            //            bannerView.center = CGPoint(x: self.addsSubView.bounds.midX,
            //                                        y: self.addsSubView.bounds.minY+150)
            self.addsSubView.addSubview(bannerView)
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
           // let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 500))
            let adSize = GADAdSizeFromCGSize(CGSize(width: SCREENWIDTH, height: SCREENHEIGHT-106))
            bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
            bannerView.delegate = self
            bannerView.center = CGPoint(x: self.addsSubView.bounds.midX,
                                        y: self.addsSubView.bounds.midY)
            
            self.addsSubView.addSubview(bannerView)
        }
        else
        {
            
           // let adSize = GADAdSizeFromCGSize(CGSize(width: SCREENWIDTH, height: SCREENHEIGHT-356))//(CGSize(width: 300, height: 500))
            
            let adSize = GADAdSizeFromCGSize(CGSize(width: SCREENWIDTH, height: SCREENHEIGHT-106))
            bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
            bannerView.delegate = self
            
            self.addsSubView.addSubview(bannerView)
        }
        */
        
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
        print("adViewDidReceiveAd")
        Indicator.sharedInstance.showIndicator()
        
       
        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            bannerView.alpha = 1
            Indicator.sharedInstance.hideIndicator()
        })
        
    }
    
    
    //    /// Tells the delegate an ad request failed.
    //    func adView(_ bannerView: GADBannerView,
    //                didFailToReceiveAdWithError error: GADRequestError) {
    //        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    //        Indicator.sharedInstance.hideIndicator()
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
//MARK:- Fav buttom Action Like /dislike Action

extension HomeVC:FaveButtonDelegate
{
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        if faveButton == self.btnLike
        {
            self.regretView.isHidden=false
            if self.AllUserDataArray.count==1
            {
                self.currentUserDetails = self.AllUserDataArray[0]
            }
            
            MusicPlayer.instance.pause()
            self.other_user_id = self.currentUserDetails?.user_id ?? ""
       
            print("user name Like: = \(self.currentUserDetails?.profile_data?.username)")
            
            
             
             var index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
             
             if list.user_id == self.other_user_id
             {
             return true
             }
             else
             {
             return false
             }
             
             
             } ?? 0
             
             
             print("Index at id = \(index)")
             
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
            //MARK:- tage 0- card, 2- user details, 3- ads
                    if self.AllUserDataArray.count==1
                    {
                        self.currentUserDetails = self.AllUserDataArray[0]
                    }
                 
                    MusicPlayer.instance.pause()
                    self.other_user_id = self.currentUserDetails?.user_id ?? ""
               
                    print("user name Like: = \(self.currentUserDetails?.profile_data?.username)")
                    
                    
                     
                     var index:Int = self.AllUserDataArray.firstIndex { (list) -> Bool in
                     
                     if list.user_id == self.other_user_id
                     {
                     return true
                     }
                     else
                     {
                     return false
                     }
                     
                     
                     } ?? 0
                     
                     
                     print("Index at id = \(index)")
                     
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
    
    
}

// MARK:- Extension Api Calls


extension HomeVC
{
    
    
    //MARK:- Get shake user list
    
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
        HomeVM.shared.callApiGetShakeUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
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
                    
                    self.imgCardLike.image = UIImage(named: "BlackLike")
                    self.imgChangeCard.image = UIImage(named: "AnoBack")
                    
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
                    //MARK:- Home page  changes
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
                
            }
            
            
        })
    }
    
    //MARK:-  user like dislike api
    
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
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
   
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String,action:String,showIndicator:Bool)
    {
        HomeVM.shared.callApiForLikeUnlikeUser(showIndiacter: showIndicator, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                let isMatch = HomeVM.shared.like_Data_Model?.is_match ?? 0
                self.isRegetEnable=true
                self.regretView.isHidden=false
                self.imgCardLike.image = UIImage(named: "BlackLike")
                self.btnLike.setSelected(selected: false, animated: false)
                if isMatch == 1
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
                            
                            
                            print("Index at id = \(index)")
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
                        
                        
                        print("Index at id = \(index)")
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
                            
                            
                            print("Index at id = \(index)")
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
                        
                        
                        print("Index at id = \(index)")
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

    
    //MARK:- Get ano user list
    
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
        HomeVM.shared.callApiGetAnonymousUser(showIndiacter:showIndiacter, data: data, response: { (message, error) in
            
            if error != nil
            {
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
                //MARK:- Home page changes
                
                if self.AllUserDataArray.count>0//HomeVM.shared.AnonymousUserDataArray.count>0
                {
                    self.cardView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    self.addsView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    self.isAnoModeOn=true
                    self.imgCardLike.image = UIImage(named: "BlackLike")
                    self.imgChangeCard.image = UIImage(named: "phoneRotate")
                    
                    
                   // self.btnLikeCard.setImage(nil, for: .normal)
                    self.btnLike.setSelected(selected: false, animated: false)
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
            
            
            if DataManager.comeFromTag==5
            {
                
                //                self.AllUserDataArray.removeAll()
                //                self.getShakeSentUser(page: 0)
                
                
            }
        })
    }
    
    
    func getMySubscriptionApi()
    {
        AccountVM.shared.callApiGetMySubscription(response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                self.regretPaymentChecked=true
                let active = AccountVM.shared.Swiping_Subsription_Data?.subscription_is_active ?? 0
                
                let active2 = AccountVM.shared.Prolong_Subsription_Data?.subscription_is_active ?? 0
                print("prolong active =\(active)")
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
                    let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
                    let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
                    destVC.type = .Regret
                    destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    
                    self.present(destVC, animated: true, completion: nil)
                }
                
            }
        })
    }
    
    
    
    //MARK:- Show like animation
    
    func lightUp(button: UIButton)
    {
        UIView.transition(with: button, duration: 0.30, options: .transitionCrossDissolve, animations: {
            button.setImage(UIImage(named: "redLike"), for: .normal)
        }, completion: {_ in
            UIView.transition(with: button, duration: 0.30, options: .transitionCrossDissolve, animations: {
                // button.setImage(UIImage(named: "BlackLike"), for: .normal)
            }, completion: { _ in
                
                print("Like done")
            }
            )})
    }
    //MARK:- getRTMTokenApi
    func getRTMTokenApi()
    {
        ChatVM.shared.callApi_RTM_Token_Generate(showIndiacter: false, response: { (message, error) in
            if error != nil
            {
                
            }
            else
            {
                let rtmToken = ChatVM.shared.Rtm_token
                
                print("RTM token = \(rtmToken)")
                let rtm = AgoraRtm.shared()
                rtm.inviterDelegate = self
                guard let kit = AgoraRtm.shared().kit else {
                    return
                }
                kit.login(account: DataManager.Id, token: rtmToken) { [unowned self] (error) in
                    print("Rtm login on home page error \(error)")
                    
                }
                
                
            }
            
        })
    }
    
}

//MARK:- Get current location

extension HomeVC: CLLocationManagerDelegate
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
//MARK:- Shake  popup

extension HomeVC:DiscardDelegate
{
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
            imgChangeCard.image = UIImage(named: "phoneRotate")
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

//MARK:- Socket method

extension HomeVC
{
    func selfJoinSocketEmit()
    {
        
        let JoinDict = ["selfUserId":DataManager.Id]
        SocketIOManager.shared.selfJoinSocket(MessageChatDict: JoinDict)
        self.selfJoinSocketON()
    }
    func selfJoinSocketON()
    {
        SocketIOManager.shared.socket.on("online", callback: { (data, error) in
            
            print("online = \(data) \(error)")
        })
        
    }
    
}

extension HomeVC:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
            return true
    }
}

extension HomeVC: AgoraRtmInvitertDelegate {
    func inviter(_ inviter: AgoraRtmCallKit, didReceivedIncoming invitation: AgoraRtmInvitation) {
        print(#function)
        print("didReceivedIncoming")

    }

    func inviter(_ inviter: AgoraRtmCallKit, remoteDidCancelIncoming invitation: AgoraRtmInvitation) {
        print("remoteDidCancelIncoming")
        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

    }
}
