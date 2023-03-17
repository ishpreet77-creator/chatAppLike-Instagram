//
//  NewChatSectionVC.swift
//  Flazhed
//
//  Created by IOS33 on 31/05/21.
//

import UIKit
import CoreLocation
import CoreData


class NewChatSectionVC: BaseVC {
    //MARK: - All outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomIcon: UIImageView!
    @IBOutlet weak var lblDataFound: UILabel!
    
    //MARK: - All Variable
    var page = 0
    var MatchPage = 0
    var tableListBool=true
    let locationmanager = CLLocationManager()
    var activeInactiveChatArray:[chat_room_details_Model] = []
    var MatchArray:[MatchUserListModel] = []
    var refreshControl = UIRefreshControl()
    var chatFilter = ""
    var imageLongPressIndex=0
    var reloadMatchCollection=true
    var reloadActiveListCollection=true
    
    var selectedUserName = ""
    var selectedUserId = ""
   
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        DataManager.comeFrom=kEmptyString
        tableListBool = true
        self.setUI()
       self.AllSocketMethod()
        DataManager.isProfileCompelete = true
        DataManager.isPrefrenceSet = true
         DataManager.isEditProfile = true
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DataManager.isEditProfile = true
        tabBarController?.removeDotAtTabBarItemIndex(index: 1)
       // badgeCountIntervalCheckON()
//        if appDelegate?.chatVisitCount == 0 {
//            self.chatTableView.showAnimatedSkeleton()
//        }

     
        self.reloadMatchCollection=true
        self.reloadActiveListCollection=true
        
        DataManager.isMessagePageOpen=false
        DataManager.currentScreen = kChat
        
        if Connectivity.isConnectedToInternet
        {
            if DataManager.comeFrom == kMessage
            {
                if tableListBool
                {
                    DispatchQueue.main.async
                    {
                        self.bottomLabel.isHidden = false
                        self.bottomIcon.isHidden = false
                        self.tableListBool = true
                        self.chatTableView.separatorStyle = .singleLine
            
                           self.activeInactiveChatArray.removeAll()
                      
                        self.callGetGetActiveChat(page: 0)
                    }
                }
            }
            
           else if DataManager.comeFrom != kViewProfile
            {
              
                if tableListBool
                {
                    DispatchQueue.main.async
                    {
                        self.bottomLabel.isHidden = false
                        self.bottomIcon.isHidden = false
                        self.tableListBool = true
                        self.chatTableView.separatorStyle = .singleLine
                       // if self.appDelegate?.chatVisitCount == 0
                       // {
                           self.activeInactiveChatArray.removeAll()
                        //    self.appDelegate?.chatVisitCount += 1
                         //}
                       
                        self.callGetGetActiveChat(page: 0)
                        
                        self.MatchArray.removeAll()
                        
                        self.callGetAllMatch(page: 0)
                      
                    }
                    
                }
                else
                {
                    DispatchQueue.main.async {
                        self.tableListBool = false
                        self.bottomLabel.isHidden = true
                        self.bottomIcon.isHidden = true
                    self.chatTableView.separatorStyle = .none
                    
                    self.activeInactiveChatArray.removeAll()
                    self.page=0
                    self.callGetInActiveChat(page: 0)
                        self.MatchArray.removeAll()
                        self.callGetAllMatch(page: 0)
                    }
                }
               
                
            }
            else
            {
                DataManager.comeFrom = kEmptyString
            }
        }
        else
        {
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
        /*
        if DataManager.comeFrom != kShare
        {
            DataManager.comeFrom=kEmptyString
            self.reloadMatchCollection=true
            self.reloadActiveListCollection=true
        }
        
        DataManager.currentScreen = kChat
        
        
       
        
        
        self.MatchPage=0
        
        updateOnlineStatusAfter2MinutesEmit()
        
        
        sendSMS_ON_Method()
        //locationmanager.startMonitoringSignificantLocationChanges()
        
        //  updateLocationAPI()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        //            // Put your code which should be executed with a delay here
        //        }
        //
        
        self.reloadMatchCollection=true
        if DataManager.comeFrom != kViewProfile
        {
            
            if tableListBool
            {
                
                
                if Connectivity.isConnectedToInternet {
                    
                    self.page=0
                    //activeButton.isSelected = true
                    //inactiveButton.isSelected = false
                    bottomLabel.isHidden = false
                    bottomIcon.isHidden = false
                    tableListBool = true
                    self.chatTableView.separatorStyle = .singleLine
                    self.activeInactiveChatArray.removeAll()
                   
                    self.callGetGetActiveChat(page: 0)
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
            }
            else
            {
                
                
                
                if Connectivity.isConnectedToInternet {
                    //inactiveButton.isSelected = true
                    
                    tableListBool = false
                    // activeButton.isSelected = false
                    bottomLabel.isHidden = true
                    bottomIcon.isHidden = true
                    self.chatTableView.separatorStyle = .none
                    self.activeInactiveChatArray.removeAll()
                    self.callGetInActiveChat(page: 0)
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
            }
            DispatchQueue.background(background: {
                    if Connectivity.isConnectedToInternet {
                        self.MatchArray.removeAll()
                        self.reloadActiveListCollection=false
                        self.reloadMatchCollection=true
                        self.callGetAllMatch(page: 0)
                    } else {
                        
                        self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                    }
                
            }, completion: {
             
            })
            
           
        }
        else
        {
            DataManager.comeFrom = kEmptyString
        }
        
        self.activeInactiveChatArray.removeAll()
        
        
        
        //  SocketIOManager.shared.initializeSocket()
        
        //   self.onActiveInactiveChatScreenJoin()
        
        */
        self.tabBarController?.removeDotAtTabBarItemIndex(index: 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.removeDotAtTabBarItemIndex(index: 1)
       
        
//                        DispatchQueue.global(qos: .background).async {
//                            if Connectivity.isConnectedToInternet {
//                                self.getMySubscriptionApi()
//                            }
//                        }
        SocketIOManager.shared.initializeSocket()
      //  self.selfJoinSocketEmit()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        // DataManager.currentScreen = kEmptyString
        
    }
    
    
    
    func setUI()
    {
        chatTableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        chatTableView.addSubview(refreshControl)
        self.setUpTable()
        
     
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        
        bottomLabel.text = kTapandHold
    }
    func AllSocketMethod()
    {
        DispatchQueue.background(background: {
            self.updateOnlineStatusAfter2MinutesEmit()
            self.sendSMS_ON_Method()
        }, completion: nil)
      
    }
    
    
    //MARK: - Filter action
    
    @objc func sortButtonAction(_ sender: UIButton) {
      
        let destVC = SortingAlertVC.instantiate(fromAppStoryboard: .Chat)
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
        //self.showToast(message: kLogoutMessage)
    }
    
    @objc func activeChatButtonAction(_ sender: UIButton){
        sender.isSelected = true//!sender.isSelected
        //        inactiveButton.isSelected = false
        //        bottomLabel.isHidden = false
        //        bottomIcon.isHidden = false
        tableListBool = true
        self.chatTableView.separatorStyle = .singleLine
        
        self.activeInactiveChatArray.removeAll()
        
        //self.chatTableView.reloadData()
        
        self.reloadActiveListCollection=true
        self.reloadMatchCollection=false

        if Connectivity.isConnectedToInternet {
            self.page=0
            self.callGetGetActiveChat(page: 0)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        //
        
    }
    
    
    @objc func inactiveButtonAction(_ sender: UIButton) {
        sender.isSelected = true//!sender.isSelected
        
        tableListBool = false
        // activeButton.isSelected = false
        bottomLabel.isHidden = true
        bottomIcon.isHidden = true
        self.chatTableView.separatorStyle = .none
        self.activeInactiveChatArray.removeAll()
        self.reloadActiveListCollection=true
        self.reloadMatchCollection=false
        if Connectivity.isConnectedToInternet {
            
            self.callGetInActiveChat(page: 0)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
        // self.chatTableView.reloadData()
    }
    
    
    @objc func refresh(_ sender: AnyObject)
    {
     
        self.reloadActiveListCollection=true
        self.reloadMatchCollection=true
        DispatchQueue.main.async {
            if Connectivity.isConnectedToInternet {
                self.MatchArray.removeAll()
                self.callGetAllMatch(page: 0,showIndiacter: false)
            } else {
                self.chatTableView.contentOffset = CGPoint.zero
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        
        if tableListBool
        {
            
            
            if Connectivity.isConnectedToInternet {
                self.page=0
                self.activeInactiveChatArray.removeAll()
                tableListBool = true
                self.chatTableView.separatorStyle = .singleLine
                self.callGetGetActiveChat(page: 0,showIndiacter: false)
            } else {
                self.chatTableView.contentOffset = CGPoint.zero
                self.refreshControl.endRefreshing()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        else
        {
            
            
            
            if Connectivity.isConnectedToInternet {
                self.chatTableView.separatorStyle = .none
                self.activeInactiveChatArray.removeAll()
                self.callGetInActiveChat(showIndiacter: false, page: 0)
            } else {
                self.chatTableView.contentOffset = CGPoint.zero
                self.refreshControl.endRefreshing()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.chatTableView])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.chatTableView])
    }
}

extension NewChatSectionVC: UITableViewDataSource, UITableViewDelegate {
    
    func setUpTable()
    {
        
        self.chatTableView.register(UINib(nibName: "ChatMatchTCell", bundle: nil), forCellReuseIdentifier: "ChatMatchTCell")
        self.chatTableView.register(UINib(nibName: "ChatSecMessageHeaderTCell", bundle: nil), forCellReuseIdentifier: "ChatSecMessageHeaderTCell")
        
        self.chatTableView.register(UINib(nibName: "ChatActiveTCell", bundle: nil), forCellReuseIdentifier: "ChatActiveTCell")
        
        self.chatTableView.register(UINib(nibName: "ActiveInactiveTCell", bundle: nil), forCellReuseIdentifier: "ActiveInactiveTCell")
        
        self.chatTableView.rowHeight = 100
        self.chatTableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.activeInactiveChatArray.count+2
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatMatchTCell") as! ChatMatchTCell
            if  self.reloadMatchCollection
            {
                cell.reloadCollection(userArray: self.MatchArray)
                cell.viewController=self
            }
           
           
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
            return cell
        }
        
        else if indexPath.row == 1
        {
            
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatSecMessageHeaderTCell") as! ChatSecMessageHeaderTCell
            cell.btnSort.addTarget(self, action: #selector(sortButtonAction), for: .touchUpInside)
            cell.sortIcon.tintColor = PURPLECOLOR
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
            return cell
        }
//        else if indexPath.row == 2
//        {
//
//            let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatActiveTCell") as! ChatActiveTCell
//            if tableListBool
//            {
//                cell.btnActive.isSelected=true
//                cell.btnInactive.isSelected=false
//            }
//            else
//            {
//                cell.btnActive.isSelected=false
//                cell.btnInactive.isSelected=true
//            }
//
//            cell.btnActive.addTarget(self, action: #selector(activeChatButtonAction), for: .touchUpInside)
//            cell.btnInactive.addTarget(self, action: #selector(inactiveButtonAction), for: .touchUpInside)
//            let bgColorView = UIView()
//            bgColorView.backgroundColor = UIColor.clear
//            cell.selectedBackgroundView = bgColorView
//
//            return cell
//        }
        
        else
        {
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "ActiveInactiveTCell") as! ActiveInactiveTCell
            
            // let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatListingTVC") as! ChatListingTVC
            cell.selectionStyle = .none
            //if self.reloadActiveListCollection
            //{
            
            if tableListBool == true{
                
                
                var cellData:chat_room_details_Model?
                
                if self.activeInactiveChatArray.count>indexPath.row-2
                {
                    cellData = self.activeInactiveChatArray[indexPath.row-2]
                }
                
                cell.pendingMessagesNumberLabel.layer.cornerRadius = 10.25
                cell.pendingMessagesNumberLabel.clipsToBounds = true
                cell.userNameLabel.text = cellData?.other_user_details?.profile_data?.username ?? ""
                
                //  cell.rightUnreadConst.constant = 0
                
                let lastMessage = cellData?.last_message ?? ""
                let last_message_sender_user_id = cellData?.last_message_sender_user_id ?? ""
                
                let messageType = cellData?.last_message_type ?? kText //last_message_file_type
                
                if messageType.uppercased() == kGif.uppercased() || lastMessage.contains(kGiphy)
                {
                    cell.userLastMessageLabel.text = kGif
                }
                else  if messageType.uppercased() == kAudio.uppercased()  || messageType.uppercased() == kVideo.uppercased()
                {
                    var msg = ""
                    if last_message_sender_user_id != DataManager.Id
                    {
                        cell.userLastMessageLabel.text  = ""
                        
                        if lastMessage.contains(kCallTry)
                        {
                            msg = lastMessage.replacingOccurrences(of: "call", with: "call from")
                        }
                        else
                        {
                            msg = lastMessage
                        }
                        
                        let tex = msg.replacingOccurrences(of: kCallTry, with: kCallMissed)
                        
                        //cell.lblTime.text = tex
                        
                        
                        
                        //  let name = tex.replacingOccurrences(of: DataManager.userName, with: cell.userNameLabel.text!.uppercased())
                        
                        let name = tex.replacingOccurrences(of: DataManager.userName, with: cell.userNameLabel.text!.uppercased(), options: .caseInsensitive)
                        
                        cell.userLastMessageLabel.text = name
                        
                        debugPrint("Name =\(name)")
                    }
                    
                    else
                    {
                        //cell.lblTime.text = messege.replacingOccurrences(of: self.userNameLabel.text!, with: DataManager.userName.capitalized)
                        
                        cell.userLastMessageLabel.text = lastMessage
                    }
                }
                
                
                //                if lastMessage.contains(kCallTry) && last_message_sender_user_id != DataManager.Id
                //                     {
                //
                //                      let tex = lastMessage.replacingOccurrences(of: kCallTry, with: kCallMissed)
                //
                //                     // cell.userLastMessageLabel.text = tex
                //
                //                    cell.userLastMessageLabel.text = tex.replacingOccurrences(of: cell.userNameLabel.text!, with: DataManager.userName.capitalized)
                //                     }
                //
                //                     else
                //                     {
                //                      cell.userLastMessageLabel.text = lastMessage//lastMessage.replacingOccurrences(of: cell.userNameLabel.text!, with: DataManager.userName.capitalized)
                //
                //                     }
                
                
                else
                {
                    cell.userLastMessageLabel.text = cellData?.last_message ?? ""
                }
                if let img = cellData?.other_user_details?.profile_data?.image
                {
                        DispatchQueue.main.async {
                            //let url = URL(string: img)!
                            cell.userProfileIMage.setImage(imageName: img)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                    
                }
                
                
                let unreadMessage = cellData?.unread_count ?? 0
                
                if unreadMessage == 0
                {
                    cell.pendingMessagesNumberLabel.isHidden = true
                    
                    cell.userLastMessageLabel.textColor = CHATINACTIVECOLOR
                    cell.userLastMessageLabel.font = UIFont(name: AppFontName.Light, size: 14)
                    
                    cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                }
                else
                {
                    cell.pendingMessagesNumberLabel.isHidden = false
                    cell.pendingMessagesNumberLabel.text = "\(unreadMessage)"
                    cell.imgRead.isHidden=true
                    cell.ConstLblMessge.constant = 0
                    cell.userLastMessageLabel.textColor = UIColor.black
                    cell.userLastMessageLabel.font = UIFont(name: AppFontName.regular, size: 14)
                    
                    cell.dateAndTimeLabel.textColor = TEXTCOLOR
                    
                    
                }
                cell.rightUnreadConst.constant = 0
                let is_read_by_second_user = cellData?.is_read_by_second_user ?? 0
                let continue_chat_status_other_user =  cellData?.continue_chat_status_other_user ?? 0
               // let chat_start_time_active =  cellData?.like_dislike?.chat_start_time_active ?? ""
                
                
                if is_read_by_second_user == 1
                {
                    cell.imgRead.isHidden=false
                    cell.ConstLblMessge.constant = 35
                }
                else
                {
                    cell.imgRead.isHidden=true
                    cell.ConstLblMessge.constant = 16
                    
                }
                
                let lastMsgTime = cellData?.last_message_time ?? ""
                let time = lastMsgTime.dateFromString(format: .NewISO, type: .utc)
                let calendar = Calendar(identifier: .gregorian)
                if calendar.isDateInToday(time)
                {
                    cell.dateAndTimeLabel.text = time.string(format: .localTime, type: .local)//"Today"
                }
                else if calendar.isDateInYesterday(time)
                {
                    cell.dateAndTimeLabel.text = "Yesterday"
                }
                else
                {
                    cell.dateAndTimeLabel.text = time.string(format: .DOBFormat, type: .local)
                }
                
                
                cell.userProfileIMage.cornerRadius = cell.userProfileIMage.frame.height/2
                cell.userProfileIMage.contentMode = .scaleAspectFill
                var continue_chat_status2 = cellData?.continue_chat_status ?? 0
                
                if continue_chat_status2 == 0
                {
                    continue_chat_status2 = cellData?.is_come_from_story_hangout ?? 0
                }
                
                
                if  continue_chat_status2 == 1
                {
               // cell.circularProgressView.isHidden = true
                }
                else
                {
                  //  cell.circularProgressView.isHidden = false
                }
              //  cell.circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
              //  cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
                
                
                
                
                cell.menuBtn2.isHidden=true
                cell.menuButton.isHidden=true
                
                let dif  = "".checkHoursLeftForRing(startTime: cellData?.like_dislike?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z")
                
                
                
                debugPrint("time check = \(dif)")
                let flo = Float(kTimeRing)
                let ring = (1.0/flo)*Float(dif)
                
                if (dif > 0) && (dif <= kTimeRing) //(dif > 0) && (dif <= 72)
                {
                    if dif <= 1440*2 // 24 Hours+24+
                    {
                       // cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: ring)
                       // cell.circularProgressView.progressClr = UIColor.red
                    }
                    else
                    {
                       // cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: ring)
                      //  cell.circularProgressView.progressClr = LINECOLOR
                    }
                }
                else
                {
                   // cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 1)
                  //  cell.circularProgressView.progressClr = LINECOLOR
                   // cell.circularProgressView.isHidden=true
                }
                
                
                var continue_chat_status = cellData?.continue_chat_status ?? 0
                
                if continue_chat_status == 0
                {
                    continue_chat_status = cellData?.is_come_from_story_hangout ?? 0
                }
                
                
                if  continue_chat_status == 1
                {
                    //cell.circularProgressView.isHidden=true
                    
                    cell.userProfileIMage.isUserInteractionEnabled = false
                }
                else
                {
                  //  cell.circularProgressView.isHidden=false
                    
                    
                    //  if DataManager.purchaseProlong == false
                    //  {
//                    let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//                    cell.userProfileIMage.tag=indexPath.row
//                    cell.userProfileIMage.isUserInteractionEnabled = true
//                    cell.userProfileIMage.addGestureRecognizer(tapGestureRecognizer)
                    //}
                }
                //MARK: - Gray out
                
                var (hourRemanning, _, _)  = "".checkHoursRemaining(startTime: cellData?.like_dislike?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z")
                debugPrint("hourRemanning \(hourRemanning)")
                
                let response_other_user = cellData?.response_other_user ?? 0
                let response_self_user = cellData?.self_send_message ?? 0
                // let is_read_by_second_user = cellData?.is_read_by_second_user ?? 0
                // let continue_chat_status_other_user =  cellData?.continue_chat_status_other_user ?? 0
                // let chat_start_time_active =  cellData?.like_dislike?.chat_start_time_active ?? ""
                
                let is_continue_from_user =  cellData?.is_continue_from_user ?? 0
                let is_continue_to_user =  cellData?.like_dislike?.is_continue_to_user ?? 0
                
                
                var difX  = "".checkHoursLeftForRing(startTime: cellData?.like_dislike?.chat_end_time_inactive ?? "2021-05-20T04:55:50.706Z")
                
                //1440 == 24 hr
                difX = difX-2880
                var is_come_from_story_hangout = cellData?.is_come_from_story_hangout ?? 0
                let have_parlong = cellData?.have_parlong ?? 0
                let activeTime = cellData?.like_dislike?.chat_start_time_active ?? ""
                
               // let timeDiff  = "".checkHoursLeftForRing24Hr(startTime: cellData?.like_dislike?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z")
                //MARK: - Payment changes
             
                if is_come_from_story_hangout == 0
                {
                    if have_parlong == 1
                    {
                        is_come_from_story_hangout = 1
                    }
                    
                }
               
                hourRemanning = hourRemanning+1
                
                if is_come_from_story_hangout != 1
                {
                    if ((is_continue_from_user == 0 && is_continue_to_user == 0) && (hourRemanning <= 48 && hourRemanning >= 25) && (activeTime != ""))
                    {
                        if (response_other_user == 1 && response_self_user == 1)
                       {
                            cell.grayView.isHidden=true
                            cell.userProfileIMage.isUserInteractionEnabled = true
                            cell.userProfileIMage.alpha = 1
                        
                            
                            cell.userNameLabel.textColor = UIColor.black
                            cell.userLastMessageLabel.textColor = UIColor.black
                            cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                        }
                        else
                        {
                        cell.userProfileIMage.alpha = 0.4
                        cell.userLastMessageLabel.text = "Chat is no long active"
                        cell.userLastMessageLabel.textColor = UIColor.lightGray
                        cell.userNameLabel.textColor = UIColor.lightGray
                            cell.userProfileIMage.isUserInteractionEnabled = false
                        cell.grayView.isHidden=true
                        }
                        
                        //End chat api call
                        
                    }
                    else if (response_other_user == 1 && response_self_user == 1) && (hourRemanning <= 24 && activeTime != "")
                    {
                        
                       // continue_chat_status == 1 && continue_chat_status_other_user == 0
                        if  continue_chat_status == 1 && continue_chat_status_other_user == 0
                        {
                            cell.userProfileIMage.isUserInteractionEnabled = true
                            cell.grayView.isHidden=true
                            cell.userProfileIMage.alpha = 1
                            cell.userNameLabel.textColor = UIColor.black
                            cell.userLastMessageLabel.textColor = UIColor.black
                            cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
//
//                            cell.userProfileIMage.alpha = 0.4
//                            cell.userLastMessageLabel.text = "Chat is no long active"
//                            cell.userLastMessageLabel.textColor = UIColor.lightGray
//                            cell.userNameLabel.textColor = UIColor.lightGray
//                            cell.circularProgressView.isHidden=true
//                            cell.userProfileIMage.isUserInteractionEnabled = false
                        }
                       else if  (continue_chat_status == 0 || continue_chat_status_other_user == 0)
                        {
                            cell.userProfileIMage.alpha = 0.4
                            cell.userLastMessageLabel.text = "Chat is no long active"
                            cell.userLastMessageLabel.textColor = UIColor.lightGray
                            cell.userNameLabel.textColor = UIColor.lightGray
                            //cell.circularProgressView.isHidden=true
                            cell.userProfileIMage.isUserInteractionEnabled = false
                        
                        cell.userProfileIMage.alpha = 1
                        cell.userNameLabel.textColor = UIColor.black
                        cell.userLastMessageLabel.textColor = UIColor.black
                        cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                            
                            cell.grayView.isHidden=true
                        }
                        else
                        {
                            cell.userProfileIMage.isUserInteractionEnabled = true
                            cell.grayView.isHidden=true
                            cell.userProfileIMage.alpha = 1
                            cell.userNameLabel.textColor = UIColor.black
                            cell.userLastMessageLabel.textColor = UIColor.black
                            cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                        }
                        
                        //Remove match api
                    }
                    else
                    {
                        cell.userProfileIMage.alpha = 1
                        cell.grayView.isHidden=true
                        cell.userProfileIMage.isUserInteractionEnabled = true
                        cell.userNameLabel.textColor = UIColor.black
                        cell.userLastMessageLabel.textColor = UIColor.black
                        cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                    }
                    
                }
                else
                {
                    cell.userProfileIMage.alpha = 1
                    cell.grayView.isHidden=true
                    cell.userProfileIMage.isUserInteractionEnabled = false
                        //cell.userProfileIMage.isUserInteractionEnabled = false
                    cell.userNameLabel.textColor = UIColor.black
                    cell.userLastMessageLabel.textColor = UIColor.black
                    cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                }
                
               // cell.circularProgressView.trackClr = .white
                //MARK: - Payment changes
                if have_parlong == 1
                {
                  //  cell.circularProgressView.isHidden=true
                }
                
                //MARK: - Update ui
                
                cell.grayView.isHidden=true
                cell.userProfileIMage.isUserInteractionEnabled = true
                cell.userProfileIMage.alpha = 1
                cell.userNameLabel.textColor = UIColor.black
                cell.userLastMessageLabel.textColor = UIColor.black
                cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
            }
            else{
                
                /*
                 
                 cell.menuButton.isHidden = false
                 cell.userNameLabel.text = "Liz"
                 cell.userLastMessageLabel.text = "I am from San Francisco. Nice to..."
                 cell.userLastMessageLabel.textColor = CHATINACTIVECOLOR
                 cell.dateAndTimeLabel.text = "07/04/20"
                 cell.dateAndTimeLabel.textColor = TIMEACTIVECOLOR
                 cell.userProfileIMage.image = #imageLiteral(resourceName: "IMag")
                 cell.pendingMessagesNumberLabel.isHidden = true
                 cell.circularProgressView.isHidden = true
                 */
                
                
                // cell.circularProgressView.isHidden=true
                
                cell.menuButton.isHidden = false
                cell.menuBtn2.isHidden = false
                var cellData:chat_room_details_Model?
                
                if self.activeInactiveChatArray.count>indexPath.row-3
                {
                    cellData = self.activeInactiveChatArray[indexPath.row-3]
                }
                cell.menuBtn2.tag=indexPath.row
                cell.menuButton.tag=indexPath.row
                
                cell.pendingMessagesNumberLabel.layer.cornerRadius = 10.25
                cell.pendingMessagesNumberLabel.clipsToBounds = true
                cell.userNameLabel.text = cellData?.other_user_details?.profile_data?.username ?? ""
                
                let lastMessage = cellData?.last_message ?? ""
                
                let messageType = cellData?.file_type ?? kText
                
                if messageType.uppercased() == kGif.uppercased() || lastMessage.contains(kGiphy)
                {
                    cell.userLastMessageLabel.text = kGif
                }
                else
                {
                    cell.userLastMessageLabel.text = cellData?.last_message ?? ""
                }
                if let img = cellData?.other_user_details?.profile_data?.image
                {
                    DispatchQueue.main.async {
                           // let url = URL(string: img)!
                        cell.userProfileIMage.setImage(imageName: img)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                    
                }
                
                cell.pendingMessagesNumberLabel.isHidden = true
                cell.ConstLblMessge.constant = 16
                cell.userLastMessageLabel.font = UIFont(name: AppFontName.regular, size: 14)
                cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                cell.imgRead.isHidden=true
                
                
                //            let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                //            cell.userProfileIMage.tag=indexPath.row
                //            cell.userProfileIMage.isUserInteractionEnabled = true
                //            cell.userProfileIMage.addGestureRecognizer(tapGestureRecognizer)
                
                
                
                /*
                 let unreadMessage = cellData?.unread_count ?? 0
                 
                 if unreadMessage == 0
                 {
                 cell.pendingMessagesNumberLabel.isHidden = true
                 cell.imgRead.isHidden=false
                 cell.ConstLblMessge.constant = 24
                 cell.userLastMessageLabel.textColor = CHATINACTIVECOLOR
                 cell.userLastMessageLabel.font = UIFont(name: AppFontName.Light, size: 14)
                 
                 cell.dateAndTimeLabel.textColor = TEXTFILEDPLACEHOLDERCOLOR
                 }
                 else
                 {
                 cell.pendingMessagesNumberLabel.isHidden = false
                 cell.pendingMessagesNumberLabel.text = "\(unreadMessage)"
                 cell.imgRead.isHidden=true
                 cell.ConstLblMessge.constant = 0
                 cell.userLastMessageLabel.textColor = UIColor.black
                 cell.userLastMessageLabel.font = UIFont(name: AppFontName.regular, size: 14)
                 
                 cell.dateAndTimeLabel.textColor = TEXTCOLOR
                 
                 
                 }
                 */
                
                let celldata = cellData?.last_message_time ?? ""
                let time = celldata.dateFromString(format: .NewISO, type: .utc)
                let calendar = Calendar(identifier: .gregorian)
                if calendar.isDateInToday(time)
                {
                    cell.dateAndTimeLabel.text = time.string(format: .localTime, type: .local)//"Today"
                }
                else if calendar.isDateInYesterday(time)
                {
                    cell.dateAndTimeLabel.text = "Yesterday"
                }
                else
                {
                    cell.dateAndTimeLabel.text = time.string(format: .DOBFormat, type: .local)
                }
                
                
                cell.userProfileIMage.cornerRadius = cell.userProfileIMage.frame.height/2
                cell.userProfileIMage.contentMode = .scaleAspectFill
               // cell.circularProgressView.isHidden = true
                // cell.circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
                //  cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
                
                
                //MARK: - Payment changes
                /*
                if DataManager.purchaseProlong
                {
                    cell.circularProgressView.isHidden=true
                    cell.menuButton.isHidden = true
                    cell.menuBtn2.isHidden = true
                }
                else
                {
                    cell.circularProgressView.isHidden=false
                    cell.menuButton.isHidden = false
                    cell.menuBtn2.isHidden = false
                }
                */
                
               // cell.circularProgressView.isHidden=false
                cell.menuButton.isHidden = false
                cell.menuBtn2.isHidden = false
                
                
                cell.grayView.isHidden=true
                cell.menuBtn2.addTarget(self, action: #selector(menuBtnAct), for: .touchUpInside)
                
                //cell.menuButton.addTarget(self, action: #selector(menuBtnAct), for: .touchUpInside)
                //cell.circularProgressView.isHidden=true
            }
            if  ((self.activeInactiveChatArray.count>1) && (indexPath.row != self.activeInactiveChatArray.count-1))
            {
                cell.viewLine.isHidden=false
            }
            else
            {
                cell.viewLine.isHidden=true
            }
           // }
            //
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
            return cell
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 130
        }
        else if indexPath.row == 1
        {
            return 55
        }
//        else if indexPath.row == 2
//        {
//            return 0
//        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row != 0 &&  indexPath.row != 1
        {

           
            var cellData:chat_room_details_Model?
            
            if self.activeInactiveChatArray.count>indexPath.row-2
            {
                cellData = self.activeInactiveChatArray[indexPath.row-2]
            }
           // if tableListBool == true{
                
                let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)

                
                DataManager.comeFrom = kEmptyString
                vc.view_user_id=cellData?.other_user_details?._id ?? ""
                vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                vc.comfrom=kChat
                vc.listType=kChat
                vc.chat_room_id=cellData?._id ?? kEmptyString
//                if  continue_chat_status == 1
//                {
//                    vc.isContinue=true
//                }
//                else
//                {
//                    vc.isContinue=false
//                }
                   if let img = cellData?.other_user_details?.profile_data?.image
                    {
                        vc.profileImage=img
                    }
                
                let id  = cellData?.other_user_details?._id ?? kEmptyString
                if id != kEmptyString
                {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
     
                /*
                
//                let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
//                let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
//                destVC.type = .Prolong
//                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//                self.present(destVC, animated: true, completion: nil)
//
//
               
                var cellData:chat_room_details_Model?
                
                if self.activeInactiveChatArray.count>indexPath.row-2
                {
                    cellData = self.activeInactiveChatArray[indexPath.row-2]
                }
                
                let username =  cellData?.other_user_details?.profile_data?.username ?? ""
                let continue_chat_status = cellData?.continue_chat_status ?? 0
                
                
                var dif  = "".checkHoursLeftNoReply(startTime: cellData?.like_dislike?.chat_end_time_inactive ?? "2021-05-20T04:55:50.706Z")
                
                debugPrint("time check = \(dif)")
                
                var is_come_from_story_hangout = cellData?.is_come_from_story_hangout ?? 0
                /*
                 let is_read_by_second_user = cellData?.is_read_by_second_user ?? 0
                 let continue_chat_status_other_user =  cellData?.continue_chat_status_other_user ?? 0
                 let chat_start_time_active =  cellData?.like_dislike?.chat_start_time_active ?? ""
                 
                 
                 if (continue_chat_status_other_user == 0) && (dif <= 1440*2) && (chat_start_time_active != "")
                 
                 {
                 let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                 let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                 destVC.type = .GrayOut
                 destVC.user_name=username.capitalized
                 destVC.view_user_id=cellData?.other_user_details?._id ?? ""
                 destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                 destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                 
                 self.present(destVC, animated: true, completion: nil)
                 }
                 else
                 */
                let response_other_user = cellData?.response_other_user ?? 0
                let response_self_user = cellData?.self_send_message ?? 0
                //let is_read_by_second_user = cellData?.is_read_by_second_user ?? 0
                let continue_chat_status_other_user =  cellData?.continue_chat_status_other_user ?? 0
               // let chat_start_time_active =  cellData?.like_dislike?.chat_start_time_active ?? ""
                let is_continue_from_user =  cellData?.is_continue_from_user ?? 0
                let is_continue_to_user =  cellData?.like_dislike?.is_continue_to_user ?? 0
                // var dif2 = 2880
                dif = dif-2880
                
                //
               // let timeDiff  = "".checkHoursLeftForRing24Hr(startTime: cellData?.like_dislike?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z")
                
                //                var hourRemanning  = "".checkHoursLeftNoReply(startTime: cellData?.like_dislike?.chat_end_time_inactive ?? "2021-05-20T04:55:50.706Z")
                //                debugPrint("hourRemanning \(hourRemanning/60)")
                //
                
                
                var (hourRemanning,_,_)  = "".checkHoursRemaining(startTime: cellData?.like_dislike?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z")
                debugPrint("hourRemanning \(hourRemanning)")
                let isActiveTime = cellData?.like_dislike?.chat_start_time_active ?? ""
                hourRemanning = hourRemanning+1
                let have_parlong = cellData?.have_parlong ?? 0
                //MARK: - Payment changes
               
                if is_come_from_story_hangout == 0
                {
                    if have_parlong == 1
                    {
                        is_come_from_story_hangout = 1
                    }
                }
                
                
                if is_come_from_story_hangout == 1
                {
                   
                    let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)

                    DataManager.comeFrom = kEmptyString
                    vc.view_user_id=cellData?.other_user_details?._id ?? ""
                    vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                    
                    vc.isContinue=true
                    vc.comfrom=kChat
                    vc.listType=kChat
                    vc.chat_room_id=cellData?._id ?? kEmptyString
                    if let img = cellData?.other_user_details?.profile_data?.image
                    {
                        vc.profileImage=img
            
                    }
                    let id  = cellData?.other_user_details?._id ?? kEmptyString
                    if id != kEmptyString
                    {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                //MARK: - For active to Inactive chat popup
                
                else if  ((is_continue_from_user == 0 && is_continue_to_user == 0) && (hourRemanning <= 48 && hourRemanning >= 25) && (isActiveTime != ""))
                {
                   
                    
                    if (response_other_user == 0 && response_self_user == 0)
                    {
                        let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
                        
                        destVC.type = .GrayOut
                        destVC.user_name=username.capitalized
                        destVC.view_user_id=cellData?.other_user_details?._id ?? ""
                        destVC.chat_room_id=cellData?._id ?? ""
                        
                        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        if let tab = self.tabBarController
                        {
                            tab.present(destVC, animated: true, completion: nil)
                        }
                        else
                        {
                            self.present(destVC, animated: true, completion: nil)
                        }                    }
                    else if (response_other_user == 1 && response_self_user == 1)
                    {
                        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)

                        DataManager.comeFrom = kEmptyString
                        vc.view_user_id=cellData?.other_user_details?._id ?? ""
                        vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                        vc.comfrom=kChat
                        vc.listType=kChat
                        vc.chat_room_id=cellData?._id ?? kEmptyString
                        if  continue_chat_status == 1
                        {
                            vc.isContinue=true
                        }
                        else
                        {
                            vc.isContinue=false
                        }
                        
                        if let img = cellData?.other_user_details?.profile_data?.image
                        {
   
                        vc.profileImage=img
                            
                        }
                        let id  = cellData?.other_user_details?._id ?? kEmptyString
                        if id != kEmptyString
                        {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else
                    {
                        let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
                        destVC.type = .GrayOut48Hrs
                        destVC.user_name=username.capitalized
                        destVC.view_user_id=cellData?.other_user_details?._id ?? ""
                        destVC.chat_room_id=cellData?._id ?? ""
                        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        
                        if let tab = self.tabBarController
                        {
                            tab.present(destVC, animated: true, completion: nil)
                        }
                        else
                        {
                            self.present(destVC, animated: true, completion: nil)
                        }                    }
                }
                //MARK: - Continue and end chat popup
                else if (response_other_user == 1 && response_self_user == 1) && (hourRemanning <= 24 && isActiveTime != "")
                {
                    
                    if  continue_chat_status == 1 && continue_chat_status_other_user == 0
                    {
                        let destVC = FeedbackAlertVC.instantiate(fromAppStoryboard: .Chat)
                        destVC.type = .onceContinue
                        destVC.user_name=username.capitalized
                        destVC.view_user_id=cellData?.other_user_details?._id ?? ""
                        destVC.chat_room_id=cellData?._id ?? ""
                        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        
                        if let tab = self.tabBarController
                        {
                            tab.present(destVC, animated: true, completion: nil)
                        }
                        else
                        {
                            self.present(destVC, animated: true, completion: nil)
                        }                    }
                    
                    else if  (continue_chat_status == 0 || continue_chat_status_other_user == 0)
                    {
                        //                else if (response_other_user == 0 || response_self_user == 0) && (hourRemanning <= 24 && isActiveTime != "")
                        //
                        //                {
                        
                        
                        //                    let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                        //                    let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                        //                    destVC.type = .GrayOut
                        //                    destVC.user_name=username.capitalized
                        //                    destVC.view_user_id=cellData?.other_user_details?._id ?? ""
                        //                    destVC.chat_room_id=cellData?._id ?? ""
                        //
                        //                    destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        //                    destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        //                    self.present(destVC, animated: true, completion: nil)
                        
                      
                        let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)

                        destVC.delegate=self
                        destVC.type = .continueChat
                        destVC.User_Name=cellData?.other_user_details?.profile_data?.username ?? ""
                        destVC.User_Id=cellData?.other_user_details?._id ?? ""
                        destVC.chat_room_id=cellData?._id ?? ""
                        self.imageLongPressIndex = indexPath.row-3
                        destVC.startTime=cellData?.like_dislike?.chat_start_time_active ?? ""
                        
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
                        let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)

                        DataManager.comeFrom = kEmptyString
                        vc.view_user_id=cellData?.other_user_details?._id ?? ""
                        vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                        vc.comfrom=kChat
                        vc.listType=kChat
                        vc.chat_room_id=cellData?._id ?? kEmptyString
                        if  continue_chat_status == 1
                        {
                            vc.isContinue=true
                        }
                        else
                        {
                            vc.isContinue=false
                        }
                        
                        if let img = cellData?.other_user_details?.profile_data?.image
                        {
                        
                        vc.profileImage=img
                        
                        }
                        let id  = cellData?.other_user_details?._id ?? kEmptyString
                        if id != kEmptyString
                        {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }
                
                
                else
                {
                    //                    let response_other_user = cellData?.response_other_user ?? 0
                    //
                    //                    if ((dif<=0) && (response_other_user == 0))
                    //                    {
                    //                        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                    //                        let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                    //                        destVC.type = .feedbackScreen
                    //                        destVC.user_name=username.capitalized
                    //                        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    //                        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    //
                    //                        self.present(destVC, animated: true, completion: nil)
                    //                    }
                    //                    else
                    //                    {
                    let vc = MessageVC.instantiate(fromAppStoryboard: .Chat)

                    
                    DataManager.comeFrom = kEmptyString
                    vc.view_user_id=cellData?.other_user_details?._id ?? ""
                    vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                    vc.comfrom=kChat
                    vc.listType=kChat
                    vc.chat_room_id=cellData?._id ?? kEmptyString
                    if  continue_chat_status == 1
                    {
                        vc.isContinue=true
                    }
                    else
                    {
                        vc.isContinue=false
                    }
                       if let img = cellData?.other_user_details?.profile_data?.image
                        {
                            vc.profileImage=img
                        }
                    
                    let id  = cellData?.other_user_details?._id ?? kEmptyString
                    if id != kEmptyString
                    {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    //}
                    
                }
                
                
                
                
                /*
                 if indexPath.row == 0 || indexPath.row == 1
                 {
                 let vc = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                 
                 let cellData = ChatVM.shared.chat_room_details_Array[indexPath.row]
                 vc.view_user_id=cellData.other_user_details?._id ?? ""
                 vc.profileName=cellData.other_user_details?.profile_data?.username ?? ""
                 
                 if cellData.other_user_details?.profile_data?.images?.count ?? 0>0
                 {
                 if let img = cellData.other_user_details?.profile_data?.images?[0].image
                 {
                 vc.profileImage=img
                 }
                 }
                 //
                 
                 self.navigationController?.pushViewController(vc, animated: true)
                 }else if indexPath.row == 1
                 {
                 
                 
                 let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                 let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
                 destVC.type = .continueChat
                 destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                 destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                 
                 self.present(destVC, animated: true, completion: nil)
                 }else if indexPath.row == 2{
                 
                 let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                 let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                 destVC.type = .feedbackScreen
                 destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                 destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                 
                 self.present(destVC, animated: true, completion: nil)
                 }
                 else
                 {
                 let vc = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                 //            let cellData = ChatVM.shared.chat_room_details_Array[indexPath.row]
                 //            vc.view_user_id=cellData.second_user_id ?? ""
                 //            vc.profileName=cellData.other_user_details?.profile_data?.username ?? ""
                 //
                 //            if cellData.other_user_details?.profile_data?.images?.count ?? 0>0
                 //                {
                 //                if let img = cellData.other_user_details?.profile_data?.images?[0].image
                 //                  {
                 //               vc.profileImage=img
                 //                }
                 //            }
                 self.navigationController?.pushViewController(vc, animated: true)
                 }
                 
                 */
    
                
                */
         
           /* }
            else
            {
                
                var cellData:chat_room_details_Model?
                
                if self.activeInactiveChatArray.count>indexPath.row-3
                {
                    cellData = self.activeInactiveChatArray[indexPath.row-3]
                }

                let id = cellData?._id ?? ""
                self.selectedUserName=id
                self.selectedUserId=cellData?.other_user_details?._id  ?? ""
                self.selectedUserName=cellData?.other_user_details?.profile_data?.username  ?? ""

                
                let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
                vc.comeFrom = kProlong
                vc.message=kReactivateProlong + "\(self.selectedUserName)" + kagainProlong
                vc.messageTitle=kHeadlineProlong
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
                
                
                /*
                //MARK: - Payment changes
                
                //if DataManager.purchaseProlong
                //{
                    
                    var cellData:chat_room_details_Model?
                    
                    if self.activeInactiveChatArray.count>indexPath.row-3
                    {
                        cellData = self.activeInactiveChatArray[indexPath.row-3]
                    }
                    let vc = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                    DataManager.comeFrom = kEmptyString
                    
                    
                    vc.comfrom=kChat
                    vc.listType=kChat
                    vc.chat_room_id=cellData?._id ?? kEmptyString
                    let continue_chat_status = cellData?.continue_chat_status ?? 0
                    vc.view_user_id=cellData?.other_user_details?._id ?? ""
                    vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                    if  continue_chat_status == 1
                    {
                        vc.isContinue=true
                    }
                    else
                    {
                        vc.isContinue=false
                    }
                    
                       if let img = cellData?.other_user_details?.profile_data?.image
                        {
                            vc.profileImage=img
                        }
                    let id  = cellData?.other_user_details?._id ?? kEmptyString
                    if id != kEmptyString
                    {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                   
               // }
                
                
                //            if ChatVM.shared.chat_room_details_Array.count>indexPath.row-3
                //            {
                //            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
                //            let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
                //            destVC.type = .chatScreen
                //            let cellData = ChatVM.shared.chat_room_details_Array[indexPath.row-3]
                //                let id = cellData._id ?? ""
                //            destVC.chat_room_id=id
                //            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                //            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                //            self.present(destVC, animated: true, completion: nil)
                //            }
                
                
                */
                
            }
            */
        }
    }
    
    
    @objc func menuBtnAct(_ sender: UIButton){
        
        
        if ChatVM.shared.chat_room_details_Array.count>sender.tag-3
        {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
//            let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
//            destVC.type = .chatScreen
            let cellData = ChatVM.shared.chat_room_details_Array[sender.tag-3]
            let id = cellData._id ?? ""
            self.selectedUserName=id
            self.selectedUserId=cellData.other_user_details?._id  ?? ""
            self.selectedUserName=cellData.other_user_details?.profile_data?.username  ?? ""
            
//            destVC.chat_room_id=id
//            destVC.view_user_id=cellData.other_user_details?._id  ?? ""
//            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            self.present(destVC, animated: true, completion: nil)
//
            
//            let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
//            let destVC = storyboard.instantiateViewController(withIdentifier: "NewPremiumVC") as!  NewPremiumVC //RegretPopUpVC
//            destVC.type = .Prolong
//            destVC.subscription_type=kProlong
//            destVC.delegate=self
//            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//
//            self.present(destVC, animated: true, completion: nil)
//
            
            
            let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
            vc.comeFrom = kProlong
            vc.message=kReactivateProlong + "\(self.selectedUserName)" + kagainProlong
            vc.messageTitle=kHeadlineProlong
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
        
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UILongPressGestureRecognizer)
    {
        if let tappedImage = tapGestureRecognizer.view as? UIImageView
        {
            if self.tableListBool
            {
                
                var cellData:chat_room_details_Model?
                
                if self.activeInactiveChatArray.count>tappedImage.tag-3
                {
                    cellData = self.activeInactiveChatArray[tappedImage.tag-3]
                }
                
            
                let destVC = StoryDiscardVC.instantiate(fromAppStoryboard: .Stories)

                destVC.delegate=self
                destVC.type = .continueChat
                destVC.User_Name=cellData?.other_user_details?.profile_data?.username ?? ""
                destVC.User_Id=cellData?.other_user_details?._id ?? ""
                destVC.chat_room_id=cellData?._id ?? ""
                destVC.startTime=cellData?.like_dislike?.chat_start_time_active ?? ""
                self.imageLongPressIndex = tappedImage.tag-3
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
            
            debugPrint(tappedImage.tag)
        }
        
        
        // Your action
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        
        if scrollView ==  self.chatTableView
        {
            if ((self.chatTableView.contentOffset.y + self.chatTableView.frame.size.height) >= self.chatTableView.contentSize.height-50)
            {
                if self.activeInactiveChatArray.count<ChatVM.shared.Pagination_Details?.totalCount ?? 0
                {
                    if tableListBool == true{
                        
                        self.callGetGetActiveChat(page: self.page)
                    }
                    else
                    {
                        self.callGetInActiveChat(page: self.page)
                    }
                }
                
            }
        }
        //       else if scrollView ==  self.chatStoriesCollectionView
        //       {
        //
        //        if ((self.chatStoriesCollectionView.contentOffset.x + self.chatStoriesCollectionView.frame.size.width) >= self.chatStoriesCollectionView.contentSize.width-50)
        //        {
        //            debugPrint("Greater")
        //
        //            if self.MatchArray.count<ChatVM.shared.Match_Pagination_Details?.totalCount ?? 0
        //            {
        //                self.callGetAllMatch(page: self.MatchPage, showIndiacter: true)
        //            }
        //        }
        //        else
        //        {
        //            debugPrint("less")
        //        }
        //
        //
        //       }
        
    }
}


// MARK:- Extension Api Calls
extension NewChatSectionVC:chatSortDelegate,DiscardDelegate
{
    
    
    //MARK: - Sort method
    
    func SortOptionName(name: String)
    {
        
        
        if tableListBool
        {
            
            
            if Connectivity.isConnectedToInternet {
                self.page=0
                self.activeInactiveChatArray.removeAll()
                //                activeButton.isSelected = true
                //                inactiveButton.isSelected = false
                //                bottomLabel.isHidden = false
                //                bottomIcon.isHidden = false
                tableListBool = true
                self.chatTableView.separatorStyle = .singleLine
                self.callGetGetActiveChat(page: 0)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        else
        {
            
            
            
            if Connectivity.isConnectedToInternet {
                // inactiveButton.isSelected = true
                
                tableListBool = false
                //                activeButton.isSelected = false
                //                bottomLabel.isHidden = true
                //                bottomIcon.isHidden = true
                self.chatTableView.separatorStyle = .none
                self.activeInactiveChatArray.removeAll()
                self.callGetInActiveChat(page: 0)
            } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
    }
    
    func callGetAllMatch(page: Int=0,showIndiacter:Bool=false)
    {
       
        
        var data = JSONDictionary()
        
        data[ApiKey.kOffset] = "\(page)"
        
        if Connectivity.isConnectedToInternet {
            
            self.getMatchesApi(data: data,showIndiacter:showIndiacter,page: page)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }
    func getMatchesApi(data:JSONDictionary,showIndiacter:Bool=false,page:Int)
    {
  
        ChatVM.shared.callApiMatchesProfile(showIndiacter: showIndiacter, data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
//                self.chatTableView.hideSkeleton()
                if page == 0
                {
                    self.MatchArray.removeAll()
                }
                
                for dict in ChatVM.shared.MatchUserDataArray
                {
                    self.MatchArray.append(dict)
                }
                
                self.MatchPage=self.MatchArray.count
                self.reloadActiveListCollection=false
                self.reloadMatchCollection=true
                self.chatTableView.reloadData()
            }
            
        })
    }
    
    
    func callGetGetActiveChat(page: Int,showIndiacter:Bool=false,ChatFilter:String=DataManager.chatFilter)
    {
        
        var data = JSONDictionary()
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kFilter] = ChatFilter//DataManager.chatFilter
        
        data[ApiKey.kOffset] = "\(page)"
        
        debugPrint("Data active = \(data)")
        
        if Connectivity.isConnectedToInternet {
//            self.chatTableView.showAnimatedSkeleton()
            self.getActiveChatApi(data: data,page: page,showIndiacter:showIndiacter)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    
    func getActiveChatApi(data:JSONDictionary,page:Int,showIndiacter:Bool)
    {
        if showIndiacter
        {
           // Indicator.sharedInstance.showIndicator2()
            
            self.showLoader()
        }
        
        
        ChatVM.shared.callApiGetActiveChat(showIndiacter:showIndiacter, data: data, response: { (message, error) in
            if error != nil
            {
           
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else
            {
                //self.chatTableView.hideSkeleton()
                if page == 0
                {
                    self.activeInactiveChatArray.removeAll()
                }
                self.tableListBool=true
                
                self.bottomLabel.isHidden = false
                self.bottomIcon.isHidden = false
    
                for dict in ChatVM.shared.chat_room_details_Array
                {
                    self.activeInactiveChatArray.append(dict)
                }
                if self.activeInactiveChatArray.count>0
                {
                    self.lblDataFound.isHidden=true
                }
                else
                {
                    self.lblDataFound.isHidden=false
                    self.lblDataFound.text = kEmptyActive
                    
                }
                self.reloadActiveListCollection=true
                self.reloadMatchCollection=false
                self.refreshControl.endRefreshing()
                self.chatTableView.reloadData()
                
                self.hideLoader()
                
            }
            
            
        })
    }
    
    
    func callGetInActiveChat(showIndiacter:Bool=false,page: Int)
    {
        
        var data = JSONDictionary()
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kFilter] = DataManager.chatFilter
        
        
        if Connectivity.isConnectedToInternet {
            
            self.getInActiveChatApi(showIndiacter:showIndiacter,data: data,page: page)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    
    func getInActiveChatApi(showIndiacter:Bool,data:JSONDictionary,page:Int)
    {
        ChatVM.shared.callApiGetInActiveChat(showIndiacter: showIndiacter,data: data, page: page, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
                
                self.tableListBool=false
                
                if page == 0
                {
                    self.activeInactiveChatArray.removeAll()
                }
                for dict in ChatVM.shared.chat_room_details_Array
                {
                    self.activeInactiveChatArray.append(dict)
                }
                if self.activeInactiveChatArray.count>0
                {
//                    self.chatTableView.hideSkeleton()
                    self.lblDataFound.isHidden=true
                    
                }
                else
                {
                    self.lblDataFound.isHidden=false
                    self.lblDataFound.text = kEmptyInActive
                    
                }
                self.reloadActiveListCollection=true
                self.refreshControl.endRefreshing()
                self.chatTableView.reloadData()
                
            }
            
            
        })
    }
    
    /*
    func updateLocationAPI()
    {
        var data = JSONDictionary()
        
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.KDeviceToken] = AppDelegate.DeviceToken
        if Connectivity.isConnectedToInternet {
            
            self.callApiForUpdateLatLong(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForUpdateLatLong(data:JSONDictionary)
    {
        HomeVM.shared.callApiForUpdateUserLatLong(showIndiacter: false, data: data, response: { (message, error) in
          //  debugPrint("Location update api = \(message)")
            
        })
    }
    */
    
    func continueChatPI()
    {
        var data = JSONDictionary()
        
        var cellData:chat_room_details_Model?
        
        if self.activeInactiveChatArray.count>self.imageLongPressIndex
        {
            cellData = self.activeInactiveChatArray[self.imageLongPressIndex]
        }
        
        let id = cellData?._id ?? ""
        
        data[ApiKey.kChat_room_id] = id
        
        if Connectivity.isConnectedToInternet {
            
            self.callApiForContinueChatPI(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func callApiForContinueChatPI(data:JSONDictionary)
    {
        ChatVM.shared.callApiContinueChat(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
                
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToChat()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToChat()
                }
            
                /*
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                
                
                var cellData:chat_room_details_Model?
                
                if self.activeInactiveChatArray.count>self.imageLongPressIndex
                {
                    cellData = self.activeInactiveChatArray[self.imageLongPressIndex]
                }
                
                vc.view_user_id=cellData?.other_user_details?._id ?? ""
                vc.profileName=cellData?.other_user_details?.profile_data?.username ?? ""
                
                if cellData?.other_user_details?.profile_data?.images?.count ?? 0>0
                {
                    if let img = cellData?.other_user_details?.profile_data?.images?[0].image
                    {
                        vc.profileImage=img
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                */
            }
            
        })
    }
    
    func getMySubscriptionApi()
    {
        AccountVM.shared.callApiGetMySubscription(response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                let active = AccountVM.shared.Prolong_Subsription_Data?.subscription_is_active ?? 0
                debugPrint("prolong active =\(active)")
                //MARK: - Payment changes
//                if active == 1
//                {
//
//                    DataManager.purchaseProlong=true
//                }
//                else
//                {
//                    DataManager.purchaseProlong=false
//                }
                
            }
        })
    }
    
  
    
    
    
    func onActiveInactiveChatScreenJoin()
    {
       
        //        socket.on('sendSmsAlert',({toUserId}) => {
        //           io.to(toUserId.toString()).emit('receivedSMS', {status : "true"});
        //         });
        
        let dict2 = ["SelfUserId":DataManager.Id]
        //,"buffer_img":gif
        SocketIOManager.shared.onActiveInactiveChatScreenJoin(MessageChatDict: dict2)
    }
    
    //MARK: - Time out continue
    
    func ClickNameAction(name: String) {
        
        if name == kContinueChat
        {
            self.continueChatPI()
            
            
        }
        
        
    }
    
    
    func saveActiveChatData(userData: MyProfileDataModel?) {


       let context = CoreDataManager.getContext()
//        let context = getbgContext()
       let entity = NSEntityDescription.entity(forEntityName: ApiKey.kOwnProfile, in: context)
       let newdata = NSManagedObject(entity: entity!, insertInto: context)
       do {
          let age = userData?.age ?? 0
           let phone = userData?.phone_number ?? 0
           newdata.setValue(userData?.bio ?? kEmptyString, forKey: ApiKey.kBio)
           newdata.setValue("\(age)", forKey: ApiKey.kAge)
           newdata.setValue("\(phone)", forKey: ApiKey.kPhoneNumber)
           newdata.setValue(userData?.unit, forKey: ApiKey.kUnit)
           newdata.setValue(userData?.city ?? kEmptyString, forKey: ApiKey.kCity)
           newdata.setValue(userData?.company_name ?? kEmptyString, forKey: ApiKey.kCompany_name)
           newdata.setValue(userData?.job_title ?? kEmptyString, forKey: ApiKey.kJob_title)
           newdata.setValue(userData?.username ?? kEmptyString, forKey: ApiKey.kUsername)
    
           do {
               try context.save()
               debugPrint("Saved profile data")
           } catch {
               debugPrint("***************** error while Saving *********")
           }
       } catch {
           debugPrint("***************** error while Saving *********")
       }
   }
    
    
}
extension NewChatSectionVC: CLLocationManagerDelegate
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


//MARK: - Socket method

extension NewChatSectionVC
{
    
//    func selfJoinSocketEmit()
//    {
//        
//        let JoinDict = ["selfUserId":DataManager.Id]
//        SocketIOManager.shared.selfJoinSocket(MessageChatDict: JoinDict)
//        
//    }
//    
    
    
    
    func updateOnlineStatusAfter2MinutesEmit()
    {
        
        let JoinDict = ["selfUserId":DataManager.Id,"timezone":TIMEZONE]
        SocketIOManager.shared.updateOnlineStatusAfter2Minutes(MessageChatDict: JoinDict)
    }
    
    
    
    /*
     
     func checkRoomExistEmit()
     {
     
     let JoinDict = ["roomID":DataManager.Id]
     SocketIOManager.shared.checkRoomExist(MessageChatDict: JoinDict)
     
     }
     
     func statusJoin_ON_Method()
     {
     
     
     SocketIOManager.shared.socket.on("statusJoin", callback: { (data, error) in
     
     debugPrint("statusJoin = \(data)")
     if let data = data as? JSONArray
     {
     for dict in data
     {
     
     let status =  dict["status"] as? String ?? ""
     
     if status == kTrue
     {
     
     }
     else
     {
     self.selfJoinSocketEmit()
     }
     }
     }
     else
     {
     self.selfJoinSocketEmit()
     }
     
     
     })
     }
     */
    
    
    
    
    func sendSMS_ON_Method()
    {
        
        
        SocketIOManager.shared.socket.on("receivedSMS", callback: { (data, error) in
            
            
            debugPrint("receivedSMS = \(data)")
            
            if let data = data as? JSONArray
            {
                for dict in data
                {
                    
                    let status =  dict["status"] as? String ?? ""
                  debugPrint("receivedSMS status = \(status)")
                    
                    if status == kTrue
                    {
                        if  DataManager.currentScreen.equalsIgnoreCase(string: kChat)
                        {
                            if self.MatchArray.count>0
                            {
                                self.reloadMatchCollection=true
                            DispatchQueue.main.async {
                                if Connectivity.isConnectedToInternet {
                                    self.MatchArray.removeAll()
                                    self.callGetAllMatch(page: 0,showIndiacter: false)
                                } else {
                                    
                                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                                }
                            }
                            }
                            
                            if self.tableListBool
                            {
                                self.reloadActiveListCollection=true
                                self.activeInactiveChatArray.removeAll()
                                //                            self.activeButton.isSelected = true
                                //                            self.inactiveButton.isSelected = false
                                //                            self.bottomLabel.isHidden = false
                                //                            self.bottomIcon.isHidden = false
                                self.tableListBool = true
                                self.chatTableView.separatorStyle = .singleLine
                                
                                if Connectivity.isConnectedToInternet {
                                    self.page=0
                                    self.callGetGetActiveChat(page: 0,showIndiacter: false)//,ChatFilter: kEmptyString
                                } else {
                                    
                                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                                }
                            }
                            else
                            {
                                
                                // self.inactiveButton.isSelected = true
                                
                                self.tableListBool = false
                                //                            self.activeButton.isSelected = false
                                //                            self.bottomLabel.isHidden = true
                                //                            self.bottomIcon.isHidden = true
                                self.chatTableView.separatorStyle = .none
                                self.activeInactiveChatArray.removeAll()
                                
                                if Connectivity.isConnectedToInternet {
                                    
                                    self.callGetInActiveChat(showIndiacter: false, page: 0)
                                } else {
                                    
                                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                                }
                            }
                        }
                    }
                }
                
            }
        })
        
    }
}

extension NewChatSectionVC:paymentScreenOpenFrom,deleteAccountDelegate,NavigateToPaymentPopup
{
 
    func FromScreenName(name: String, ActiveDay: Int)
    {
        debugPrint("name \(name)")
        
    }
    
    func deleteAccountFunc(name: String) {
        
        debugPrint(name)
        if name.equalsIgnoreCase(string: kProlong)
        {

            self.showLoader()
            
            IAPHandler.shared.purchase(product: .kChat)
                IAPHandler.shared.delegate=self
            
        }
    }
    
    func NavigateToPayment(name: String,transactionId: String?)
    {
        
        debugPrint("payment call \(name)")
        if name.equalsIgnoreCase(string: kSucess)
        {
           
     
            
            var data = JSONDictionary()
            data[ApiKey.kTransaction_id] = transactionId ?? kEmptyString
            data[ApiKey.kAmount] = "100"
            data[ApiKey.kSubscription_type] = kProlong
            data[ApiKey.kSubName] = kProlong
 
            data["other_user_id"] = self.selectedUserId

            
            debugPrint("Payment para = \(data)")
            
            if Connectivity.isConnectedToInternet {

                self.updatePaymentApi(data: data)
            } else {
                self.hideLoader()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        else
        {
            self.hideLoader()
        }
    }
    
    
    func updatePaymentApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdatePayment(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
     
                    self.tableListBool=true
                    DispatchQueue.main.async
                    {
                        self.bottomLabel.isHidden = false
                        self.bottomIcon.isHidden = false
                        self.tableListBool = true
                        self.chatTableView.separatorStyle = .singleLine
            
                           self.activeInactiveChatArray.removeAll()
                      
                        self.callGetGetActiveChat(page: 0)
                    }
                
                
            }
            
            
        })
    }
    
//    func badgeCountIntervalCheckEmit()
//    {
//
//        let JoinDict = ["userId":DataManager.Id]
//
//        debugPrint("badgeCountIntervalCheckEmit \(JoinDict)")
//        SocketIOManager.shared.badgeCountIntervalCheckEmit(MessageChatDict: JoinDict)
//        DispatchQueue.main.async {
//            self.badgeCountIntervalCheckON()
//        }
//
//    }
//    func badgeCountIntervalCheckON()
//    {
//        SocketIOManager.shared.socket.on("receivedBadgeCount", callback: { (data, error) in
//
//            //self.RoundRedView.isHidden=true
//            //  debugPrint("badgeCountIntervalCheckON \(data) \(error)")
//
//            if let data = data as? JSONArray
//            {
//                for dict in data
//                {
//
//                    let badgeCount =  dict["badgeCount"] as? Int ?? 0
//                    if badgeCount > 0
//                    {
//
//                        self.tabBarController?.tabBar.items![1].badgeValue = ""
//                    }
//                    else
//                    {
//
//                    }
//                }
//            }
//            else
//            {
//               // self.RoundRedView.isHidden=true
//            }
//
//            //  debugPrint("receivedBadgeCount = \(data) \(error)")
//        })
//
//    }
}
