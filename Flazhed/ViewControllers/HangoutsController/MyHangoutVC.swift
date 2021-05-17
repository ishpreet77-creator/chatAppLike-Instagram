//
//  MyHangoutVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//

import UIKit
import CoreLocation
import MapKit

class MyHangoutVC: BaseVC {
    //MARK:- All outlets  🍎
    
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
    
    //MARK:- All Variable  🍎
    
    var refreshControl = UIRefreshControl()
    var fromCreateHangout=false
    var page = 0
    var hangout_id = ""
    var MyHangoutData:[HangoutDataModel] = []
    let locationmanager = CLLocationManager()
    var hagoutTYpe=""
    
    //MARK:- View Lifecycle   🍎
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewHeader.isHidden=true
        self.viewEmptyList.isHidden=true
        self.setUpTable()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableHangout.addSubview(refreshControl)
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
   
        if DataManager.fromHangout==kCreate
        {
            
            if self.hagoutTYpe==kTravel
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
           else if self.hagoutTYpe==kSports
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
           else if self.hagoutTYpe==kBusiness
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
            else if self.hagoutTYpe==kSocial
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
                self.viewSocial.backgroundColor=UIColor.white//SOCAILBACK
                self.viewSport.backgroundColor=UIColor.white
                self.viewTravel.backgroundColor=UIColor.white
                self.viewBusiness.backgroundColor=UIColor.white
                
             
                self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
                self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
                self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
                self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)//SOCAILTEXRT)
                

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
        
            self.viewSocial.backgroundColor=UIColor.white//SOCAILBACK
            self.viewSport.backgroundColor=UIColor.white
            self.viewTravel.backgroundColor=UIColor.white
            self.viewBusiness.backgroundColor=UIColor.white
            
         
            self.imgSport.image = self.imgSport.image?.tinted(color:  UIColor.lightGray)
            self.imgBusiness.image = self.imgBusiness.image?.tinted(color:  UIColor.lightGray)
            self.imgTravel.image = self.imgTravel.image?.tinted(color:  UIColor.lightGray)
            self.imgSocial.image = self.imgSocial.image?.tinted(color:  UIColor.lightGray)//SOCAILTEXRT)
            

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
     
        HangoutVM.shared.page=0
        self.MyHangoutData.removeAll()
 
        self.callGetHangoutApi(page: 0)
    }
    //MARK:- back button action  🍎
    
    @IBAction func BackAct(_ sender: UIButton)
    {
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
//        vc.selectedIndex=4
//        DataManager.comeFrom = kViewProfile
//        self.navigationController?.pushViewController(vc, animated: false)
        
        DataManager.comeFrom = kViewProfile
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func editAct(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostHangoutVC") as! PostHangoutVC
        let cellData = self.MyHangoutData[sender.tag]
        
        vc.HangoutDetail=cellData
        vc.fromEdit=true
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
    
    @objc func deleteAct(_ sender: UIButton)
    {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
        destVC.delegate=self
        let cellData = self.MyHangoutData[sender.tag]
        self.hangout_id=cellData._id ?? ""
        destVC.type = .deleteHangout
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        self.present(destVC, animated: true, completion: nil)
    }
    
    @IBAction func createHangoutAct(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostHangoutVC") as! PostHangoutVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
   //MARK:- Filter button action  🍎
    
    @IBAction func SocialAct(_ sender: UIButton)
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
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    @IBAction func travelAct(_ sender: UIButton)
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
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    @IBAction func sportAct(_ sender: UIButton)
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
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
    }
    @IBAction func businessAct(_ sender: UIButton)
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
        self.MyHangoutData.removeAll()
        self.callGetHangoutApi(page: 0)
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
    
}

//MARK:- delete hangout delegate  🍎

extension MyHangoutVC:DiscardDelegate
{
    func ClickNameAction(name: String)
    {
        print(name)
        if name == kDelete
        {
            self.callDeleteHangoutApi(hangout_id: self.hangout_id)
        }
    }
    
    
}
//MARK:- Tableview  setup and show my hangout data 🍎

extension MyHangoutVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
{
   
    
    func setUpTable()
    {
        
        self.tableHangout.register(UINib(nibName: "MyHangoutTCell", bundle: nil), forCellReuseIdentifier: "MyHangoutTCell")
        self.tableHangout.rowHeight = 100
        self.tableHangout.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableHangout.delegate = self
        self.tableHangout.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MyHangoutData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHangoutTCell") as! MyHangoutTCell
        
        let cellData = self.MyHangoutData[indexPath.row]
        cell.txtDesc.text=cellData.aditional_description
        
        let heading = (cellData.heading ?? "")+" "
        let desc = cellData.description ?? ""
        cell.txtTitle.customFontText(boldSting: heading, regularSting: desc)
        cell.lblLocation.text=cellData.place
        
        
        let hangoutType = cellData.hangout_type ?? ""
        
        if hangoutType == kBusiness
        {
            cell.imgHangoutTypeIcon.image=UIImage(named: "business")
            cell.lblHanoutType.text = kBusiness.uppercased()
            cell.lblHanoutType.textColor=BUSSINESSTEXRT
            cell.viewHangoutType.backgroundColor = BUSSINESSBACK
        }
       else if hangoutType == kTravel
        {
            cell.imgHangoutTypeIcon.image=UIImage(named: "travler")
            cell.lblHanoutType.text = kTravel.uppercased()
        
        cell.lblHanoutType.textColor=TRAVELTEXRT
        cell.viewHangoutType.backgroundColor = TRAVELBACK
        }
       else if hangoutType == kSports
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
 
        
        if let time = cellData.date
        {
           // let time2 = time.dateFromString(format: .NewISO, type: .local)
   // let date = time2.string(format: .longdateTime2, type: .local)
            
            let date = time.utcToLocalDate(dateStr: time) ?? ""
            
            if let time11 = cellData.time
            {
              //let time12 = time11.dateFromString(format: .NewISO, type: .local)
             //   let date12 = time12.string(format: .localTime, type: .local)
                let date12 = time11.utcToLocalTime(dateStr: time11) ?? ""
                cell.lblDateTime.text = date+" @ "+date12
            }
        }

        
        

        if let img = cellData.image
        {
          let url = URL(string: img)!
          DispatchQueue.main.async {
            cell.imgHangout.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
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

            let lat = self.MyHangoutData[sender.tag].latitude ?? 30.123
            let long = self.MyHangoutData[sender.tag].longitude ?? 76.123
            let place = self.MyHangoutData[sender.tag].place ?? ""

            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CURRENTLAT, longitude: CURRENTLONG)))
            source.name = "Source"

            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)))
            destination.name = place

            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        
        
        
    }
}
//MARK:- Get current location 🍎

extension MyHangoutVC: CLLocationManagerDelegate
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

// MARK:- Extension get and delete my hangout api Calls   🍎

extension MyHangoutVC
{
    
    func callGetHangoutApi(page: Int)
    {
        var data = JSONDictionary()

        data[ApiKey.kFilter_type] = self.hagoutTYpe
        data[ApiKey.kOffset] = "\(page)"
         
            if Connectivity.isConnectedToInternet {
                
                self.callApiForHangout(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForHangout(data:JSONDictionary)
    {
        HangoutVM.shared.callApiGetMyHangout(data: data, response: { (message, error) in
     
            if error != nil
            {
            
                self.showErrorMessage(error: error)
            }
            else{
 
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
              self.callGetHangoutApi(page: self.page)
                
                
            }

         
        })
    }
    
}
