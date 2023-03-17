//
//  AnonymousListVC.swift
//  Flazhed
//
//  Created by ios2 on 20/04/22.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds

class AnonymousListVC: BaseVC {
    
    //MARK: - All Outlet
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewtableBack: UIView!
    @IBOutlet weak var viewUserList: UIView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var addsSubView: UIView!
    @IBOutlet weak var regretView: UIView!
    @IBOutlet weak var disLikeView: UIView!
    @IBOutlet weak var hearView: UIView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var changeModeView: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDisLike: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var imgCardLike: UIImageView!
    @IBOutlet weak var btnHearVoice: UIButton!
    @IBOutlet weak var imgNewRegret: UIImageView!
    @IBOutlet weak var imgNewVoice: UIImageView!
    @IBOutlet weak var imgNewDislike: UIImageView!
    @IBOutlet weak var imgNewAno: UIImageView!
    
    
    //MARK: - All Variable
    var swipeRight = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var currentUserDetails:HomeUserListModel?
    var AllUserDataArray:[HomeUserListModel] = []
    var cellHeights = [IndexPath: CGFloat]()
    var cellHeight = SCREENHEIGHT-200
    var page = 0
    var other_user_id = ""
    var voiceUrl = ""
    var regretPaymentChecked=false
    var scrollDown=false
    var isPagination=false
    var isRegetEnable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTable()
        self.adsSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.regretPaymentChecked=false
        if Connectivity.isConnectedToInternet {
            
            self.getAnonymousUser(page: self.page)
            
        }
        else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        DispatchQueue.global(qos: .background).async {
            if Connectivity.isConnectedToInternet {
                
                debugPrint("self.appDelegate?.homeVisitCount \(self.appDelegate?.homeVisitCount)")
                
                if self.appDelegate?.homeVisitCount == 0 {
                    self.getMySubscriptionApi(MySubscriptiontype: kDidAppear)
                    self.updateLocationAPI()
                }
                self.appDelegate?.homeVisitCount += 1
            }
        }
    }
    
    //MARK: - BottomBtnAct
    
    @IBAction func BottomBtnAct(_ sender: UIButton)
    {
        self.stopVoice()
        //MARK: - Regret act
        let index = sender.tag
        
        if index == 0
        {
            
          
//            if self.regretPaymentChecked
//            {
//                let active = AccountVM.shared.Shake_Subsription_Data?.subscription_is_active ?? 0
//
//                if active == 1
//                {
                    var type = kAnonymous
                    
                    DataManager.purchasePlan=true
                    
                    
                    var data = JSONDictionary()
                    
                    data[ApiKey.kTimezone] = TIMEZONE
                    data[ApiKey.kRegret_type] = type
                    
                    if Connectivity.isConnectedToInternet {
                        
                        self.callApiForToGetRegretUser(data: data)
                    } else {
                        
                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
                    
                 /*
                }
                else
                {
                    DataManager.purchasePlan=false
                    
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
            */
        }
        //MARK: - Dislike user action
        else if index == 1
        {
//                        let vc = ShakeSentVC.instantiate(fromAppStoryboard: .Shake)
//                       // vc.delegate=self
//                       // vc.comeFrom="Home"
//                        if let tab = self.tabBarController
//                        {
//                            tab.present(vc, animated: true, completion: nil)
//                        }
//                        else
//                        {
//                            self.present(vc, animated: true, completion: nil)
//                        }
//
//
        
            self.imgNewDislike.image = UIImage(named: "NewImgDislikeFill")
            Timer.scheduledTimer(withTimeInterval: kButtonLikeDuration, repeats: false, block: { _ in
                self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
            })
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
            
            
            if self.AllUserDataArray.count == 0
            {
                self.AllUserDataArray.removeAll()
                
                self.getAnonymousUser(page: self.page)
            }
            else
            {
                self.tableView.reloadData()
            }
            self.regretView.isHidden=false
            
            
            
            // let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
            
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
            
         
        }
        //MARK: - Hear voice action
        else if index == 2
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
        //MARK: - Like user action
        else if index == 3
        {
            self.imgCardLike.image = UIImage(named: "NewLikeImg")
            
            Timer.scheduledTimer(withTimeInterval: kButtonLikeDuration, repeats: false, block: { _ in
                self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill")
            })
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
            self.regretView.isHidden=false
            
            if self.AllUserDataArray.count == 0
            {
                self.AllUserDataArray.removeAll()
                
                self.getAnonymousUser(page: 0)
            }
            else
            {
                self.tableView.reloadData()
            }
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kAnonymous, type: kAnonymous,showIndicator: false)
        }
        //MARK: - Message Button action
        else if index == 4
        {
            let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)
            vc.screenType = kHome
            DataManager.HomeRefresh = false
            if self.AllUserDataArray.count==1
            {
                self.currentUserDetails = self.AllUserDataArray[0]
            }
            
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
    }
    
    
}
//MARK: - Table view setup and show data

extension AnonymousListVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
    
    
    func setUpTable()
    {
        
        self.tableView.register(UINib(nibName: "HomeUserTCell", bundle: nil), forCellReuseIdentifier: "HomeUserTCell")
        
        self.tableView.rowHeight = self.tableView.bounds.height//UIScreen.main.bounds.height
        self.tableView.estimatedRowHeight = self.tableView.bounds.height//UIScreen.main.bounds.height
        self.tableView.separatorStyle = .none
        self.tableView.isPagingEnabled = true
        self.tableView.bounces = false
        self.tableView.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        self.tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        self.tableView.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
        self.tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.up
        swipeRight.delegate = self
        self.viewtableBack.addGestureRecognizer(swipeRight)
        
        self.swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.delegate = self
        
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.viewtableBack.addGestureRecognizer(swipeDown)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.AllUserDataArray.count
    }
    
    
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
        
        cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: true, VC: self)
        
        
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
                
                self.btnMessage.isHidden=false
                self.likeView.isHidden=false
                
            }
            else if isMatch == 1
            {
                self.btnLike.isHidden=true
                self.imgCardLike.isHidden=true
                
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
        self.cellHeight = cellHeights[indexPath] ?? self.tableView.frame.height
        
        return cellHeights[indexPath] ?? self.tableView.frame.height//self.tableAllUser.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? self.tableView.frame.height//UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: -  Scroll delegate

extension AnonymousListVC
{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // debugPrint(#function)
        self.stopVoice()
        
        var index = 0
        
        
        if scrollView == self.tableView
        {
            
            if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
                
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
        if scrollView == self.tableView
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
        if scrollView == self.tableView
        {
            
            var index = 0
            
            
            if let indexPath = self.tableView.indexPathsForVisibleRows?.first {
                
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
                    self.isRegetEnable=true
                    self.regretView.isHidden=false
                    
                    if self.AllUserDataArray.count == 1
                    {
                        self.AllUserDataArray.removeAll()
                        self.isPagination=true
                        self.getAnonymousUser(page: 0)
                        self.tableView.reloadData()
                        self.tableView.scrollToTop(animated: false)
                    }
                    
                    debugPrint("AllUserDataArray count 1 = \(AllUserDataArray.count)")
                    
                }
            }
            
            if ((self.tableView.contentOffset.y + self.tableView.frame.size.height) >= self.tableView.contentSize.height-50)
            {
                if self.AllUserDataArray.count<HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    self.isPagination=true
                    self.getAnonymousUser(page: self.page)
                    
                }
                else if self.AllUserDataArray.count >= HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    
                    self.isPagination=true
                    self.AllUserDataArray.removeAll()
                    self.getAnonymousUser(page: 0)
                    self.tableView.scrollToTop(animated: false)
                    
                }
                
                
            }
            
            
            
        }
    }
    
    
}

// MARK: - All Api Calls


extension AnonymousListVC
{
    
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
    
    func callApiForGetAnonymousUser(showIndiacter:Bool, data:JSONDictionary,page:Int = 0)
    {
        if  page == 0
        {
            self.AllUserDataArray.removeAll()
        }
        self.showLoader()
        HomeVM.shared.callApiGetAnonymousUser(showIndiacter:showIndiacter, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                
                for dict in HomeVM.shared.AnonymousUserDataArray
                {
                    
                    self.AllUserDataArray.append(dict)
                    
                }
                
                self.currentUserDetails?.user_id = nil
                if self.AllUserDataArray.count>0
                {
                    self.viewBottom.isHidden=false
                    self.viewUserList.isHidden=false
                    self.viewAds.isHidden=true
                    
                }
                else
                {
                    self.viewBottom.isHidden=true
                    self.viewUserList.isHidden=true
                    self.viewAds.isHidden=false
                }
                self.tableView.reloadData()
                
                self.hideLoader()
            }
            
            
        })
    }
    //MARK: - Get regret user
    
    func callApiForToGetRegretUser(data:JSONDictionary)
    {
        
        HomeVM.shared.callApiGetRegretuser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
                
                self.AllUserDataArray.removeAll()
                
                self.getAnonymousUser(page: 0)
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
    
    //MARK: -  user like dislike api
    
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
                self.imgCardLike.image = UIImage(named: "NewLikeImgNotFill") // //BlackLike
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
            }
            
            
        })
    }
    //MARK: -  getMySubscriptionApi
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
                    
                    if MySubscriptiontype.equalsIgnoreCase(string: kShake)
                    {
                        var data = JSONDictionary()
                        
                        data[ApiKey.kTimezone] = TIMEZONE
                        data[ApiKey.kRegret_type] = type
                        
                        if Connectivity.isConnectedToInternet {
                            
                            
                            self.callApiForToGetRegretUser(data: data)
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
    
    
}
//MARK: - Custom function

extension AnonymousListVC:UIGestureRecognizerDelegate
{
    //MARK: - respond ToSwipe Gesture action
    
    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        if DataManager.purchasePlan
        {
            self.tableView.isScrollEnabled=true
        }
        else
        {
            if sender.direction == .up
            {
                debugPrint("swipe up")
                self.tableView.isScrollEnabled=true
            }
            else if sender.direction == .down
            {
                debugPrint("swipe down")
                self.tableView.isScrollEnabled=false
            }
        }
        
        
    }
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.tableView,self.viewBottom])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.tableView,self.viewBottom])
        self.viewBottom.backgroundColor = UIColor.clear
    }
    
    func stopVoice()
    {
        MusicPlayer.instance.pause()
        self.btnHearVoice.isSelected=false
        self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
    }
}
//MARK: - Shake  popup

extension AnonymousListVC:DiscardDelegate,deleteAccountDelegate,paymentScreenOpenFrom
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
            
            //            self.cardView.isHidden=true
            //            self.shakeView.isHidden=true
            //
            //            self.addsView.isHidden=true
            //            self.shakeView.isHidden=true
            //            self.adsSetup()
            //
            //            self.fromLikeDisLike=false
            //            self.AllUserDataArray.removeAll()
            //            self.getShakeSentUser(page: 0)
        }
        else
        {
            //            self.cardView.isHidden=true
            //            self.shakeView.isHidden=true
            //
            //            self.addsView.isHidden=true
            //            self.shakeView.isHidden=true
            //
            //
            //            DataManager.comeFromTag=3
            //            imgChangeCard.image = UIImage(named: "NewPhoneRotate")
            //            self.fromLikeDisLike=false
            //            self.AllUserDataArray.removeAll()
            //            self.getAnonymousUser(page: 0)
            //            self.tableAllUser.scrollToTop(animated: false)
        }
    }
    
    
    func reload(tableView: UITableView)
    {
        
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
        
    }
    
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
//MARK: - Ads setup

extension AnonymousListVC:GADBannerViewDelegate
{
    func adsSetup()
    {
        
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
