//
//  hangoutDetailsVC.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit
import SDWebImage

class hangoutDetailsVC: BaseVC {
    @IBOutlet weak var lineButtomConst: NSLayoutConstraint!
    @IBOutlet weak var lineTopCost: NSLayoutConstraint!
    @IBOutlet weak var imgDelete1: UIImageView!
    
    @IBOutlet weak var viewLineDesc: UIView!
    @IBOutlet weak var lblTextLookingfor: UILabel!
    @IBOutlet weak var heightLookingConst: NSLayoutConstraint!
    @IBOutlet weak var lookingTopConst: NSLayoutConstraint!
    @IBOutlet weak var viewAge: UIView!
    @IBOutlet weak var viewLookingFor: UIView!
    @IBOutlet weak var lblDelete1: UILabel!
    @IBOutlet weak var viewDelate1: UIView!
    
    @IBOutlet weak var lblMessage1: UILabel!
    @IBOutlet weak var viewMessage1: UIView!
    
    @IBOutlet weak var imgMessage1: UIImageView!
    
    @IBOutlet weak var viewHangout: UIView!
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
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    var hangoutId = ""
    var otherUserId = ""
    var hangout_id = ""
    var isLikeUpdate=false
    var appdel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.toConst.constant = -getStatusBarHeight()
        
        self.viewLoc.roundCorners(corners: [.topLeft,.topRight], radius: 10)
        self.viewDesc.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 10)
        self.navigationController?.navigationBar.isHidden=true
        
        self.viewHangout.isHidden=true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.callGetHangoutDetailApi(hangoutId: self.hangoutId)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        .lightContent
    }
    
    @IBAction func BackAct(_ sender: UIButton)
    {
     
        
        if self.appdel.equalsIgnoreCase(string: kAppDelegate) 
        {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=0
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if self.appdel.equalsIgnoreCase(string: kMessage)
        {
            DataManager.comeFrom=kViewProfile
            self.navigationController?.popViewController(animated: true)

        }
        
        else
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
        
       
    }
    
    @IBAction func messgeButtonAction(_ sender: UIButton) {
        
       if self.imgMessage1.image == UIImage(named: "interested")//(self.lblMessage1.text == kInterested)//(self.btnMessage.title(for: .normal) == kInterested) //kLikeProfile
        {
        self.likeUnlikeAPI(hangout_id: self.hangoutId, type: "1")
        //self.btnMessage.setTitle(kNotInterested, for: .normal) //kDislikeProfile
        self.imgMessage1.image = UIImage(named: "notInterested") //redLike3
        self.lblMessage1.text = kInterested//kNotInterested//kDislikeProfile //kLikeProfile
        self.lblMessage1.textColor = LIKECOLOR
        
        
        }
       else if  self.imgMessage1.image == UIImage(named: "notInterested")//HangoutVM.shared.hangoutDetail?.hangout_like_by_self == 0//(self.btnMessage.title(for: .normal) == kNotInterested) //kDislikeProfile
        {
           // self.likeUnlikeAPI(other_user_id: self.otherUserId, action: "2", like_mode: "Shake", type: "Shake")
            self.likeUnlikeAPI(hangout_id: self.hangoutId, type: "2")
        self.imgMessage1.image = UIImage(named: "interested") //BlackLike
        self.lblMessage1.text = kInterested   //kLikeProfile
        self.lblMessage1.textColor = UIColor.black
        }
        
       else if self.lblMessage1.text?.uppercased() == kEdit.uppercased()//(self.btnMessage.title(for: .normal) == kEdit)
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
//            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
//            let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
//            let cellData = HangoutVM.shared.hangoutDetail
//            vc.view_user_id=cellData?.user_id ?? ""
//            vc.profileName=(cellData?.profile_data?.username ?? "").capitalized
//
//            if cellData?.profile_data?.images?.count ?? 0>0
//                {
//                if let img = cellData?.profile_data?.images?[0].image
//                  {
//               vc.profileImage=img
//                }
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func viewProfileAct(_ sender: UIButton) {
        
        
        let userid = HangoutVM.shared.hangoutDetail?.user_id ?? ""
        
        if userid == DataManager.Id
        {

            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=4
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        else if self.appdel == kViewProfile
        {
            if isLikeUpdate
            {
                DataManager.comeFrom=""
            }
            else
            {
                
                DataManager.comeFrom=kViewProfile
            }
            self.navigationController?.popViewController(animated: false)
        }
        else
        {
            let id = HangoutVM.shared.hangoutDetail?.user_id ?? ""
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = id
            vc.likeMode = kHangout
            vc.hangout_id = HangoutVM.shared.hangoutDetail?.hangout_details?._id ?? ""
            DataManager.comeFrom=kEmptyString
             self.navigationController?.pushViewController(vc, animated: true)
//
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
//            DataManager.HomeRefresh="true"
//            let id = HangoutVM.shared.hangoutDetail?.user_id ?? ""
//
//            DataManager.OtherUserId = id
//            DataManager.comeFromTag=6
//            vc.selectedIndex=2
//            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        
       
    }
    
    @IBAction func deleteHangoutAct(_ sender:UIButton)
    {
          
        if self.lblDelete1.text?.uppercased() == kShare.uppercased()//(self.btnDelete.title(for: .normal) == kSHARE)
        {
            let text = ShareHangoutText
            
            // set up activity view controller
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
           // activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        else
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
       
                self.showErrorMessage2(error: error)
            }
            else{
                
                self.imgHangout.contentMode = .scaleAspectFill
                
                self.otherUserId=HangoutVM.shared.hangoutDetail?.user_id ?? ""
                
                let heading = (HangoutVM.shared.hangoutDetail?.hangout_details?.heading ?? "")+" \n"
                let desc = HangoutVM.shared.hangoutDetail?.hangout_details?.description ?? ""
                self.txtViewTitle.customFontText(boldSting: heading, regularSting: desc, fontSize: 16)
                
                self.lblUsername.text = (HangoutVM.shared.hangoutDetail?.profile_data?.username)?.capitalized
                self.txtViewDesc.textColor = UIColor.darkGray
                
                let addDesc = HangoutVM.shared.hangoutDetail?.hangout_details?.aditional_description ?? ""
                
                self.txtViewDesc.text =  addDesc
                
                if addDesc.count>0
                {
                    self.viewLineDesc.isHidden=false
                    self.lineTopCost.constant = 2
                    self.lineButtomConst.constant = 7
                }
                else
                {
                    self.viewLineDesc.isHidden=true
                    self.lineTopCost.constant = 0
                    self.lineButtomConst.constant = 0
                }
                
                self.txtViewDesc.addInterlineSpacing(spacingValue: 9.5)

                
               
                self.lblLocation.text =  HangoutVM.shared.hangoutDetail?.hangout_details?.place ?? ""
               
                
                
                
                if HangoutVM.shared.hangoutDetail?.hangout_like_by_self == 1 //is_liked_by_self_user
                {
                    self.imgMessage1.image = UIImage(named: "notInterested") //redLike3
                    self.lblMessage1.text = kInterested//kNotInterested//kDislikeProfile //kLikeProfile
                    self.lblMessage1.textColor = LIKECOLOR
                }
                else
                {
                    self.imgMessage1.image = UIImage(named: "interested") //BlackLike
                    self.lblMessage1.text = kInterested   //kLikeProfile
                    self.lblMessage1.textColor = UIColor.black
                }
                if HangoutVM.shared.hangoutDetail?.user_id == DataManager.Id
                {
                    self.viewDelate1.isHidden=false
                    self.imgMessage1.image = UIImage(named: "edit")
                    self.lblMessage1.text = kEdit.uppercased()
                    self.lblMessage1.textColor = LINECOLOR
                    
                    self.viewDelate1.isHidden=false
                    self.lblDelete1.text = kDelete.uppercased()
                    self.lblDelete1.textColor = DELETECOLOR
                    self.imgDelete1.image = UIImage(named: "delete")

                    
                }
                else
                {
                    
                    self.viewDelate1.isHidden=false
                    self.lblDelete1.text = kShare.uppercased()
                    self.lblDelete1.textColor = UIColor.black
                    self.imgDelete1.image = UIImage(named: "share_hang")


                }
                

                
                
                
                
//                if HangoutVM.shared.hangoutDetail?.is_liked_by_self_user == 1 && HangoutVM.shared.hangoutDetail?.is_liked_by_other_user_id == 1//.like_dislike?.is_match == 1
//              {
//
//                    self.btnMessage.setTitle(kMessage, for: .normal)
//
//              }
//                else
                
                /*
                
                if HangoutVM.shared.hangoutDetail?.hangout_like_by_self == 1
              {
                 
                    self.lblMessage1.text = kInterested
                   // self.btnMessage.setTitle(kNotInterested, for: .normal) //kDislikeProfile
              }
              else
              {
                
               // self.btnMessage.setTitle(kInterested, for: .normal) //kLikeProfile
                self.lblMessage1.text = kInterested
                
              }
                
                
                if HangoutVM.shared.hangoutDetail?.user_id == DataManager.Id
                {
//                    self.btnDelete.isHidden=false
//                    self.btnMessage.setTitle(kEdit, for: .normal)
//                    self.btnDelete.setTitle(kDelete, for: .normal)
                    
                    self.viewDelate1.isHidden=false
            
                    self.lblMessage1.text = kEdit
                    self.lblDelete1.text = kDelete
                }
                else
                {
//                    self.btnDelete.isHidden=false
//                    self.btnDelete.setTitle(kSHARE, for: .normal)

                    self.viewDelate1.isHidden=false
                    self.lblDelete1.text = kSHARE
                }
                
               */
                
                let userid = HangoutVM.shared.hangoutDetail?.user_id ?? ""
                
                if userid == DataManager.Id
                {
                    
                    
                     //top const = 84
                     
                    let min = HangoutVM.shared.hangoutDetail?.hangout_details?.age_from ?? 18
                    let max = HangoutVM.shared.hangoutDetail?.hangout_details?.age_to ?? kMaxAge
                    self.lblAgeRange.text =  "\(min)" + "-" + "\(max)"
                    
                    
                    let looking = HangoutVM.shared.hangoutDetail?.hangout_details?.looking_for ?? ""
                    
                    if looking.equalsIgnoreCase(string: kBothGender)
                    {
                        self.lblLookingFor.text =  "Male, Female"
                    }
                    else
                    {
                    self.lblLookingFor.text =  HangoutVM.shared.hangoutDetail?.hangout_details?.looking_for ?? ""
                    }
                    self.viewAge.isHidden=false
                    self.lblLookingFor.isHidden=false
                    self.heightLookingConst.constant = 68
                    self.lookingTopConst.constant=84
                    
                    self.lblLookingFor.isHidden=false
                    self.lblAgeRange.isHidden=false
                    self.lblTextLookingfor.isHidden=false

                }
                else
                {
                    self.viewAge.isHidden=true
                    self.lblLookingFor.isHidden=true
                    self.heightLookingConst.constant = 0
                    self.lookingTopConst.constant=4
                    self.lblLookingFor.isHidden=true
                    self.lblAgeRange.isHidden=true
                    self.lblTextLookingfor.isHidden=true

                
                }
                //MARK:- Change due to client feedback
              
            
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
                
                if hangoutType.equalsIgnoreCase(string: kBusiness)
                {
                    self.imgHangoutType.image=UIImage(named: "business")
                    self.lblHangoutType.text = kBusiness.uppercased()
                    self.lblHangoutType.textColor=BUSSINESSTEXRT
                    self.viewHangoutType.backgroundColor = BUSSINESSBACK
                }
                else if hangoutType.equalsIgnoreCase(string: kTravel)
                {
                self.imgHangoutType.image=UIImage(named: "travler")
                self.lblHangoutType.text = kTravel.uppercased()
                
                self.lblHangoutType.textColor=TRAVELTEXRT
                self.viewHangoutType.backgroundColor = TRAVELBACK
                }
                else if hangoutType.equalsIgnoreCase(string: kSports)
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
                    /*
                    let size = self.imgHangout.image?.getImageSizeWithURL(url: img)
                 
                    let height = size?.height ?? 375
                    DispatchQueue.main.async {
                        if height > SCREENHEIGHT
                        {
                            let per = (height*kLongImagePercent)/100
                            
                            self.imgHeightConst.constant = SCREENHEIGHT-120//height-per
                        }
                   else if height > 700
                    {
                        let per = (height*kImagePercent)/100
                        
                        self.imgHeightConst.constant = height-per
                    }
                    else
                    {
                        self.imgHeightConst.constant = size?.height ?? 375
                    }
                        */
                    self.imgHeightConst.constant =  390
                        var cellFrame = self.imgHangout.frame.size
                    self.imgHangout.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.imgHangout.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
                    
                    /*
                        self.imgHangout.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in
                            
                            if theImage != nil
                            {
//                            self.imgHeightConst.constant  = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
//                                print("Height = \(self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!))")
                                
                                let height = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)
                                
                                if height>500
                                {
                                    self.imgHeightConst.constant  = 500
                                }
                            else
                                {
                                    self.imgHeightConst.constant  = height
                                }
                            }
                            else
                            {
                                self.imgHeightConst.constant  = 499
                            }

                            })
                    */
 
                    //self.imgHangout.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                  //}
                    }
                
                
                if HangoutVM.shared.hangoutDetail?.profile_data?.images?.count ?? 0>0
                    {
                    if let img = HangoutVM.shared.hangoutDetail?.profile_data?.images?[0].image
                      {
                        let url = URL(string: img)!
                        DispatchQueue.main.async {
                            self.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
                        }
                      }
                    }
                self.viewHangout.isHidden=false
            }

         
        })
    }
    
    //MARK:-  user like
    
    func likeUnlikeAPI(hangout_id:String,type:String)
    {
        var data = JSONDictionary()
        
        data[ApiKey.kHangout_id] = hangout_id
        data[ApiKey.kIs_like] = type
        data[ApiKey.kTimezone] = TIMEZONE
            if Connectivity.isConnectedToInternet {
              
                self.callApiForLikeUnlike(data: data,type: type)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String)
    {
   
        HangoutVM.shared.callApiLikeDislikeHangout(showIndiacter: false,data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                self.isLikeUpdate=true
              //  self.callGetHangoutDetailApi(hangoutId: self.hangoutId)
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
                
                if self.appdel.equalsIgnoreCase(string: kAppDelegate)
                {
//                    if #available(iOS 13.0, *) {
//                        SCENEDEL?.navigateToHangout()
//                    } else {
//                        // Fallback on earlier versions
//                        APPDEL.navigateToHangout()
//                    }
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
                    vc.selectedIndex=0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if self.appdel.equalsIgnoreCase(string: kMessage)
                {
                    DataManager.comeFrom=kViewProfile
                    self.navigationController?.popViewController(animated: true)

                }
                else
                {
                    DataManager.comeFrom=""
                    self.navigationController?.popViewController(animated: true)
                }
               
            }

         
        })
    }
    
}
extension hangoutDetailsVC:threeDotMenuDelegate,DiscardDelegate
{
    func ClickNameAction(name: String)
    {
       
        if name.equalsIgnoreCase(string: kDelete)
            {
                self.callDeleteHangoutApi(hangout_id: self.hangout_id)
            }
        
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
    
           
    
}
extension hangoutDetailsVC:FeedbackAlertDelegate
{
    func FeedbackAlertOkFunc(name: String)
    {
        
        print(#function)
        print(name)
     if name == kStory
     {
//         if self.appdel.equalsIgnoreCase(string: kMessage)
//        {
//            DataManager.comeFrom=kViewProfile
//            self.navigationController?.popViewController(animated: true)
//        }
//        else
//         {
//            self.navigationController?.popViewController(animated: true)
//         }
        
        if self.appdel.equalsIgnoreCase(string: kAppDelegate)
        {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=0
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if self.appdel.equalsIgnoreCase(string: kMessage)
        {
            DataManager.comeFrom=kViewProfile
            self.navigationController?.popViewController(animated: true)

        }
        
        else
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
     }
    
    }
}
