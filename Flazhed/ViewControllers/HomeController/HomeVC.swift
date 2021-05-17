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

class HomeVC: BaseVC {
    
    //MARK:- All outlets  🍎
    
    @IBOutlet weak var btnLikeCard: UIButton!
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
    
    //MARK:- All Variable  🍎
    var permissionLocationCheck:Bool = false
    var toShow = ""
    var toShowAno = ""
    var isplayVideo=false
    var isAnoModeOn=true
    var isPagination=false
    
    var anoCollectionHeight = 50
    var shakeCollectionHeight = 50
    
    var currentPage = ""
    
    var UserData:UserListModel?
    var bannerView: GADBannerView!
    var other_user_id = ""
    var other_user_image = ""
    var is_liked_by_other_user_id = 0
    
    let locationmanager = CLLocationManager()
    var voiceUrl = ""
    
    var currentUserIndex = 0
    var currentUserDetails:UserListModel?
    var AllUserDataArray:[UserListModel] = []
    var page = 0
    
    var fromLikeDisLike=false
    var scrollDown=false
    
    //MARK:- View Lifecycle   🍎
    override func viewDidLoad() {
        super.viewDidLoad()
        self.page = 0
        DataManager.comeFrom = ""
        DataManager.HomeRefresh = "true"
        
        self.cardView.isHidden=true
        self.shakeView.isHidden=false
        self.addsView.isHidden=true
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        
        
        self.adsSetup()
        
        //MARK:- Hide load view
        
        self.viewButtomCard.isHidden=true
        NotificationCenter.default.addObserver(self, selector: #selector(self.openProfileDetails(notification:)), name: Notification.Name("OpenProfileDetails"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setUpTable()
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        
        
        //MARK:-  data manager 5- show initial two card, 4- show shake user, 3- Show card anonyous user
        
        print("current comefrom tag = \(DataManager.comeFromTag)")
        
        
        if DataManager.HomeRefresh == "true"
        //self.isplayVideo==false
        {
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
                self.cardView.isHidden=true
                self.shakeView.isHidden=true
                
                self.addsView.isHidden=true
                self.shakeView.isHidden=false
                DataManager.comeFromTag=3
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
            DataManager.HomeRefresh = "false"
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
        
        
        
        
    }
    //MARK:- Stop audio  🍎
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        MusicPlayer.instance.pause()
        
    }
    
    
    //MARK:- Bottom Five (Like , dislike...) Act  🍎
    
    
    //MARK:- Regret swipe action  🍎
    
    @IBAction func shareAct(_ sender: UIButton)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
        destVC.type = .Regret
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(destVC, animated: true, completion: nil)
    }
    
    //MARK:- Hear voice action  🍎
    
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
    
    //MARK:- Dislike user action  🍎
    
    @IBAction func DisLikeAct(_ sender: UIButton)
    {
        
        //MARK:- tage 0- card, 2- user details, 3- ads
        self.other_user_id = self.currentUserDetails?.user_id ?? ""
        
        MusicPlayer.instance.pause()
        
        
        let currentTag = DataManager.comeFromTag
        
        if self.isAnoModeOn//currentTag == 3
        {
            self.fromLikeDisLike=true
            
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: "Anonymous", type: "Ano")
        }
        else
        {
            self.fromLikeDisLike=true
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: "Shake", type: "Shake")
        }
        
        
    }
    
    //MARK:- Like user action  🍎
    
    @IBAction func LikeAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        self.other_user_id = self.currentUserDetails?.user_id ?? ""
        
        let currentTag = DataManager.comeFromTag
    /*
    
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
        
        self.tableAllUser.reloadData()
        
        
        
        */
        
        
        
        if self.isAnoModeOn//currentTag == 3
        {
            self.lightUp(button: sender)
            self.fromLikeDisLike=true
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: "Anonymous", type: "Ano")
        }
        else
        {
            self.fromLikeDisLike=true
            self.lightUp(button: sender)
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: "Shake", type: "Shake")
        }
        
    }
    
    
    //MARK:- Shake send to user action  🍎
    
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
    
    //MARK:- Show ano user action  🍎
    
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
        
    }
    
    //MARK:- Change mode (Ano,Shake) Show action  🍎
    
    @IBAction func playAnoAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        if sender.tag == 1
        {
            DataManager.comeFromTag=3
            imgChangeCard.image = UIImage(named: "phoneRotate")
            
            
            self.AllUserDataArray.removeAll()
            self.fromLikeDisLike=false
            self.getAnonymousUser(page: 0)
            
        }
        else
        {
            if  self.imgChangeCard.image == UIImage(named: "phoneRotate") //DataManager.comeFromTag==3
            {
                self.fromLikeDisLike=false
                self.AllUserDataArray.removeAll()
                self.getShakeSentUser()
                self.imgChangeCard.image = UIImage(named: "AnoBack")
                
                
            }
            else
            {
                self.AllUserDataArray.removeAll()
                self.fromLikeDisLike=false
                self.getAnonymousUser(page: 0)
                imgChangeCard.image = UIImage(named: "phoneRotate")
                
            }
        }
        
    }
    //MARK:- Close ads action  🍎
    
    @IBAction func closeAdsAct(_ sender: UIButton)
    {
        MusicPlayer.instance.pause()
        self.cardView.isHidden=true
        self.shakeView.isHidden=false
        
        self.addsView.isHidden=true
    }
}



//MARK:- Table view setup and show data 🍎

extension HomeVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
    
    func setUpTable()
    {
        
        self.tableAllUser.register(UINib(nibName: "HomeUserTCell", bundle: nil), forCellReuseIdentifier: "HomeUserTCell")
        // self.tableAllUser.rowHeight = 100
        //self.tableAllUser.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableAllUser.delegate = self
        self.tableAllUser.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.AllUserDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeUserTCell") as! HomeUserTCell
        var currentUserDetails:UserListModel?
        
        if self.AllUserDataArray.count>indexPath.row
        {
            currentUserDetails = self.AllUserDataArray[indexPath.row]
            self.currentUserDetails=self.AllUserDataArray[0]
        }
        if self.isAnoModeOn
        {
            
            
            //HomeVM.shared.AnonymousUserDataArray[indexPath.row]
            cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: true)
        }
        else
        {
            // currentUserDetails = self.AllUserDataArray[indexPath.row]//HomeVM.shared.ShakeUserDataArray[indexPath.row]
            cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: false)
        }
        
        
        return cell
    }
    
    
    @objc func openProfileDetails(notification: Notification)
    {
        if let data = notification.userInfo as? [String:String]
        {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = data["userId"] ?? ""
            self.isplayVideo=true
            DataManager.comeFrom = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        print("cell height = \(self.tableAllUser.frame.height)")
        return self.tableAllUser.frame.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        MusicPlayer.instance.pause()
        var index = 0
        
        
        if scrollView == self.tableAllUser
        {
            if let indexPath = self.tableAllUser.indexPathsForVisibleRows?.first {
                
                index = indexPath.row
            }
        }
        
        if self.AllUserDataArray.count>index//HomeVM.shared.AnonymousUserDataArray.count>index
        {
            self.currentUserDetails = self.AllUserDataArray[index]//HomeVM.shared.AnonymousUserDataArray[index]
            
        }
        
        //   if self.AllUserDataArray.count>(index-1)
        //        {
        //            var user:UserListModel?
        //
        //            if index == 0
        //            {
        //                if self.AllUserDataArray.count>0
        //                {
        //                 user = self.AllUserDataArray[0]
        //                }
        //            }
        //            else
        //            {
        //                 user = self.AllUserDataArray[index-1]
        //            }
        //
        //
        //            if self.isAnoModeOn
        //            {
        //
        //               // self.likeUnlikeAPI(other_user_id: user?.user_id ?? "", action: "2", like_mode: "Anonymous", type: "Ano")
        //            }
        //            else
        //            {
        //               // self.likeUnlikeAPI(other_user_id: user?.user_id ?? "", action: "2", like_mode: "Shake", type: "Shake")
        //            }
        //        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
                    // it's going down
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
                    // it's going down
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
    /*
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
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
                    //                if self.isAnoModeOn
                    //                {
                    //                    self.fromLikeDisLike=false
                    //                    self.likeUnlikeAPI(other_user_id: user?.user_id ?? "", action: "2", like_mode: "Anonymous", type: "Ano")
                    //                }
                    //                else
                    //                {
                    //                    self.fromLikeDisLike=false
                    //                    self.likeUnlikeAPI(other_user_id: user?.user_id ?? "", action: "2", like_mode: "Shake", type: "Shake")
                    //                }
                    
                }
                
                
            }
        }
    }
    */
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

//        if ((self.tableAllUser.contentOffset.y + self.tableAllUser.frame.size.height) >= self.tableAllUser.contentSize.height-50)
//            {
//                if self.AllUserDataArray.count<HomeVM.shared.Pagination_Details?.totalCount ?? 0
//                {
//                    if self.isAnoModeOn
//                    {
//                        self.isPagination=true
//                        self.getAnonymousUser(page: self.page)
//                    }
//
//                }
//
//            }
       
       
    }
    
    
}

extension HomeVC:ButtonTapDelegate
{
    func buutonName(name: String) {
        toShow = "Card"
    }
    
    
}

//MARK:- Ads setup 🍎

extension HomeVC:GADBannerViewDelegate
{
    func adsSetup()
    {
        //Indicator.sharedInstance.showIndicator()
        
        let size = self.addsView.frame.size
        let bannerView = GADBannerView(frame: self.addsSubView.frame)
        
        bannerView.frame = self.addsSubView.frame
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        if self.getDeviceModel() == "iPhone 6"
        {
            let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
            bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
            bannerView.delegate = self
            
            self.addsSubView.addSubview(bannerView)
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 500))
            bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
            bannerView.delegate = self
            
            self.addsSubView.addSubview(bannerView)
        }
        else
        {
            
            let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 500))
            bannerView.adSize = adSize//kGADAdSizeSmartBannerPortrait
            bannerView.delegate = self
            
            self.addsSubView.addSubview(bannerView)
        }
        
        
        
        
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView)
    {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
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
    
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
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

// MARK:- Extension Api Calls


extension HomeVC
{
    
    
    //MARK:- Get shake user list 🍎
    
    func getShakeSentUser()
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "0"
        
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
                
                //MARK:- Home page  changes
                
                if HomeVM.shared.ShakeUserDataArray.count>0
                {
                    
                    self.cardView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    self.addsView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    self.imgCardLike.image = UIImage(named: "BlackLike")
                    
                    self.btnLikeCard.setImage(nil, for: .normal)
                    self.viewButtomCard.isHidden=false
                    self.isAnoModeOn=false
                    
                    for dict in HomeVM.shared.ShakeUserDataArray
                    {
                        
                        self.AllUserDataArray.append(dict)
                        
                    }
                    self.page = self.AllUserDataArray.count
                    
                    if  self.fromLikeDisLike==false
                    {
                        
                        self.tableAllUser.scrollToTop(animated: false)
                    }
                    else
                    {
                        self.tableAllUser.reloadData()
                    }
                    
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
    
    //MARK:-  user like dislike api 🍎
    
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
        HomeVM.shared.callApiForLikeUnlikeUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                print(" DataManager.comeFromTag = \(message) \(DataManager.comeFromTag)")
                
                if message! == "User has been liked successfully."
                {
                    if self.is_liked_by_other_user_id == 1
                    {
                        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                        vc.comefrom = kAppDelegate
                        vc.user2Image=self.other_user_image
                        vc.profileImage=self.other_user_image
                        vc.view_user_id=self.other_user_id
                        vc.profileName=(self.UserData?.profile_data?.username ?? "").capitalized
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        if type == "Ano"
                        {
                            self.imgChangeCard.image = UIImage(named: "phoneRotate")
                            
                            self.AllUserDataArray.removeAll()
                            self.getAnonymousUser(page: 0)
                            
                        }
                        else
                        {
                            self.imgChangeCard.image = UIImage(named: "AnoBack")
                            
                            
                            self.AllUserDataArray.removeAll()
                            
                            self.getShakeSentUser()
                        }
                    }
                    
                }
                else if message! == "User has been disliked successfully." ||  message! == "User has been disliked successfully."
                {
                    if type == "Ano"
                    {
                        self.imgChangeCard.image = UIImage(named: "phoneRotate")
                        
                        self.AllUserDataArray.removeAll()
                        self.getAnonymousUser(page: 0)
                    }
                    else
                    {
                        self.imgChangeCard.image = UIImage(named: "AnoBack")
                        
                        self.AllUserDataArray.removeAll()
                        self.getShakeSentUser()
                    }
                }
                else
                {
                    self.openSimpleAlert(message: message)
                }
            }
            
            
        })
    }
    
    
    //MARK:- Get ano user list 🍎
    
    func getAnonymousUser(page:Int)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        
        if Connectivity.isConnectedToInternet {
            
            
            self.callApiForGetAnonymousUser(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetAnonymousUser(data:JSONDictionary)
    {
        HomeVM.shared.callApiGetAnonymousUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                self.isAnoModeOn=true
                for dict in HomeVM.shared.AnonymousUserDataArray
                {
                    
                    self.AllUserDataArray.append(dict)
                    
                }
                self.page = self.AllUserDataArray.count
                
                //MARK:- Home page changes
                
                if self.AllUserDataArray.count>0//HomeVM.shared.AnonymousUserDataArray.count>0
                {
                    self.cardView.isHidden=false
                    self.shakeView.isHidden=true
                    
                    self.addsView.isHidden=true
                    self.shakeView.isHidden=true
                    
                    self.isAnoModeOn=true
                    self.imgCardLike.image = UIImage(named: "BlackLike")
                    
                    
                    self.btnLikeCard.setImage(nil, for: .normal)
                    
                    
                    
                    
                    self.viewButtomCard.isHidden=false
                    
                    self.cardView.isHidden=false
                    
                  //  self.tableAllUser.reloadData()
                 
                   // self.reload(tableView: self.tableAllUser)
//                    if self.isPagination==true
//                   {
//                       //self.tableAllUser.scrollToTop(animated: false, row: 10)
//                       // self.tableAllUser.isPagingEnabled=false
//                        self.tableAllUser.reloadData()
//                   }
//                    else
//
                    if  self.fromLikeDisLike==false
                    {
                       // self.tableAllUser.isPagingEnabled=true
                        self.tableAllUser.scrollToTop(animated: false)
                    }
                    else
                    {
                        self.tableAllUser.reloadData()
                       // self.tableAllUser.isPagingEnabled=true
                    }
                    
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
    
    //MARK:- Show like animation  🍎
    
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
    
}

//MARK:- Get current location 🍎

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
//MARK:- Shake  popup 🍎

extension HomeVC:DiscardDelegate
{
    func ClickNameAction(name: String)
    {
        if name == kCancel
        {
            
            self.cardView.isHidden=true
            self.shakeView.isHidden=true
            
            self.addsView.isHidden=true
            self.shakeView.isHidden=true
            self.adsSetup()
            
            self.fromLikeDisLike=false
            self.AllUserDataArray.removeAll()
            self.getShakeSentUser()
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

