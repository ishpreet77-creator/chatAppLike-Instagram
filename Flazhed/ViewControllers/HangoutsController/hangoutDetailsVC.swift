//
//  hangoutDetailsVC.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit

class hangoutDetailsVC: BaseVC {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txtViewTitle: UITextView!
    @IBOutlet weak var txtViewDesc: UILabel!
    @IBOutlet weak var toConst: NSLayoutConstraint!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var viewLoc: UIView!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var viewHangoutType: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblHangoutType: UILabel!
    @IBOutlet weak var imgHangoutType: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblAgeRange: UILabel!
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var imgHangout: UIImageView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnThreeDot: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var hangoutId = ""
    var otherUserId = ""
    var hangout_id = ""
    var isLikeUpdate=false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.toConst.constant = -getStatusBarHeight()
        
        self.viewLoc.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        self.viewDesc.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callGetHangoutDetailApi(hangoutId: self.hangoutId)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        if isLikeUpdate
        {
            DataManager.comeFrom=""
        }
        else
        {
            
            DataManager.comeFrom=kViewProfile
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func messgeButtonAction(_ sender: UIButton) {
        
       if (self.btnMessage.title(for: .normal) == kInterested) //kLikeProfile
        {
        self.likeUnlikeAPI(other_user_id: self.otherUserId, action: "1", like_mode: "Shake", type: "Shake")
        self.btnMessage.setTitle(kNotInterested, for: .normal) //kDislikeProfile
        }
        else if (self.btnMessage.title(for: .normal) == kNotInterested) //kDislikeProfile
        {
            self.likeUnlikeAPI(other_user_id: self.otherUserId, action: "2", like_mode: "Shake", type: "Shake")
            self.btnMessage.setTitle(kInterested, for: .normal) //kLikeProfile
        }
        else if (self.btnMessage.title(for: .normal) == kEdit)
        {
            let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PostHangoutVC") as! PostHangoutVC
        
            
            vc.HangoutDetail=HangoutVM.shared.hangoutDetail?.hangout_details
            vc.fromEdit=true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else
        {
//        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
//        self.navigationController?.pushViewController(vc, animated: true)
//
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
            let cellData = HangoutVM.shared.hangoutDetail
            vc.view_user_id=cellData?.user_id ?? ""
            vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
            
            if cellData?.profile_data?.images?.count ?? 0>0
                {
                if let img = cellData?.profile_data?.images?[0].image
                  {
               vc.profileImage=img
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func viewProfileAct(_ sender: UIButton) {
        
        
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        vc.view_user_id = HangoutVM.shared.hangoutDetail?.user_id ?? ""
   
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteHangoutAct(_ sender:UIButton)
    {
          
            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
            destVC.delegate=self
        let cellData = HangoutVM.shared.hangoutDetail
        self.hangout_id=cellData?.hangout_details?._id ?? ""
            destVC.type = .deleteHangout
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
        
    }

    
}
// MARK:- Extension Api Calls
extension hangoutDetailsVC
{
    
    func callGetHangoutDetailApi(hangoutId: String)
    {
     
        var data = JSONDictionary()
        data[ApiKey.kHangout_id] = hangoutId
            
            if Connectivity.isConnectedToInternet {
              
                self.callApiForHangoutDetail(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForHangoutDetail(data:JSONDictionary)
    {
        HangoutVM.shared.callApiGetHangoutDetail(data: data, response: { (message, error) in
            
            if error != nil
            {
       
                self.showErrorMessage(error: error)
            }
            else{
                self.otherUserId=HangoutVM.shared.hangoutDetail?.user_id ?? ""
                
                let heading = (HangoutVM.shared.hangoutDetail?.hangout_details?.heading ?? "")+" \n"
                let desc = HangoutVM.shared.hangoutDetail?.hangout_details?.description ?? ""
                self.txtViewTitle.customFontText(boldSting: heading, regularSting: desc, fontSize: 16)
                
                self.lblUsername.text = (HangoutVM.shared.hangoutDetail?.profile_data?.username)?.capitalized
                
                self.txtViewDesc.text =  HangoutVM.shared.hangoutDetail?.hangout_details?.aditional_description ?? ""
                
                let looking = HangoutVM.shared.hangoutDetail?.hangout_details?.looking_for ?? ""
                
                if looking == kBothGender
                {
                    self.lblLookingFor.text =  "Male, Female"
                }
                else
                {
                self.lblLookingFor.text =  HangoutVM.shared.hangoutDetail?.hangout_details?.looking_for ?? ""
                }
                self.lblLocation.text =  HangoutVM.shared.hangoutDetail?.hangout_details?.place ?? ""
                let min = HangoutVM.shared.hangoutDetail?.hangout_details?.age_from ?? 18
                let max = HangoutVM.shared.hangoutDetail?.hangout_details?.age_to ?? kMaxAge
                
//                if HangoutVM.shared.hangoutDetail?.is_liked_by_self_user == 1 && HangoutVM.shared.hangoutDetail?.is_liked_by_other_user_id == 1//.like_dislike?.is_match == 1
//              {
//
//                    self.btnMessage.setTitle(kMessage, for: .normal)
//
//              }
//                else
                
                if HangoutVM.shared.hangoutDetail?.is_liked_by_self_user == 1
              {
                 
                    
                    self.btnMessage.setTitle(kNotInterested, for: .normal) //kDislikeProfile
              }
              else
              {
                
                self.btnMessage.setTitle(kInterested, for: .normal) //kLikeProfile
              }
                
                
                if HangoutVM.shared.hangoutDetail?.user_id == DataManager.Id
                {
                    self.btnDelete.isHidden=false
                    self.btnMessage.setTitle(kEdit, for: .normal)
                }
                else
                {
                    self.btnDelete.isHidden=true
                }
                
                
                
                self.lblAgeRange.text =  "\(min)" + "-" + "\(max)"
                
            
                if let time = HangoutVM.shared.hangoutDetail?.hangout_details?.date
                {
                   // let time2 = time.dateFromString(format: .NewISO, type: .utc)
                   // let date = time2.string(format: .longdateTime2, type: .local)
                    let date = time.utcToLocalDate(dateStr: time) ?? ""
                    if let time11 = HangoutVM.shared.hangoutDetail?.hangout_details?.time
                    {
                      //let time12 = time11.dateFromString(format: .NewISO, type: .utc)
                       // let date12 = time12.string(format: .localTime, type: .local)
                        let date12 = time11.utcToLocalTime(dateStr: time11) ?? ""
                        self.lblDateTime.text = date+" @ "+date12
                    }
                }
                
             
                
                
                
                let hangoutType =  HangoutVM.shared.hangoutDetail?.hangout_details?.hangout_type ?? ""
                
                if hangoutType == kBusiness
                {
                    self.imgHangoutType.image=UIImage(named: "business")
                    self.lblHangoutType.text = kBusiness.uppercased()
                    self.lblHangoutType.textColor=BUSSINESSTEXRT
                    self.viewHangoutType.backgroundColor = BUSSINESSBACK
                }
               else if hangoutType == kTravel
                {
                self.imgHangoutType.image=UIImage(named: "travler")
                self.lblHangoutType.text = kTravel.uppercased()
                
                self.lblHangoutType.textColor=TRAVELTEXRT
                self.viewHangoutType.backgroundColor = TRAVELBACK
                }
               else if hangoutType == kSports
                {
                self.imgHangoutType.image=UIImage(named: "sport-1")
                self.lblHangoutType.text = kSports.uppercased()
                self.lblHangoutType.textColor=SPORTTEXRT
                self.viewHangoutType.backgroundColor = SPORTBACK
                }
                else
               {
                self.imgHangoutType.image=UIImage(named: "social-1")
                self.lblHangoutType.text = kSocial.uppercased()
                self.lblHangoutType.textColor=SOCAILTEXRT
                self.viewHangoutType.backgroundColor = SOCAILBACK
               }
                
                if let img = HangoutVM.shared.hangoutDetail?.hangout_details?.image
                {
                  let url = URL(string: img)!
                  DispatchQueue.main.async {
                    self.imgHangout.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                  }
                }
                
                if HangoutVM.shared.hangoutDetail?.profile_data?.images?.count ?? 0>0
                    {
                    if let img = HangoutVM.shared.hangoutDetail?.profile_data?.images?[0].image
                      {
                        let url = URL(string: img)!
                        DispatchQueue.main.async {
                            self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                      }
                    }
                
            }

         
        })
    }
    
    //MARK:-  user like
    
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
   
        HomeVM.shared.callApiForLikeUnlikeUser(showIndiacter: false,data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
            
                self.isLikeUpdate=true
           
            }

         
        })
    }
    
    //MARK:- Delete hangout  api
    
    
    
    func callDeleteHangoutApi(hangout_id:String)
    {
        var data = JSONDictionary()

    
        data[ApiKey.kHangout_id] = hangout_id
         
            if Connectivity.isConnectedToInternet {
                
                self.callApiForDeleteHangout(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForDeleteHangout(data:JSONDictionary)
    {
        HangoutVM.shared.callApiDeleteHangout(data: data, response: { (message, error) in
        
            if error != nil
            {
            
                self.showErrorMessage(error: error)
            }
            else{
                DataManager.comeFrom=""
                self.navigationController?.popViewController(animated: true)
            }

         
        })
    }
    
}
extension hangoutDetailsVC:threeDotMenuDelegate,DiscardDelegate
{
    func ClickNameAction(name: String)
    {
       
            if name == kDelete
            {
                self.callDeleteHangoutApi(hangout_id: self.hangout_id)
            }
        
    }
    
    
}
