//
//  ChatScreenVC.swift
//  Flazhed
//
//  Created by IOS25 on 07/01/21.
//

import UIKit
import CoreLocation

class ChatScreenVC: BaseVC {
    //MARK:- All outlets
    @IBOutlet weak var topStoryHeightConst: NSLayoutConstraint!
    @IBOutlet weak var chatsStoriesView: UIView!
    @IBOutlet weak var chatStoriesCollectionView: UICollectionView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var inactiveButton: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomIcon: UIImageView!
    
    //MARK:- All Variable
    
    var storyImageArray: [UIImage] = [#imageLiteral(resourceName: "chatdp"), #imageLiteral(resourceName: "chatdp")]
    var UserNameArray: [String] = ["Emily","Chelsea"]
    var chatUserNameArray:[String] = ["Stephanie","Sarah","Diana","Natasha"]
    var chatUserLastMessageArray:[String] = ["Let's have a call soon😉✌","Send me some tunes🎵","You got a cute dog","Heyy"]
    var dateTimeArray:[String] = ["10:30 PM","Yesterday","Yesterday","15/08/20"]
    var chatImageArray:[UIImage] = [#imageLiteral(resourceName: "user2"),#imageLiteral(resourceName: "user2"),#imageLiteral(resourceName: "user2"),#imageLiteral(resourceName: "user2")]
    var tableListBool: Bool?
    let locationmanager = CLLocationManager()
    
    var activeInactiveChatArray:[chat_room_details_Model] = []
    
    var chatFilter = ""  //Filter should be unread,latest,closest
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeButton.isSelected = true
        tableListBool = true
        chatTableView.tableFooterView = UIView()
     //  SocketIOManager.shared.initializeSocket()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        
        /*
        let currentuser =  Profile()
        
        print("current usr = \(currentuser)")
        
       if DataManager.comeFrom != kViewProfile
        {
            
        if Connectivity.isConnectedToInternet {

            self.callGetAllMatch(page: 0)
        } else {

            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        }
        else
       {
        DataManager.comeFrom = kEmptyString
       }
        
        self.activeInactiveChatArray.removeAll()
        
        

        if Connectivity.isConnectedToInternet {

            self.callGetGetActiveChat(page: 0)
        } else {

            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
        */
        
        
    
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
       // SocketIOManager.shared.disconnectSocket()
    }
    //MARK:- Filter action
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "SortingAlertVC") as! SortingAlertVC
        destVC.delegate=self
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
    }
    
    @IBAction func activeChatButtonAction(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        inactiveButton.isSelected = false
        bottomLabel.isHidden = false
        bottomIcon.isHidden = false
        tableListBool = true
        self.chatTableView.separatorStyle = .singleLine
        self.chatTableView.reloadData()
        self.activeInactiveChatArray.removeAll()
        /*
        if Connectivity.isConnectedToInternet {

            self.callGetGetActiveChat(page: 0)
        } else {

            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        */

    }
    
    
    @IBAction func inactiveButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        tableListBool = false
        activeButton.isSelected = false
        bottomLabel.isHidden = true
        bottomIcon.isHidden = true
        self.chatTableView.separatorStyle = .none
        self.activeInactiveChatArray.removeAll()
        
//        if Connectivity.isConnectedToInternet {
//
//            self.callGetInActiveChat(page: 0)
//        } else {
//
//            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
//        }

        self.chatTableView.reloadData()
    }
    
}

extension ChatScreenVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  UserNameArray.count//ChatVM.shared.MatchUserDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatStoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "ChatStoriesCVC", for: indexPath) as! ChatStoriesCVC
        
        cell.progressView.trackClr = .white
        
        cell.progressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
        if indexPath.row == 0{
            cell.heighLightColorView.isHidden = false
            cell.progressView.setProgressWithAnimation(duration: 1.0, value: 0.75)
        }else if indexPath.row == 1{
            cell.progressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
        }
        cell.userName.text = UserNameArray[indexPath.row]
         cell.storyImageView.image = storyImageArray[indexPath.row]
        
    
        /*
        let cellData = ChatVM.shared.MatchUserDataArray[indexPath.row]

        cell.heighLightColorView.isHidden = false
        cell.progressView.setProgressWithAnimation(duration: 1.0, value: 0.75)
        
        let dif  = "".checkTimeDiffrent(startTime: cellData.like_dislikeData?.chat_start_time_active ?? "")
        print("time check = \(dif)")
        cell.heighLightColorView.isHidden = false
        if dif <= 48
        {
            if dif <= 24
            {
                cell.progressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
                cell.progressView.progressClr = UIColor.red
            }
            else
            {
                cell.progressView.setProgressWithAnimation(duration: 1.0, value: 1)
                cell.progressView.progressClr = LINECOLOR
            }
        }
        else
        {
            cell.progressView.setProgressWithAnimation(duration: 1.0, value: 1)
            cell.progressView.progressClr = LINECOLOR
        }
        
        if cellData.profile_data?.images?.count ?? 0>0
            {
              if let img = cellData.profile_data?.images?[0].image
              {
                DispatchQueue.main.async {
                let url = URL(string: img)!
                cell.storyImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                }
              }
            }
        
 
        cell.userName.text = cellData.profile_data?.username ?? ""///UserNameArray[indexPath.row]
        cell.storyImageView.cornerRadius = cell.storyImageView.frame.height/2
        cell.storyImageView.contentMode = .scaleAspectFill
        
        */
      
 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = chatStoriesCollectionView.bounds.width //collectionWidth/4 - 10   65
        return CGSize(width: collectionWidth/4 - 10 , height: collectionWidth/4) //collectionWidth/4  110
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       

        let vc = storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC//MessageVC
        /*
        let cellData = ChatVM.shared.MatchUserDataArray[indexPath.row]
        vc.view_user_id=cellData.user_id ?? ""
        vc.profileName=cellData.profile_data?.username ?? ""

        if cellData.profile_data?.images?.count ?? 0>0
            {
            if let img = cellData.profile_data?.images?[0].image
              {
           vc.profileImage=img
            }
        }
        */
        
        
//
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ChatScreenVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableListBool == true{
            return  chatUserNameArray.count // self.activeInactiveChatArray.count
        }else{
            return 1 // ChatVM.shared.chat_room_details_Array.count//
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatListingTVC") as! ChatListingTVC
        cell.selectionStyle = .none
        
        if tableListBool == true{
            /*
            var cellData:chat_room_details_Model?
            
            if self.activeInactiveChatArray.count>indexPath.row
            {
                cellData = self.activeInactiveChatArray[indexPath.row]
            }
            
           
            cell.pendingMessagesNumberLabel.layer.cornerRadius = 10.25
            cell.pendingMessagesNumberLabel.clipsToBounds = true
            cell.userNameLabel.text = cellData?.other_user_details?.profile_data?.username ?? ""
            cell.userLastMessageLabel.text = cellData?.last_message ?? ""
            
            if cellData?.other_user_details?.profile_data?.images?.count ?? 0>0
                {
                if let img = cellData?.other_user_details?.profile_data?.images?[0].image
                  {
                    DispatchQueue.main.async {
                    let url = URL(string: img)!
                    cell.userProfileIMage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    }
                  }
                }
            
            cell.userProfileIMage.cornerRadius = cell.userProfileIMage.frame.height/2
            cell.userProfileIMage.contentMode = .scaleAspectFill
            cell.circularProgressView.isHidden = false
            cell.circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
            cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
            
            */
            
            cell.circularProgressView.isHidden = false
            cell.menuButton.isHidden = true
            cell.pendingMessagesNumberLabel.layer.cornerRadius = 10.25
            cell.pendingMessagesNumberLabel.clipsToBounds = true
            cell.userNameLabel.text = chatUserNameArray[indexPath.row]
            cell.userLastMessageLabel.text = chatUserLastMessageArray[indexPath.row]
            cell.dateAndTimeLabel.text = dateTimeArray[indexPath.row]
            cell.userProfileIMage.image = chatImageArray[indexPath.row]
//            cell.circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
//
            if indexPath.row == 0{
                cell.pendingMessagesNumberLabel.isHidden = false
                cell.dateAndTimeLabel.textColor = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
                cell.userLastMessageLabel.textColor = .black
                cell.circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
                cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
            }else{
                cell.pendingMessagesNumberLabel.isHidden = true
                cell.userLastMessageLabel.textColor = #colorLiteral(red: 0.3921568627, green: 0.4784313725, blue: 0.6078431373, alpha: 1)
                if indexPath.row == 1 || indexPath.row == 3 {
                    cell.circularProgressView.progressClr = #colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
                    cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.42)
                }else{
                    cell.circularProgressView.progressClr = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.0)
                }
            }
            
        
            cell.circularProgressView.trackClr = .white
           
            
            
            
        }else{
            
            
           
            cell.menuButton.isHidden = false
            cell.userNameLabel.text = "Liz"
            cell.userLastMessageLabel.text = "I am from San Francisco. Nice to..."
            cell.userLastMessageLabel.textColor = CHATINACTIVECOLOR
            cell.dateAndTimeLabel.text = "07/04/20"
            cell.dateAndTimeLabel.textColor = TIMEACTIVECOLOR
            cell.userProfileIMage.image = #imageLiteral(resourceName: "IMag")
            cell.pendingMessagesNumberLabel.isHidden = true
            cell.circularProgressView.isHidden = true
            
            
        
            
            
            /*
            let cellData = ChatVM.shared.chat_room_details_Array[indexPath.row]
            cell.pendingMessagesNumberLabel.layer.cornerRadius = 10.25
            cell.pendingMessagesNumberLabel.clipsToBounds = true
            cell.userNameLabel.text = cellData.other_user_details?.profile_data?.username ?? ""
            if cellData.other_user_details?.profile_data?.images?.count ?? 0>0
                {
                if let img = cellData.other_user_details?.profile_data?.images?[0].image
                  {
                    DispatchQueue.main.async {
                    let url = URL(string: img)!
                    cell.userProfileIMage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    }
                  }
                }
            
            cell.userProfileIMage.cornerRadius = cell.userProfileIMage.frame.height/2
            cell.userProfileIMage.contentMode = .scaleAspectFill
            
            */
             cell.menuButton.addTarget(self, action: #selector(menuBtnAct), for: .touchUpInside)
            
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    @objc func menuBtnAct(_ sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
        destVC.type = .chatScreen
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableListBool == true{

        if indexPath.row == 0{
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
        }
        else
        {
//            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
//            let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
//            destVC.type = .chatScreen
//            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//            self.present(destVC, animated: true, completion: nil)
        }
    }
}


// MARK:- Extension Api Calls
extension ChatScreenVC:chatSortDelegate
{
    func SortOptionName(name: String)
    {
        
        self.chatFilter=name
        self.callGetGetActiveChat(page: 0)
    }
    
    func callGetAllMatch(page: Int)
    {
        var data = JSONDictionary()

        data[ApiKey.kOffset] = "\(page)"
  
            if Connectivity.isConnectedToInternet {
                
                self.getMatchesApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
    }
    func getMatchesApi(data:JSONDictionary)
    {
        ChatVM.shared.callApiMatchesProfile(data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {

                
                self.chatStoriesCollectionView.reloadData()
//                if ChatVM.shared.MatchUserDataArray.count>0
//                {
//                    self.topStoryHeightConst.constant = 150
//                    self.chatStoriesCollectionView.reloadData()
//                }
//                else
//                {
//                    self.topStoryHeightConst.constant = 0
//                    self.chatStoriesCollectionView.reloadData()
//                }
            }
     
        })
    }

    
    func callGetGetActiveChat(page: Int)
    {
        var data = JSONDictionary()
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kFilter] = DataManager.chatFilter
        
        data[ApiKey.kOffset] = "\(page)"
  
        print("Data active = \(data)")
        
            if Connectivity.isConnectedToInternet {
                
                self.getActiveChatApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    
    
    func getActiveChatApi(data:JSONDictionary)
    {
        ChatVM.shared.callApiGetActiveChat(data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
                self.tableListBool=true
                
                for dict in ChatVM.shared.chat_room_details_Array
                {
                    self.activeInactiveChatArray.append(dict)
                }
                
                self.chatTableView.reloadData()
            }
            
            
        })
    }

    
    func callGetInActiveChat(page: Int)
    {
      
        var data = JSONDictionary()
        data[ApiKey.kLatitude] = CURRENTLAT
        data[ApiKey.kLongitude] = CURRENTLONG
        data[ApiKey.kOffset] = "\(page)"
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kFilter] = "latest"
        
  
            if Connectivity.isConnectedToInternet {
                
                self.getInActiveChatApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    
    
    func getInActiveChatApi(data:JSONDictionary)
    {
        ChatVM.shared.callApiGetInActiveChat(data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
                self.tableListBool=false
                self.chatTableView.reloadData()
            }
            
            
        })
    }
    
}
extension ChatScreenVC: CLLocationManagerDelegate
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
