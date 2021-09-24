//
//  HangoutListVC.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//



import UIKit
import CoreLocation
import MapKit
import GoogleMobileAds
import SDWebImage

class HangoutListVC: BaseVC {
    
    //MARK:- All outlets  
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var tableHangout: UITableView!
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var viewCreate: UIView!

    @IBOutlet weak var lblNoFound: UILabel!
    //MARK:- All Variable
    var adIndex = 5
    var page = 0
    let locationmanager = CLLocationManager()
    var refreshControl = UIRefreshControl()
    var HangoutListArray:[HangoutListTypeModel] = []
    var hangoutTableCell:HangoutUserTCell?
    var hangoutCount = 0
    var toShowLoader=true
    var hangout_id = ""
    var cellHeights = [IndexPath: CGFloat]()
    private var lastContentOffset: CGFloat = 0
    var allCellHeights = [IndexPath : CGFloat]()
    var view_user_id = "1"
    //MARK:- View Lifecycle   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        self.lblNoFound.isHidden=true
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableHangout.addSubview(refreshControl)
      

    }
   

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        self.toShowLoader=true
        //locationmanager.startMonitoringSignificantLocationChanges()
        
        self.viewSort.isHidden=false
        if DataManager.comeFrom != kViewProfile
        {
            self.HangoutListArray.removeAll()
            self.page = 0
            self.adIndex=4
            self.hangoutCount = 0
            self.callGetAllHangoutApi(page: self.page)
            self.updateLocationAPI()
        }
        else
        {
            DataManager.comeFrom = ""
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //
//
//        UIView.performWithoutAnimation {
//            self.tableHangout.beginUpdates()
//            self.tableHangout.reloadData()
//            self.tableHangout.endUpdates()
//            }
    }
   
  
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        self.topStackView.isHidden=true
        self.viewCreate.isHidden=true

        
        self.toShowLoader=false
        HangoutVM.shared.page=0
        self.HangoutListArray.removeAll()
        self.adIndex=4
        self.hangoutCount = 0
        self.callGetAllHangoutApi(page: 0)
    }
    
    @IBAction func SortAct(_ sender:UIButton)
    {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Hangouts", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "HangoutSortVC") as!  HangoutSortVC
        destVC.delegate=self
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(destVC, animated: true, completion: nil)
    }
    //MARK:- Create hangout
    
    
  
    
    
    @IBAction func createHangoutAct(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostHangoutVC") as! PostHangoutVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK:- Tableview setup and show hangout and ads data 

extension HangoutListVC:UITableViewDelegate,UITableViewDataSource
{
    
    
    func setUpTable()
    {
        self.tableHangout.register(UINib(nibName: "HangoutUserTCell", bundle: nil), forCellReuseIdentifier: "HangoutUserTCell")
        
        self.tableHangout.register(UINib(nibName: "StoryAdsTCell", bundle: nil), forCellReuseIdentifier: "StoryAdsTCell")
        self.tableHangout.rowHeight = 100
        self.tableHangout.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableHangout.delegate = self
        self.tableHangout.dataSource = self
        self.tableHangout.remembersLastFocusedIndexPath = true
        self.tableHangout.alwaysBounceVertical = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      //  let count = HangoutListArray.count
        return self.HangoutListArray.count//count+count/5 //
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var CellType:HangoutListTypeModel?
        if self.HangoutListArray.count>indexPath.row
        {
            CellType = self.HangoutListArray[indexPath.row]
        }
        
        
        if CellType?.type == .hangoutList
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HangoutUserTCell") as! HangoutUserTCell
            var cellData:HangoutListDM?
            cellData = self.HangoutListArray[indexPath.row].hangoutData
            cell.lblUsername.text = (cellData?.profile_data?.username)?.capitalized
            
            cell.txtViewDesc.text = cellData?.hangout_details?.description
            
            cell.lblLocation.text=cellData?.hangout_details?.place
            if let time = cellData?.hangout_details?.date
            {
                //let time2 = time.dateFromString(format: .NewISO, type: .utc)
                let date = time.utcToLocalDate(dateStr: time) ?? ""//time2.string(format: .longdateTime2, type: .local)
                
                if let time11 = cellData?.hangout_details?.time
                {
                    // let time12 = time11.dateFromString(format: .NewISO, type: .utc)
                    let date12 = time11.utcToLocalTime(dateStr: time11) ?? ""//time12.string(format: .localTime, type: .local)
                    
                    cell.lblDateTime.text = date+" @ "+date12
                    
                }
                
                
            }
        
            
            let hangoutType = cellData?.hangout_details?.hangout_type ?? ""
            
            if hangoutType.equalsIgnoreCase(string: kBusiness)
            {
                cell.imgHangoutType.image=UIImage(named: "business")
                cell.lblHangoutType.text = kBusiness.uppercased()
                cell.lblHangoutType.textColor=BUSSINESSTEXRT
                cell.viewHangoutType.backgroundColor = BUSSINESSBACK
            }
            else if hangoutType.equalsIgnoreCase(string: kTravel)
            {
                cell.imgHangoutType.image=UIImage(named: "travler")
                cell.lblHangoutType.text = kTravel.uppercased()
                
                cell.lblHangoutType.textColor=TRAVELTEXRT
                cell.viewHangoutType.backgroundColor = TRAVELBACK
            }
            else if hangoutType.equalsIgnoreCase(string: kSports)
            {
                cell.imgHangoutType.image=UIImage(named: "sport-1")
                cell.lblHangoutType.text = kSports.uppercased()
                cell.lblHangoutType.textColor=SPORTTEXRT
                cell.viewHangoutType.backgroundColor = SPORTBACK
            }
            else
            {
                cell.imgHangoutType.image=UIImage(named: "social-1")
                cell.lblHangoutType.text = kSocial.uppercased()
                cell.lblHangoutType.textColor=SOCAILTEXRT
                cell.viewHangoutType.backgroundColor = SOCAILBACK
            }
            
            let heading = (cellData?.hangout_details?.heading ?? "")+" "
            let desc = cellData?.hangout_details?.description ?? ""
            
            cell.txtViewDesc.customFontText(boldSting: heading, regularSting: desc)
        
          
            
            
            if cellData?.profile_data?.images?.count ?? 0>0
            {
                if let img = cellData?.profile_data?.images?[0].image
                {
                    let url = URL(string: img)!
                    DispatchQueue.main.async {
                        cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
                    }
                }
            }
            
            
            if cellData?.hangout_like_by_self == 1 //is_liked_by_self_user
            {
                cell.imgMessage.image = UIImage(named: "notInterested") //redLike3
                cell.lblMessage.text = kInterested//kNotInterested//kDislikeProfile //kLikeProfile
                cell.lblMessage.textColor = LIKECOLOR
            }
            else
            {
                cell.imgMessage.image = UIImage(named: "interested") //BlackLike
                cell.lblMessage.text = kInterested   //kLikeProfile
                cell.lblMessage.textColor = UIColor.black
            }
            if cellData?.hangout_details?.user_id == DataManager.Id
            {
                cell.viewDelete.isHidden=false
                cell.imgMessage.image = UIImage(named: "edit")
                cell.lblMessage.text = "EDIT"
                cell.lblMessage.textColor = LINECOLOR
                
                cell.viewDelete.isHidden=false
                cell.lblDelete.text = "DELETE"
                cell.lblDelete.textColor = DELETECOLOR
                cell.imgDelete.image = UIImage(named: "delete")

                cell.btnThreeDot.isHidden=true
            }
            else
            {
                
                cell.viewDelete.isHidden=false
                cell.lblDelete.text = "SHARE"
                cell.lblDelete.textColor = UIColor.black
                cell.imgDelete.image = UIImage(named: "share_hang")

                cell.btnThreeDot.isHidden=false
            }
           // DispatchQueue.main.async {
            DispatchQueue.main.async {
            if let img = cellData?.hangout_details?.image
            {
                let url = URL(string: img)!
               // let cellFrame = cell.frame.size
                cell.imgHeightConst.constant =  390
              //  cell.imgHangout.sd_imageTransition = SDWebImageTransition.fade

                cell.imgHangout.sd_imageIndicator = SDWebImageActivityIndicator.gray
              
                    
                 //   let image = UIImage(blurHash: "9QN^0d~q", size: cell.imgHangout.frame.size)
                     
                     
                     
                  cell.imgHangout.sd_setImage(with: url, placeholderImage:UIImage(named: "placeholderImage") , options: [], completed: nil) //UIImage(named: "placeholderImage")
                }
                /*
                cell.imgHangout.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { (theImage, error, cache, url) in

                    if theImage != nil
                    {
                        let height = self.getAspectRatioAccordingToiPhones(cellImageFrame: cellFrame,downloadedImage: theImage!)

                        if height>500
                        {
                            cell.imgHeightConst.constant  = 500
                        }
                    else
                        {
                            cell.imgHeightConst.constant  = height

                        }
                        print("Height = \(height)")
                    }
                    else
                    {
                        cell.imgHeightConst.constant = 375
                    }
       })
                */
            }
            
           // }
            
            cell.btnProfile.tag=indexPath.row
            cell.btnMessage.tag=indexPath.row
            cell.btnLocation.tag=indexPath.row
            cell.btnImageTap.tag=indexPath.row
            cell.btnDelete.tag=indexPath.row
            cell.btnThreeDot.tag=indexPath.row
            cell.imgHangout.tag = indexPath.row
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTap(_:)))

            cell.btnImageTap.isUserInteractionEnabled=false

            cell.imgHangout.isUserInteractionEnabled = true
           // cell.imgHangout.tag = indexPath.row
            cell.imgHangout.addGestureRecognizer(tapGestureRecognizer)

            cell.btnMessage.addTarget(self, action: #selector(messageAct), for: .touchUpInside)

            cell.btnProfile.addTarget(self, action: #selector(viewProfileAct), for: .touchUpInside)

            cell.btnImageTap.addTarget(self, action: #selector(imageTap), for: .touchUpInside)

            cell.btnLocation.addTarget(self, action: #selector(LocationAct), for: .touchUpInside)

            cell.btnDelete.addTarget(self, action: #selector(deleteHangoutAct), for: .touchUpInside)

            cell.btnThreeDot.addTarget(self, action: #selector(ThreeDotAct), for: .touchUpInside)
//
            cell.lblLocation.underline()
            cell.btnThreeDot.isHidden=true
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoryAdsTCell") as! StoryAdsTCell
            let width = (cell.bounds.width-300)/2
//                let fram = cell.bounds.height
//
            let  frame = CGRect(origin: CGPoint(x: width, y: 0), size: CGSize(width: 300, height: 600))
            DispatchQueue.main.async
            {
                let bannerView = StoryAdsTCell.cellBannerView(rootVC: self, frame: frame)
                      // let bannerView = StoryAdsTCell.cellBannerView(rootVC: self, frame: cell.bounds)
                   bannerView.adUnitID =  "ca-app-pub-3940256099942544/2934735716"
                   bannerView.load(GADRequest())
                   bannerView.delegate=self
                   bannerView.adSizeDelegate=self
                   
                   for subview in cell.subviews {
                     subview.removeFromSuperview()
                   }
                   cell.backgroundColor=UIColor.black
                   cell.addSubview(bannerView)
            }
       
            return cell
            
            
        }
        

     
       
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var CellType:HangoutListTypeModel?
        if self.HangoutListArray.count>indexPath.row
        {
            CellType = self.HangoutListArray[indexPath.row]
        }
        
        
        if CellType?.type == .hangoutList
        {
            return UITableView.automaticDimension
        }
        else
        {
            return 600//SCREENWIDTH
        }
        
    }

    //MARK:- Table Button action 
    
    @objc func messageAct(_ sender:UIButton)
    {
       
        
        if self.HangoutListArray.count>sender.tag
        {
            let modelHangout = self.HangoutListArray[sender.tag].hangoutData
            
            
            if modelHangout?.hangout_details?.user_id == DataManager.Id
            {
                let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PostHangoutVC") as! PostHangoutVC
            
                
                vc.HangoutDetail=modelHangout?.hangout_details
                vc.fromEdit=true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else
            {
                /*
            
            
//            if (modelHangout.is_liked_by_self_user == 1) && (modelHangout.is_liked_by_other_user_id == 1)
//            {
//                let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
//                let vc = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
//                let cellData = modelHangout
//                vc.view_user_id=cellData.user_id ?? ""
//                vc.profileName=(cellData.profile_data?.username ?? "").capitalized
//
//                if cellData.profile_data?.images?.count ?? 0>0
//                    {
//                    if let img = cellData.profile_data?.images?[0].image
//                      {
//                   vc.profileImage=img
//                    }
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
//
//
//            }
//            else
            if modelHangout.is_liked_by_other_user_id == 1
            {
               
                self.HangoutListArray[sender.tag].hangout_like_by_self = modelHangout.hangout_like_by_self == 1 ? 0 : 1
                for (index, model) in self.HangoutListArray.enumerated(){
                    
                    if model.user_id == modelHangout.user_id{
                        self.HangoutListArray[index].hangout_like_by_self = self.HangoutListArray[sender.tag].hangout_like_by_self
                    }
                }
                
                tableHangout.reloadData()
                let likeSelfId = modelHangout.hangout_like_by_self ?? 0
                
            let hangoutId = modelHangout.hangout_details?._id ?? ""
                
            let valueLike = String(likeSelfId + 1)
            self.likeUnlikeAPI(hangout_id: hangoutId, type: "\(valueLike)")
                
                if valueLike == "1"
                {
                    let imag = modelHangout.profile_data?.images
                    let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MatchVC") as!  MatchVC
                    if imag?.count ?? 0>0
                    {
                        vc.user2Image=imag?[0].image ?? ""
                    }
    //                vc.profileImage=self.other_user_image
    //                vc.view_user_id=self.other_user_id
    //                vc.profileName=(self.UserData?.profile_data?.username ?? "").capitalized
                  //  self.navigationController?.present(vc, animated: true, completion: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
              
                }
            }
            
            else
            {
            
            */
            
                self.HangoutListArray[sender.tag].hangoutData?.hangout_like_by_self = modelHangout?.hangout_like_by_self == 1 ? 0 : 1
                let status =  self.HangoutListArray[sender.tag].hangoutData?.hangout_like_by_self
                for (index, model) in self.HangoutListArray.enumerated(){
                
                    if model.hangoutData?.hangout_details?._id == modelHangout?.hangout_details?._id
                    {
                        self.HangoutListArray[index].hangoutData?.hangout_like_by_self = status //self.HangoutListArray[sender.tag].hangoutData?.hangout_like_by_self
                    }
            }
            
//                UIView.performWithoutAnimation {
//                    let loc = tableHangout.contentOffset
//                    tableHangout.reloadRows(at: [0...<self.HangoutListArray.count], with: .none)
//                    tableHangout.contentOffset = loc
//                }
                
            tableHangout.reloadData()
                let likeSelfId = modelHangout?.hangout_like_by_self ?? 0
                let hangoutId = modelHangout?.hangout_details?._id ?? ""
                
            let valueLike = String(likeSelfId + 1)
            self.likeUnlikeAPI(hangout_id: hangoutId, type: "\(valueLike)")
            //}
        
        }
        }
        
    }
    @objc func viewProfileAct(_ sender:UIButton)
    {
        
        if self.HangoutListArray.count>sender.tag
        {
            let userid = self.HangoutListArray[sender.tag].hangoutData?.user_id ?? ""
            
            if userid == DataManager.Id
            {

                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
                vc.selectedIndex=4
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
            else
            {
                let id =  self.HangoutListArray[sender.tag].hangoutData?.user_id ?? ""
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = id
            vc.hangout_id =  self.HangoutListArray[sender.tag].hangoutData?.hangout_details?._id ?? ""
            vc.likeMode=kHangout
            vc.comeFrom=kHangout
        vc.isfromHangoutListing=true
            self.navigationController?.pushViewController(vc, animated: true)

            }
        }
    }
    
    
    @objc func deleteHangoutAct(_ sender:UIButton)
    {
        
        if self.HangoutListArray.count>sender.tag
        {
            let cellData = self.HangoutListArray[sender.tag].hangoutData

            let id = cellData?.hangout_details?.user_id ?? ""
            
            if id == DataManager.Id
            {
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
                destVC.delegate=self
                self.hangout_id=cellData?.hangout_details?._id ?? ""
                destVC.type = .deleteHangout
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.present(destVC, animated: true, completion: nil)
            }
            else
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
        }
    }
    
    
    
    @objc func ThreeDotAct(_ sender:UIButton)
    {
       
        if self.HangoutListArray.count>sender.tag
        {
           
          
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
                destVC.delegate=self
                
            self.view_user_id = self.HangoutListArray[sender.tag].hangoutData?.user_id ?? ""
            destVC.post_id = self.HangoutListArray[sender.tag].hangoutData?.hangout_details?._id ?? ""
            destVC.user_name = self.HangoutListArray[sender.tag].hangoutData?.profile_data?.username?.capitalized ?? ""
                
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                 self.present(destVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    @objc func imageTap(_ sender:AnyObject)
    {
        print("you tap image number: \(sender.view.tag)")
let tag = sender.view.tag
        
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "hangoutDetailsVC") as! hangoutDetailsVC
        if self.HangoutListArray.count>=tag
        {
            let cellData = self.HangoutListArray[tag].hangoutData

            vc.hangoutId=cellData?.hangout_details?._id ?? ""

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func LocationAct(_ sender:UIButton)
    {
        
        if self.HangoutListArray.count>sender.tag
        {
          
            let lat = self.HangoutListArray[sender.tag].hangoutData?.hangout_details?.latitude ?? 30.123
            let long = self.HangoutListArray[sender.tag].hangoutData?.hangout_details?.longitude ?? 76.123
            let place = self.HangoutListArray[sender.tag].hangoutData?.hangout_details?.place ?? ""
            
            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CURRENTLAT, longitude: CURRENTLONG)))
            source.name = "Source"
            
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)))
            destination.name = place
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
       // self.topStackView.isHidden=false
        

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {


        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
                   //print("up")
            if self.toShowLoader==false
            {
                self.topStackView.isHidden=true
                self.viewCreate.isHidden=true

            }
            else
            {
                self.topStackView.isHidden=false
                self.viewCreate.isHidden=false

            }

               }
               else {
                  // print("down")
                self.topStackView.isHidden=true
                self.viewCreate.isHidden=true

               }
        
//        if (self.lastContentOffset > scrollView.contentOffset.y) {
//                // move up
//            self.topStackView.isHidden=true
//
//            }
//            else if (self.lastContentOffset < scrollView.contentOffset.y) {
//               // move down
//                self.topStackView.isHidden=false
//
//            }
//
//            // update the new position acquired
//            self.lastContentOffset = scrollView.contentOffset.y
        
        }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       // self.topStackView.isHidden=false
        print(#function)
        
        if ((tableHangout.contentOffset.y + tableHangout.frame.size.height) >= tableHangout.contentSize.height-50)
        {
            if self.hangoutCount<HangoutVM.shared.Pagination_Details?.totalCount ?? 0
            {
                self.callGetAllHangoutApi(page: self.page)
            }
            
        }
        
    }
}
//MARK:- Get current location 

extension HangoutListVC: CLLocationManagerDelegate
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
//MARK:-  delete hangout popup delegate 

extension HangoutListVC:threeDotMenuDelegate,DiscardDelegate
{
    func ClickNameAction(name: String)
    {
        if name.equalsIgnoreCase(string: kReportPost)
        {
            self.dismiss(animated:true) {
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "BlockReportPopUpVC") as!  BlockReportPopUpVC                
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

                self.navigationController?.pushViewController(destVC, animated: false)
                
            }
           
        }
        else  if name.equalsIgnoreCase(string: kViewProfile)
        {
    
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = self.view_user_id
            vc.hangout_id = self.hangout_id
            vc.likeMode=kHangout
           DataManager.comeFrom=kStory
            vc.comeFrom=kHangout
            vc.isfromHangoutListing=true
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        else  if name.equalsIgnoreCase(string: kDelete) 
            {
                self.callDeleteHangoutApi(hangout_id: self.hangout_id)
            }
        
    }
    
    
}

//MARK:- get hangout and like dislike profile, delete hangout api call 

extension HangoutListVC:SortHangoutDelegate
{
 
    func SortHangoutOption() {
    
        self.HangoutListArray.removeAll()
        self.page = 0
        self.adIndex=4
        self.hangoutCount = 0
        self.callGetAllHangoutApi(page: self.page)
        
    }
    
    
    func callGetAllHangoutApi(page: Int)
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
        
        print("Hangout para = \(data)")
        if Connectivity.isConnectedToInternet {
            
            self.callApiForGetHangout(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForGetHangout(data:JSONDictionary)
    {
        HangoutVM.shared.callApiGetOtherHangout(showIndiacter: self.toShowLoader, data: data, response: { (message, error) in
            
            if error != nil
            {
                self.topStackView.isHidden=false
                self.viewCreate.isHidden=false

                self.showErrorMessage(error: error)
            }
            else{
                Indicator.sharedInstance.showIndicator()
                self.hangoutCount = self.hangoutCount + HangoutVM.shared.hangoutOtherDataArray.count
                for dict in HangoutVM.shared.hangoutOtherDataArray
                {
                    if  self.HangoutListArray.count == self.adIndex
                    {
                        self.HangoutListArray.append(HangoutListTypeModel.init(type: .ads))
                        self.adIndex = self.adIndex + 5
                    }
                    self.HangoutListArray.append(HangoutListTypeModel.init(type: .hangoutList, hangoutData: dict))
                    
                }
                self.toShowLoader=true
                
               // self.topStackView.isHidden=false
                self.refreshControl.endRefreshing()
                HangoutVM.shared.page=self.page
                
                self.page = self.hangoutCount//self.HangoutListArray.count
                
                if self.HangoutListArray.count>0
                {
                    self.lblNoFound.isHidden=true
                }
                else
                {
                    self.lblNoFound.isHidden=false
                }
                self.topStackView.isHidden=false

                self.viewCreate.isHidden=false

               self.tableHangout.reloadData()

           
                //DispatchQueue.main.async {

                     //   self.tableHangout.reloadData()

                      //  self.tableHangout.setNeedsLayout()
                       // self.tableHangout.layoutIfNeeded()

                       // self.tableHangout.reloadData()

                   // }
                
                Indicator.sharedInstance.hideIndicator()
                
                UIView.performWithoutAnimation {

                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
                        self.tableHangout.isHidden = false
                        self.tableHangout.reloadData()
                    })
                
            }
            }
            
            
        })
    }
    
    //MARK:-  user like dislike
    
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
 
                self.HangoutListArray.removeAll()
                self.page=0
                self.adIndex=4
                self.hangoutCount = 0
              self.callGetAllHangoutApi(page: self.page)
                
                
            }

         
        })
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
                
                print("Location update api = \(message)")
                
            })
        }
        
    
    
}
//MARK:- Ads setup 

extension HangoutListVC:GADBannerViewDelegate,GADAdSizeDelegate
{
    func adView(_ bannerView: GADBannerView, willChangeAdSizeTo size: GADAdSize) {
        print("Banner loaded successfull \(size)")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
      
        
    }
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError)
//    {
//        print("adView:didFailToReceiveAdWithError: \(error)")
//
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

