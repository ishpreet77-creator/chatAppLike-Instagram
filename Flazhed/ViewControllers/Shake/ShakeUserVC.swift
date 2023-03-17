//
//  ShakeUserVC.swift
//  Flazhed
//
//  Created by ios2 on 20/04/22.
//

import UIKit

class ShakeUserVC: BaseVC {
    
    //MARK: - All Outlet
    
    @IBOutlet weak var lblShakeDetailText: UILabel!
    @IBOutlet weak var lblShakePhoneText: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewtableBack: UIView!
    @IBOutlet weak var viewUserList: UIView!
    @IBOutlet weak var viewShakeGif: UIView!
    @IBOutlet weak var imgShake: UIImageView!
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
    var isRegetEnable = false
    var other_user_id = ""
    var voiceUrl = ""
    var regretPaymentChecked=false
    var scrollDown=false
    var isPagination=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTable()
        DataManager.isProfileCompelete = true
        DataManager.isPrefrenceSet = true
         DataManager.isEditProfile = true
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
        
         if DataManager.comeFromTag==4
        {
    
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
        else
        {
            if Connectivity.isConnectedToInternet {
                
                self.getShakeSentUser(page: self.page)
                
            }
            else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        
        
        
    }
    //MARK: - Setup UI method
    func setUpUI()
    {
        
        self.lblShakePhoneText.text = kShakeYourPhone
        self.lblShakeDetailText.text = kShakeSubtext
        
    }
    
    //MARK: - BottomBtnAct
    
    @IBAction func BottomBtnAct(_ sender: UIButton)
    {
        self.stopVoice()
        //MARK: - Regret act
        let index = sender.tag
        
        if index == 0
        {
            var data = JSONDictionary()
            
            data[ApiKey.kTimezone] = TIMEZONE
            data[ApiKey.kRegret_type] = kShake
            
            if Connectivity.isConnectedToInternet {
                
                self.callApiForToGetRegretUser(data: data)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        //MARK: - Dislike user action
        else if index == 1
        {

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
                
                self.getShakeSentUser(page: self.page)
            }
            else
            {
                self.tableView.reloadData()
            }
            self.regretView.isHidden=false
            
            
            
            // let mode = self.currentUserDetails?.second_table_like_dislike?.by_like_mode ?? ""
            
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kShake, type: kShake,showIndicator: false)
          
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
                
                self.getShakeSentUser(page: 0)
            }
            else
            {
                self.tableView.reloadData()
            }
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: kShake, type: kShake,showIndicator: false)
            
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

extension ShakeUserVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
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
        
        cell.reloadCollection(userDetails: currentUserDetails, isAnoModeOn: false, VC: self)
        
        
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
// MARK: - Scroll method
extension ShakeUserVC
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
                    
                    if (self.AllUserDataArray.count>index)
                    {
                        self.AllUserDataArray.remove(at: index)
                    }
                    
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
                    debugPrint("AllUserDataArray count 1 = \(AllUserDataArray.count)")
                }
            }
            if ((self.tableView.contentOffset.y + self.tableView.frame.size.height) >= self.tableView.contentSize.height-50)
            {
                if self.AllUserDataArray.count<HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    self.isPagination=true
                    self.getShakeSentUser(page: self.page)
                }
                else if self.AllUserDataArray.count >= HomeVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    self.AllUserDataArray.removeAll()
                    self.isPagination=true
                    self.getShakeSentUser(page: 0)
                    self.tableView.scrollToTop(animated: false)
                    
                }
            }
        }
    }
}

// MARK: - Api Calls
extension ShakeUserVC
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
            
            
            self.callApiForGetShakeSentUser(data: data,page:page)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetShakeSentUser(data:JSONDictionary,page:Int = 0)
    {
        self.showLoader()
        
            if  page == 0
            {
                self.AllUserDataArray.removeAll()
            }

        HomeVM.shared.callApiGetShakeUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                
                for dict in HomeVM.shared.ShakeUserDataArray
                {
                    
                    self.AllUserDataArray.append(dict)
                    
                }
                
                if self.AllUserDataArray.count>0
                {
                    self.viewBottom.isHidden=false
                    self.viewUserList.isHidden=false
                    self.viewShakeGif.isHidden=true
                    
                }
                else
                {
                    self.imgShake.loadingGif(gifName: "shake")
                    self.viewBottom.isHidden=true
                    self.viewUserList.isHidden=true
                    self.viewShakeGif.isHidden=false
                }
                self.currentUserDetails?.user_id = nil
                
                self.tableView.reloadData()
                
                self.hideLoader()
            }
            
            
        })
    }
  
    //MARK: - Get regret user api
    
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
                
                self.getShakeSentUser(page: 0)
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
                else{
                    self.getShakeSentUser(page: 0)
                }
            }
            
            
        })
    }
    //MARK: - RemoveStoryHangoutAPI
    
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
    //MARK: - callApiForRemoveStoryHangout
    func callApiForRemoveStoryHangout(data:JSONDictionary,showIndicator:Bool)
    {
        HomeVM.shared.callApiForRemoveStoryHangout(showIndiacter: showIndicator, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
              
                self.isRegetEnable=true
            }
        }
        )
        
    }

}
//MARK: - Custom function

extension ShakeUserVC:UIGestureRecognizerDelegate
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
    func stopVoice()
    {
        MusicPlayer.instance.pause()
        self.btnHearVoice.isSelected=false
        self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
    }
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.tableView,self.viewBottom])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.tableView,self.viewBottom])
    }
    
}


extension ShakeUserVC:DiscardDelegate
{
    
    func ClickNameAction(name: String)
    {
        if name.equalsIgnoreCase(string: kCancel)
        {
            self.AllUserDataArray.removeAll()
            self.getShakeSentUser(page: 0)
        }
        else
        {
            self.goToAnonymous()
        }
    }
    
}
