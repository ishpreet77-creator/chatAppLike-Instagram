//
//  MyHangoutVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//

import UIKit
import CoreLocation
import MapKit
import SDWebImage
import SkeletonView

class MyHangoutVC: BaseVC {
    //MARK: - All outlets  
    
    @IBOutlet weak var topIconConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tableHangout: UITableView!
    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var viewSocial: UIView!
    @IBOutlet weak var viewTravel: UIView!
    @IBOutlet weak var viewSport: UIView!
    @IBOutlet weak var viewBusiness: UIView!
    @IBOutlet weak var imgSocial: UIImageView!
    @IBOutlet weak var imgTravel: UIImageView!
    @IBOutlet weak var imgSport: UIImageView!
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var btnCreateHangout: UIButton!

    //MARK: - All Variable  
    
    var refreshControl = UIRefreshControl()
    var fromCreateHangout=false
    var page = 0
    var hangout_id = ""
    var MyHangoutData:[HangoutDataModel] = []
    let locationmanager = CLLocationManager()
    var hagoutTYpe=""
    
    var fromDelete=false
    
    //MARK: - View Lifecycle   
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewHeader.isHidden=true
        self.viewEmptyList.isHidden=true
        self.setUpTable()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableHangout.addSubview(refreshControl)
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //locationmanager.startMonitoringSignificantLocationChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if DataManager.fromHangout==kCreate
        {
            
            if self.hagoutTYpe.equalsIgnoreCase(string: kTravel)
            {
                self.viewSocial.backgroundColor=UIColor.white
                self.viewSport.backgroundColor=UIColor.white
                self.viewTravel.backgroundColor=TRAVELBACK
                self.viewBusiness.backgroundColor=UIColor.white
          
                self.imgTravel.image = self.imgTravel.image?.tinted(color:  TRAVELTEXRT)
                self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                self.imgSocial.image = self.imgSocial.image?.tinted(color:   UIColor.lightGray)
                
                
                hagoutTYpe=kTravel
             
                if DataManager.comeFrom != kViewProfile
                {
                    self.page = 0
                 
                    self.MyHangoutData.removeAll()
                    self.callGetHangoutApi(page: self.page)
                }
                else
                {
                    DataManager.comeFrom = ""
                }
            }
            else if self.hagoutTYpe.equalsIgnoreCase(string: kSports)
            {
            self.viewSocial.backgroundColor=UIColor.white
            self.viewSport.backgroundColor=SPORTBACK
            self.viewTravel.backgroundColor=UIColor.white
            self.viewBusiness.backgroundColor=UIColor.white
            
            self.imgSport.image = self.imgSport.image?.tinted(color:  SPORTTEXRT)
            self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
            self.imgSocial.image = self.imgSocial.image?.tinted(color:   UIColor.lightGray)
            self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)

            
            hagoutTYpe=kSports
            if DataManager.comeFrom != kViewProfile
            {
                self.page = 0
             
          
                self.MyHangoutData.removeAll()
                self.callGetHangoutApi(page: self.page)
            }
            else
            {
                DataManager.comeFrom = ""
            }
           }
            else if self.hagoutTYpe.equalsIgnoreCase(string: kBusiness)
            {
            self.viewSocial.backgroundColor=UIColor.white
            self.viewSport.backgroundColor=UIColor.white
            self.viewTravel.backgroundColor=UIColor.white
            self.viewBusiness.backgroundColor=BUSSINESSBACK
            
            self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  BUSSINESSTEXRT)
            self.imgSport.image = self.imgSport.image?.tinted(color:   UIColor.lightGray)
            self.imgSocial.image = self.imgSocial.image?.tinted(color:   UIColor.lightGray)
            self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)

            
            
            hagoutTYpe=kBusiness
            if DataManager.comeFrom != kViewProfile
            {
                self.page = 0
             
            
                self.MyHangoutData.removeAll()
                self.callGetHangoutApi(page: self.page)
            }
            else
            {
                DataManager.comeFrom = ""
            }
           }
            else if self.hagoutTYpe.equalsIgnoreCase(string: kSocial)
           {
            self.viewSocial.backgroundColor=SOCAILBACK
            self.viewSport.backgroundColor=UIColor.white
            self.viewTravel.backgroundColor=UIColor.white
            self.viewBusiness.backgroundColor=UIColor.white
            
         
            self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
            self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
            self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
            self.imgSocial.image = self.imgSocial.image?.tinted(color:  SOCAILTEXRT)
            
            hagoutTYpe=kSocial
          
            if DataManager.comeFrom != kViewProfile
            {
                self.page = 0
             
             
                self.MyHangoutData.removeAll()
                self.callGetHangoutApi(page: self.page)
            }
            else
            {
                DataManager.comeFrom = ""
            }
            
           }
            else
            {
//                self.viewSocial.backgroundColor=UIColor.white//SOCAILBACK
//                self.viewSport.backgroundColor=UIColor.white
//                self.viewTravel.backgroundColor=UIColor.white
//                self.viewBusiness.backgroundColor=UIColor.white
//
//
//                self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
//                self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
//                self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
//                self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)//SOCAILTEXRT)
                

            if DataManager.comeFrom != kViewProfile
            {
                self.page = 0
            
                self.MyHangoutData.removeAll()
                self.callGetHangoutApi(page: self.page)
            }
            else
            {
                DataManager.comeFrom = ""
            }
            }
            DataManager.fromHangout=""
        }
        else
        {
        
//            self.viewSocial.backgroundColor=UIColor.white//SOCAILBACK
//            self.viewSport.backgroundColor=UIColor.white
//            self.viewTravel.backgroundColor=UIColor.white
//            self.viewBusiness.backgroundColor=UIColor.white
//
//
//            self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
//            self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
//            self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
//            self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)//SOCAILTEXRT)
//

        if DataManager.comeFrom != kViewProfile
        {
            self.page = 0
    
            self.MyHangoutData.removeAll()
            self.callGetHangoutApi(page: self.page)
        }
        else
        {
            DataManager.comeFrom = ""
        }
            
       }
        
//        if self.getDeviceModel() == "iPhone 6"
//        {
//            self.topConst.constant = STATUSBARHEIGHT
//        }
//        else if self.getDeviceModel() == "iPhone 8+"
//        {
//            self.topConst.constant = TOPSPACING
//        }
//        else
//        {
//            self.topConst.constant = TOPSPACING
//        }
        
    }
    @objc func refresh(_ sender: AnyObject) {
     
        if Connectivity.isConnectedToInternet {
            HangoutVM.shared.page=0
            self.MyHangoutData.removeAll()
     
            self.callGetHangoutApi(page: 0)
         } else {
             
             self.refreshControl.endRefreshing()
             self.tableHangout.contentOffset = CGPoint.zero
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
       
    }
    //MARK: - back button action  
    
    @IBAction func BackAct(_ sender: UIButton)
    {
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "OldTapControllerVC") as! OldTapControllerVC
//        vc.selectedIndex=4
//        DataManager.comeFrom = kViewProfile
//        self.navigationController?.pushViewController(vc, animated: false)
        
        DataManager.comeFrom = kViewProfile
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func editAct(_ sender: UIButton)
    {
        let vc = PostHangoutVC.instantiate(fromAppStoryboard: .Hangouts)

        let cellData = self.MyHangoutData[sender.tag]
        
        vc.HangoutDetail=cellData
        vc.fromEdit=true
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
    
    @objc func deleteAct(_ sender: UIButton)
    {
        
        let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)
        destVC.delegate=self
        let cellData = self.MyHangoutData[sender.tag]
        self.hangout_id=cellData._id ?? ""
        destVC.type = .deleteHangout
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
    
    @IBAction func createHangoutAct(_ sender: UIButton)
    {
        let vc = PostHangoutVC.instantiate(fromAppStoryboard: .Hangouts)
        self.navigationController?.pushViewController(vc, animated: true)
    }
   //MARK: - Filter button action  
    
    @IBAction func SocialAct(_ sender: UIButton)
    {
        self.viewSocial.backgroundColor=SOCAILBACK
        self.viewSport.backgroundColor=UIColor.white
        self.viewTravel.backgroundColor=UIColor.white
        self.viewBusiness.backgroundColor=UIColor.white
        self.fromDelete=false

     
        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
        self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
        self.imgSocial.image = self.imgSocial.image?.tinted(color:  SOCAILTEXRT)
        
        hagoutTYpe=kSocial
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    @IBAction func travelAct(_ sender: UIButton)
    {
        self.viewSocial.backgroundColor=UIColor.white
        self.viewSport.backgroundColor=UIColor.white
        self.viewTravel.backgroundColor=TRAVELBACK
        self.viewBusiness.backgroundColor=UIColor.white
        self.fromDelete=false

        self.imgTravel.image = self.imgTravel.image?.tinted(color:  TRAVELTEXRT)
        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
        self.imgSocial.image = self.imgSocial.image?.tinted(color:   UIColor.lightGray)
        
        
        hagoutTYpe=kTravel
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    @IBAction func sportAct(_ sender: UIButton)
    {
        self.viewSocial.backgroundColor=UIColor.white
        self.viewSport.backgroundColor=SPORTBACK
        self.viewTravel.backgroundColor=UIColor.white
        self.viewBusiness.backgroundColor=UIColor.white
        self.fromDelete=false

        self.imgSport.image = self.imgSport.image?.tinted(color:  SPORTTEXRT)
        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
        self.imgSocial.image = self.imgSocial.image?.tinted(color:   UIColor.lightGray)
        self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)

        
        hagoutTYpe=kSports
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    @IBAction func businessAct(_ sender: UIButton)
    {
        self.viewSocial.backgroundColor=UIColor.white
        self.viewSport.backgroundColor=UIColor.white
        self.viewTravel.backgroundColor=UIColor.white
        self.viewBusiness.backgroundColor=BUSSINESSBACK
        self.fromDelete=false

        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  BUSSINESSTEXRT)
        self.imgSport.image = self.imgSport.image?.tinted(color:   UIColor.lightGray)
        self.imgSocial.image = self.imgSocial.image?.tinted(color:   UIColor.lightGray)
        self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)

        
        
        hagoutTYpe=kBusiness
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    
    func showLoader()
    {
        self.tableHangout.showAnimatedGradientSkeleton()
        //self.viewSport.isSkeletonable=true
       // self.viewSocial.isSkeletonable=true
        
        self.viewHeader.clipsToBounds=true
        self.btnCreateHangout.clipsToBounds=true
        self.viewHeader.isSkeletonable=true
      
       
       // self.viewSport.showAnimatedGradientSkeleton()
        self.viewHeader.showAnimatedGradientSkeleton()
        self.btnCreateHangout.showAnimatedGradientSkeleton()
       
    

    }
    func hideLoader()
    {
        self.tableHangout.hideSkeleton()
        self.viewHeader.hideSkeleton()
        //self.viewSocial.hideSkeleton()
        self.btnCreateHangout.hideSkeleton()
     

    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

            if ((tableHangout.contentOffset.y + tableHangout.frame.size.height) >= tableHangout.contentSize.height-50)
            {
                if self.MyHangoutData.count<HangoutVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    self.callGetHangoutApi(page: self.page)
                }
                
            }
   
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint(#function)
        self.btnCreateHangout.isHidden=false
        

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if self.MyHangoutData.count>0
        {
            self.btnCreateHangout.isHidden=false

        }
        else
        {
            self.btnCreateHangout.isHidden=false

        }
        
        }
    
}

//MARK: - delete hangout delegate  

extension MyHangoutVC:DiscardDelegate
{
    func ClickNameAction(name: String)
    {
        debugPrint(name)
        if name.equalsIgnoreCase(string: kDelete)
        {
            self.callDeleteHangoutApi(hangout_id: self.hangout_id)
        }
    }
    
    
}
//MARK: - Tableview  setup and show my hangout data 

extension MyHangoutVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SkeletonTableViewDataSource
{
   
    
    func setUpTable()
    {
        
        self.tableHangout.register(UINib(nibName: "MyHangoutTCell", bundle: nil), forCellReuseIdentifier: "MyHangoutTCell")
        self.tableHangout.rowHeight = 100
        self.tableHangout.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableHangout.delegate = self
        self.tableHangout.dataSource = self
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        
        return "MyHangoutTCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "MyHangoutTCell") as! MyHangoutTCell
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MyHangoutData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHangoutTCell") as! MyHangoutTCell
        var cellData:HangoutDataModel?
        
        if self.MyHangoutData.count>indexPath.row
        {
            cellData = self.MyHangoutData[indexPath.row]

        }
        cell.txtDesc.text=cellData?.aditional_description
     
        let heading = (cellData?.heading ?? "")+" "
        let desc = cellData?.description ?? ""
        cell.txtTitle.customFontText(boldSting: heading, regularSting: desc)
        cell.lblLocation.text=cellData?.place
        
        
        let hangoutType = cellData?.hangout_type ?? ""
        
        if hangoutType.equalsIgnoreCase(string: kBusiness)
        {
            cell.imgHangoutTypeIcon.image=UIImage(named: "business")
            cell.lblHanoutType.text = kBusiness.uppercased()
            cell.lblHanoutType.textColor=BUSSINESSTEXRT
            cell.viewHangoutType.backgroundColor = BUSSINESSBACK
        }
        else if hangoutType.equalsIgnoreCase(string: kTravel)
        {
            cell.imgHangoutTypeIcon.image=UIImage(named: "travler")
            cell.lblHanoutType.text = kTravel.uppercased()
        
        cell.lblHanoutType.textColor=TRAVELTEXRT
        cell.viewHangoutType.backgroundColor = TRAVELBACK
        }
        else if hangoutType.equalsIgnoreCase(string: kSports)
        {
            cell.imgHangoutTypeIcon.image=UIImage(named: "sport-1")
            cell.lblHanoutType.text = kSports.uppercased()
        cell.lblHanoutType.textColor=SPORTTEXRT
        cell.viewHangoutType.backgroundColor = SPORTBACK
        }
        else
       {
        cell.imgHangoutTypeIcon.image=UIImage(named: "social-1")
        cell.lblHanoutType.text = kSocial.uppercased()
        cell.lblHanoutType.textColor=SOCAILTEXRT
        cell.viewHangoutType.backgroundColor = SOCAILBACK
       }
 
        
        if let time = cellData?.date
        {
           // let time2 = time.dateFromString(format: .NewISO, type: .local)
   // let date = time2.string(format: .longdateTime2, type: .local)
            
            let date = time.utcToLocalDate(dateStr: time) ?? ""
            
            if let time11 = cellData?.time
            {
              //let time12 = time11.dateFromString(format: .NewISO, type: .local)
             //   let date12 = time12.string(format: .localTime, type: .local)
                let date12 = time11.utcToLocalTime(dateStr: time11) ?? ""
                cell.lblDateTime.text = date+" @ "+date12
            }
        }

        
       

        if let img = cellData?.image
        {
//            let size = cell.imgHangout.image?.getImageSizeWithURL(url: img)
//
//            let height = size?.height ?? 375
         let url = URL(string: img)!
//            if height > SCREENHEIGHT
//            {
//                let per = (height*kLongImagePercent)/100
//
//                cell.imgHeightConst.constant = SCREENHEIGHT-120//height-per
//            }
//       else if height > 700
//        {
//            let per = (height*kImagePercent)/100
//
//        cell.imgHeightConst.constant = height-per
//        }
//        else
//        {
//            cell.imgHeightConst.constant = size?.height ?? 375
//        }
            
            
//            let imageURL = URL(string: img)!
//            let source = CGImageSourceCreateWithURL(imageURL as CFURL,nil)
//            let imageHeader = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil)! as NSDictionary;
//
//            debugPrint("Sizec = \(imageHeader)")
            cell.imgHangout.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgHeightConst.constant =  kListImageHeight

          DispatchQueue.main.async {
            cell.imgHangout.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
          }

        }
        cell.lblLocation.underline()
        
        cell.btnEdit.tag=indexPath.row

        cell.btnEdit.addTarget(self, action: #selector(editAct), for: .touchUpInside)
        
        
        cell.btnDelete.tag=indexPath.row

        cell.btnDelete.addTarget(self, action: #selector(deleteAct), for: .touchUpInside)
        
        cell.btnLocation.tag=indexPath.row

        cell.btnLocation.addTarget(self, action: #selector(LocationAct), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
     return UITableView.automaticDimension

    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: 100))
        view.backgroundColor=UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    @objc func LocationAct(_ sender:UIButton)
    {
     
        if self.MyHangoutData.count>sender.tag
        {

            let lat = self.MyHangoutData[sender.tag].latitude ?? CURRENTLAT
            let long = self.MyHangoutData[sender.tag].longitude ?? CURRENTLONG
            let place = self.MyHangoutData[sender.tag].place ?? ""

            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CURRENTLAT, longitude: CURRENTLONG)))
            source.name = "Source"

            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)))
            destination.name = place

            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        
        
        
    }
}
//MARK: - Get current location 

extension MyHangoutVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first
           {
               debugPrint("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
          
           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
       {
           debugPrint("Failed to find user's location: \(error.localizedDescription)")
       }
}

// MARK:- Extension get and delete my hangout api Calls   

extension MyHangoutVC
{
    
    func callGetHangoutApi(page: Int)
    {
        var data = JSONDictionary()

        data[ApiKey.kFilter_type] = self.hagoutTYpe
        data[ApiKey.kOffset] = "\(page)"
         
            if Connectivity.isConnectedToInternet {
                self.showLoader()
                self.callApiForHangout(data: data)
             } else {
                 self.hideLoader()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForHangout(data:JSONDictionary)
    {
        HangoutVM.shared.callApiGetMyHangout(data: data, response: { (message, error) in
     
            if error != nil
            {
                self.btnCreateHangout.isHidden=false
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                self.btnCreateHangout.isHidden=false
                for dict in HangoutVM.shared.HangoutDataArray
                {
                    
                    self.MyHangoutData.append(dict)
            
                }
                
            
                Indicator.sharedInstance.hideIndicator()
               self.refreshControl.endRefreshing()
                HangoutVM.shared.page=self.page
                           
                self.page = self.MyHangoutData.count
                
             
          
                
                
                if self.hagoutTYpe == ""
                {
                    if self.MyHangoutData.count>0
                    {
                        self.tableHangout.isHidden=false
                        self.viewEmptyList.isHidden=true
                        self.viewHeader.isHidden=false
                    }
                    else
                    {
                        self.tableHangout.isHidden=true
                        self.viewEmptyList.isHidden=false
                        self.viewHeader.isHidden=true
                    }
                    
                    if self.getDeviceModel() == "iPhone 6"
                    {
                        self.topIconConst.constant = 0
                    }
                    else if self.getDeviceModel() == "iPhone 8+"
                    {
                        self.topIconConst.constant = 10
                    }
                    else
                    {
                        self.topIconConst.constant = 10
                    }
                    if HangoutVM.shared.total_travel_count > 0
                    {
                        self.viewTravel.backgroundColor=UIColor.black
                     self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
                    }
                    else
                    {
                        self.viewTravel.backgroundColor=UIColor.white
                        self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
                    }
                     if HangoutVM.shared.total_social_count > 0
                     {
//                         self.viewSocial.backgroundColor=SOCAILBACK
//                         self.imgSocial.image = self.imgSocial.image?.tinted(color:  SOCAILTEXRT)

                        self.viewSocial.backgroundColor=UIColor.black
                        self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)
                     }
                    else
                     {
                        self.viewSocial.backgroundColor=UIColor.white
                        
                        self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)
                     }
                     if HangoutVM.shared.total_business_count > 0
                     {
//                         self.viewBusiness.backgroundColor=BUSSINESSBACK
//                         self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  BUSSINESSTEXRT)
                        self.viewBusiness.backgroundColor=UIColor.black
                        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                     }
                    else
                     {
                        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                        self.viewBusiness.backgroundColor=UIColor.white

                     }
                      if HangoutVM.shared.total_sport_count > 0
                      {
//                         self.viewSport.backgroundColor=SPORTBACK
//                         self.imgSport.image = self.imgSport.image?.tinted(color:  SPORTTEXRT)

                        self.viewSport.backgroundColor=UIColor.black
                        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                      }
                    else
                      {
                        self.viewSport.backgroundColor=UIColor.white
                        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                      }
                }
                else
                {
                    if self.MyHangoutData.count>0
                    {
                        self.tableHangout.isHidden=false
                        self.viewEmptyList.isHidden=true
                        self.viewHeader.isHidden=false
                    }
                    else
                    {
                        self.tableHangout.isHidden=true
                        self.viewEmptyList.isHidden=false
                        self.viewHeader.isHidden=false
                        
                       
                    }
                }
                
                
            var isavailble = false

                if self.fromDelete
                {
                    if HangoutVM.shared.total_travel_count > 0
                    {
                        self.viewTravel.backgroundColor=UIColor.black
                     self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
                        isavailble=true
                    }
                    else
                    {
                        self.viewTravel.backgroundColor=UIColor.white
                        self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
                    }
                     if HangoutVM.shared.total_social_count > 0
                     {
//                         self.viewSocial.backgroundColor=SOCAILBACK
//                         self.imgSocial.image = self.imgSocial.image?.tinted(color:  SOCAILTEXRT)
                        isavailble=true

                        self.viewSocial.backgroundColor=UIColor.black
                        self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)
                     }
                    else
                     {
                        self.viewSocial.backgroundColor=UIColor.white
                        
                        self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)
                     }
                     if HangoutVM.shared.total_business_count > 0
                     {
                        isavailble=true

//                         self.viewBusiness.backgroundColor=BUSSINESSBACK
//                         self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  BUSSINESSTEXRT)
                        self.viewBusiness.backgroundColor=UIColor.black
                        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                     }
                    else
                     {
                        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                        self.viewBusiness.backgroundColor=UIColor.white

                     }
                      if HangoutVM.shared.total_sport_count > 0
                      {
                        isavailble=true

//                         self.viewSport.backgroundColor=SPORTBACK
//                         self.imgSport.image = self.imgSport.image?.tinted(color:  SPORTTEXRT)

                        self.viewSport.backgroundColor=UIColor.black
                        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                      }
                    else
                      {
                        self.viewSport.backgroundColor=UIColor.white
                        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                      }
                    if isavailble == false
                    {
                        self.viewSocial.backgroundColor=UIColor.white//SOCAILBACK
                        self.viewSport.backgroundColor=UIColor.white
                        self.viewTravel.backgroundColor=UIColor.white
                        self.viewBusiness.backgroundColor=UIColor.white
                        
                       
                        self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                        self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                        self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
                        self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)
                    }
                    
                    self.viewBusiness.backgroundColor=UIColor.white
                    self.fromDelete=false

                }
                
                
                self.btnCreateHangout.isHidden=false

                self.tableHangout.reloadData()
                
            }
        })
    }
    
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
 
                self.MyHangoutData.removeAll()
                self.page=0
                self.fromDelete=true
              self.callGetHangoutApi(page: self.page)
                
                
            }

         
        })
    }
    
}
