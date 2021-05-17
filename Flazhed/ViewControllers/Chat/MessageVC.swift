//
//  MessageVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import Quickblox
import QuickbloxWebRTC

class MessageVC:BaseVC {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var navigateView: UIView!
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var audioCallButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var shareBUtton: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var buttomConst: NSLayoutConstraint!

    @IBOutlet weak var txtHeightConst: NSLayoutConstraint!
    
    var profileImage=""
    var profileName = ""
    var view_user_id = ""
    
    let dataArray = [["Haha, alright. Then my cooking MIGHT be  okay. ", "Do you know cooking???"]]
    
    var appdel = ""
    var chat_room_id = ""
    var from_user_id = ""
    
    var chatDataArray:[Socket_Chat_Model] = []
    let opponentsIDs = [3245, 2123, 3122]
    private weak var session: QBRTCSession?
    let newUser = QBUUser()
    
    var allMessageArray:[AllMessageModel] = []
    
    var messageSortArray:[ShowMessageModel] = []
    var messageHeaderArray:[ShowMessageModel] = []
    var TodayMessageArray:[ShowMessageModel] = []
    var YesterDayMessageArray:[ShowMessageModel] = []
    
    var messageArray:[AllMessageModel] = []
    var messageGroupArray:[[AllMessageModel]] = []
    
    
    
    var messageOffSet = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circularProgressView.trackClr = .white
        circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
        circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.messageTableView.rowHeight = 100
        self.messageTableView.estimatedRowHeight = UITableView.automaticDimension
        
        setupTable()
        self.messageGroupArray.removeAll()
        //self.getAllMessage()
        
       // QBRTCClient.initializeRTC()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DismissFeedBackAct), name: NSNotification.Name(rawValue: "DismissFeedBack"), object: nil)
        
        print("Other user id:  = \(self.view_user_id)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        self.txtMessage.text = ""
        self.txtMessage.delegate=self
        
        IQKeyboardManager.shared.enable=false
        /*
           SocketIOManager.shared.initializeSocket()
        if view_user_id != ""
        {
            self.allMessageArray.removeAll()
            self.messageGroupArray.removeAll()
            self.callCreateRoomApi(other_User_Id: view_user_id, offSet: self.messageOffSet)
            self.userNameLabel.text = profileName
            if profileImage != ""
            {

              let url = URL(string: profileImage)!
              self.userProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)

            }
           // self.connect()
        }
        */
        
        userProfile.cornerRadius = userProfile.frame.height/2
        userProfile.contentMode = .scaleAspectFill
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.navigationBar.isHidden=true
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable=true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    
    }
    @objc func DismissFeedBackAct()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK:- View profile button action 🍎
    
    @IBAction func ViewProfileAct(_ sender: UIButton) {
        
//        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
//        vc.view_user_id = self.view_user_id
//
//        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    
    //MARK:- Three dot button action 🍎
    
    @IBAction func menuButtopnAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
        destVC.type = .messageScreen
        destVC.view_user_id=self.view_user_id
        destVC.user_name=self.profileName.capitalized
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
      
    }
    //MARK:- audio call button action 🍎
    
    @IBAction func audioCallBUttonAction(_ sender: UIButton) {
       let vc = storyboard?.instantiateViewController(withIdentifier: "AudioCallingVC") as! AudioCallingVC
        self.navigationController?.pushViewController(vc, animated: true)
     
    }
    
    //MARK:- video call button action 🍎
    
    @IBAction func videoCallButtonAction(_ sender: UIButton) {
        
       
        

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC

    self.navigationController?.pushViewController(vc, animated: true)

        /*
        
      //  self.signUp(fullName: "amar12345", login: "123456")
        
        
       
        newUser.login = self.from_user_id//"Amar123457"
        newUser.fullName = DataManager.userName ?? chat_room_id///"Qickblock@!123"
        newUser.password = LoginConstant.defaultPassword
        
        QBRequest.signUp(newUser, successBlock: { [weak self] response, user in
            
            print(response)
            print(user)
            QBRequest.logIn(withUserLogin: self?.from_user_id ?? "",
                            password: LoginConstant.defaultPassword,
                            successBlock: { [weak self] response, user in
                               
                                print(response)
                                print(user)
                                //user.password = password
                                //user.updatedAt = Date()
                                Profile.synchronize(user)
                              print(user)
                                if user.fullName != (self?.from_user_id ?? "") {
                                    self?.updateFullName(fullName: DataManager.userName, login: self?.from_user_id ?? "")
                                } else {
                                    self?.connectToChat(user: user)
                                }
                                
//                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
//                                self?.navigationController?.pushViewController(vc, animated: true)
                                
                }, errorBlock: { [weak self] response in
                   
                    print(response.error)
                    if response.status == QBResponseStatusCode.unAuthorized
                    {
                        // Clean profile
                        Profile.clearProfile()
                       
                    }
            })

         
            
            }, errorBlock: { [weak self] response in
                
                print(response.error)
                QBRequest.logIn(withUserLogin: "Amar123457",
                                password: LoginConstant.defaultPassword,
                                successBlock: { [weak self] response, user in
                                   
                                    print(response)
                                    print(user)
                                    //user.password = password
                                    //user.updatedAt = Date()
                                    Profile.synchronize(user)
                                  print(user)
                                    if user.fullName != "Qickblock@!123" {
                                        self?.updateFullName(fullName: "Qickblock@!123", login: "Amar123457")
                                    } else {
                                        self?.connectToChat(user: user)
                                    }
                                })
                if response.status == QBResponseStatusCode.validationFailed {
                    // The user with existent login was created earlier
                  
                    return
                }
                
        })
 
        */
       
       // self.signUpOnQuickBlox()
    }
    
    /*
    
    func signUpOnQuickBlox()
    {
        newUser.login = self.from_user_id
        newUser.fullName = DataManager.userName
        newUser.password = LoginConstant.defaultPassword
        
        
        QBRequest.signUp(newUser, successBlock: { [weak self] response, user in
            self?.signInOnQuickBlox()
            print("Sign up response = \(response)")
        }) { (error) in
            self.signInOnQuickBlox()
            print("Error in signup = \(error)")
        }
    }
    
    func signInOnQuickBlox()
    {
        newUser.login = self.from_user_id
        newUser.fullName = DataManager.userName
        newUser.password = LoginConstant.defaultPassword
        
        QBRequest.logIn(withUserLogin: self.from_user_id,
                        password: LoginConstant.defaultPassword,
                        successBlock: { [weak self] response, user in
                            print("Sign in response = \(response) \(user)")
                            self?.ConnectUserQuickBlox(user: user)
                        }) { (error) in
            print("Error in signin = \(error)")
        }
            
        
        let firstPage = QBGeneralResponsePage(currentPage: 1, perPage: 100)
        QBRequest.users(withExtendedRequest: ["order": "desc date updated_at"],
                        page: firstPage,
                        successBlock: { [weak self] (response, page, users) in
                           
                            print("user List = \(users)")
            }, errorBlock: { response in
               
                debugPrint("[UsersViewController] loadUsers error: \(response)")
        })

    }
    
    func ConnectUserQuickBlox(user:QBUUser)
    {
    QBChat.instance.connect(withUserID: user.id,
                            password: LoginConstant.defaultPassword,
                            completion: { [weak self] error in
                                
                                print("Error in connect = \(error)")
                                
                                if let error = error
                                {
                                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                                        // Clean profile
                                        Profile.clearProfile()
                                        self?.defaultConfiguration()
                                    }
                                    else if error._code == -1000
                                    {
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
                                        let otherUser = QBUUser()
                                        otherUser.login = self?.view_user_id//"Amar123457"
                                        otherUser.fullName = self?.profileName///"Qickblock@!123"
                                        otherUser.password = LoginConstant.defaultPassword
                                        
                                        vc.newUser2=user//otherUser
                                        self?.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else {
                                        self?.handleError(error, domain: ErrorDomain.logIn)
                                    }
                                } else {
                            
                                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
                                    let otherUser = QBUUser()
                                    otherUser.login = self?.view_user_id//"Amar123457"
                                    otherUser.fullName = self?.profileName///"Qickblock@!123"
                                    otherUser.password = LoginConstant.defaultPassword
                                    
                                    vc.newUser2=user//otherUser
                                            self?.navigationController?.pushViewController(vc, animated: true)
                                }

                            })
    }
    */
    
    //MARK:- back button action 🍎
    
    @IBAction func backBUttonAction(_ sender: UIButton) {
        if self.appdel == kAppDelegate
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
            DataManager.comeFrom=kViewProfile
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK:- Send message action 🍎
    
    
    @IBAction func shareButtonAction(_ sender: UIButton)
    {
        let dateFromatter = DateFormatter()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        dateFromatter.calendar = calendar
        dateFromatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let now = Date()

        let dateInString = dateFromatter.string(from: now)
        
      
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let dict = ["timezone":TIMEZONE,"chat_room_id":self.chat_room_id,"to_user_id":self.view_user_id,"message":self.txtMessage.text!,"from_user_id":self.from_user_id,"messageTime":dateInString]

         //   let JoinDict = ["otherName":self.profileName,"room":self.chat_room_id,"selfName":DataManager.userName]

    //self.chat_room_id
           // SocketIOManager.shared.establishConnection(emitRequest: "Chat", jsonDict: dict, joinDict: JoinDict)
            
            SocketIOManager.shared.sendChatMessage(MessageChatDict: dict)
            self.txtMessage.text = ""
        }
        self.txtHeightConst.constant=60
    }
    
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
//        if self.getDeviceModel() == "iPhone 6"
//        {
//            buttomConst.constant = keyboardHeight+40
//
//        }else if self.getDeviceModel() == "iPhone 10"{
//            buttomConst.constant = keyboardHeight+40
//        }
//        else
//        {
//            self.buttomConst.constant = keyboardHeight+40
//
//        }
        self.buttomConst.constant = keyboardHeight+40
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        buttomConst.constant = 20
       
    }
    
    // MARK:- Private Functions
    private func validateData () -> String?
    {
        if txtMessage.text.isEmpty {
            return kEmptyMessage
        }
      
        
        return nil
    }
    
}

extension MessageVC : UITableViewDelegate, UITableViewDataSource{
    
    
    func setupTable()
    {
    
        self.messageTableView.register(UINib(nibName: "SenderTCell", bundle: nil), forCellReuseIdentifier: "SenderTCell")
        self.messageTableView.register(UINib(nibName: "ReceiverTCell", bundle: nil), forCellReuseIdentifier: "ReceiverTCell")
        
        self.messageTableView.register(UINib(nibName: "TimeHeadeTCell", bundle: nil), forCellReuseIdentifier: "TimeHeadeTCell")
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //self.messageGroupArray.count//1//self.messageSortArray.count//self.messageHeaderArray.count//1//dataArray.count //1//
    }
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 2 //self.messageGroupArray[section].count//2//self.chatDataArray.count//self.messageSortArray.count// self.messageHeaderArray[section].headerAllMessage?.count ?? 0//self.messageSortArray.count//self.allMessageArray.count// // dataArray[section].count //s   self.chatDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        /*
        let cellData = self.messageGroupArray[indexPath.section][indexPath.row] //self.messageHeaderArray[indexPath.section].headerAllMessage?[indexPath.row]//self.messageSortArray[indexPath.row]//self.allMessageArray[indexPath.row] //self.chatDataArray[indexPath.row]
        
        
        if self.from_user_id == cellData.to_user_id//cellData.from_user_id
        {
            let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReceiverTCell") as! ReceiverTCell
            cell.lblMessage.text =  cellData.messageText
            let time = cellData.messageTime ?? ""
            
           let time2 = time.utcToLocalTime(dateStr: time)
           
            cell.lbltime.text = time2
            
            return cell
        }else{
            let cell = messageTableView.dequeueReusableCell(withIdentifier: "SenderTCell") as! SenderTCell
            cell.lblMessage.text =  cellData.messageText
            let time = cellData.messageTime ?? ""
            
           let time2 = time.utcToLocalTime(dateStr: time)
           
            cell.lbltime.text = time2
            
            return cell
        }
    */
        
    
        if indexPath.row == 0 //self.from_user_id == cellData.from_user_id
        {
            
            let cell = messageTableView.dequeueReusableCell(withIdentifier: "SenderTCell") as! SenderTCell
            cell.lblMessage.text =  "Haha, alright. Then my cooking MIGHT be okay." //cellData.message
            return cell
        }else{
            let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReceiverTCell") as! ReceiverTCell
            cell.lblMessage.text =  "Do you know cooking???" // cellData.message
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeHeadeTCell") as! TimeHeadeTCell
        
        /*
      let data =  self.messageGroupArray[section]
        
        if data.count>0
        {
            let celldata = data[0].messageTime ?? ""
            let time = celldata.dateFromString(format: .NewISO, type: .utc)
            let calendar = Calendar(identifier: .gregorian)
            if calendar.isDateInToday(time)
            {
                cell.lblTime.text = "Today"
            }
            else if calendar.isDateInYesterday(time)
            {
                cell.lblTime.text = "Yesterday"
            }
            else
            {
            cell.lblTime.text = time.string(format: .DOBFormat, type: .local)
            }
        }
        */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {

//        if ((self.messageTableView.contentOffset.y + self.messageTableView.frame.size.height) >= self.messageTableView.contentSize.height-50)
//            {
//
//            print("scroll down ")
//                if self.messageSortArray.count<ChatVM.shared.Pagination_Details?.totalCount ?? 0
//                {
//
//
//                }
//
//            }
//        else
        
        
        
        if ((self.messageTableView.contentOffset.y + self.messageTableView.frame.size.height) <= self.messageTableView.contentSize.height-50)
        {
            print("scroll up ")
            if self.allMessageArray.count<ChatVM.shared.Pagination_Details?.totalCount ?? 0
            {
                self.callCreateRoomApi(other_User_Id: view_user_id, offSet: self.messageOffSet)
                
            }
        }
       
    }
}

extension MessageVC: UITextViewDelegate {

func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
    let numberOfChars = newText.count // for Swift use count(newText)
    
    if numberOfChars>20
    {
        self.txtHeightConst.constant=110
    }
    else
    {
        self.txtHeightConst.constant=60
    }
    
    let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
    
    if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0
    
    {
        return false
    }
    else
    {
    
    return numberOfChars <= 500;
    }
}

}
// MARK:- Extension Api Calls
extension MessageVC
{
    func callCreateRoomApi(other_User_Id: String,offSet:Int)
    {
        var data = JSONDictionary()
        data[ApiKey.kOther_user_id] = other_User_Id
        data[ApiKey.kOpen_status] = "1"
        data[ApiKey.kOffset] = "\(offSet)"
  
            if Connectivity.isConnectedToInternet {
                
                self.CreateRoomApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func CreateRoomApi(data:JSONDictionary)
    {
        var shouIndicator = true
        
        if messageOffSet>0
        {
            shouIndicator = false
        }
        
        
        ChatVM.shared.callApiCreateRoom(showIndiacter: shouIndicator,data: data, response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else
            {
              
                if self.messageOffSet==0
                {
                    self.chat_room_id = ChatVM.shared.chat_Room_Data?._id ?? ""
                    self.from_user_id = ChatVM.shared.chat_Room_Data?.from_user_id ?? ""
                   
                    let JoinDict = ["otherName":self.profileName,"room":self.chat_room_id,"selfName":DataManager.userName]
                SocketIOManager.shared.joinRoomForChat(joinRoomDict: JoinDict)
                }
                
                for dict in ChatVM.shared.allMessageToShow
                {
                    
                    let all = AllMessageModel(messageText: dict.message ?? "", messageTime: dict.chat_time ?? "", to_user_id: dict.to_user_id ?? "")
                    
                    self.allMessageArray.append(all)
                    
                }
                self.messageOffSet = self.allMessageArray.count
                
               self.groupingDataBasedOnDate()
                self.messageTableView.reloadData()
            }
            
            
        })
    }

    func getAllMessage()
    {
    
        self.chatDataArray.removeAll()
        SocketIOManager.shared.socket.on("message", callback: { (data, error) in
        
            if let data = data as? JSONArray
            {
                for dict in data
                {
            
                 let chatTime = dict["messageTime"] as? String ?? ""
                    let chatMessage =  dict["message"] as? String ?? ""
                    let to_user_id =  dict["to_user_id"] as? String ?? ""
                    
                    let all = AllMessageModel(messageText: chatMessage, messageTime: chatTime, to_user_id: to_user_id)
                    
                    self.allMessageArray.append(all)
                }
                
                self.groupingDataBasedOnDate()
             
            }
        })
    }
    
    fileprivate func groupingDataBasedOnDate() {
       
        self.messageGroupArray.removeAll()
        var keyS:[Any] = []
        
        let listingFromServer = self.allMessageArray
       
        let groupingData = Dictionary(grouping: listingFromServer) { (element) -> Date in
            
            let date = element.messageTime ?? ""
            
            let dateFromatter = DateFormatter()

            dateFromatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let dateStr = dateFromatter.date(from: date) ?? Date()
        
            let dateFromatter2 = DateFormatter()
            dateFromatter2.dateFormat = "yyyy-MM-dd"
          let dateStr2 = dateFromatter2.string(from: dateStr)
            let date2 = dateFromatter2.date(from: dateStr2)
            
            return date2 ?? Date()
        }
            let sorteKeys  = groupingData.keys.sorted(by: <)
            sorteKeys.forEach { (key) in
                let values  = groupingData[key]

                keyS.append(key)
            
                self.messageGroupArray.append(values ?? [])
            }
        
        print("Key  = \(keyS)")
        self.messageTableView.reloadData()
        
        
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            self.messageTableView.scrollToBottom()
            /*
            let indexPath = IndexPath(row: self.messageGroupArray[self.messageGroupArray.count-1].count-1, section: self.messageGroupArray.count-1)
            if self.messageTableView.hasRowAtIndexPath(indexPath: indexPath)
            {
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        */
        }
    }
}

extension MessageVC:QBRTCClientDelegate
{
    /*
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        print(#function)
       if self.session != nil {
           // we already have a video/audio call session, so we reject another one
           // userInfo - the custom user information dictionary for the call from caller. May be nil.
           let userInfo = ["key":"value"] // optional
           session.rejectCall(userInfo)
           return
       }
       // saving session instance here
       self.session = session
    }
    
    
    private func signUp(fullName: String, login: String) {
       
        let newUser = QBUUser()
        newUser.login = login
        newUser.fullName = fullName
     
        
        QBRequest.signUp(newUser, successBlock: { [weak self] response, user in
            
            self?.login(fullName: fullName, login: login)
            
            }, errorBlock: { [weak self] response in
                
                if response.status == QBResponseStatusCode.validationFailed {
                    // The user with existent login was created earlier
                    self?.login(fullName: fullName, login: login)
                    return
                }
                self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
        })
    }
    
    
    private func login(fullName: String, login: String, password: String = LoginConstant.defaultPassword)
    {
        
        QBRequest.logIn(withUserLogin: login,
                        password: password,
                        successBlock: { [weak self] response, user in

                            user.password = password
                            user.updatedAt = Date()
                            Profile.synchronize(user)
                            
                            if user.fullName != fullName {
                                self?.updateFullName(fullName: fullName, login: login)
                            } else {
                                self?.connectToChat(user: user)
                            }
                            
            }, errorBlock: { [weak self] response in
                self?.handleError(response.error?.error, domain: ErrorDomain.logIn)
                if response.status == QBResponseStatusCode.unAuthorized
                {
                    // Clean profile
                    Profile.clearProfile()
                    self?.defaultConfiguration()
                }
        })
    }

    // MARK: - Handle errors
    private func handleError(_ error: Error?, domain: ErrorDomain) {
        guard let error = error else {
            return
        }
        var infoText = error.localizedDescription
        
        print("error = \(infoText) \(error)")
        if error._code == NSURLErrorNotConnectedToInternet {
            infoText = LoginConstant.checkInternet
        }
     
    }
    
    //MARK - Setup
    private func defaultConfiguration() {
        
        //MARK: - Reachability
        let updateLoginInfo: ((_ status: NetworkConnectionStatus) -> Void)? = { [weak self] status in
            let notConnection = status == .notConnection
            let loginInfo = notConnection ? LoginConstant.checkInternet : LoginConstant.enterUsername
         
        }
        
        Reachability.instance.networkStatusBlock = { status in
            updateLoginInfo?(status)
        }
        updateLoginInfo?(Reachability.instance.networkConnectionStatus())
    }
    
    private func updateFullName(fullName: String, login: String) {
        let updateUserParameter = QBUpdateUserParameters()
        updateUserParameter.fullName = fullName
        QBRequest.updateCurrentUser(updateUserParameter, successBlock: {  [weak self] response, user in

            user.updatedAt = Date()
            
            Profile.update(user)
            self?.connectToChat(user: user)
            
            }, errorBlock: { [weak self] response in
                self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
        })
    }
    
    private func connectToChat(user: QBUUser) {
       
        QBChat.instance.connect(withUserID: user.id,
                                password: LoginConstant.defaultPassword,
                                completion: { [weak self] error in
                                    print(error)
                                    if let error = error {
                                        if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                                            // Clean profile
                                            Profile.clearProfile()
                                            self?.defaultConfiguration()
                                        }
                                        else if error._code == -1000
                                        {
                                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
                                            let otherUser = QBUUser()
                                            otherUser.login = self?.view_user_id//"Amar123457"
                                            otherUser.fullName = self?.profileName///"Qickblock@!123"
                                            otherUser.password = LoginConstant.defaultPassword
                                            
                                            vc.newUser2=user//otherUser
                                                    self?.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else {
                                            self?.handleError(error, domain: ErrorDomain.logIn)
                                        }
                                    } else {
                                        //did Login action
                                       // self?.performSegue(withIdentifier: LoginConstant.showUsers, sender: nil)
                                        
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
                                        let otherUser = QBUUser()
                                        otherUser.login = self?.view_user_id//"Amar123457"
                                        otherUser.fullName = self?.profileName///"Qickblock@!123"
                                        otherUser.password = LoginConstant.defaultPassword
                                        
                                        vc.newUser2=user//otherUser
                                                self?.navigationController?.pushViewController(vc, animated: true)
                                    }
        })
    }
    */
}
