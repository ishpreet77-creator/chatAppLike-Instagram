//
//  ViewProfileVC.swift
//  Flazhed
//
//  Created by IOS32 on 01/02/21.
//

import UIKit
import AVKit

class ViewProfileVC:BaseVC
{
    //MARK:- All outlets  🍎
    
    @IBOutlet weak var instaPostHeightConst: NSLayoutConstraint!
    @IBOutlet weak var viewLike2: UIView!
    @IBOutlet weak var viewVoice: UIView!
    @IBOutlet weak var viewDislike: UIView!
    @IBOutlet weak var viewRegrate: UIView!
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
    @IBOutlet weak var viewSwap: UIView!
    @IBOutlet weak var btnSwap: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var detailsButtomConst: NSLayoutConstraint!
    @IBOutlet weak var viewImageCount: UIView!
    @IBOutlet weak var lblDetailsUserName: UILabel!
    @IBOutlet weak var lblDetailsDesignation: UILabel!
    @IBOutlet weak var lblDetailLocation: UILabel!
    @IBOutlet weak var txtBio: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblUserPost: UILabel!
    @IBOutlet weak var lblInstaPost: UILabel!
    @IBOutlet weak var imgJob: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var imgCardJob: UIImageView!
    @IBOutlet weak var imgCardLocation: UIImageView!
    @IBOutlet weak var imgLikeDislike: UIImageView!
    @IBOutlet weak var imgLikeDislike2: UIImageView!
    @IBOutlet weak var viewLike: UIView!
    
    //MARK:- All Variable  🍎
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardView.isHidden=true
        self.userDetailsView.isHidden=false
        self.setupCollection()
        self.postImageData.removeAll()
        self.attributeDict.removeAllObjects()
        self.btnSwap.isHidden=true
        self.viewSwap.isHidden=true
        
        self.imgJob.isHidden=true
        self.imgLocation.isHidden=true
        self.viewButtom.isHidden=true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.attributeCount=0.0
        if fromPlay==false
        {
            if view_user_id != ""
            {
               if DataManager.comeFrom != kViewProfile
                {
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
    
    
    @IBAction func backAct(_ sender: UIButton)
    {
        
        if comeFrom == kAppDelegate
        {
            if #available(iOS 13.0, *) {
                SCENEDEL?.navigateToHome()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToHome()
            }
        }
        else
        {
            if self.islikeApiCall==false{
                DataManager.comeFrom=kViewProfile
                DataManager.HomeRefresh = "false"
            }
            if self.islikeApiCall
            {
                DataManager.HomeRefresh="true"
            }
            
            self.navigationController?.popViewController(animated: false)
        }
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
    self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "2", like_mode: "Shake", type: "Shake")
    
    }
    
    //MARK:- Like user action  🍎
    
    @IBAction func LikeAct(_ sender: UIButton)
    {
        
        
        if sender.tag == 0
        {
            self.lightUp(button: sender)
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: "Shake", type: "Shake")
            
            
        }
        else if sender.tag == 1
        {
            self.lightUp(button: sender)
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: "Anonymous", type: "Ano")
            
        }
        else if sender.tag == 2
        {
            self.lightUp(button: sender)
            self.likeUnlikeAPI(other_user_id: self.other_user_id, action: "1", like_mode: "Shake", type: "Shake")
        }
        
    }
    
    // }
    
    
    @IBAction func btnSwapScreenAct(_ sender: UIButton)
    {
        if self.btnSwap.isSelected//sender.isSelected
        {
            self.btnSwap.isSelected=false
            self.cardView.isHidden=true
            self.userDetailsView.isHidden=false
            self.btnSwap.isHidden=false
            self.viewSwap.isHidden=false
        }
        else
        {
            self.btnSwap.isSelected=true
            self.cardView.isHidden=false
            self.btnSwap.isHidden=true
            self.viewSwap.isHidden=true
            self.userDetailsView.isHidden=true
        }
    }
    
    
}
//MARK:- Collection view setup and show post,attribute data 🍎

extension ViewProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
        self.PostCollection.delegate=self
        self.PostCollection.dataSource=self
        self.PostCollection.register(UINib(nibName: "PostCCell", bundle: nil), forCellWithReuseIdentifier: "PostCCell")
        self.usersCollection.delegate=self
        self.usersCollection.dataSource=self
        self.usersCollection.register(UINib(nibName: "HomeCardCCell", bundle: nil), forCellWithReuseIdentifier: "HomeCardCCell")
        
        
        self.instaCollection.delegate=self
        self.instaCollection.dataSource=self
        self.instaCollection.register(UINib(nibName: "PostCCell", bundle: nil), forCellWithReuseIdentifier: "PostCCell")
        
        self.attributeCollectionView.register(UINib(nibName: "ProfileAttributeCCell", bundle: nil), forCellWithReuseIdentifier: "ProfileAttributeCCell")
        self.attributeCollectionView.delegate=self
        self.attributeCollectionView.dataSource=self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if (collectionView == self.usersCollection)
        {
            return self.userImageData.count
        }
        else if collectionView == self.PostCollection
        {
            return self.UserData?.arrAllPostCollection.count ?? 0//self.postImageData.count
        }
        else if collectionView == self.attributeCollectionView
        {
            return self.UserData?.more_profile_details?.arrCollection.count ?? 0
            
        }
        else
        {
            return self.UserData?.Insta_data?.images?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView == self.PostCollection
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCCell", for: indexPath) as! PostCCell
            
            let model = self.UserData?.arrAllPostCollection[indexPath.row]
            // case story
            //case hangout
            
            if model?.type == .story{
                
                cell.lblPostType.text = "STORY"
                if model?.PostData?.file_type==kVideo
                {
                    cell.btnPlay.isHidden=false
                    if let img = model?.PostData?.thumbnail
                    {
                        let url = URL(string: img)!
                        
                        
                        cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        
                    }
                }
                else
                {
                    cell.btnPlay.isHidden=true
                    
                    if let img = model?.PostData?.file_name
                    {
                        let url = URL(string: img)!
                        
                        
                        cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    }
                }
                
                cell.tagView.isHidden=false
                cell.btnPlay.tag=indexPath.row
                
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
                        let url = URL(string: img)!
                        
                        
                        cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
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
            
            if model?.type == .education{
                cell.imgIcon.image = UIImage(named: "Graduate")
                cell.lblTitle.text = model?.education_selected?.education_name
                cell.lblTitle.text = cell.lblTitle.text?.capitalized
            }else if model?.type == .height{
                cell.imgIcon.image = UIImage(named: "scaleIcon")
                
                let unit = DataManager.currentUnit//self.UserData?.unit_settings?.unit ?? ""
                if let height  = model?.height
                {
                    if  unit == kFeet
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
                    let url = URL(string: img)!
                    
                    cell.imgIcon.sd_setImage(with: url, placeholderImage: UIImage(named: "toddlerIcon"), options: .refreshCached) { (img, error, type, url) in
                        
                        cell.imgIcon.image = cell.imgIcon.image?.tinted(color:  #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1))
                    }
                }
                
                cell.lblTitle.text = model?.children_selected?.children_name
                cell.lblTitle.text = cell.lblTitle.text?.capitalized
            }
            
            
            cell.imgIcon.image = cell.imgIcon.image?.tinted(color:  #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1))
            return cell
        }
        else if collectionView == self.usersCollection
        {
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell
            
            let celldata = self.userImageData[indexPath.row]
            
            if let img = celldata.image
            {
                let url = URL(string: img)!
                
                cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                
            }
            
            return cell
        }
        else
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCCell", for: indexPath) as! PostCCell
            
            let cellData = self.UserData?.Insta_data?.images?[indexPath.row] ?? ""
            
            if cellData != ""
            {
                let url = URL(string: cellData)
                
                cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
            }
            cell.btnPlay.isHidden=true
            
            cell.tagView.isHidden=true
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.usersCollection
        {
            return CGSize(width: SCREENWIDTH, height: usersCollection.frame.height+30)
        }
        else if collectionView == self.attributeCollectionView
        {
            return CGSize(width: ((self.attributeCollectionView.frame.width/2)-4), height: 46)
        }
        else
        {
            return CGSize(width: 110, height: 150)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == usersCollection
        {
            self.btnSwap.isSelected=false
            self.cardView.isHidden=true
            self.btnSwap.isHidden=false
            self.viewSwap.isHidden=false
            self.userDetailsView.isHidden=false
        }
          else  if collectionView == self.PostCollection
            {
               let model = self.UserData?.arrAllPostCollection[indexPath.row]
          
                if model?.type == .story
                {
                    let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "ViewStoryVC") as!  ViewStoryVC
                   // vc.comefrom = kViewProfile
                    //vc.cellData=self.other_user_image
                    vc.cellData = model?.PostData
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "hangoutDetailsVC") as! hangoutDetailsVC
                
                    vc.hangoutId=model?.hangoutData?._id ?? ""
                        
                    self.navigationController?.pushViewController(vc, animated: true)
                    

                }
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == usersCollection
        {
            let x = scrollView.contentOffset.x
            let index = Int(x/usersCollection.frame.width) + 1
            let total = Int(usersCollection.contentSize.width/usersCollection.frame.width)
            print("INDEX",index)
            self.lblImageCount.text = "\(index)/\(total)"
            usersCollection.reloadData()
        }
        
    }
    
    @objc func playAct(_ sender: UIButton)
    {
        let model = self.UserData?.arrAllPostCollection[sender.tag]
         
        
        
        if model?.type == .story
        {
            
//            if  let url = model?.PostData?.file_name //self.postImageData[sender.tag].file_name
//            {
//                self.fromPlay=true
//                self.postCollectionCell?.img.playVideoOnImage(URL(string: url)!, VC: self)
//            }
            
            
           let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                 let vc = storyBoard.instantiateViewController(withIdentifier: "ViewStoryVC") as!  ViewStoryVC

                 vc.cellData = model?.PostData
                 self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
//MARK:- get user data api 🍎

extension ViewProfileVC
{
    
    func getUserDetails()
    {
        if Connectivity.isConnectedToInternet {
            
            self.callApiForGetUserDetails(data: self.view_user_id)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetUserDetails(data:String)
    {
        HomeVM.shared.callApiGetUserDetails(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                if let UserData = HomeVM.shared.viewProfileUserDetail
                {
                    var name  = ""
                    
                    self.imgJob.isHidden=false
                    self.imgLocation.isHidden=false
                    self.viewButtom.isHidden=false
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
                            self.imgLikeDislike.image = UIImage(named: "redLike")
                            self.imgLikeDislike2.image = UIImage(named: "redLike")
                        
                            
                        }
                        else
                        {
                            
                            self.imgLikeDislike2.image = UIImage(named: "BlackLike")
                            self.imgLikeDislike.image = UIImage(named: "BlackLike")
                        }
                        
                    }
                    
                    else
                    {
                        self.imgLikeDislike2.image = UIImage(named: "BlackLike")
                        self.imgLikeDislike.image = UIImage(named: "BlackLike")
                        
                        self.viewLike2.isHidden=false
                        self.viewDislike.isHidden=false
                        self.viewVoice.isHidden=false
                        
                        self.viewRegrate.isHidden=true
                    }
                    if let ProfileData = UserData.profile_data
                    {
                        if let username = ProfileData.username
                        {
                            name = username.capitalized
                            
                            
                            self.lblUserPost.isHidden=false
                            self.lblInstaPost.isHidden=false
                            self.lblUserPost.text = username + "'s Posts"
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
                            }}
                        self.voiceUrl = ProfileData.voice ?? ""
                        
                        self.detailsButtomConst.constant = 80
                        self.usersCollection.reloadData()
                        
                    }
                    if let  image = UserData.post_details
                    {
                        self.postImageData = image //.append(image)
                        
                    }
                    self.PostCollection.reloadData()
                    
                    if UserData.arrAllPostCollection.count>0 //self.postImageData.count>0
                    {
                        self.scrollDetails.isScrollEnabled=true
                        self.lblUserPost.isHidden=false
                    }
                    else
                    {
                        self.scrollDetails.isScrollEnabled=false
                        self.lblUserPost.isHidden=true
                    }
                    
                    
                    
                    self.instaCollection.isHidden = false
                    self.PostCollection.isHidden = false
                    self.other_user_id = UserData.user_id ?? ""
                    self.is_liked_by_other_user_id = UserData.is_liked_by_other_user_id ?? 0
                    
                    self.lblImageCount.text = "\("1")/\(self.userImageData.count)"
                    
                    
                    if self.userImageData.count == 0
                    {
                        self.viewImageCount.isHidden=true
                    }
                    else
                    {
                        self.viewImageCount.isHidden=false
                    }
                    if let more_profile_details = UserData.more_profile_details
                    {
                        
                        if let city = more_profile_details.city
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
                        
                        
                        if let job = more_profile_details.job_title
                        {
                            let company = more_profile_details.company_name
                            
                            if job !=  nil && company != nil
                            {
                                let job2 = (job ?? "")+" @ "+(company ?? "")
                                
                                self.lblDesignation.text = job2
                                self.lblDetailsDesignation.text=job2
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
                            
                            name = name + ", " + "\(age)"
                        }
                        
                    }
                    
                    
                    self.UserData=UserData
            
                    let count = Double(self.UserData?.more_profile_details?.arrCollection.count ?? 0)
                    
                    let noOfCell = ceil(Double(count/2.0))
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
                    
                    
                    
                    self.lblUserName.text = name.capitalized
                    self.lblDetailsUserName.text = name.capitalized
                    
                    
                    self.attributeCollectionView.reloadData()
                    
                    
                    self.btnSwap.isSelected=true
                    self.cardView.isHidden=true
                    self.btnSwap.isHidden=true
                    self.viewSwap.isHidden=true
                    self.userDetailsView.isHidden=false
                    
                    if let bio = UserData.more_profile_details?.bio, bio.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                        self.descriptionTopConstraint.constant = 0
                        self.descriptionBottomConstraint.constant = 16
                        if noOfCell == 0 {
                            self.postTopConstraint.constant = 8
                        }
                    }
                    if UserData.more_profile_details?.bio == nil {
                        self.descriptionTopConstraint.constant = 0
                        self.descriptionBottomConstraint.constant = 16
                        if noOfCell == 0 {
                            self.postTopConstraint.constant = 8
                        }
                        
                    }
                    else if noOfCell == 0 {
                        self.postTopConstraint.constant = 16
                    }
                    
                    self.instaCollection.reloadData()
                }
                
            }
            
            
        })
    }
    
//MARK:- user like dislike 🍎
    
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
                self.btnLike.setImage(nil, for: .normal)
                self.showErrorMessage(error: error)
                
            }
            else{
                self.islikeApiCall=true
                self.btnLike.setImage(nil, for: .normal)
                
                if message! == "User has been liked successfully."
                {
                    if self.is_liked_by_other_user_id == 1
                    {
                        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                        vc.comefrom = kViewProfile
                        vc.user2Image=self.other_user_image
                        vc.profileImage=self.other_user_image
                        vc.profileName=(self.UserData?.profile_data?.username ?? "").capitalized
                        vc.view_user_id=self.other_user_id
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        if self.comeFrom == kAppDelegate
                        {
                            if #available(iOS 13.0, *) {
                                SCENEDEL?.navigateToHome()
                            } else {
                                // Fallback on earlier versions
                                APPDEL.navigateToHome()
                            }
                        }
                        else
                        {
                            
                            self.getUserDetails()
                        }
                        
                    }
                    
                }
                else if message! == "User has been disliked successfully." ||  message! == "User has been disliked successfully."
                {
                    if #available(iOS 13.0, *) {
                        SCENEDEL?.navigateToHome()
                    } else {
                        // Fallback on earlier versions
                        APPDEL.navigateToHome()
                    }
                }
                else
                {
                    self.openSimpleAlert(message: message)
                }
            }
            
            
        })
    }
    
    func lightUp(button: UIButton)
    {
        UIView.transition(with: button, duration: 0.30, options: .transitionCrossDissolve, animations: {
            button.setImage(UIImage(named: "redLike"), for: .normal)
        }, completion: {_ in
            UIView.transition(with: button, duration: 0.30, options: .transitionCrossDissolve, animations: {
                
            }, completion: { _ in
                
                print("Like done")
            }
            )})
        
        
    }
    
}
