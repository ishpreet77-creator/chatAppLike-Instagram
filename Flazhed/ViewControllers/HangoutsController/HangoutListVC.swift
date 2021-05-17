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

class HangoutListVC: BaseVC {
    
    //MARK:- All outlets  🍎
    @IBOutlet weak var tableHangout: UITableView!
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var lblNoFound: UILabel!
    //MARK:- All Variable  🍎
    var page = 0
    let locationmanager = CLLocationManager()
    var refreshControl = UIRefreshControl()
    var HangoutListArray:[HangoutListDM] = []
    var hangoutTableCell:HangoutUserTCell?
    var toShowLoader=true
    var hangout_id = ""
    
    //MARK:- View Lifecycle   🍎
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
  
        self.viewSort.isHidden=false
        if DataManager.comeFrom != kViewProfile
        {
            self.HangoutListArray.removeAll()
            self.page = 0
            self.callGetAllHangoutApi(page: self.page)
        }
        else
        {
            DataManager.comeFrom = ""
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        self.viewSort.isHidden=true
        self.toShowLoader=false
        HangoutVM.shared.page=0
        self.HangoutListArray.removeAll()

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
}
//MARK:- Tableview setup and show hangout and ads data 🍎

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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = HangoutListArray.count
        return count+count/5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HangoutUserTCell") as! HangoutUserTCell
        var cellData:HangoutListDM?
        if indexPath.row % 5 == 0
        {
            if indexPath.row == 0
            {
                if self.HangoutListArray.count>0
                {
                    cellData = self.HangoutListArray[0]
                }
                cell.btnProfile.tag=0
                cell.btnMessage.tag=0
                cell.btnLocation.tag=0
                cell.btnImageTap.tag=0
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoryAdsTCell") as! StoryAdsTCell
               // DispatchQueue.main.async {
                    let bannerView = StoryAdsTCell.cellBannerView(rootVC: self, frame: cell.bounds)
                    
                    for subview in cell.viewAds.subviews {
                        subview.removeFromSuperview()
                  //  }
                    
                    cell.addSubview(bannerView)
                    
                }
                return cell
                
            }
        }
        else
        {
            var tag = 1
            
            if indexPath.row > (indexPath.row/5)
            {
                tag=indexPath.row-(indexPath.row/5)
            }
            else
            {
                tag = indexPath.row
            }
            if self.self.HangoutListArray.count>tag
            {
                cellData = self.HangoutListArray[tag]
            }
            else
            {
                if self.HangoutListArray.count>0
                {
                    cellData = self.HangoutListArray[0]
                }
            }
            cell.btnProfile.tag=tag
            cell.btnMessage.tag=tag
            cell.btnLocation.tag=tag
            cell.btnImageTap.tag=tag
        }
        
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
        
        
//        if cellData?.is_liked_by_self_user == 1 &&  cellData?.is_liked_by_other_user_id == 1
//        {
//            cell.imgMessage.image = UIImage(named: "Message")
//            cell.lblMessage.text = kMessage
//            cell.lblMessage.textColor = LINECOLOR
//        }
//        else
        if cellData?.is_liked_by_self_user == 1
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
        
        
        let hangoutType = cellData?.hangout_details?.hangout_type ?? ""
        
        if hangoutType == kBusiness
        {
            cell.imgHangoutType.image=UIImage(named: "business")
            cell.lblHangoutType.text = kBusiness.uppercased()
            cell.lblHangoutType.textColor=BUSSINESSTEXRT
            cell.viewHangoutType.backgroundColor = BUSSINESSBACK
        }
        else if hangoutType == kTravel
        {
            cell.imgHangoutType.image=UIImage(named: "travler")
            cell.lblHangoutType.text = kTravel.uppercased()
            
            cell.lblHangoutType.textColor=TRAVELTEXRT
            cell.viewHangoutType.backgroundColor = TRAVELBACK
        }
        else if hangoutType == kSports
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
        
        
        if let img = cellData?.hangout_details?.image
        {
            let url = URL(string: img)!
            DispatchQueue.main.async {
                cell.imgHangout.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
            }
        }
        
        if cellData?.profile_data?.images?.count ?? 0>0
        {
            if let img = cellData?.profile_data?.images?[0].image
            {
                let url = URL(string: img)!
                DispatchQueue.main.async {
                    cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                }
            }
        }
        
        
        
        if cellData?.hangout_details?.user_id == DataManager.Id
        {
            cell.viewDelete.isHidden=false
            cell.imgMessage.image = UIImage(named: "edit")
            cell.lblMessage.text = "EDIT"
            cell.lblMessage.textColor = LINECOLOR
        }
        else
        {
            
            cell.viewDelete.isHidden=true
    
        }
        
        
        
        
        cell.btnMessage.addTarget(self, action: #selector(messageAct), for: .touchUpInside)
        
        cell.btnProfile.addTarget(self, action: #selector(viewProfileAct), for: .touchUpInside)
        
        cell.btnImageTap.addTarget(self, action: #selector(imageTap), for: .touchUpInside)
        
        cell.btnLocation.addTarget(self, action: #selector(LocationAct), for: .touchUpInside)
        
        cell.btnDelete.addTarget(self, action: #selector(deleteHangoutAct), for: .touchUpInside)
        
        cell.lblLocation.underline()

        return cell
        
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row%5==0
        {
            if indexPath.row == 0
            {
                return UITableView.automaticDimension
            }
            else
            {
                return 500
            }
            
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    //MARK:- Table Button action 🍎
    
    @objc func messageAct(_ sender:UIButton)
    {
        if self.HangoutListArray.count>sender.tag
        {
            let modelHangout = self.HangoutListArray[sender.tag]
            
            
            if modelHangout.hangout_details?.user_id == DataManager.Id
            {
                let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "PostHangoutVC") as! PostHangoutVC
            
                
                vc.HangoutDetail=modelHangout.hangout_details
                vc.fromEdit=true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else
            {
            
            
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
               
                self.HangoutListArray[sender.tag].is_liked_by_self_user = modelHangout.is_liked_by_self_user == 1 ? 0 : 1
                for (index, model) in self.HangoutListArray.enumerated(){
                    
                    if model.user_id == modelHangout.user_id{
                        self.HangoutListArray[index].is_liked_by_self_user = self.HangoutListArray[sender.tag].is_liked_by_self_user
                    }
                }
                
                tableHangout.reloadData()
                let likeSelfId = modelHangout.is_liked_by_self_user ?? 0
                    
                let valueLike = String(likeSelfId + 1)
                self.likeUnlikeAPI(other_user_id: modelHangout.user_id!, action: valueLike, like_mode: "Shake", type: "Shake")
                
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
            
            
            self.HangoutListArray[sender.tag].is_liked_by_self_user = modelHangout.is_liked_by_self_user == 1 ? 0 : 1
            for (index, model) in self.HangoutListArray.enumerated(){
                
                if model.user_id == modelHangout.user_id{
                    self.HangoutListArray[index].is_liked_by_self_user = self.HangoutListArray[sender.tag].is_liked_by_self_user
                }
            }
            
            tableHangout.reloadData()
            let likeSelfId = modelHangout.is_liked_by_self_user ?? 0
                
            let valueLike = String(likeSelfId + 1)
            self.likeUnlikeAPI(other_user_id: modelHangout.user_id!, action: valueLike, like_mode: "Shake", type: "Shake")
            }
        
        }
        }
        
    }
    @objc func viewProfileAct(_ sender:UIButton)
    {
        
        if self.HangoutListArray.count>sender.tag
        {
            
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
            vc.view_user_id = self.HangoutListArray[sender.tag].user_id ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func deleteHangoutAct(_ sender:UIButton)
    {
        
        if self.HangoutListArray.count>sender.tag
        {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
            destVC.delegate=self
            let cellData = self.HangoutListArray[sender.tag]
            self.hangout_id=cellData.hangout_details?._id ?? ""
            destVC.type = .deleteHangout
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func imageTap(_ sender:UIButton)
    {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "hangoutDetailsVC") as! hangoutDetailsVC
        if self.HangoutListArray.count>sender.tag
        {
            let cellData = self.HangoutListArray[sender.tag]
            
            vc.hangoutId=cellData.hangout_details?._id ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func LocationAct(_ sender:UIButton)
    {
        
        if self.HangoutListArray.count>sender.tag
        {
          
            let lat = self.HangoutListArray[sender.tag].hangout_details?.latitude ?? 30.123
            let long = self.HangoutListArray[sender.tag].hangout_details?.longitude ?? 76.123
            let place = self.HangoutListArray[sender.tag].hangout_details?.place ?? ""
            
            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CURRENTLAT, longitude: CURRENTLONG)))
            source.name = "Source"
            
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)))
            destination.name = place
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((tableHangout.contentOffset.y + tableHangout.frame.size.height) >= tableHangout.contentSize.height-50)
        {
            if self.HangoutListArray.count<HangoutVM.shared.Pagination_Details?.totalCount ?? 0
            {
                self.callGetAllHangoutApi(page: self.page)
            }
            
        }
        
    }
}
//MARK:- Get current location 🍎

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
//MARK:-  delete hangout popup delegate 🍎

extension HangoutListVC:threeDotMenuDelegate,DiscardDelegate
{
    func ClickNameAction(name: String)
    {
        if name == kReportPost
        {
            self.dismiss(animated:true) {
                let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                let destVC = storyboard.instantiateViewController(withIdentifier: "BlockReportPopUpVC") as!  BlockReportPopUpVC
                
                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            
        }
          else  if name == kDelete
            {
                self.callDeleteHangoutApi(hangout_id: self.hangout_id)
            }
        
    }
    
    
}

//MARK:- get hangout and like dislike profile, delete hangout api call 🍎

extension HangoutListVC:SortHangoutDelegate
{
 
    func SortHangoutOption() {
    
        self.HangoutListArray.removeAll()
        self.page = 0
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
        HangoutVM.shared.callApiGetOtherHangout(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.viewSort.isHidden=false
                self.showErrorMessage(error: error)
            }
            else{
                self.viewSort.isHidden=false
                for dict in HangoutVM.shared.hangoutOtherDataArray
                {
                    
                    self.HangoutListArray.append(dict)
                    
                }
                
                Indicator.sharedInstance.hideIndicator()
                self.refreshControl.endRefreshing()
                HangoutVM.shared.page=self.page
                
                self.page = self.HangoutListArray.count
                
                if self.HangoutListArray.count>0
                {
                    self.lblNoFound.isHidden=true
                }
                else
                {
                    self.lblNoFound.isHidden=false
                }
                
                self.tableHangout.reloadData()
                
                
            }
            
            
        })
    }
    
    //MARK:-  user like dislike
    
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
              self.callGetAllHangoutApi(page: self.page)
                
                
            }

         
        })
    }

    
}
//MARK:- Ads setup 🍎

extension HangoutListVC:GADBannerViewDelegate
{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        Indicator.sharedInstance.hideIndicator()
        
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError)
    {
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
