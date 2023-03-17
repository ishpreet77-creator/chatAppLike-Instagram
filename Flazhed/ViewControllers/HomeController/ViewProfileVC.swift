//
//  ViewProfileVC.swift
//  Flazhed
//
//  Created by IOS32 on 01/02/21.
//

import UIKit
import AVKit
import SDWebImage

class ViewProfileVC:BaseVC
{
    //MARK: - All outlets
    
    @IBOutlet weak var viewUserDetals: UIView!
    @IBOutlet weak var stackBottom: UIStackView!
    @IBOutlet weak var collectionFacebookPost: UICollectionView!
    @IBOutlet weak var lblFacebookPost: UILabel!
    @IBOutlet weak var viewFacebook: UIView!
    @IBOutlet weak var btnVoicePlay: UIButton!
    @IBOutlet weak var imgNewVoice: UIImageView!
    @IBOutlet weak var imgNewDislike: UIImageView!
    @IBOutlet weak var viewUserCollectionBack: UIView!
    @IBOutlet weak var companyButtomConst: NSLayoutConstraint!
    @IBOutlet weak var companyTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var instaTopConst: NSLayoutConstraint!
    @IBOutlet weak var instaPostHeightConst: NSLayoutConstraint!
    @IBOutlet weak var viewLike2: UIView!
    @IBOutlet weak var viewVoice: UIView!
    @IBOutlet weak var viewDislike: UIView!

    @IBOutlet weak var viewButtom: UIView!
    @IBOutlet weak var scrollDetails: UIScrollView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var userDetailsView: UIView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var PostView: UIView!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var PostCollection: UICollectionView!
    @IBOutlet weak var instaCollection: UICollectionView!
    @IBOutlet weak var attributeCollectionView: UICollectionView!
    @IBOutlet weak var usersCollection: UICollectionView!
    @IBOutlet weak var attributeCollHeightConst: NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var postTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblAge: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var detailsButtomConst: NSLayoutConstraint!
    @IBOutlet weak var viewImageCount: UIView!
    @IBOutlet weak var lblDetailsUserName: UILabel!
    @IBOutlet weak var lblDetailsDesignation: UILabel!
    @IBOutlet weak var lblDetailLocation: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var txtBio: UILabel!
  
    @IBOutlet weak var lblUserPost: UILabel!
    @IBOutlet weak var lblPostsText: UILabel!
    @IBOutlet weak var lblInstaPost: UILabel!
    @IBOutlet weak var imgJob: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgCardJob: UIImageView!
    @IBOutlet weak var imgCardLocation: UIImageView!
    @IBOutlet weak var imgNewLike: UIImageView!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnDisLike: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var viewlikeMode: UIView!
    @IBOutlet weak var lblLikeMode: UILabel!
    @IBOutlet weak var imgLikeMode: UIImageView!
    @IBOutlet weak var topView: UIView!
    //MARK: - All Variable
    let columnLayout = CustomViewFlowLayout()
    
    var swipeLeftRight = UISwipeGestureRecognizer()
    
    var audioPlayer : AVAudioPlayer?
    var voiceUrl = ""
    var postCollectionCell:PostCCell?
    var islikeApiCall = false
    var currentPage = ""
    var attributeCount = 0.0
    var singleShakeUserData = JSONDictionary()
    var userImageData:[ImageDataModel] = []
    var postImageData:[PostdetailModel] = []
    var view_user_id = "601a3769db19430c7ea84786"
    var other_user_id = ""
    var other_user_image = ""
    var is_liked_by_other_user_id = 0
    var toShow = ""
    var toShowAno = ""
    var other_User_id = ""
    var comeFrom = ""
    var childImage = ""
    var fromPlay=false
    var UserData:UserListModel?
    var attributeDict = NSMutableDictionary()
    
    var likeMode = ""
    var story_id = ""
    var hangout_id = ""
    
    var isAnoModeOn=false
    var isPlayedVideo=false
    var totalWidth:CGFloat = 0.0
    var userData:UserListModel?
    var currentIndex  = 0
    var index = 0
    var isfromStoryListing=false
    var isfromHangoutListing=false
    var isfromHomeListing=false
    var is_match = 0
    var hangout_like_by_self = 0
    var profileName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardView.isHidden=true
        self.userDetailsView.isHidden=false
        self.setupCollection()
        self.postImageData.removeAll()
        self.attributeDict.removeAllObjects()
        
        self.fromPlay=false
        self.imgJob.isHidden=true
        self.imgLocation.isHidden=true
        self.viewButtom.isHidden=true
        self.userDetailsView.backgroundColor = UIColor.white
        //self.userDetailsView.applyGradient(colours: [.white,.white,.black])
        
        let height = (SCREENHEIGHT*65)/100
        
        self.imgHeightConst.constant = height
       // self.setUI()
        APPDEL.timerBudgeCount?.invalidate()
  
        NotificationCenter.default.addObserver(self, selector: #selector(self.profileAudioStopedReceivedNotification(notification:)), name: Notification.Name("profileAudioStoped"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.attributeCount=0.0

        self.tabBarController?.tabBar.isHidden = true
        if fromPlay==false
        {
            if view_user_id != ""
            {
                if DataManager.comeFrom != kViewProfile
                {
                    self.showLoader()
                    self.getUserDetails()
                }
                else
                {
                    DataManager.comeFrom = kEmptyString
                }
                
            }
        }
        self.navigationController?.navigationBar.isHidden=true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.stopVoice()
    }
    
    
    func setUI()
    {
        self.btnLike.tag = 1
        
        /*
        self.btnLike.normalColor = UIColor.black
        self.btnLike.selectedColor = UIColor.red
        self.btnLike.setImage(UIImage(named: "NewLike"), for: .selected)
      //  self.btnLike.setImage(UIImage(named: "BlackLike2"), for: .normal)
        self.btnLike.setSelected(selected: false, animated: false)
        self.btnLike.delegate=self
        
        self.btnDisLike.tag = 2
        self.btnDisLike.normalColor = UIColor.red
        self.btnDisLike.selectedColor = UIColor.red
        self.btnDisLike.setImage(UIImage(named: "crosss"), for: .selected)
       // self.btnDisLike.setImage(UIImage(named: "crosss"), for: .normal)
        self.btnDisLike.setSelected(selected: true, animated: false)
        self.btnDisLike.delegate=self
        self.btnDisLike.setSelected(selected: false, animated: false)
        
        */
        
       // topView.borderWidth=0.2
        topView.borderColor=HOMESADOWCOLOR
        self.topView.addBottomShadow()
    }
    
    @IBAction func backAct(_ sender: UIButton)
    {
        
        if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
        {
    
            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

            vc.selectedIndex=2
            //DataManager.comeFromTag=100
            DataManager.comeFromTag=5
            DataManager.HomeRefresh=true
            //DataManager.HomeRefresh=false
            self.navigationController?.pushViewController(vc, animated: true)

          //  self.navigationController?.popViewController(animated: false)
        }
        else
        {
            if self.islikeApiCall==false{
                DataManager.comeFrom=kViewProfile
                DataManager.HomeRefresh = false
            }
            if self.islikeApiCall
            {
                DataManager.HomeRefresh=true
            }
            else if self.comeFrom.equalsIgnoreCase(string: kBaseVC)
            {
                DataManager.comeFromTag=5
                DataManager.HomeRefresh=true
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    //MARK: - Bottom Five (Like , dislike...) Act
    
    //MARK: - Regret swipe action
    
    @IBAction func shareAct(_ sender: UIButton)
    {
       
        let destVC = RegretPopUpVC.instantiate(fromAppStoryboard: .Account)
        destVC.type = .Regret
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
    //MARK: - Hear voice action
    
    @IBAction func soundPlayAct(_ sender: UIButton)
    {
        debugPrint("Voice url \(self.voiceUrl)")
        if  self.voiceUrl != ""
        {
            //self.voiceUrl = self.voiceUrl
           
            MusicPlayer.instance.initPlayer(url:self.voiceUrl, tag: 10)
    
            if self.btnVoicePlay.isSelected
            {
                self.btnVoicePlay.isSelected=false
                MusicPlayer.instance.pause()
                self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
            }
            else
            {
                self.lightUp(imageName: self.imgNewVoice)
                self.btnVoicePlay.isSelected=true
                MusicPlayer.instance.play()
                
            }
            
        }
        
        
    }
//MARK: - Dislike user action
    
    @IBAction func DisLikeAct(_ sender: UIButton)
    {
        if self.imgNewDislike.image == UIImage(named: "NewImgDislikeFill")
        {
            self.imgNewDislike.image = UIImage(named: "NewDislikeImg")
        }
        else
        {
            self.imgNewDislike.image = UIImage(named: "NewImgDislikeFill")
            
        }
       
        self.stopVoice()
       // self.lightUp(imageName: self.imgNewDislike)
        if self.isfromStoryListing
        {

            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kStory, type: kStory,story_id: self.story_id)
        }
        else
        {
                            if likeMode == "" ||  likeMode == nil
                            {
                                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous)
                            }
                            else
                            {
                                if self.isfromHangoutListing
                                {
                                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous)
                                }
                                else
                                {
                                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: likeMode, type: likeMode)
                                }
                                
                            }
        }
 
    }
    
//MARK: - - Like user action
    
    @IBAction func LikeAct(_ sender: UIButton)
    {
       
        if self.imgNewLike.image == UIImage(named: "NewLikeImg")
        {
            self.imgNewLike.image = UIImage(named: "NewLikeImgNotFill")
        }
        else
        {
            self.imgNewLike.image = UIImage(named: "NewLikeImg")
        }
   
      
        self.stopVoice()
       // self.lightUp(imageName: self.imgNewLike)
    
        if self.isfromStoryListing
        {
            let likeSelfId = self.userData?.is_liked_by_self_user ?? 0
                
            let valueLike = String(likeSelfId + 1)
           // let id = self.userData?.second_table_like_dislike?._id ?? ""
            
            
           
          //  self.StoryLikeUnlikeAPI(other_user_id: self.story_id, action: valueLike, like_mode: kStory, type: kStory)
            
            
           // let storyId = modelHangout?.post_details?._id ?? "0"
            
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: kStory, type: kStory,story_id: self.story_id,from_story_only: "1")
        }
        else
        {
          
            let likeSelfId = self.userData?.is_liked_by_self_user ?? 0
                
            let valueLike = String(likeSelfId + 1)
            if likeMode == "" ||  likeMode == nil
            {
    
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: kAnonymous, type: kAnonymous)
            }
            else
            {
                if self.isfromHangoutListing
                {
                    
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: kAnonymous, type: kAnonymous)
                }
                else
                {
                  
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: likeMode, type: likeMode)
                }
               
            }
        }
        
    
      
    }
    
    // }
    
    
    
    //MARK: - Message Button action

    @IBAction func messageBtnAct (_ sender:UIButton)
    {
        
         
           let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)

           let cellData = self.userData
                       
        vc.chat_room_id=cellData?.chat_room_details?._id ?? ""
        
            // let mode = cellData?.second_table_like_dislike?.by_like_mode ?? ""
        
        
//        if (cellData?.is_liked_by_self_user == 1 && cellData?.is_liked_by_other_user_id == 1)
//        {
//            vc.comfrom=kViewProfile
//            vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
//           // vc.profileImage=self.user2Image
//            vc.view_user_id=cellData?.user_id ?? ""
//
//        }
//        else
        
        if ((self.isfromStoryListing) && (self.is_match == 1))//kStory.equalsIgnoreCase(string: mode)
            {
                
                
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kStory
                let postType = cellData?.Single_Story_Details?.file_type ?? ""
                
                if  kVideo.equalsIgnoreCase(string: postType)
                {
                vc.commentImage=cellData?.Single_Story_Details?.thumbnail ?? ""
                }
                else
              {
                vc.commentImage=cellData?.Single_Story_Details?.file_name ?? ""
              }
                vc.commentTitle=cellData?.Single_Story_Details?.post_text ?? ""
                
                vc.commentPostId=cellData?.Single_Story_Details?._id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            }
        else if (hangout_like_by_self == 1) && (self.is_match == 1)//kHangout.equalsIgnoreCase(string: mode) //((self.isfromHangoutListing) && (self.is_match == 1))//
            {
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kHangout
                vc.commentTitle=cellData?.Single_Hangout_Details?.heading ?? ""
                vc.commentImage=cellData?.Single_Hangout_Details?.image ?? ""
                vc.commentPostId=cellData?.Single_Hangout_Details?._id ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        else if (hangout_like_by_self == 1) && (self.is_match == 0)//kHangout.equalsIgnoreCase(string: mode) //((self.isfromHangoutListing) && (self.is_match == 1))//
            {
                vc.view_user_id=cellData?.user_id ?? ""
                vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
                vc.comfrom=kHangout
                vc.commentTitle=cellData?.Single_Hangout_Details?.heading ?? ""
                vc.commentImage=cellData?.Single_Hangout_Details?.image ?? ""
                vc.commentPostId=cellData?.Single_Hangout_Details?._id ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        else if (self.is_match == 1)
        {
            
            vc.view_user_id=cellData?.user_id ?? ""
            vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func theeDotAct(_ sender: UIButton) {
        
        let destVC = StoryMenuPopUpVC.instantiate(fromAppStoryboard: .Stories)
        destVC.type = .ViewProfile
        destVC.comeFromScreen = .ViewProfile
        destVC.view_user_id=self.view_user_id
        destVC.from_user_id=DataManager.Id
        destVC.user_name=self.profileName.capitalized
        //destVC.chat_room_id=self.chat_room_id
       // destVC.is_hangout_strory=self.is_hangout_strory
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
    
    func showLoader()
    {

        Indicator.sharedInstance.showIndicator3(views: [self.collectionFacebookPost,self.instaCollection,self.usersCollection,self.attributeCollectionView])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.collectionFacebookPost,self.instaCollection,self.usersCollection,self.attributeCollectionView])

    }
    
    @objc func profileAudioStopedReceivedNotification(notification: Notification)
    {
        debugPrint(" view Profile vc")
        self.stopVoice()
    }
    
    
    func stopVoice()
   {
       MusicPlayer.instance.pause()
       self.btnVoicePlay.isSelected=false
       self.imgNewVoice.image = UIImage(named: "NewVoicePlay")
   }
    
}
//MARK: - Collection view setup and show post,attribute data

extension ViewProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
        self.PostCollection.delegate=self
        self.PostCollection.dataSource=self
        self.usersCollection.register(UINib(nibName: "HomeCardCCell", bundle: nil), forCellWithReuseIdentifier: "HomeCardCCell")
        self.PostCollection.register(UINib(nibName: "PostCCell", bundle: nil), forCellWithReuseIdentifier: "PostCCell")
        self.usersCollection.delegate=self
        self.usersCollection.dataSource=self
     
        
        
        self.instaCollection.delegate=self
        self.instaCollection.dataSource=self
        self.instaCollection.register(UINib(nibName: "PostCCell", bundle: nil), forCellWithReuseIdentifier: "PostCCell")
        attributeCollectionView.collectionViewLayout = columnLayout
        attributeCollectionView.contentInsetAdjustmentBehavior = .always
        
        self.attributeCollectionView.register(UINib(nibName: "ProfileAttributeCCell", bundle: nil), forCellWithReuseIdentifier: "ProfileAttributeCCell")
        self.attributeCollectionView.delegate=self
        self.attributeCollectionView.dataSource=self
        
        
        self.collectionFacebookPost.delegate=self
        self.collectionFacebookPost.dataSource=self
        self.collectionFacebookPost.register(UINib(nibName: "PostCCell", bundle: nil), forCellWithReuseIdentifier: "PostCCell")
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if (collectionView == self.usersCollection)
        {
            if (self.userImageData.count>1)
            {
                return self.userImageData.count+1
            }
            else
            {
                return self.userImageData.count
            }
            
        }
        else if collectionView == self.PostCollection
        {
            return self.UserData?.arrAllPostCollection.count ?? 0//self.postImageData.count
        }
        else if collectionView == self.attributeCollectionView
        {
            return self.UserData?.more_profile_details?.arrCollection.count ?? 0
            
        }
        
        else if collectionView == self.collectionFacebookPost
        {
            return self.UserData?.facebook_Profile_data?.images?.count ?? 0
            
        }
        
        else
        {
        let count = self.UserData?.Insta_data?.images?.count ?? 0
            if count>10
            {
                return 10
            }
            else
            {
                return count
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.PostCollection
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCCell", for: indexPath) as! PostCCell
            
            cell.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let model = self.UserData?.arrAllPostCollection[indexPath.row]
            // case story
            //case hangout
            
            if model?.type == .story{
                
                cell.lblPostType.text = "STORY"
                if kVideo.equalsIgnoreCase(string:  model?.PostData?.file_type ?? "")
                {
                    cell.btnPlay.isHidden=false
                    if let img = model?.PostData?.thumbnail
                    {
                        cell.img.setImage(imageName: img, isStory: true)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    }
                }
                else
                {
                    cell.btnPlay.isHidden=true
                    
                    if let img = model?.PostData?.file_name
                    {
    
                        cell.img.setImage(imageName: img, isStory: true)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    }
                }
                
                cell.tagView.isHidden=false
                cell.btnPlay.tag=indexPath.row
                cell.btnPlay.isUserInteractionEnabled=false
                 cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
                
                
            }
            else
            {
                if model?.type == .hangout{
                    cell.btnPlay.isHidden=true
                    cell.tagView.isHidden=false
                    cell.lblPostType.text = "HANGOUT"
                    if let img = model?.hangoutData?.image
                    {
    
                        cell.img.setImage(imageName: img, isHangout: true)
                    }
                }
            }
            self.postCollectionCell=cell
            
            return cell
        }
        else if collectionView == self.attributeCollectionView
        {
            
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAttributeCCell", for: indexPath) as! ProfileAttributeCCell
            let model = self.UserData?.more_profile_details?.arrCollection[indexPath.row]
            
            if model?.type == .education
            {
                cell.imgIcon.image = UIImage(named: "Graduate")
                // cell.lblTitle.text = model?.education_selected?.education_name
                // cell.lblTitle.text = cell.lblTitle.text?.capitalized
                
                let name = model?.education_selected?.education_name ?? ""
                
                if name.capitalized == kPhD.capitalized
                {
                    cell.lblTitle.text = kPhD
                }
                else
                {
                    cell.lblTitle.text = name.capitalizingFirstLetter()
                    // cell.lblTitle.text = cell.lblTitle.text?.capitalized
                }
                
            }else if model?.type == .height{
                cell.imgIcon.image = UIImage(named: "scaleIcon")
                
                let unit = DataManager.currentUnit//self.UserData?.unit_settings?.unit ?? ""
                if let height  = model?.height
                {
                    if  unit.equalsIgnoreCase(string: kFeet)
                    {
                        cell.lblTitle.text = self.showFootAndInchesFromCm(Double(height))
                    }
                    else
                    {
                        cell.lblTitle.text = "\(height)"+" cm"
                    }
                }
                
            }else if model?.type == .hairColor{
                cell.imgIcon.image = UIImage(named: "faceIcon")
                cell.lblTitle.text = model?.hair_selected?.hair_name
                cell.lblTitle.text = cell.lblTitle.text?.capitalized
            }else{
                
                if let img = model?.children_selected?.image
                {
                    let str = IMAGE_BASE_URL+img
                    let url = URL(string: str)!
                    
                    cell.imgIcon.sd_setImage(with: url, placeholderImage: UIImage(named: "toddlerIcon"), options: .refreshCached) { (img, error, type, url) in
                        
                        cell.imgIcon.image = cell.imgIcon.image?.tinted(color: PURPLECOLOR)
                    }
                }
                
                cell.lblTitle.text = model?.children_selected?.children_name
                cell.lblTitle.text = cell.lblTitle.text?.capitalized
            }
            
            
      
            
            cell.imgIcon.image = cell.imgIcon.image?.tinted(color: PURPLECOLOR)
            
            return cell
        }
        else if collectionView == self.usersCollection
        {
            /*
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell
            var celldata:ImageDataModel?
    
            if (indexPath.row == 0) {
                celldata = self.userImageData.last
                
            } else if (indexPath.row == ((self.userImageData.count) + 1)) {
  
                celldata = self.userImageData.first
             } else {
                celldata = self.userImageData[indexPath.row-1]
             }
            
            if let img = celldata?.image
            {
                let url = URL(string: img)!
                cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
            }
            cell.viewBlur.isHidden=true
            cell.viewBlur.alpha = BLUR_ALPHA
            
            if self.isAnoModeOn
            {
                cell.viewBlur.isHidden=false
                
            }
            else
            {
                cell.viewBlur.isHidden=true
            }
            
            return cell
            
            
          */
            
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell
            var celldata:ImageDataModel?
            if self.userImageData.count>(indexPath.row) //&& indexPath.row != 0
            {
                    celldata = self.userImageData[indexPath.row]
            }
    
            
            if let img = celldata?.image
            {
                cell.userImage.setImage(imageName: img)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil) //refreshCached //UIImage(named: "placeholderImage")
    
            }
            cell.viewBlur.isHidden=true
            cell.viewBlur.alpha = BLUR_ALPHA
            
            if self.isAnoModeOn
            {
                cell.viewBlur.isHidden=false
                
            }
            else
            {
                cell.viewBlur.isHidden=true
            }
            
            return cell
        
        }
        
        else if collectionView == self.collectionFacebookPost
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCCell", for: indexPath) as! PostCCell
            cell.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let cellData = self.UserData?.facebook_Profile_data?.images?[indexPath.row]
            cell.tagView.isHidden=true
            cell.btnPlay.isHidden=true
            if let str = cellData
            {
                //let url = URL(string: str)!
                cell.img.setImage(imageName: str)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil) //refreshCached
                
            }
            
//            if cellData != ""
//            {
//                let str = IMAGE_BASE_URL+cellData
//
//                let url = URL(string: str)
//                if cellData.contains("postTypeVideo")
//                {
//                    cell.btnPlay.isHidden=false
//                    cell.img.getThumbnailImageFromVideoUrl(url: url!) { image in
//                        cell.img.image  = image
//                    }
//
//                    cell.lblPostType.text = "VIDEO"
//                }
//                else
//                {
//                    cell.btnPlay.isHidden=true
//                    cell.img.setImage(imageName: cellData, isStory: true)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
//                    cell.lblPostType.text = "IMAGE"
//                }
//
//
//
//            }
          
         //   cell.btnPlay.isUserInteractionEnabled=true
             //cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
            
           
            return cell
        }
        else
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCCell", for: indexPath) as! PostCCell
            cell.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let cellData = self.UserData?.Insta_data?.images?[indexPath.row] ?? ""
            cell.tagView.isHidden=true
            cell.btnPlay.isHidden=true
            if cellData != ""
            {
                cell.img.setImage(imageName: cellData)
            }
            
            /*
            if cellData != ""
            {
                let str = cellData //IMAGE_BASE_URL+
                
                let url = URL(string: str)
                if cellData.contains("postTypeVideo")
                {
                    cell.btnPlay.isHidden=false
                    cell.img.getThumbnailImageFromVideoUrl(url: url!) { image in
                        cell.img.image  = image
                    }
                
                    cell.lblPostType.text = "VIDEO"
                }
                else
                {
                    cell.btnPlay.isHidden=true
                    cell.img.setImage(imageName: cellData, isStory: true)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    cell.lblPostType.text = "IMAGE"
                }
               
                
               
            }
            */
           // cell.btnPlay.tag=indexPath.row
            //cell.btnPlay.isUserInteractionEnabled=true
            // cell.btnPlay.addTarget(self, action: #selector(playAct), for: .touchUpInside)
            
           
            return cell
        }
        
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.usersCollection
        {
            let size = collectionView.frame.size
            return CGSize(width:size.width , height: size.height)//CGSize(width: SCREENWIDTH, height: usersCollection.frame.height+30)
        }
        else if collectionView == self.attributeCollectionView
        {
            
            let model = self.UserData?.more_profile_details?.arrCollection[indexPath.row]
            
            if model?.type == .education
            {
                let name = model?.education_selected?.education_name ?? ""
                let label = UILabel(frame: CGRect.zero)
                label.text = name
                label.sizeToFit()
                let width = label.frame.width+38+8
               // self.totalWidth = self.totalWidth+width
                return CGSize(width: width, height: 46)
            }
            else if model?.type == .height{
                let name = model?.height ?? 123
                let label = UILabel(frame: CGRect.zero)
                label.text = "\(name)"+" cm"
                
                label.sizeToFit()
                let width = label.frame.width+38+8
              //  self.totalWidth = self.totalWidth+width
                return CGSize(width: width, height: 46)
                
             
            }
            else if model?.type == .hairColor{
                let name = model?.hair_selected?.hair_name ?? ""
                let label = UILabel(frame: CGRect.zero)
                label.text = name
                label.sizeToFit()
             
                
                let width = label.frame.width+38+16
               // self.totalWidth = self.totalWidth+width
                return CGSize(width: width, height: 46)
                
            }
            else if model?.type == .children {
                let name = model?.children_selected?.children_name ?? ""
                let label = UILabel(frame: CGRect.zero)
                label.text = name
                label.sizeToFit()
                let width = label.frame.width+38+16
               // self.totalWidth = self.totalWidth+width
                return CGSize(width: width, height: 46)
                
            }
            else
            {
                return CGSize(width: ((self.attributeCollectionView.frame.width/2)-4), height: 46)
            }
            
            
            
        }
        else
        {
            return CGSize(width: 110, height: 150)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == usersCollection
        {
            
            self.cardView.isHidden=false
            
            self.userDetailsView.isHidden=false
        }
        else  if collectionView == self.PostCollection
        {
            let model = self.UserData?.arrAllPostCollection[indexPath.row]
            
            if model?.type == .story
            {
                
                
                if Connectivity.isConnectedToInternet {
                    let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ViewStoryVC") as!  ViewStoryVC
                    // vc.comefrom = kViewProfile
                    //vc.cellData=self.other_user_image
                    vc.StoryId=model?.PostData?._id ?? ""
                    
                   // vc.cellData = model?.PostData
                    self.navigationController?.pushViewController(vc, animated: true)
                      } else {
                          
                          self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                      }
                
             
            }
            else
            {
                if Connectivity.isConnectedToInternet {
                    let vc = hangoutDetailsVC.instantiate(fromAppStoryboard: .Hangouts)

                    vc.appdel=kViewProfile
                    vc.hangoutId=model?.hangoutData?._id ?? ""
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                      } else {
                          
                          self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                      }
                
                
                
            }
        }
        
        else if collectionView == collectionFacebookPost
        {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewImagesVC") as!  ViewImagesVC
    
           let cellData = self.UserData?.facebook_Profile_data?.images ?? []
            vc.imagesArray = cellData
            vc.pageTitle=kFacebookPhotos
            vc.imageIndex = indexPath.row
            self.navigationController?.pushViewController(vc, animated: false)
           
        }
        else if collectionView == instaCollection
        {
                    
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewImagesVC") as!  ViewImagesVC
    
           let cellData =  self.UserData?.Insta_data?.images ?? []
            vc.imagesArray = cellData
            vc.pageTitle=kInstagramPhotos
            vc.imageIndex = indexPath.row
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.usersCollection || collectionView == self.attributeCollectionView
        {
            return 0
        }
        else
        {
            return 16
        }
        
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.usersCollection || collectionView == self.attributeCollectionView
        {
            return 0
        }
        else
        {
            return 16
        }
    }
    
    
    /*
    
    func scrollViewDidEndDecelerating (_ scrollview:UIScrollView) {
  
        if scrollview == self.usersCollection
        {
        let count = self.userImageData.count
            
        
                if count>1
                {
                    self.lblImageCount.isHidden=false
                  
                }
                else
                {
                    self.lblImageCount.isHidden=true
                }
        if (scrollview.contentOffset.x == 0)
    {
            scrollview.contentOffset = CGPoint(x:CGFloat(count) * UIScreen.main.bounds.width, y:0)
            debugPrint("Page1 = \(1)")
            self.index = 1

    } else if
        (scrollview.contentOffset.x == CGFloat (count + 1) * UIScreen.main.bounds.width) {
     scrollview.contentOffset=CGPoint(x:UIScreen.main.bounds.width, y:0)
        
       let page = Int(scrollview.contentOffset.x/UIScreen.main.bounds.width)
        debugPrint("Page2 = \(page)")
        self.index = page

    } else {
    let index = Int(scrollview.contentOffset.x/UIScreen.main.bounds.width)-1
        debugPrint("Page3 = \(index)")
        self.index = index+1
    }
           // var counterlabel = "\(self.index)/\(count)"
           // self.lblImageCount.text = counterlabel
            
            for cell in self.usersCollection.visibleCells {
                let indexPath = self.usersCollection.indexPath(for: cell)
               // debugPrint(indexPath)
                var index = indexPath?.row ?? 0
                debugPrint("index =  \(index) \(count)")
                if index == 0
                {
                    index = count
                }
                else if index>count
                {
                    index = 1
                }
                var counterlabel = "\(index)/\(count)"
                self.lblImageCount.text = counterlabel
            }
            
    
        
        }
    }
    */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == usersCollection
        {
            let x = scrollView.contentOffset.x
            var index = Int(x/usersCollection.frame.width) + 1
            let total = Int(usersCollection.contentSize.width/usersCollection.frame.width)-1
           // self.lblImageCount.text = "\(index)/\(total)"

          //  debugPrint("image index = \(index)")
            
//            if (total>1) && index > total
//            {
//                self.usersCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
//                index = 1
//            }
            
            if (total>1) && index > total
            {
                self.usersCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
                index = 1
                self.lblImageCount.text = "\(index)/\(total)"
            } else {
                self.lblImageCount.text = "\(index)/\(total)"
            }
            
            
            self.usersCollection.reloadData()
            
            //var isRightMove=false
//            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//               if translation.x > 0 {
//                   // swipes from top to bottom of screen -> down
//                debugPrint("right")
//                isRightMove=true
//               } else {
//                   // swipes from bottom to top of screen -> up
//                isRightMove=false
//                debugPrint("left")
//               }
        
          //  debugPrint("total count = \(total)")
//            if ((total>1))
//            {
//                if  (index > total+1)
//                {
//                self.usersCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
//                index = 1
//                }
//                else if index == 1 && isRightMove
//                {
//                    self.usersCollection.scrollToItem(at:IndexPath(item: 5, section: 5), at: .right, animated: false)
//                    index = total+1
//                }
//            }

         //  usersCollection.reloadData()
        }

    }
    
//    func infinateLoop(scrollView: UIScrollView) {
//        var index = Int((scrollView.contentOffset.x)/(scrollView.frame.width))
//        guard currentIndex != index else {
//            return
//        }
//        currentIndex = index
//        debugPrint("current index  = \(index)")
//
//        if index <= 0 {
//            index = self.userImageData.count - 1
//            scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width+60) * CGFloat(self.userImageData.count), y: 0), animated: false)
//        } else if index >= self.userImageData.count + 1 {
//            index = 0
//            scrollView.setContentOffset(CGPoint(x: (scrollView.frame.width), y: 0), animated: false)
//        } else {
//            index -= 1
//        }
//
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        infinateLoop(scrollView: scrollView)
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        infinateLoop(scrollView: scrollView)
//    }
    
    @objc func playAct(_ sender: UIButton)
    {
        
        let model = self.UserData?.arrAllPostCollection[sender.tag]
        
        
        
        if model?.type == .story
        {
            if Connectivity.isConnectedToInternet {
                let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewStoryVC") as!  ViewStoryVC
                vc.StoryId=model?.PostData?._id ?? ""
                //vc.cellData = model?.PostData
                self.navigationController?.pushViewController(vc, animated: true)
                   } else {
                       
                       self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                   }
            
           
        }
        else
        {
            if self.UserData?.Insta_data?.images?.count ?? 0>sender.tag
            {
                self.fromPlay=true
                let cellData = self.UserData?.Insta_data?.images?[sender.tag] ?? ""
                let videoURL = URL(string: cellData)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
           
        }
    }
    
}
extension ViewProfileVC//:FaveButtonDelegate
{
    
    
    
    func lightUp(imageName: UIImageView)
    {
        UIView.transition(with: imageName, duration: 0.30, options: .transitionCrossDissolve, animations: {
            
            if imageName == self.imgNewLike
            {
                self.imgNewLike.image = UIImage(named: "NewLikeImg")
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
                
                debugPrint("Like done")
            }
            )})
        
        
    }
    
    /*
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
        if Connectivity.isConnectedToInternet {
        
        if faveButton == self.btnLike
        {
            
            if self.isfromStoryListing
            {
                let likeSelfId = self.userData?.is_liked_by_self_user ?? 0
                    
                let valueLike = String(likeSelfId + 1)
               // let id = self.userData?.second_table_like_dislike?._id ?? ""
                
                
               
              //  self.StoryLikeUnlikeAPI(other_user_id: self.story_id, action: valueLike, like_mode: kStory, type: kStory)
                
                
               // let storyId = modelHangout?.post_details?._id ?? "0"
                
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: kStory, type: kStory,story_id: self.story_id,from_story_only: "1")
            }
            else
            {
              
                let likeSelfId = self.userData?.is_liked_by_self_user ?? 0
                    
                let valueLike = String(likeSelfId + 1)
                if likeMode == "" ||  likeMode == nil
                {
        
                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: kAnonymous, type: kAnonymous)
                }
                else
                {
                    if self.isfromHangoutListing
                    {
                        
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: kAnonymous, type: kAnonymous)
                    }
                    else
                    {
                      
                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: valueLike, like_mode: likeMode, type: likeMode)
                    }
                   
                }
            }
        }
        else
        {
//            let mode =  self.userData?.second_table_like_dislike?.by_like_mode ?? ""
//
//            if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
//            {
//                let id = self.userData?.second_table_like_dislike?._id ?? ""
//
//                self.RemoveStoryHangoutAPI(listId: id)
//            }
//            else
//            {
//                if likeMode == "" ||  likeMode == nil
//                {
//                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous)
//                }
//                else
//                {
//                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: likeMode, type: likeMode)
//                }
//            }
//
            
            
            if self.isfromStoryListing
            {
               // let id = self.userData?.second_table_like_dislike?._id ?? ""
                //
               // self.RemoveStoryHangoutAPI(listId: id)
//                let likeSelfId = self.userData?.story_like_by_self ?? 0
//
//                let valueLike = String(likeSelfId + 1)
//                self.StoryLikeUnlikeAPI(other_user_id: self.story_id, action: "2", like_mode: kStory, type: kStory)
                
                
              //  let likeSelfId = self.userData?.story_like_by_self ?? 0
                    
              //  let valueLike = String(likeSelfId + 1)
                //let id = self.userData?.second_table_like_dislike?._id ?? ""
                
              //  self.StoryLikeUnlikeAPI(other_user_id: self.story_id, action: valueLike, like_mode: kStory, type: kStory)
                
                
               // let storyId = modelHangout?.post_details?._id ?? "0"
                
                self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kStory, type: kStory,story_id: self.story_id)
            }
            else
            {
                                if likeMode == "" ||  likeMode == nil
                                {
                                    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous)
                                }
                                else
                                {
                                    if self.isfromHangoutListing
                                    {
                                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: kAnonymous, type: kAnonymous)
                                    }
                                    else
                                    {
                                        self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: likeMode, type: likeMode)
                                    }
                                    
                                }
            }
                   
        }
    } else {
        /*
        self.btnLike.setImage(UIImage(named: "NewLike"), for: .selected)
        self.btnLike.setSelected(selected: false, animated: false)
        */
              self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        
        
          }
    }
    */
    
    
    
}

//MARK: - get user data api

extension ViewProfileVC
{
    
    func getUserDetails()
    {
        if Connectivity.isConnectedToInternet {
            var data = JSONDictionary()
            
            data[ApiKey.kStoryId] = self.story_id
            data[ApiKey.kHangout_Id] = self.hangout_id
            data[ApiKey.kUser_id] = self.view_user_id
            data[ApiKey.kTimezone] = TIMEZONE
            
            self.showLoader()
            self.callApiForGetUserDetails(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetUserDetails(data:JSONDictionary)
    {
        HomeVM.shared.callApiGetUserDetails(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                self.totalWidth = 0.0
               // self.viewRegrate.isHidden=true
                if let UserData = HomeVM.shared.viewProfileUserDetail
                {
                    self.userData=UserData

                    //var name  = ""
                    
                    self.imgJob.isHidden=false
                    self.imgLocation.isHidden=false
                    self.viewButtom.isHidden=false
                   
                    if let ProfileData = UserData.profile_data
                    {
                        if let username = ProfileData.username
                        {
                            self.profileName = username.capitalized
                            
                            self.lblPostsText.isHidden=false
                            self.lblUserPost.isHidden=false
                            self.lblInstaPost.isHidden=false
                            self.lblUserPost.text = username //+ "'s Posts"
                            self.lblPostsText.text = "'s Posts"
                            self.lblInstaPost.text = username + "'s Instagram Photos"
                        }
                        
                        if let gender = ProfileData.gender
                        {
                            self.lblLocation.text = gender
                        }
                        if let  image = ProfileData.images
                        {
                            self.userImageData = image //.append(image)
                            
                        }
                        if self.userImageData.count>0
                        {
                            if let img = self.userImageData[0].image
                            {
                                self.other_user_image=img
                            }
                            
                        }
                        self.voiceUrl = ProfileData.voice ?? ""
                        
                        
//                        if self.userImageData.count > 1
//                        {
//                            self.usersCollection.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: false)
//
//                        }
                        self.usersCollection.reloadData()
                      
                        
                    }
                    
                    let array = UserData.facebook_Profile_data?.images ?? []
                    if array.count>0
                    {
                        //self.constFacebookImage.constant = 150
                        let user = UserData.profile_data?.username ?? kEmptyString
                        
                        self.lblFacebookPost.text = "\(user) 's Facebook Photos"
                        //self.lblConnectFacebook.text = "FACEBOOK"
                        self.detailsButtomConst.constant = 380
                    }
                    else
                    {
                       // self.constFacebookImage.constant = 0
                        self.lblFacebookPost.text = kEmptyString
                       // self.lblConnectFacebook.text = "CONNECT FACEBOOK"
                        self.detailsButtomConst.constant = 80
                    }
                    self.collectionFacebookPost.reloadData()
                    
                    if let  image = UserData.post_details
                    {
                        self.postImageData = image //.append(image)
                        
                    }
                    self.PostCollection.reloadData()
                    
                    if UserData.arrAllPostCollection.count>0 //self.postImageData.count>0
                    {
                        self.scrollDetails.isScrollEnabled=true
                        self.lblUserPost.isHidden=false
                        self.lblPostsText.isHidden=false
                    }
                    else
                    {
                        self.scrollDetails.isScrollEnabled=true
                        self.lblUserPost.isHidden=true
                        self.lblPostsText.isHidden=true
                    }
                    
                    
                    
                    self.instaCollection.isHidden = false
                    self.PostCollection.isHidden = false
                    self.other_user_id = UserData.user_id ?? ""
                    self.is_liked_by_other_user_id = UserData.is_liked_by_other_user_id ?? 0
                    
                    self.lblImageCount.text = "\("1")/\(self.userImageData.count)"
                    
                    
                    if self.userImageData.count < 2
                    {
                        self.viewImageCount.isHidden=true
                    }
                    else
                    {
                        self.viewImageCount.isHidden=false
                    }
                    if let more_profile_details = UserData.more_profile_details
                    {
                        let city = more_profile_details.city ?? kEmptyString
                        
                        if city.count>0
                        {
                            self.lblLocation.text = city
                            self.lblDetailLocation.text=city
                            self.imgLocation.isHidden=false
                            self.imgCardLocation.isHidden=false
                            
                            self.lblLocation.isHidden=false
                            self.lblDetailLocation.isHidden=false
                            //self.usrNameHeightConst.constant = 90
                        }
                        else
                        {
                            self.imgLocation.isHidden=true
                            self.imgCardLocation.isHidden=true
                            
                            self.lblLocation.isHidden=true
                            self.lblDetailLocation.isHidden=true
                            //self.usrNameHeightConst.constant = 60
                        }
                        
                        let job_title = more_profile_details.job_title ?? kEmptyString
                        
                         if job_title.count>0
                        {
                            self.lblDetailsDesignation.text=job_title
                            self.imgCardJob.isHidden=false
                            self.imgJob.isHidden=false
                            self.lblDetailsDesignation.isHidden=false
                            self.lblDesignation.isHidden=false
                        }
                        else
                        {
                            self.lblDetailsDesignation.text=""
                            self.imgCardJob.isHidden=true
                            self.imgJob.isHidden=true
                            self.lblDetailsDesignation.isHidden=true
                            self.lblDesignation.isHidden=true
                        }
                         let company_name = more_profile_details.company_name ?? kEmptyString
                        if company_name.count>0
                        {
                            self.lblCompanyName.text="@ "+company_name
                            self.lblCompanyName.isHidden=false
                            self.companyButtomConst.constant = 12
                            self.companyTopConst.constant = 12
                        }
                        else
                        {
                            self.lblCompanyName.text=""
                            self.lblCompanyName.isHidden=true
                            self.companyButtomConst.constant = 0
                            self.companyTopConst.constant = 8
                            
                        }
                           
                            
                           
                            /*
                            
                            if job !=  nil && company != nil
                            {
                                let job2 = (job ?? "")//+"\n@ "+(company ?? "")
                                
                                self.lblDesignation.text = job2
                                self.lblDetailsDesignation.text=job2
                                self.lblDetailsDesignation.addInterlineSpacing(spacingValue: 4)
                            }
                            else
                            {
                                
                                self.lblDesignation.text = job
                                self.lblDetailsDesignation.text=job
                            }
                            
                            //self.usrNameHeightConst.constant = 90
                            self.imgCardJob.isHidden=false
                            self.imgJob.isHidden=false
                            self.lblDetailsDesignation.isHidden=false
                            self.lblDesignation.isHidden=false
                        }
                        else
                        {
                            self.imgCardJob.isHidden=true
                            self.imgJob.isHidden=true
                            self.lblDetailsDesignation.isHidden=true
                            self.lblDesignation.isHidden=true
                            //  self.usrNameHeightConst.constant = 60
                        }
                        */
                      
                        
                        if let bio = more_profile_details.bio
                        {
                            self.txtBio.text=bio
                        }
                        else
                        {
                            self.txtBio.text=""
                        }
                        if let age = more_profile_details.age
                        {
                            
                            
                            self.lblAge.text =  ", " + "\(age)"
                        }
                        
                    }
                    
                    
                    self.UserData=UserData
                    
                    for i in 0..<(self.UserData?.more_profile_details?.arrCollection.count ?? 0)
                    {
                    
                    let model = self.UserData?.more_profile_details?.arrCollection[i]
                    
                    if model?.type == .education
                    {
                        let name = model?.education_selected?.education_name ?? ""
                        let label = UILabel(frame: CGRect.zero)
                        label.text = name
                        label.sizeToFit()
                        let width = label.frame.width+38+8
                        self.totalWidth = self.totalWidth+width
                      
                    }
                    else if model?.type == .height{
                        let name = model?.height ?? 123
                        let label = UILabel(frame: CGRect.zero)
                        label.text = "\(name)"+" cm"
                        
                        label.sizeToFit()
                        let width = label.frame.width+38+8
                        self.totalWidth = self.totalWidth+width
                    
                     
                    }
                    else if model?.type == .hairColor{
                        let name = model?.hair_selected?.hair_name ?? ""
                        let label = UILabel(frame: CGRect.zero)
                        label.text = name
                        label.sizeToFit()
                     
                        
                        let width = label.frame.width+38+8
                        self.totalWidth = self.totalWidth+width
                     
                        
                    }
                    else if model?.type == .children {
                        let name = model?.children_selected?.children_name ?? ""
                        let label = UILabel(frame: CGRect.zero)
                        label.text = name
                        label.sizeToFit()
                        let width = label.frame.width+38+8
                        self.totalWidth = self.totalWidth+width
                    }
                    }
                    self.totalWidth = self.totalWidth + 64 + SCREENWIDTH/2
                    
                  
                    
                    
                   // let count = Double(self.UserData?.more_profile_details?.arrCollection.count ?? 0)
                    
                    let noOfCell = ceil(self.totalWidth/SCREENWIDTH)+1//ceil(Double(count/2.0))
                    
                    debugPrint("Total width = \(noOfCell)")
                    if noOfCell==1
                    {
                        self.attributeCollHeightConst.constant = 50
                    }
                    else if noOfCell>1
                    {
                        self.attributeCollHeightConst.constant = CGFloat(50.0*noOfCell)//118
                    }
                    
                    else
                    {
                        self.attributeCollHeightConst.constant = 10
                    }
                    if let insta = UserData.Insta_data?.images
                    {
                        if insta.count>0
                        {
                            self.instaPostHeightConst.constant = 185
                            self.lblInstaPost.isHidden=false
                        }
                        else
                        {
                            self.instaPostHeightConst.constant = 0
                            self.lblInstaPost.isHidden=true
                        }
                    }
                    else
                    {
                        self.instaPostHeightConst.constant = 0
                        self.lblInstaPost.isHidden=true
                    }
                    
                    /*
                    if  let data = self.UserData?.second_table_like_dislike //UserData.is_liked_by_other_user_id == 1
                    {
                        if let mode = data.by_like_mode//let mode = UserData.like_mode_by_other_user
                        {
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            
                            self.viewRegrate.isHidden=true
                            
                            if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
                            {
                                
                            }
                            else
                            {
                                self.likeMode = mode
                            }
                        
                            
                            
                            // self.lblLikeMode.text = "  " + mode + "  "
                            if mode.equalsIgnoreCase(string: kAnonymous)
                            {
                                self.imgLikeMode.image = UIImage(named: "profile")
                                self.imgLikeMode.isHidden=true
                                
                                self.viewlikeMode.isHidden=true
                            }
                            else
                            {
                                if mode.equalsIgnoreCase(string: kHangout)
                                {
                                    self.imgLikeMode.image = UIImage(named: "smile")
                                }
                                else  if mode.equalsIgnoreCase(string: kStory)
                                {
                                    self.imgLikeMode.image = UIImage(named: "Stories")
                                }
                                else  if mode.equalsIgnoreCase(string: kShake)
                                {
                                    self.imgLikeMode.image = UIImage(named: "playing-cards")
                                }
                                else  if mode.equalsIgnoreCase(string: kProfile)
                                {
                                    self.imgLikeMode.image = UIImage(named: "profile")
                                }
                                self.imgLikeMode.isHidden=false
                                self.viewlikeMode.isHidden=false
                            }
                            self.imgLikeMode.image = self.imgLikeMode.image?.tinted(color: UIColor.white)
                            
                        }
                        else
                        {
                            if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
                            {
                                
                            }
                            else
                            {
                                self.likeMode = ""
                            }
                            //
                            self.imgLikeMode.isHidden=true
                            
                            self.viewlikeMode.isHidden=true
                            
                            
                                if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
                                {
                                    
                                }
                                else
                                {
                                    self.likeMode = ""
                                }
                                
                                self.imgLikeMode.isHidden=true
                                
                                self.viewlikeMode.isHidden=true
                                
                                if (UserData.is_liked_by_self_user == 1 && UserData.is_liked_by_other_user_id == 1)
                                
                                {
                                    self.viewLike2.isHidden=true
                                    self.viewDislike.isHidden=true
                                    self.viewRegrate.isHidden=true
                                    self.viewVoice.isHidden=false
                                }
                                else
                                {
                                    self.viewLike2.isHidden=false
                                    self.viewDislike.isHidden=false
                                    self.viewVoice.isHidden=false
                                    self.viewRegrate.isHidden=true
                                }
                                
                                
                                
                                if let islike = UserData.is_liked_by_self_user
                                {
                                    if islike == 1
                                    {
                                        self.btnLike.setSelected(selected: true, animated: false)
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        self.btnLike.setSelected(selected: false, animated: false)
                            
                                    }
                                    
                                }
                                
                                else
                                {
                                    self.btnLike.setSelected(selected: true, animated: false)
                                
                                    
                                    self.viewLike2.isHidden=false
                                    self.viewDislike.isHidden=false
                                    self.viewVoice.isHidden=false
                                    
                                    self.viewRegrate.isHidden=true
                                }
                            
                        }
                        
                        if (UserData.is_liked_by_self_user == 1 && UserData.is_liked_by_other_user_id == 1)
                        
                        {
                            self.viewLike2.isHidden=true
                            self.viewDislike.isHidden=true
                            self.viewRegrate.isHidden=true
                            self.viewVoice.isHidden=false
                        }
                        else
                        {
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            self.viewRegrate.isHidden=true
                        }
                        
                        
                        
                        if let islike = UserData.is_liked_by_self_user
                        {
                            if islike == 1
                            {
                                self.btnLike.setSelected(selected: true, animated: false)
                                
                                
                            }
                            else
                            {
                                
                                self.btnLike.setSelected(selected: false, animated: false)
                    
                            }
                            
                        }
                        
                        else
                        {
                            self.btnLike.setSelected(selected: true, animated: false)
                        
                            
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            
                            self.viewRegrate.isHidden=true
                        }
                    }
                    else
                    {
                        if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
                        {
                            
                        }
                        else
                        {
                            self.likeMode = ""
                        }
                        
                        self.imgLikeMode.isHidden=true
                        
                        self.viewlikeMode.isHidden=true
                        
                        if (UserData.is_liked_by_self_user == 1 && UserData.is_liked_by_other_user_id == 1)
                        
                        {
                            self.viewLike2.isHidden=true
                            self.viewDislike.isHidden=true
                            self.viewRegrate.isHidden=true
                            self.viewVoice.isHidden=false
                        }
                        else
                        {
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            self.viewRegrate.isHidden=true
                        }
                        
                        
                        
                        if let islike = UserData.is_liked_by_self_user
                        {
                            if islike == 1
                            {
                                self.btnLike.setSelected(selected: true, animated: false)
                                
                                
                            }
                            else
                            {
                                
                                self.btnLike.setSelected(selected: false, animated: false)
                    
                            }
                            
                        }
                        
                        else
                        {
                            self.btnLike.setSelected(selected: true, animated: false)
                        
                            
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            
                            self.viewRegrate.isHidden=true
                        }
                    }
                    
                    
                    */
                    self.lblUserName.text = self.profileName.capitalized
                    self.lblDetailsUserName.text = self.profileName.capitalized
                    
                    
                    self.attributeCollectionView.reloadData()
                    
                    
                    
                    self.cardView.isHidden=false
                    
                    
                    self.userDetailsView.isHidden=false
                    
                    if let bio = UserData.more_profile_details?.bio, bio.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                        //self.descriptionTopConstraint.constant = 0
                        self.descriptionBottomConstraint.constant = 16
                        if noOfCell == 0 {
                            self.postTopConstraint.constant = 8
                        }
                    }
                    if UserData.more_profile_details?.bio == nil {
                        //self.descriptionTopConstraint.constant = 0
                        self.descriptionBottomConstraint.constant = 16
                        if noOfCell == 0 {
                            self.postTopConstraint.constant = 8
                        }
                        
                    }
                    else if noOfCell == 0 {
                        self.postTopConstraint.constant = 16
                    }
                    
                    if (self.UserData?.arrAllPostCollection.count ?? 0)>0
                    {
                        self.instaTopConst.constant=257
                        
                    }else
                    {
                        self.instaTopConst.constant=40
                    }
                  
                   
                    
                    //MARK: - New changes
                    
                    self.imgLikeMode.isHidden=true
                    self.viewlikeMode.isHidden=true
                    
                   let mode =  UserData.second_table_like_dislike?.by_like_mode ?? ""
                    self.is_match = UserData.like_dislikeData?.is_match ?? 0
                  //  let story_like_by_self = UserData.story_like_by_self ?? 0
                    self.hangout_like_by_self = UserData.hangout_like_by_self ?? 0
                    debugPrint("Match data = \(mode) \(self.is_match)")
                    
                    if self.hangout_like_by_self == 1
                    {
                        self.btnLike.isHidden=true
                        self.imgNewLike.isHidden=true
                        self.btnMessage.isHidden=false
                        
                        self.viewDislike.isHidden=true
                       
                        self.viewVoice.isHidden=false
                        self.viewLike2.isHidden=false
                    }
//                    else if story_like_by_self == 1
//                    {
//                        self.btnLike.isHidden=true
//                        self.btnMessage.isHidden=false
//
//                        self.viewDislike.isHidden=true
//                        self.viewRegrate.isHidden=true
//                        self.viewVoice.isHidden=false
//                        self.viewLike2.isHidden=false
//                    }
//MARK: - Match case
                    
                    else if self.is_match == 1
                    {
                        
                        if self.isfromStoryListing
                        {
                            self.btnLike.isHidden=true
                            self.imgNewLike.isHidden=true
                         self.viewDislike.isHidden=true
                    

                         self.viewVoice.isHidden=false
                         self.viewLike2.isHidden=false
                        self.btnMessage.isHidden=false
                        }
                        
                        else if self.isfromHangoutListing
                        {
                          
                    let isActiveTime =  UserData.like_dislikeData?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z"
                    var (hourRemanning,_,_)  = "".checkHoursRemaining(startTime: isActiveTime)
                            hourRemanning = hourRemanning+1
                   debugPrint("hourRemanning \(hourRemanning)")
                            
                            let prolong_subscription_is_active = UserData.prolong_subscription_is_active ?? 0
                            let response_other_user = UserData.response_other_user ?? 0
                            let response_self_user = UserData.self_send_message ?? 0
                          //  let is_read_by_second_user = UserData.is_read_by_second_user ?? 0
                    let continue_chat_status_other_user =  UserData.continue_chat_status_other_user ?? 0
                   // let chat_start_time_active =  UserData.like_dislikeData?.chat_start_time_active ?? ""
                            let is_continue_from_user =  UserData.continue_chat_status ?? 0
                            let is_continue_to_user =  UserData.continue_chat_status_other_user ?? 0
                            let continue_chat_status =  UserData.continue_chat_status ?? 0
                            
                            
                            
                            if prolong_subscription_is_active == 1
                            {
                                self.btnLike.isHidden=true
                                self.imgNewLike.isHidden=true
                             self.viewDislike.isHidden=true
                            

                             self.viewVoice.isHidden=false
                             self.viewLike2.isHidden=false
                            self.btnMessage.isHidden=false
                            }
                            else if  ((is_continue_from_user == 0 && is_continue_to_user == 0) && (hourRemanning <= 48 && hourRemanning >= 25) && (isActiveTime != ""))
                            {
                                if (response_other_user == 1 && response_self_user == 1)
                                {
                                  
                                 self.viewDislike.isHidden=true
                                

                                 self.viewVoice.isHidden=false
                                 self.viewLike2.isHidden=false
                                    self.btnLike.isHidden=true
                                    self.imgNewLike.isHidden=true
                                self.btnMessage.isHidden=false
                                }
                                else
                                {
                                    self.btnLike.isHidden=true
                                    self.imgNewLike.isHidden=true
                                 self.viewDislike.isHidden=true
                               
                                    self.viewLike2.isHidden=true
                                   self.btnMessage.isHidden=true
                                 self.viewVoice.isHidden=false
                                 
                                }
                            }
                            else if (response_other_user == 1 && response_self_user == 1) && (hourRemanning <= 24 && isActiveTime != "")
                            {
                                if  continue_chat_status == 1 && continue_chat_status_other_user == 0
                                {
                                    self.btnLike.isHidden=true
                                    self.imgNewLike.isHidden=true
                                 self.viewDislike.isHidden=true
                                
                                    self.viewLike2.isHidden=true
                                   self.btnMessage.isHidden=true
                                    
                                 self.viewVoice.isHidden=false
                                 
                                }
                                else if  (continue_chat_status == 0 || continue_chat_status_other_user == 0)
                                {
                                    self.btnLike.isHidden=true
                                    self.imgNewLike.isHidden=true
                                 self.viewDislike.isHidden=true
                                
                                    self.viewLike2.isHidden=true
                                   self.btnMessage.isHidden=true
                                    
                                 self.viewVoice.isHidden=false
                                 
                                }
                                else
                                {
                                    
                                 self.viewDislike.isHidden=true
                                

                                 self.viewVoice.isHidden=false
                                 self.viewLike2.isHidden=false
                                    self.btnLike.isHidden=true
                                    self.imgNewLike.isHidden=true
                                self.btnMessage.isHidden=false
                                }
                            }
                            
                            else
                            {
                            self.btnLike.isHidden=true
                                self.imgNewLike.isHidden=true
                            self.imgNewLike.isHidden=true
                             self.viewDislike.isHidden=true
                           

                             self.viewVoice.isHidden=false
                             self.viewLike2.isHidden=false
                            self.btnMessage.isHidden=false
                            }
                        }
//                        else if self.isfromHangoutListing //self.hangout_like_by_self == 1//
//                        {
//                            self.btnLike.isHidden=true
//                         self.viewDislike.isHidden=true
//                         self.viewRegrate.isHidden=true
//
//                         self.viewVoice.isHidden=false
//                         self.viewLike2.isHidden=false
//                        self.btnMessage.isHidden=false
//                        }
                        
                        else
                        {
                        self.btnLike.isHidden=true
                            self.imgNewLike.isHidden=true
                         self.viewDislike.isHidden=true
                     
                        self.viewLike2.isHidden=true
                        self.btnMessage.isHidden=true
                        
                         self.viewVoice.isHidden=false
                        }
                                       
                    }
                    else
                    {
                        self.viewDislike.isHidden=false
                    
                        self.viewVoice.isHidden=false
                        self.viewLike2.isHidden=false
                        
                        self.btnLike.isHidden=false
                        self.btnMessage.isHidden=true
                      var  islike = UserData.is_liked_by_self_user
                        
                        if self.isfromStoryListing
                        {
                            islike = UserData.is_liked_by_self_user//.story_like_by_self
                        }
                        else
                        {
                            islike = UserData.is_liked_by_self_user
                        }
                       // if let islike = UserData.is_liked_by_self_user
                        //{
                        
                            if islike == 1
                            {
                                //self.btnLike.setSelected(selected: true, animated: false)
                                self.imgNewLike.image = UIImage(named: "NewLikeImg")
                                self.btnLike.isUserInteractionEnabled=true
                            }
                            else
                            {
                                
                                self.imgNewLike.image = UIImage(named: "NewLikeImgNotFill")
                                self.btnLike.isUserInteractionEnabled=true
                            }
                        
                    
                       // }
                        
//                        else
//                        {
//                            self.btnLike.setSelected(selected: true, animated: false)
//
//                        }
                        
                    }
                    
                    
                    let other_user_inactive_state = UserData.other_user_inactive_state ?? 0
                    
                    if other_user_inactive_state == 1 && UserData.hangout_like_by_self == 0	
                    {
                        self.btnMessage.isHidden=true
                        self.viewLike2.isHidden=true
                    }
                    
                    
                    self.postTopConstraint.constant = 0
                    self.descriptionBottomConstraint.constant = 16
                    self.lblLocation.isHidden=true
                    self.lblDesignation.isHidden=true
                    self.imgCardLocation.isHidden=true
                    self.imgCardJob.isHidden=true
                    self.instaCollection.reloadData()
                   
                    /*
                    
                    if mode != ""
                    {
                    if (kHangout.equalsIgnoreCase(string: mode))//kStory.equalsIgnoreCase(string: mode) ||
                    {
                        self.btnLike.isHidden=true
                        self.btnMessage.isHidden=false
                    }
                    else
                    {
                        self.btnLike.isHidden=false
                        self.btnMessage.isHidden=true
                    }
                        
                        if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
                        {
                            
                        }
                        else
                        {
                            self.likeMode = mode
                        }
                        // self.lblLikeMode.text = "  " + mode + "  "
                        if mode.equalsIgnoreCase(string: kAnonymous)
                        {
                            self.imgLikeMode.image = UIImage(named: "profile")
                            self.imgLikeMode.isHidden=true
                            
                            self.viewlikeMode.isHidden=true
                            self.btnMessage.isHidden=true
                            self.viewlikeMode.isHidden=true
                            if (UserData.is_liked_by_self_user == 1 && UserData.is_liked_by_other_user_id == 1)
                            
                            {
                               
                                self.viewDislike.isHidden=true
                                self.viewRegrate.isHidden=true
                                self.viewVoice.isHidden=false
                                self.viewLike2.isHidden=true
                                
                                
//                                self.viewLike2.isHidden=false
//                                self.btnLike.isHidden=true
//                                self.btnMessage.isHidden=false
                            }
                            else
                            {
                                self.viewLike2.isHidden=false
                                self.viewDislike.isHidden=false
                                self.viewVoice.isHidden=false
                                self.viewRegrate.isHidden=true
                                
//                                self.btnLike.isHidden=false
//                                self.btnMessage.isHidden=true
                            }
                            
                            
                            
                            if let islike = UserData.is_liked_by_self_user
                            {
                                if islike == 1
                                {
                                    self.btnLike.setSelected(selected: true, animated: false)
                                    
                                    
                                }
                                else
                                {
                                    
                                    self.btnLike.setSelected(selected: false, animated: false)
                        
                                }
                            }
                            
                            else
                            {
                                self.btnLike.setSelected(selected: true, animated: false)
                                self.viewLike2.isHidden=false
                                self.viewDislike.isHidden=false
                                self.viewVoice.isHidden=false
                                
                                self.viewRegrate.isHidden=true
                            }
                            
                        }
                        else
                        {
                            if mode.equalsIgnoreCase(string: kHangout)
                            {
                                self.imgLikeMode.image = UIImage(named: "smile")
                            }
                            else  if mode.equalsIgnoreCase(string: kStory)
                            {
                                self.imgLikeMode.image = UIImage(named: "Stories")
                            }
                            else  if mode.equalsIgnoreCase(string: kShake)
                            {
                                self.imgLikeMode.image = UIImage(named: "playing-cards")
                            }
                            else  if mode.equalsIgnoreCase(string: kProfile)
                            {
                                self.imgLikeMode.image = UIImage(named: "profile")
                            }
                            self.imgLikeMode.isHidden=false
                            self.viewlikeMode.isHidden=false
                        }
                        self.imgLikeMode.image = self.imgLikeMode.image?.tinted(color: UIColor.white)
                         let islike = UserData.is_liked_by_self_user ?? 0
                        
                            if islike == 1
                            {
                                self.btnLike.setSelected(selected: true, animated: false)
                                self.btnLike.isUserInteractionEnabled=false
                            }
                            else
                            {
                                self.btnLike.isUserInteractionEnabled=true
                            }
                        
                    }
                    else
                    {
                        self.btnMessage.isHidden=true
                        self.viewlikeMode.isHidden=true
                        if (UserData.is_liked_by_self_user == 1 && UserData.is_liked_by_other_user_id == 1)
                        
                        {
                            self.viewLike2.isHidden=true
                            self.viewDislike.isHidden=true
                            self.viewRegrate.isHidden=true
                            self.viewVoice.isHidden=false
                            
                            
//                            self.viewLike2.isHidden=false
//                            self.btnLike.isHidden=true
//                            self.btnMessage.isHidden=false
                        }
                        else
                        {
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            self.viewRegrate.isHidden=true
                            
//                            self.btnLike.isHidden=false
//                            self.btnMessage.isHidden=true
                        }
                        
                        
                        
                        if let islike = UserData.is_liked_by_self_user
                        {
                            if islike == 1
                            {
                                self.btnLike.setSelected(selected: true, animated: false)
                                
                                self.btnLike.isUserInteractionEnabled=false
                            }
                            else
                            {
                                
                                self.btnLike.setSelected(selected: false, animated: false)
                                self.btnLike.isUserInteractionEnabled=true
                            }
                        }
                        
                        else
                        {
                            self.btnLike.setSelected(selected: true, animated: false)
                            self.viewLike2.isHidden=false
                            self.viewDislike.isHidden=false
                            self.viewVoice.isHidden=false
                            
                            self.viewRegrate.isHidden=true
                            self.btnLike.isUserInteractionEnabled=true
                        }
                    }
                    //MARK: - hide shake icon //
                    
                  //  if self.comeFrom.equalsIgnoreCase(string: kHangout)
                   // {
                     
                            self.imgLikeMode.isHidden=true
                            self.viewlikeMode.isHidden=true
                        
                    //}
                    
                    
                    let singleHangoutId =  UserData.Single_Hangout_Details?._id ?? ""
                    
                    if !singleHangoutId.equalsIgnoreCase(string: kEmptyString)
                    {
                        self.viewDislike.isHidden=true
                    }
                    else
                    {
                        self.viewDislike.isHidden=false
                    }
                
                    
                    */
                    
                    
//                    self.postTopConstraint.constant = 0
//                    self.descriptionBottomConstraint.constant = 16
//                    self.lblLocation.isHidden=true
//                    self.lblDesignation.isHidden=true
//                    self.imgCardLocation.isHidden=true
//                    self.imgCardJob.isHidden=true
//                    self.instaCollection.reloadData()
                    
                    /*
                    //MARK: - New condition
                    debugPrint("New condition 2 = \(mode) \(is_match)")
                    if (is_match == 1 && (!kStory.equalsIgnoreCase(string: mode) && !(kHangout.equalsIgnoreCase(string: mode))))
                    {
                        
                        self.viewLike2.isHidden=true
                        self.viewDislike.isHidden=true
                        self.viewRegrate.isHidden=true
                        self.viewVoice.isHidden=false
                    }
                    else
                    {
                        self.viewLike2.isHidden=false
                        self.viewDislike.isHidden=false
                        self.viewVoice.isHidden=false
                        self.viewRegrate.isHidden=true
                    }
                    
                    
                    if let islike = UserData.is_liked_by_self_user
                    {
                        if islike == 1
                        {
                            self.btnLike.setSelected(selected: true, animated: false)
                            
                            self.btnLike.isUserInteractionEnabled=false
                        }
                        else
                        {
                            
                            self.btnLike.setSelected(selected: false, animated: false)
                            self.btnLike.isUserInteractionEnabled=true
                        }
                    }
                    
                    else
                    {
                        self.btnLike.setSelected(selected: true, animated: false)
                        self.viewLike2.isHidden=false
                        self.viewDislike.isHidden=false
                        self.viewVoice.isHidden=false
                        
                        self.viewRegrate.isHidden=true
                        self.btnLike.isUserInteractionEnabled=true
                    }
                    
                    */
                    
                    
                    
                   
                }
                
            }
            
            
        })
    }
    
    
    
    
    //MARK: - user like dislike
    
    func likeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String,story_id:String=kEmptyString,from_story_only:String=kEmptyString)
    {
        var data = JSONDictionary()
        
        if likeMode.equalsIgnoreCase(string: kAnonymous) || likeMode == ""
        {
            self.story_id=""
            self.hangout_id=""
        }
        if likeMode == ""
        {
            likeMode = kAnonymous
        }
        data[ApiKey.kOther_user_id] = other_user_id
        data[ApiKey.kAction] = action
        data[ApiKey.kLike_mode] = like_mode
       if self.isfromStoryListing
       {
        data[ApiKey.kStory_Id] = story_id
       }
        else
       {
        data[ApiKey.kStory_Id] = self.story_id
       }
        
        data[ApiKey.kHangout_Id] = self.hangout_id
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kfrom_story_only] = from_story_only
        
        if Connectivity.isConnectedToInternet {
            
            self.callApiForLikeUnlike(data: data,type: action)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String)
    {
        HomeVM.shared.callApiForLikeUnlikeUser(data: data, response: { (message, error) in
            
            if error != nil
            {

                
                if let islike = self.userData?.is_liked_by_self_user
                {
                    if islike == 1
                    {
                      
                        self.imgNewLike.image = UIImage(named: "NewLikeImg")
                        
                        self.btnLike.isUserInteractionEnabled=true
                    }
                    else
                    {
                        
                        self.imgNewLike.image = UIImage(named: "NewLikeImgNotFill")
                        self.btnLike.isUserInteractionEnabled=true
                    }
                    
                }
                
                else
                {
                    self.imgNewLike.image = UIImage(named: "NewLikeImg")
                    self.btnLike.isUserInteractionEnabled=true
                }
                
                
                self.showErrorMessage(error: error)
                
            }
            else{
                self.islikeApiCall=true
                /*
                if type == "1"
                {
                    self.btnLike.setSelected(selected: true, animated: true)
                    self.btnLike.isUserInteractionEnabled=true
                }
                else
                {
                    self.btnLike.isUserInteractionEnabled=true
                }
               */
                
                if type == "1"//"User has been liked successfully."
                {
                    if self.is_liked_by_other_user_id == 1
                    {
                        let vc = MatchVC.instantiate(fromAppStoryboard: .Home)

                        vc.comefrom = kViewProfile
                        vc.user2Image=self.other_user_image
                        vc.profileImage=self.other_user_image
                        vc.profileName=(self.UserData?.profile_data?.username ?? "").capitalized
                        vc.view_user_id=self.other_user_id
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {

//                        self.getUserDetails()
                        
                        if self.comeFrom == kAppDelegate
                        {
                            let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

                            vc.selectedIndex=2
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else
                        {
                            if self.islikeApiCall==false{
                                DataManager.comeFrom=kViewProfile
                                DataManager.HomeRefresh = false
                            }
                            if self.islikeApiCall
                            {
                                DataManager.HomeRefresh=true
                            }
                            
                            self.navigationController?.popViewController(animated: false)
                        }

                    }
                    
                }
                else
                {
                    if self.comeFrom == kAppDelegate
                    {
                        let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

                        vc.selectedIndex=2
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        if self.islikeApiCall==false{
                            DataManager.comeFrom=kViewProfile
                            DataManager.HomeRefresh = false
                        }
                        if self.islikeApiCall
                        {
                            DataManager.HomeRefresh=true
                        }
                        
                        self.navigationController?.popViewController(animated: false)
                    }

                }
                
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
                 self.islikeApiCall = true
                if self.comeFrom == kAppDelegate
                {
                    let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

                    vc.selectedIndex=2
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    if self.islikeApiCall==false{
                        DataManager.comeFrom=kViewProfile
                        DataManager.HomeRefresh = false
                    }
                    if self.islikeApiCall
                    {
                        DataManager.HomeRefresh=true
                    }
                    
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
        )
        
    }
    
    //MARK: -  Story like,dislike
    
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
                self.islikeApiCall=true
                if self.comeFrom == kAppDelegate
                {
                    let vc = TabbarWithOutStoryHangout.instantiate(fromAppStoryboard: .CustomTabar)

                    vc.selectedIndex=2
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    if self.islikeApiCall==false{
                        DataManager.comeFrom=kViewProfile
                        DataManager.HomeRefresh = false
                    }
                    if self.islikeApiCall
                    {
                        DataManager.HomeRefresh=true
                    }
                    
                    self.navigationController?.popViewController(animated: false)
                }
            }

         
        })
    }
}
/*
extension ViewProfileVC:UIGestureRecognizerDelegate
{
    //MARK: - respond ToSwipe Gesture action

    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer)
    {
        /*
        debugPrint("sender: = \(sender.direction)")
        debugPrint("current index = \(self.index)")
        if ((sender.direction == .right))// && (self.index == 0)
        {
            debugPrint("right")
           // self.usersCollection.reloadData()
            //self.usersCollection.scrollToItem(at: NSIndexPath(item: self.userImageData.count+1, section: 0) as IndexPath, at: .left, animated: false)
          
            self.usersCollection.setContentOffset(CGPoint(x: (self.usersCollection.frame.width), y: 0), animated: false)
            
           // self.usersCollection.scrollToItem(at:IndexPath(item: self.userImageData.count+1, section: 0), at: .right, animated: false)
            
           // self.usersCollection.reloadData()
         //   self.usersCollection.scrollToItem(at: NSIndexPath(item: self.userImageData.count, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
          
        }
        */
     
       

    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
            return true
    }
}

*/
extension UICollectionView {
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition = .left, animated: Bool = true) {
        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return }
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
    func scrollToFirstItem(at scrollPosition: UICollectionView.ScrollPosition = .left, animated: Bool = true) {
        let lastSection = numberOfSections
        guard lastSection >= 0 else { return }
        let lastItem = numberOfItems(inSection: lastSection)
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
}
