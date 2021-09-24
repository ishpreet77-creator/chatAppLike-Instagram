//
//  MessageVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import GiphyUISDK
import SDWebImage
import AgoraRtmKit
import AgoraRtcKit

class MessageVC:BaseVC {
    @IBOutlet weak var tableButtomConst: NSLayoutConstraint!
    
    @IBOutlet weak var topTableConst: NSLayoutConstraint!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgRed: UIImageView!
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
    
    @IBOutlet weak var lblTitle: UITextView!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var imgComment: UIImageView!
    
    var startTime="2021-05-24T04:22:20.282Z"
    var gameTimer: Timer?
    var isCommented=false
    var imageHeight = 200
    
    var profileImage=""
    var profileName = ""
    var view_user_id = ""
    var isContinue=false
    var isPresent=true
    
    let dataArray = [["Haha, alright. Then my cooking MIGHT be  okay. ", "Do you know cooking???"]]
    
    var comfrom = ""
    var screenType = ""
    var commentTitle = ""
    var commentImage = ""
    var commentPostId = ""
    var chat_room_id = ""
    var from_user_id = ""
   var is_hangout_strory=false
    var chatDataArray:[Socket_Chat_Model] = []
    let opponentsIDs = [3245, 2123, 3122]
    
    var allMessageArray:[AllMessageModel] = []
    
    var messageSortArray:[ShowMessageModel] = []
    var messageHeaderArray:[ShowMessageModel] = []
    var TodayMessageArray:[ShowMessageModel] = []
    var YesterDayMessageArray:[ShowMessageModel] = []
    
    var messageArray:[AllMessageModel] = []
    var messageGroupArray:[[AllMessageModel]] = []
    var messageGroupArray2:[[AllMessageModel]] = []
    
    
    var messageOffSet = 0
    
    //MARK:-
    var theme: GPHThemeType = GPHThemeType.light
    var confirmationScreen: ConfirmationScreenSetting = ConfirmationScreenSetting.defaultSetting
    var mediaTypeConfig: [GPHContentType] = GPHContentType.defaultSetting
    var contentTypeSetting: ContentTypeSetting = .multiple
    var selectedContentType: GPHContentType?
    var showMoreByUser: String?
    
    var imageView = GPHMediaView()
    
    let dateFromatter = DateFormatter()
    var calendar = Calendar.current
    var cellHeights = [IndexPath: CGFloat]()
    var intialLoad=true
    var scrollToButtom=true
    var fromUpdate=false
    var spinner = UIActivityIndicatorView(style: .gray)
    var fromStart=true
    
    var longPressIndexPath = IndexPath(row: -1, section: -1)
    
    var agoraRtmKit: AgoraRtmKit?
    var agoraCallInvite:AgoraRtmLocalInvitation?
    private lazy var appleCallKit = CallCenter(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgRed.isHidden=true
        self.lblTime.isHidden=true
  
        self.userNameLabel.numberOfLines=1
        
        isPresent=true
        circularProgressView.isHidden=true
        circularProgressView.trackClr = .white
        circularProgressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)
        circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.50)
        Giphy.configure(apiKey: "wETlRoUsOUmn7T3k6nQUFfMy7j2pKJ4E")
        
        
        self.messageTableView.rowHeight = 100
        self.messageTableView.estimatedRowHeight = UITableView.automaticDimension
        
        setupTable()
        dateFromatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        dateFromatter.calendar = calendar
        dateFromatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//"yyyy-MM-dd'T'HH:mm:ss.SSSZ" //"yyyy-MM-dd'T'HH:mm:ss.SSSXXX"//"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.intialLoad=true
        
        self.messageGroupArray.removeAll()
        
        // QBRTCClient.initializeRTC()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DismissFeedBackAct), name: NSNotification.Name(rawValue: "DismissFeedBack"), object: nil)
        
        print("Other user id:  = \(self.view_user_id)")
        
    
       // self.Continue_End_alert_Method()
        self.alertForRemoveBlock_Method()
        
        APPDEL.timerBudgeCount?.invalidate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      
        self.lblTime.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messageOffSet = 0
        self.txtMessage.text = ""
        self.txtMessage.delegate=self
      
        IQKeyboardManager.shared.enable=false
        
        DataManager.isMessagePageOpen=true
        
        SocketIOManager.shared.initializeSocket()
        
        updateOnlineStatusAfter2MinutesEmit()
        updateOnlineStatusAfter2MinutesON()
        
        if self.comfrom.equalsIgnoreCase(string: kStory) || self.comfrom.equalsIgnoreCase(string: kHangout)
        {
            self.lblTitle.text = self.commentTitle
            if commentImage != ""
            {
                
                let url = URL(string: commentImage)!
                self.imgComment.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                
            }
            self.viewComment.isHidden=false
            
            self.gifButton.isEnabled=false
        }
        else
        {
            self.viewComment.isHidden=true
            self.gifButton.isEnabled=true
        }
        
        
        if DataManager.comeFrom != kViewProfile
        {
            if view_user_id != ""
            {
                
                
                if Connectivity.isConnectedToInternet {
                    self.allMessageArray.removeAll()
                    self.messageGroupArray.removeAll()
                    self.callCreateRoomApi(other_User_Id: view_user_id, offSet: self.messageOffSet,loaderShow: true, startLoad: true)
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
                
                
                self.userNameLabel.text = profileName
                if profileImage != ""
                {
                    
                    let url = URL(string: profileImage)!
                    self.userProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    
                }
                self.getAllMessage()
                
                scrollToButtom=true
            }
            
            // self.connect()
        }
        else
        
        {
            DataManager.comeFrom = kEmptyString
            
        }
        
        self.deleteMessageOnMetthod()
        
        
        userProfile.cornerRadius = userProfile.frame.height/2
        userProfile.contentMode = .scaleAspectFill
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.navigationBar.isHidden=true
        DataManager.currentScreen = kMessage
       self.Agora_RTM_Setup()
        self.buttomConst.constant = 20
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable=true
        DataManager.isMessagePageOpen=false
        self.badgeCountIntervalCheckEmit()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        
        self.badgeCountIntervalCheckEmit()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.requestCameraPermission()
    }
    @objc func DismissFeedBackAct()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- AGORA RTM setup
    
    func Agora_RTM_Setup()
    {
        agoraRtmKit = AgoraRtmKit.init(appId: AGORA_APP_ID, delegate: self)
      
    }
    
    
    //MARK:- View profile button action 
    
    @IBAction func ViewProfileAct(_ sender: UIButton) {
        self.txtMessage.endEditing(true)
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC //TapControllerVC
//        DataManager.HomeRefresh="true"
//        DataManager.OtherUserId = self.view_user_id
//        DataManager.comeFromTag=6
//        vc.selectedIndex=2
        vc.likeMode=kShake
        vc.view_user_id = self.view_user_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Three dot button action 
    
    @IBAction func menuButtopnAction(_ sender: UIButton) {
        
        self.txtMessage.endEditing(true)
        let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "StoryMenuPopUpVC") as!  StoryMenuPopUpVC
        destVC.type = .messageScreen
        destVC.view_user_id=self.view_user_id
        destVC.from_user_id=self.from_user_id
        destVC.user_name=self.profileName.capitalized
        destVC.chat_room_id=self.chat_room_id
        destVC.is_hangout_strory=self.is_hangout_strory
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(destVC, animated: true, completion: nil)
        
    }
    //MARK:- audio call button action 
    
    @IBAction func audioCallBUttonAction(_ sender: UIButton) {
      
        if Connectivity.isConnectedToInternet {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AudioCallingVC") as! AudioCallingVC
        
            
            
            vc.userName = self.userNameLabel.text ?? ""
            vc.profileImageUrl = self.profileImage
            vc.Other_user_id=self.view_user_id
            vc.self_user_id=self.from_user_id
            vc.chat_room_id=self.chat_room_id
            vc.from_user_id=self.from_user_id
            vc.view_user_id=self.view_user_id
            vc.comeFrom = kMessage
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        self.txtMessage.endEditing(true)
       
        
    }
    
    //MARK:- video call button action 
    
    @IBAction func videoCallButtonAction(_ sender: UIButton) {
        self.txtMessage.endEditing(true)
       
        
        
        if Connectivity.isConnectedToInternet {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallingVC") as! VideoCallingVC
            vc.userName = self.userNameLabel.text ?? ""
            vc.profileImageUrl = self.profileImage
            vc.Other_user_id=self.view_user_id
            vc.self_user_id=self.from_user_id
            vc.chat_room_id=self.chat_room_id
            vc.from_user_id=self.from_user_id
            vc.view_user_id=self.view_user_id
            vc.comeFrom = kMessage
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    
    //MARK:- back button action 
    
    @IBAction func backBUttonAction(_ sender: UIButton) {
        APPDEL.timerTimeLeftCheck?.invalidate()
        
        if self.comfrom.equalsIgnoreCase(string: kAppDelegate)  || self.comfrom.equalsIgnoreCase(string: kHomePage) || self.comfrom.equalsIgnoreCase(string: kViewProfile)
        {
            
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
            vc.selectedIndex=3
            DataManager.comeFrom = kEmptyString
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        else  if self.appdel == kHomePage
//        {
//
//            DataManager.comeFrom=kViewProfile
//
//            self.navigationController?.popViewController(animated: true)
//        }
        else
        {
            // if self.fromUpdate
            // {
            
            //
            //            }
            //            else
            //            {
            //                DataManager.comeFrom=kViewProfile
            //
            //            }
            
            if comfrom.equalsIgnoreCase(string: kMatch)
            {
                DataManager.comeFrom=kViewProfile
            }
            else
            {
                DataManager.comeFrom=kEmptyString
            }
            if self.screenType.equalsIgnoreCase(string: kHome) && self.isCommented
            {
                DataManager.HomeRefresh=true
                DataManager.comeFromTag=5
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func closeCommentAct(_ sender: UIButton)
    {
        self.screenType = kEmptyString
        self.viewComment.isHidden=true
        self.comfrom=kEmptyString
        self.commentTitle = ""
        self.commentImage=""
        self.commentPostId = ""
        self.gifButton.isEnabled=true
        
    }
    
    @IBAction func sendGIFAct(_ sender: UIButton)
    {
        
        if Connectivity.isConnectedToInternet {
            
            self.view.endEditing(true)
            let giphy = GiphyViewController()
            giphy.theme = GPHTheme(type: self.theme)
            giphy.mediaTypeConfig = self.mediaTypeConfig
            GiphyViewController.trayHeightMultiplier = 0.7
            giphy.showConfirmationScreen = false //== .on
            giphy.shouldLocalizeSearch = true
            giphy.delegate = self
            giphy.dimBackground = true
            giphy.modalPresentationStyle = .overCurrentContext
            
            if let contentType = self.selectedContentType {
                giphy.selectedContentType = contentType
            }
            if let user = self.showMoreByUser {
                giphy.showMoreByUser = user
            }
            
            present(giphy, animated: true, completion: nil)
        }
        else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
        
        
        
        
    }
    
//MARK:- Send message action
    
    
    @IBAction func shareButtonAction(_ sender: UIButton)
    {
        
//        let dict2 = ["from_user_id":self.from_user_id,"to_user_id":self.view_user_id,"alert_type":"removematch"]
//        SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
//        self.alertForRemoveBlock_Method()
        
        
//
//
//        self.agoraRtmKit?.send(AgoraRtmMessage(text: "hello"), toPeer: self.view_user_id, completion: { (error) in
//            print("Hello \(error)")
//        })
//
//
//        guard let inviter = AgoraRtm.shared().inviter else {
//            fatalError("rtm inviter nil")
//        }
//
//
//        let vc = storyboard?.instantiateViewController(withIdentifier:"VideoCallingVC") as! VideoCallingVC
//
//        inviter.sendInvitation(peer: self.view_user_id, extraContent: "name", accepted: { [weak self, weak vc] in
//            //vc?.close(.toVideoChat)
//            print("Close")
//            self?.appleCallKit.setCallConnected(of: self?.view_user_id ?? "")
//
////            guard let remote = UInt(remoteNumber) else {
////                fatalError("string to int fail")
////            }
////
////            var data: (channel: String, remote: UInt)
////            data.channel = channel
////            data.remote = remote
////            self?.performSegue(withIdentifier: "DialToVideoChat", sender: data)
////
//        }, refused: { [weak vc] in
//            //vc?.close(.remoteReject(self.view_user_id))
//        }) { [weak vc] (error) in
//            //vc?.close(.error(error))
//            print(error)
//        }
//
        if validateData() != nil // message = validateData()
        {
           // self.openSimpleAlert(message: message)
         
        }
        else
        {
          
            //   let dict = ["timezone":TIMEZONE,"chat_room_id":self.chat_room_id,"to_user_id":self.view_user_id,"message":self.txtMessage.text!,"from_user_id":self.from_user_id,"messageTime":dateInString]
            
            // let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "wave-GIF", withExtension: "gif")!)
            // Convert image Data to base64 encodded string
            
            //  let imageBase64String = imageData?.base64EncodedString() ?? ""
            
            //  print(imageBase64String ?? "Could not encode image to Base64")
            
            // let gif = "data:image/gif;base64,".appending(imageBase64String)
            
            if Connectivity.isConnectedToInternet {
                
                var type  = kText
                
                if self.comfrom == kStory
                {
                    type = kStory
                }
                else if self.comfrom == kHangout
                {
                    type = kHangout
                }
                    
                
                let now = Date()
                
                let dateInString = dateFromatter.string(from: now)
                
               // userInfo.comment_from == "Home"

                if self.screenType == kHome
                {
                    self.isCommented = true
                }
                
                let dict2 = ["timezone":TIMEZONE,"chat_room_id":self.chat_room_id,"to_user_id":self.view_user_id,"message":self.txtMessage.text!,"from_user_id":self.from_user_id,"messageTime":dateInString,"message_type":type,"item_title":self.commentTitle,"item_image":self.commentImage,"item_id":self.commentPostId,"comment_message_from":self.screenType]
                //,"buffer_img":gif
                print("Send message time =\(Date())")
                SocketIOManager.shared.sendChatMessage(MessageChatDict: dict2)
                
                
                /*
                let all = AllMessageModel(_id: "2132", messageText: self.txtMessage.text!, messageTime: dateInString, to_user_id: self.view_user_id,messageType: type,item_title:self.commentTitle, item_image: self.commentImage, item_id: self.commentPostId)
                
                
               // let all = AllMessageModel(_id: id, messageText: chatMessage, messageTime: chatTime, to_user_id: to_user_id,messageType: type)
                if self.fromStart
                {
                    self.allMessageArray = self.allMessageArray.reversed()
                    self.fromStart=false
                }
//                        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

                
                self.allMessageArray.append(all)
                
            self.scrollToButtom=true
        
           self.groupingDataBasedOnDate(startLoad: false)
            self.userOnChatMessageScreen()
        */
                
                
                
                self.comfrom=kEmptyString
                self.commentTitle = ""
                self.commentImage=""
                self.commentPostId = ""
                
                self.viewComment.isHidden=true
                self.gifButton.isEnabled=true
                
                self.sendSMS()
               
                intialLoad=false
                self.fromUpdate=true
                self.txtMessage.text = ""
                self.txtHeightConst.constant=45
               // self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0);
            }
            else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
            
            
        }
        
    
       
        
        //let dict2 = ["alert_type":kRemoveMatch,"to_user_id":self.view_user_id]
                    //,"buffer_img":gif
              //      SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
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
        if  self.getDeviceModel() == "iPhone 6"
        {
            self.buttomConst.constant = keyboardHeight+2
        }
        else if  self.getDeviceModel() == "iPhone 8+"
        {
            self.buttomConst.constant = keyboardHeight+2
        }
        else
        {
            self.buttomConst.constant = keyboardHeight+35
        }
        
        //+40
        
        // self.tableButtomConst.constant = keyboardHeight+200
        //self.messageTableView.setBottomInset(to: keyboardHeight+40)
        
        
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        buttomConst.constant = 20
        // self.messageTableView.setBottomInset(to: 0.0)
        
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
        self.messageTableView.alwaysBounceVertical=false
        self.messageTableView.register(UINib(nibName: "SenderTCell", bundle: nil), forCellReuseIdentifier: "SenderTCell")
        self.messageTableView.register(UINib(nibName: "ReceiverTCell", bundle: nil), forCellReuseIdentifier: "ReceiverTCell")
        
        self.messageTableView.register(UINib(nibName: "TimeHeadeTCell", bundle: nil), forCellReuseIdentifier: "TimeHeadeTCell")
        
        self.messageTableView.register(UINib(nibName: "ShowGIFTCell", bundle: nil), forCellReuseIdentifier: "ShowGIFTCell")
        
        self.messageTableView.register(UINib(nibName: "GIFTCell", bundle: nil), forCellReuseIdentifier: "GIFTCell")
        self.messageTableView.register(UINib(nibName: "SenderCommentTCell", bundle: nil), forCellReuseIdentifier: "SenderCommentTCell")
        
        self.messageTableView.register(UINib(nibName: "ReceiverCommnetTCell", bundle: nil), forCellReuseIdentifier: "ReceiverCommnetTCell")
        
        self.messageTableView.estimatedRowHeight = 100;
        self.messageTableView.rowHeight = UITableView.automaticDimension;
        //self.messageTableView.setNeedsLayout()
        //  self.messageTableView.layoutIfNeeded()
        self.messageTableView.allowsSelection=false
        if  self.getDeviceModel() == "iPhone 6"
        {
            self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0);
        }
        else if  self.getDeviceModel() == "iPhone 8+"
        {
            self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0);
        }
        else
        {
            self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0);
        }
        
        self.messageTableView.allowsSelection=false
        //self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0);
        
        //values
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return  self.messageGroupArray.count+1//
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0
        {
            return 0
        }
        else
        {
            let sec = section-1
            
            if self.messageGroupArray.count>sec
            {
                return self.messageGroupArray[sec].count
            }
            else
            {
                return 0
            }
            //2//
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellData:AllMessageModel?
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReceiverTCell") as? ReceiverTCell
        let sec = indexPath.section-1
        
        if  self.messageGroupArray.count>sec
        {
            if self.messageGroupArray[sec].count>indexPath.row
            {
                cellData = self.messageGroupArray[sec][indexPath.row]
                
                let lastMessage = cellData?.messageText ?? ""
                    
                   
                let messageType = cellData?.messageType ?? ""
                
                if messageType.uppercased() == kGif.uppercased()  || lastMessage.contains(kGiphy)
                {
                    let cell = messageTableView.dequeueReusableCell(withIdentifier: "GIFTCell") as! GIFTCell
                    let messege = cellData?.messageText ?? "http"
                    let time = cellData?.messageTime ?? ""
                    
                    let time2 = time.utcToLocalTime(dateStr: time)
                    cell.lblTime.text = time2

                    DispatchQueue.main.async
                    {
                        //  let imageURL = UIImage.gifImageWithURL(gifURL)
                        
                        // cell.imgGif.image = imageURL
                        
                        cell.imgGif.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        if messege != ""
                        {
                            let url = URL(string: messege)!
                            cell.imgGif.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                        
                        if self.from_user_id == cellData?.to_user_id
                        {
                            
                            cell.leftConst.constant = 8
                            cell.rightConst.constant = 120
                            
                        }
                        else
                        {
                            
                            cell.leftConst.constant = 120
                            cell.rightConst.constant = 8
                            
                        }
                        
                    }
                    if indexPath == self.longPressIndexPath
                    {
                        cell.viewBack.backgroundColor = UIColor.lightGray
                    }
                    else
                    {
                        if self.from_user_id == cellData?.to_user_id
                        {
                            
                            
                            
                            cell.viewBack.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.2)
                            cell.lblTime.textColor = UIColor.black
                        }
                        else
                        
                        {
                            cell.viewBack.backgroundColor = LINECOLOR
                            cell.lblTime.textColor = UIColor.white
                        }
                        //UIColor.white
                    }
                    
                    
                    self.imageHeight = Int(cell.frame.height)
                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
                    cell.imgGif.addGestureRecognizer(longPress)
                    
                    
                  
                    return cell
                     
                }
              else  if messageType.uppercased() == kAudio.uppercased()  || messageType.uppercased() == kVideo.uppercased()
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TimeHeadeTCell") as! TimeHeadeTCell
                       var messege = cellData?.messageText ?? ""
                      var msg = ""
                  if DataManager.Id == cellData?.to_user_id
                       {
                    if messege.contains(kCallTry)
                    {
                        msg = messege.replacingOccurrences(of: "call", with: "call from")
                    }
                    else
                    {
                        msg = messege
                    }
                    
                        let tex = msg.replacingOccurrences(of: kCallTry, with: kCallMissed)
                        
                        //cell.lblTime.text = tex
                        
                    print("user name:- \(DataManager.userName)")
                    
                   // let name = tex.replacingOccurrences(of: DataManager.userName, with: self.userNameLabel.text!.uppercased())
                    
                   // let name = tex.replacingOccurrences(of: DataManager.userName, with: self.userNameLabel.text!.uppercased(), options: .regularExpression, range: nil)
                    let name = tex.replacingOccurrences(of: DataManager.userName, with: self.userNameLabel.text!.uppercased(), options: .caseInsensitive)

                    
                    cell.lblTime.text = name
                    
                    
                    print("Name =\(name)")
                       }
                       else
                       {
                        //cell.lblTime.text = messege.replacingOccurrences(of: self.userNameLabel.text!, with: DataManager.userName.capitalized)
                        cell.lblTime.text = messege
                       }
                     cell.lblTime.text = cell.lblTime.text?.uppercased()
                        
                    return cell
                }
                
                else if self.from_user_id == cellData?.to_user_id//cellData.from_user_id
                {
                    
                    if messageType.equalsIgnoreCase(string: kStory) || messageType.equalsIgnoreCase(string: kHangout)
                    {
                        
                        let cell = messageTableView.dequeueReusableCell(withIdentifier: "SenderCommentTCell") as! SenderCommentTCell//SenderTCell
                        
                        cell.constLeft.constant = 8
                        cell.constRight.constant = 52
                    
                        let time = cellData?.messageTime ?? ""
                        let titleText = cellData?.item_title ?? ""
                        let time2 = time.utcToLocalTime(dateStr: time)
                        
                        cell.lbltime.text = time2
                        
                        let messege = cellData?.messageText ?? ""
                        
                        cell.lblTitle.text = kCommentedOn + (messageType.lowercased())
                        cell.lblCommentText.text = titleText
                        cell.lblMessageText.text =  messege
                        cell.viewBack.backgroundColor = UIColor.white
                        
                        let message1 = cellData?.item_image ?? ""
                        
                        if message1 != ""
                        {
                            let url = URL(string: message1)!
                            cell.imgComment.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                        
                        if indexPath == self.longPressIndexPath
                        {
                            cell.viewBack.backgroundColor = UIColor.darkGray
                        }
                        else
                        {
                            cell.viewBack.backgroundColor = APPCOLOR//UIColor.clear
                        }
                        
                        cell.lblTitle.textColor = UIColor.black
                        cell.lblMessageText.textColor = UIColor.black
                        cell.lblCommentText.textColor = UIColor.black
                        cell.lbltime.textColor = UIColor.black
                        cell.viewBack.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
                        cell.viewMessageBack.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                        
                        cell.btnDetail.layer.name = messageType+"X"+(cellData?.item_id ?? "")
                        
        
                        cell.btnDetail.addTarget(self, action: #selector(CommentDetailAct), for: .touchUpInside)
                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
                        cell.viewBack.addGestureRecognizer(longPress)
                        return cell
                        /*
                        let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReceiverCommnetTCell") as! ReceiverCommnetTCell//ReceiverTCell
                        cell.lblMessage.text =  ""
                        let time = cellData?.messageTime ?? ""
                        
                        let time2 = time.utcToLocalTime(dateStr: time)
                        
                        cell.lbltime.text = time2
                        let titleText = cellData?.item_title ?? ""
                        let messege = cellData?.messageText ?? ""
                        
                        cell.lblMessage.text = kCommentedOn + (messageType.lowercased()) + " " + titleText +  "\n" + messege
                        //cell.lblMessage.text = kCommentedOn + (messageType ?? "") + messege
                        cell.viewBack.backgroundColor = UIColor.white
                        if indexPath == self.longPressIndexPath
                        {
                            cell.viewBack.backgroundColor = UIColor.darkGray
                        }
                        else
                        {
                            cell.viewBack.backgroundColor = UIColor.clear
                        }

                        cell.lblMessage.textColor = UIColor.black
                        cell.lbltime.textColor = UIColor.black
                        let message1 = cellData?.item_image ?? ""
                        
                        if message1 != ""
                        {
                            let url = URL(string: message1)!
                            cell.imgComment.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                        
                        
                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
                        cell.viewBack.addGestureRecognizer(longPress)
                        
                        return cell
                        
                        */
                    }
                    else
                    {
                            let cell = messageTableView.dequeueReusableCell(withIdentifier: "ReceiverTCell") as! ReceiverTCell//ReceiverTCell
                            cell.lblMessage.text =  ""
                            let time = cellData?.messageTime ?? ""
                            
                            let time2 = time.utcToLocalTime(dateStr: time)
                            
                            cell.lbltime.text = time2
                            
                            let messege = cellData?.messageText ?? ""
                            cell.lblMessage.text =  messege
                            cell.viewBack.backgroundColor = UIColor.white
                            if indexPath == self.longPressIndexPath
                            {
                                cell.viewBack.backgroundColor = UIColor.darkGray
                            }
                            else
                            {
                                cell.viewBack.backgroundColor = UIColor.clear
                            }

                            cell.lblMessage.textColor = UIColor.black
                            cell.lbltime.textColor = UIColor.black
                            
                            
                            
                            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
                            cell.viewBack.addGestureRecognizer(longPress)
                            
                            return cell
                       
                    }
                    
                    
                    
                }
                
                else{
                    
                    
                    if messageType.equalsIgnoreCase(string: kStory) || messageType.equalsIgnoreCase(string: kHangout)
                    {
                        let cell = messageTableView.dequeueReusableCell(withIdentifier: "SenderCommentTCell") as! SenderCommentTCell//SenderTCell
                        cell.constLeft.constant = 52
                        cell.constRight.constant = 8
                        let time = cellData?.messageTime ?? ""
                        let titleText = cellData?.item_title ?? ""
                        let time2 = time.utcToLocalTime(dateStr: time)
                        
                        cell.lbltime.text = time2
                        
                        let messege = cellData?.messageText ?? ""
                        
                        cell.lblTitle.text = kCommentedOn + (messageType.lowercased())
                        cell.lblCommentText.text = titleText
                        cell.lblMessageText.text =  messege
                        cell.viewBack.backgroundColor = UIColor.white
                        
                        let message1 = cellData?.item_image ?? ""
                        
                        if message1 != ""
                        {
                            let url = URL(string: message1)!
                            cell.imgComment.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                        }
                        
                        if indexPath == self.longPressIndexPath
                        {
                            cell.viewBack.backgroundColor = UIColor.darkGray
                        }
                        else
                        {
                            cell.viewBack.backgroundColor = APPCOLOR
                        }
                        
                        cell.lblTitle.textColor = UIColor.white
                        cell.lblMessageText.textColor = UIColor.white
                        cell.lblCommentText.textColor = UIColor.white
                        cell.lbltime.textColor = UIColor.white
                        
                        cell.viewBack.backgroundColor = APPCOLOR
                        cell.viewMessageBack.backgroundColor = APPCOLORX
                    
                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
                        cell.viewBack.addGestureRecognizer(longPress)
                    
                    
                        cell.btnDetail.layer.name = messageType+"X"+(cellData?.item_id ?? "")
                        
                        cell.btnDetail.addTarget(self, action: #selector(CommentDetailAct), for: .touchUpInside)

                        
                        return cell
                    }
                    else
                    {
                        let cell = messageTableView.dequeueReusableCell(withIdentifier: "SenderTCell") as! SenderTCell//SenderTCell
                        cell.lblMessage.text =  ""
                        let time = cellData?.messageTime ?? ""
                        
                        let time2 = time.utcToLocalTime(dateStr: time)
                        
                        cell.lbltime.text = time2
                        
                        let messege = cellData?.messageText ?? ""
                        cell.lblMessage.text = messege
                        cell.viewBack.backgroundColor = UIColor.white
                        
                       
                        
                        if indexPath == self.longPressIndexPath
                        {
                            cell.viewBack.backgroundColor = UIColor.darkGray
                        }
                        else
                        {
                            cell.viewBack.backgroundColor = UIColor.clear
                        }
                        
                        
                        cell.lblMessage.textColor = UIColor.white
                        cell.lbltime.textColor = UIColor.white
                        
                        
                        
                        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
                        cell.viewBack.addGestureRecognizer(longPress)
                        
                        return cell
                    }
                    
                    
                }
            }
            else
            {
                return cell ?? UITableViewCell()
            }
        }
        
        else
        {
            
            return cell ?? UITableViewCell()
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeHeadeTCell") as! TimeHeadeTCell
        let name =  self.userNameLabel.text ?? ""
        
        if section == 0
        {
            cell.lblTime.text = kMatchMessage+"\(name)"+"."
            
            cell.topConstHeader.constant=8
        }
        else
        {
            cell.topConstHeader.constant=0
            if self.messageGroupArray.count>section-1
            {
                let data =  self.messageGroupArray[section-1]
                
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
                
            }
        }
        cell.lblTime.text = cell.lblTime.text?.uppercased()
        
        cell.lblTime.numberOfLines=1
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let isMatch = ChatVM.shared.chat_Room_Like_Data?.is_match ?? 0
        if isMatch == 0
        {
            if section == 0
            {
                return 0
            }
            else
            {
                return UITableView.automaticDimension
            }
        }
        else
        {
            return UITableView.automaticDimension
        }
        
        //}
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.messageGroupArray.count>indexPath.section-1
        {
            if self.messageGroupArray[indexPath.section-1].count>indexPath.row
            {
                let cellData = self.messageGroupArray[indexPath.section-1][indexPath.row]
                
                
                let lastMessage = cellData.messageText ?? ""
    
                let messageType = cellData.messageType
                if messageType.uppercased() == kGif.uppercased() || lastMessage.contains(kGiphy)
                {
                    return CGFloat(self.imageHeight)//200
                    
                }
                else  if messageType.uppercased() == kAudio.uppercased()  || messageType.uppercased() == kVideo.uppercased()
                {
                    return UITableView.automaticDimension//40
                }
                else
                {
                    return UITableView.automaticDimension
                    
                }
            }
            
            else
            {
                return UITableView.automaticDimension
                
            }
        }
        
        
        else
        {
            return UITableView.automaticDimension
            
        }
        //  }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        self.deleteCopyMessge(indexPath: indexPath)
    //    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if ((self.messageTableView.contentOffset.y + self.messageTableView.frame.size.height) <= self.messageTableView.contentSize.height-50)
        {
            
            if self.allMessageArray.count<ChatVM.shared.Pagination_Details?.totalCount ?? 0
            {
                print("scroll up ")
                self.scrollToButtom=false
                
                
                if Connectivity.isConnectedToInternet {
                    
                    self.callCreateRoomApi(other_User_Id: view_user_id, offSet: self.messageOffSet,loaderShow: true, startLoad: true)
                } else {
                    
                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
                
                
                
            }
        }
        
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began
        {
            let touchPoint = sender.location(in: self.messageTableView)
            if let indexPath = self.messageTableView.indexPathForRow(at: touchPoint) {
                print("index path =\(indexPath.row)")
                self.longPressIndexPath = indexPath
                self.messageTableView.reloadData()
                self.deleteCopyMessge(indexPath: indexPath)
                
                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
    @objc func CommentDetailAct(_ sender:UIButton)
    {
        
        let text = sender.layer.name
        
        let array = text?.split(separator: "X") ?? [] //.split(separator: "TYPE")
        
        if (array.count)>0
        {
            if kStory.equalsIgnoreCase(string: String(array[0]))//array[0].e kStory.eq
            {
                let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ViewStoryVC") as!  ViewStoryVC
                if array.count>1
                {
                    vc.StoryId=String(array[1])
                }
            
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if kHangout.equalsIgnoreCase(string: String(array[0]))
                
                {
                let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "hangoutDetailsVC") as! hangoutDetailsVC
                vc.appdel=kMessage
                vc.isLikeUpdate=true
                if array.count>1
                {
                    vc.hangoutId=String(array[1])
                }
                self.navigationController?.pushViewController(vc, animated: true)
               }
        }
        
        //print("was Pressed     \(sender.layer.name)")
    }
              
    
    
}

extension MessageVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
//        if numberOfChars>20
//        {
//            self.txtHeightConst.constant=110
//        }
//        else
//        {
//            self.txtHeightConst.constant=45
//        }
        
    
        let numLines = self.txtMessage.numberOfLines()

       // print("no of line = \(numLines)")
        
        if numLines < 3
        {
        
            self.txtHeightConst.constant=45
        }
        else if numLines < 4
        {
           
            self.txtHeightConst.constant=70
        }
        else if numLines < 5
        {
           
            self.txtHeightConst.constant=90
        }
        
       else if numLines < 6
       {
       
        self.txtHeightConst.constant=110
    
       }
      
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
//        if numberOfChars > 0
//        {
//            self.shareBUtton.isEnabled=true
//        }
//        else
//        {
//            self.shareBUtton.isEnabled=false
//        }
         
        
        
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
    func callCreateRoomApi(other_User_Id: String,offSet:Int,loaderShow:Bool,startLoad:Bool)
    {
        
        var data = JSONDictionary()
        data[ApiKey.kOther_user_id] = other_User_Id
        data[ApiKey.kOpen_status] = "1"
        data[ApiKey.kOffset] = "\(offSet)"
        
        if Connectivity.isConnectedToInternet {
            
            self.CreateRoomApi(data: data,loaderShow:loaderShow, startLoad: startLoad)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func CreateRoomApi(data:JSONDictionary,loaderShow:Bool,startLoad:Bool)
    {
        
        print(#function)
        
        ChatVM.shared.callApiCreateRoom(showIndiacter: loaderShow,data: data, response: { (message, error) in
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
                    
                   // self.DisconnectRoomEmit()
                    let JoinDict = ["otherName":self.profileName,"room":self.chat_room_id,"selfName":DataManager.userName]
                    SocketIOManager.shared.joinRoomForChat(joinRoomDict: JoinDict)
                //  self.getRTMTokenApi()
                }
                
                var Continue = ChatVM.shared.chat_Room_Data?.continue_chat_status ?? 0
                
                let is_come_from_story_hangout = ChatVM.shared.is_come_from_story_hangout
                if is_come_from_story_hangout == 1
                {
                    Continue = 1
                    self.is_hangout_strory=true
                }
                
                if Continue == 1
                {
                    self.imgRed.isHidden=true
                    self.lblTime.isHidden=true
                    self.circularProgressView.isHidden=true
                    self.topTableConst.constant=0
                    self.navigateView.borderColor=HOMESADOWCOLOR
                    self.navigateView.addBottomShadow()
                }
                else
                {
                    
                    self.imgRed.isHidden=false
                    self.lblTime.isHidden=false
                    self.circularProgressView.isHidden=false
                    self.topTableConst.constant=30
                    let time = ChatVM.shared.chat_Room_Like_Data?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z"
                    
                    
                    
                    
                    let dif  = "".checkHoursLeftForRing(startTime: time)
                    print("time check = \(dif)")
                    
                  //  let ring = (1.0/72.0)*Float(dif)
                    
                    
                    
                    let flo = Float(kTimeRing)
                    
                    let ring = (1.0/flo)*Float(dif)
                    
                    if (dif > 0) && (dif <= kTimeRing)
                    {
                        if dif <= 1440*2
                        {
                            self.circularProgressView.setProgressWithAnimation(duration: 1.0, value: ring)
                            self.circularProgressView.progressClr = UIColor.red
                            
                        }
                        else
                        {
                            self.circularProgressView.setProgressWithAnimation(duration: 1.0, value: ring)
                            self.circularProgressView.progressClr = LINECOLOR
                        }
                    }
                    else
                    {
                        self.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 1)
                        self.circularProgressView.progressClr = LINECOLOR
                        
                        self.imgRed.isHidden=true
                        self.lblTime.isHidden=true
                        self.circularProgressView.isHidden=true
                        self.topTableConst.constant=0
                    }
                    
                    if DataManager.purchaseProlong
                    {
                        self.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 1)
                        self.circularProgressView.progressClr = LINECOLOR
                        
                        self.imgRed.isHidden=true
                        self.lblTime.isHidden=true
                        self.circularProgressView.isHidden=true
                        self.topTableConst.constant=0
                    }
                   
                    
                    self.startTime = time
                    
                    APPDEL.timerTimeLeftCheck = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkTimerTime), userInfo: nil, repeats: true)
                    RunLoop.main.add(APPDEL.timerTimeLeftCheck ?? Timer(), forMode: RunLoop.Mode.common)
                }
                
                
                
                
                self.userNameLabel.text =  ChatVM.shared.chat_Room_Data?.other_user_details?.profile_data?.username ?? ""
                if ChatVM.shared.chat_Room_Data?.other_user_details?.profile_data?.images?.count ?? 0>0
                {
                    self.profileImage = ChatVM.shared.chat_Room_Data?.other_user_details?.profile_data?.images?[0].image ?? ""
                }
                
                
                if self.profileImage != ""
                {
                    
                    let url = URL(string: self.profileImage)!
                    self.userProfile.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                    
                }
                
                for dict in ChatVM.shared.allMessageToShow
                {
                    let type = dict.message_type ?? kText
                    let item_title = dict.item_title ?? kEmptyString
                    let item_id = dict.item_id ?? kEmptyString
                    let item_image = dict.item_image ?? kEmptyString
                    
                    let all = AllMessageModel(_id:dict._id ?? "",  messageText: dict.message ?? "", messageTime: dict.chat_time ?? "", to_user_id: dict.to_user_id ?? "",messageType: type,item_title: item_title,item_image: item_image, item_id: item_id)
                    
                    self.allMessageArray.append(all)
                    
                }
                self.messageOffSet = self.allMessageArray.count
                
                self.groupingDataBasedOnDate(startLoad: startLoad)
                
            }
            
            
        })
    }
    
    func getAllMessage()
    {
        
        //Indicator.sharedInstance.showIndicator()
        if DataManager.isMessagePageOpen
        {
            self.chatDataArray.removeAll()
            SocketIOManager.shared.socket.on("message", callback: { (data, error) in
                
                print("Recieve message time =\(Date())")
                /*
                 
                 
                 
                 self.scrollToButtom=true
                 self.allMessageArray.removeAll()
                 self.messageGroupArray.removeAll()
                 if let data = data as? JSONArray
                 {
                 for dict in data
                 {
                 
                 let to_user_id =  dict["to_user_id"] as? String ?? ""
                 
                 if self.from_user_id == to_user_id
                 {
                 //other message
                 self.loaderView.isHidden=true
                 
                 
                 if Connectivity.isConnectedToInternet {
                 
                 self.callCreateRoomApi(other_User_Id: self.view_user_id, offSet:0,loaderShow: false)
                 } else {
                 
                 self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                 }
                 
                 }
                 else
                 {
                 self.loaderView.isHidden=false
                 
                 
                 if Connectivity.isConnectedToInternet {
                 
                 self.callCreateRoomApi(other_User_Id: self.view_user_id, offSet:0,loaderShow: false)
                 } else {
                 
                 self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                 }
                 
                 // self.loaderView.isHidden=true
                 }
                 
                 
                 }
                 }
                 else
                 {
                 self.loaderView.isHidden=false
                 if Connectivity.isConnectedToInternet {
                 
                 self.callCreateRoomApi(other_User_Id: self.view_user_id, offSet:0,loaderShow: false)
                 } else {
                 
                 self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                 }
                 
                 
                 }
                 
                 
                 */
               
                if DataManager.currentScreen ==  kMessage
                {

                if let data = data as? JSONArray
                {
                    for dict in data
                    {
                      //  let from_user_id =  dict["from_user_id"] as? String ?? ""
                        
                        // if self.from_user_id != from_user_id
                        //{
                            
        
                        let id = dict["_id"] as? String ?? ""
                        let chatTime = dict["messageTime"] as? String ?? ""
                        let chatMessage =  dict["message"] as? String ?? ""
                            let to_user_id =  dict["to_user_id"] as? String ?? ""
                        let type = dict["message_type"] as? String ?? kText//dict["buffer_img"] as? String ?? kText
                        
                        let item_title = dict["item_title"] as? String ?? ""//dict.item_title ?? kEmptyString
                        let item_id = dict["item_id"] as? String ?? ""//dict.item_id ?? kEmptyString
                        let item_image = dict["item_image"] as? String ?? ""//dict.item_image ?? kEmptyString
                        
                        let all = AllMessageModel(_id: id, messageText: chatMessage, messageTime: chatTime, to_user_id: to_user_id,messageType: type,item_title:item_title, item_image: item_image, item_id: item_id)
                        
                        
                       // let all = AllMessageModel(_id: id, messageText: chatMessage, messageTime: chatTime, to_user_id: to_user_id,messageType: type)
                        if self.fromStart
                        {
                            self.allMessageArray = self.allMessageArray.reversed()
                            self.fromStart=false
                        }
//                        APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

                        
                        self.allMessageArray.append(all)
                         
                    //}
                }
                self.scrollToButtom=true
                
                self.groupingDataBasedOnDate(startLoad: false)
                    
                }
                    APPDEL.provider?.reportCall(with: APPDEL.uuid, endedAt: Date(), reason: .remoteEnded)

                print("reportCall called")
                    
                    self.userOnChatMessageScreen()
                }
            })
        }
    }
    
    fileprivate func groupingDataBasedOnDate(startLoad:Bool=true)
    {
        
        //  Indicator.sharedInstance.showIndicator()
        
        print(#function)
        
        self.messageGroupArray.removeAll()
        var keyS:[Any] = []
        
        var listingFromServer = self.allMessageArray
        //if intialLoad
        // {
        if startLoad
        {
            listingFromServer.reverse()
        }
        
        
        //       }
        //        else
        //    {
        //        //self.intialLoad=true
        //    }
        // listingFromServer.reverse()
        
        let groupingData = Dictionary(grouping: listingFromServer) { (element) -> Date in
            
            let date = element.messageTime ?? ""
            
            let dateFromatter = DateFormatter()
            
            dateFromatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//"yyyy-MM-dd'T'HH:mm:ss.SSSZ"

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
            
            var valu = (values ?? []) //?.reversed()
            
            self.messageGroupArray.append(valu)
            /*
             if startLoad == true
             {
             let values  = groupingData[key]
             
             keyS.append(key)
             
             var valu = (values ?? []) //?.reversed()
             
             self.messageGroupArray.append(valu)
             }
             else
             {
             let celldata = key
             let time = key//celldata. dateFromString(format: .NewISO, type: .utc)
             let calendar = Calendar(identifier: .gregorian)
             if calendar.isDateInToday(time)
             {
             print("Today \(key)")
             let values  = groupingData[key]
             
             keyS.append(key)
             
             var valu = (values ?? []) //?.reversed()
             
             self.messageGroupArray.append(valu)
             }
             else
             {
             let values  = groupingData[key]
             
             keyS.append(key)
             
             var valu = (values ?? []) //?.reversed()
             
             self.messageGroupArray.append(valu)
             }
             }
             */
            
            
            
        }
        UIView.performWithoutAnimation {
            self.messageTableView.reloadData()
            if scrollToButtom
            {
                
                let numberOfSections = self.messageTableView.numberOfSections
                if numberOfSections>0
                {
                    let numberOfRows = self.messageTableView.numberOfRows(inSection: numberOfSections-1)
                    
                    if numberOfRows>0
                    {
                        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                        self.messageTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
                    }
                }
            }
        }
        
      
        Indicator.sharedInstance.hideIndicator()
        
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
    
    func sendSMS()
    {
        print("sendSMS ")
        let dict2 = ["toUserId":self.view_user_id]
        SocketIOManager.shared.sendSmsAlert(MessageChatDict: dict2)
    }
    
    func userOnChatMessageScreen()
    {

        
        print("userOnChatMessageScreen call")
            let dict2 = ["user_id":self.from_user_id,"chat_room_id":self.chat_room_id]
            SocketIOManager.shared.userOnChatMessageScreen(MessageChatDict: dict2)
        
    }
    
    //Delete messge emirt method
    func deleteMessageEmit(singleChatId:String)
    {
        let dict = ["singleChatId":singleChatId,"chatRoomId":self.chat_room_id,"from_user_id":self.from_user_id]
        SocketIOManager.shared.deleteChatBySingleIdEmit(MessageChatDict: dict)
        
        self.deleteMessageOnMetthod()
    }
    
    //Delete messge on method
    func deleteMessageOnMetthod()
    {
        SocketIOManager.shared.socket.on("message_delete_success", callback: { (data, error) in
            
            
            if DataManager.currentScreen.equalsIgnoreCase(string: kMessage)
            {
            
            self.messageGroupArray2 = self.messageGroupArray
            
            if let data = data as? JSONArray
            {
                for dict in data
                {
                    
                    
                    let status =  dict["status"] as? String ?? ""
                    let messageId =  dict["_id"] as? String ?? ""
                    if status == kTrue
                    {
                        self.messageGroupArray.removeAll()
                    
                        
                        for  i in 0..<self.messageGroupArray2.count
                        {
                            
                            if self.messageGroupArray2.count>i
                            {
                                var messages = self.messageGroupArray2[i]
                                var messageArr:[AllMessageModel] = []
                                for k in 0..<self.allMessageArray.count
                                {
                                    if self.allMessageArray.count>k
                                    {
                                    let mesg = self.allMessageArray[k]
                                    if messageId == mesg._id
                                    {
                                    self.allMessageArray.remove(at: k)
                                    }
                                    }
                                }
                                
                                for j in 0..<messages.count
                                {
                                    
                                    if messages.count>j
                                    {
                                        let message = messages[j]
                                        
                                        if messageId == message._id
                                        {
                                            print("j \(j) \(i) \(message)")
                                            
                                            messages.remove(at: j)
                                        }
                                        
                                    }
                                    
                                }
                                
                                messageArr = messages
                                //self.allMessageArray = messageArr
                                self.messageGroupArray.append(messageArr)
                                
                            }
                        }
                    }
                }
            }
            
            
            self.longPressIndexPath = IndexPath(row: -1, section: -1)
            self.messageTableView.reloadData()
            
            print("deletedMessage = \(data)  \(error)")
        }
        })
    }
    
    func Continue_End_alert_Method()
    {
        SocketIOManager.shared.socket.on("back_alert_page", callback: { (data, error) in
            
            print("back_alert_page = \(data)  \(error)")
            self.view.endEditing(true)
            if #available(iOS 13.0, *) {
               
                SCENEDEL?.navigateToChat()
            } else {
                // Fallback on earlier versions
                APPDEL.navigateToChat()
            }
        })
    }
    
    func alertForRemoveBlock_Method()
    {
        SocketIOManager.shared.socket.on("alertForRemoveBlock", callback: { (data, error) in
            
            print("alertForRemoveBlock = \(data)  \(error)")
            
            if let data = data as? JSONArray
            {
                for dict in data
                {
                    let from_user_id = dict["from_user_id"] as? String ?? ""
                    
                    if from_user_id == self.view_user_id
                    {
                        if (DataManager.isMessagePageOpen) //|| DataManager.currentScreen == kChat
                        {
                            self.view.endEditing(true)
                        if #available(iOS 13.0, *) {
                            SCENEDEL?.navigateToChat()
                        } else {
                            // Fallback on earlier versions
                            APPDEL.navigateToChat()
                        }
                        }
                    }
                }
            }
            
    
        })
    }
    
    
    
    func getRTMTokenApi()
    {
        ChatVM.shared.callApi_RTM_Token_Generate(response: { (message, error) in
            if error != nil
            {
               // self.showErrorMessage(error: error)
            }
            else
            {
              let rtmToken = ChatVM.shared.Rtm_token
                
                print("RTM token = \(rtmToken)")
                print("user id  \(self.from_user_id)")
                self.agoraRtmKit?.login(byToken: rtmToken, user: self.from_user_id, completion: { (error) in
                            print("Error in login \(error)")
                        })
                
                         }
     
        })
    }
    
    
    @objc func checkTimerTime()
    {
        let dif  = "".checkTimeDiffrent(startTime: self.startTime)
        let timer  = "".checkHoursTimeDiffrent(startTime: self.startTime)
        
        // print("time check = \(dif)")
        
        if dif <= kTimeRing
        {
            self.lblTime.isHidden=false
            self.imgRed.isHidden=false
            self.lblTime.text = ("\(timer)"+" LEFT TO AGREE AND CONTINUE THE CHAT").uppercased()
            
            //self.Continue_End_alert_Method()
        }
        else
        {
            self.lblTime.isHidden=true
            self.imgRed.isHidden=true
        }
        
        
        
        
        
    }
    
    func DisconnectRoomEmit()
    {
        let dict = ["chat_room_id":self.chat_room_id]
        SocketIOManager.shared.disconnectRoomEmit(MessageChatDict: dict)
        
        //self.deleteMessageOnMetthod()
    }
}

extension UITableView {
    func setOffsetToBottom(animated: Bool) {
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
    }
    
    func scrollToLastRow(animated: Bool) {
        if self.numberOfRows(inSection: 0) > 0 {
            self.scrollToRow(at: NSIndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0) as IndexPath, at: .bottom, animated: animated)
        }
    }
}
extension MessageVC: GiphyDelegate {
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia, contentType: GPHContentType) {
        print(media)
        print(contentType)
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        showMoreByUser = nil
        self.selectedContentType = giphyViewController.selectedContentType
        Indicator.sharedInstance.showIndicator()
        print("Details ==== ")
        print(media)
        print(media.url)
        print(media.bitlyGifUrl)
        print(media.bitlyUrl)
        
        let id = media.id
        
        let gifURL = media.url(rendition: .fixedWidth, fileType: .gif) ?? ""
        let url = URL(string: gifURL)
        
        print("Gif url = \(url)")
        
        // self.imageView.media = media
        let now = Date()
        
        let dateInString = dateFromatter.string(from: now)
        
        let dict2 = ["timezone":TIMEZONE,"chat_room_id":self.chat_room_id,"to_user_id":self.view_user_id,"message":gifURL,"from_user_id":self.from_user_id,"messageTime":dateInString,"buffer_img":kGif,"message_type":kGif]
        self.fromUpdate=true
        
        SocketIOManager.shared.sendChatMessage(MessageChatDict: dict2)
        self.sendSMS()
        self.badgeCountIntervalCheckEmit()
        Indicator.sharedInstance.hideIndicator()
      //  self.messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0);

        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            print(media)
        })
        GPHCache.shared.clear()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        GPHCache.shared.clear()
    }
}
//MARK:- Delete copy meesage

extension MessageVC:UIActionSheetDelegate
{
    func requestCameraPermission()
    {
        print(#function)
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            
            if accessGranted == false
            {
                self.openSettings()
            }
           // guard accessGranted == true else { return }
           
        })
    }
    
    func deleteCopyMessge(indexPath:IndexPath)
    {
        print("indexpath = \(indexPath)")
        
        let sec = indexPath.section-1
        
        if  self.messageGroupArray.count>sec
        {
            
            if self.messageGroupArray[sec].count>indexPath.row
            {
                let cellData = self.messageGroupArray[sec][indexPath.row]
                let messageType = cellData.messageType ?? ""
                
                
                let optionMenu = UIAlertController(title: nil, message: kOptionChoose, preferredStyle: .actionSheet)
                
                let copy = UIAlertAction(title: kCopy, style: .default, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                print(kCopy)
                                                
                                                let pasteboard = UIPasteboard.general
                                                pasteboard.string = cellData.messageText ?? ""
                                                self.longPressIndexPath = IndexPath(row: -1, section: -1)
                                                self.messageTableView.reloadData()
                                                
                                            })
                
                let delete = UIAlertAction(title: kDeleteMessage, style: .default, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                print(kDeleteMessage)
                                                
                                                
                                                self.deleteMessageEmit(singleChatId: cellData._id ?? "")
                                                
                                            })
                
                let cancel = UIAlertAction(title: kCancel, style: .cancel, handler:
                                            {
                                                (alert: UIAlertAction!) -> Void in
                                                print(kCancel)
                                                self.longPressIndexPath = IndexPath(row: -1, section: -1)
                                                self.messageTableView.reloadData()
                                                
                                            })
                
                
                
                if messageType.uppercased() == kGif.uppercased()
                {
                    
                    optionMenu.addAction(delete)
                    optionMenu.addAction(cancel)
                }
                
                else if self.from_user_id == cellData.to_user_id//cellData.from_user_id
                {
                    optionMenu.addAction(copy)

                    optionMenu.addAction(cancel)
                }
                
                else
                {
                    optionMenu.addAction(copy)
                    optionMenu.addAction(delete)
                    optionMenu.addAction(cancel)
                }
                
                
                
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
    }
}
//MARK:- Socket method

extension MessageVC
{
    func updateOnlineStatusAfter2MinutesEmit()
    {
        
        let JoinDict = ["selfUserId":DataManager.Id,"timezone":TIMEZONE]
        SocketIOManager.shared.updateOnlineStatusAfter2Minutes(MessageChatDict: JoinDict)
        updateOnlineStatusAfter2MinutesON()
    }
    
    func updateOnlineStatusAfter2MinutesON()
    {
        
        SocketIOManager.shared.socket.on("onlineActive", callback: { (data, error) in
            
            print("onlineActive = \(data) \(error)")
        })
        
    }
    
    func badgeCountIntervalCheckEmit()
    {
        
//                let JoinDict = ["userId":self.view_user_id]
//                SocketIOManager.shared.badgeCountIntervalCheckEmit(MessageChatDict: JoinDict)
    }
    
    
}


//MARK:- RTM method

extension MessageVC:AgoraRtmDelegate
{
    func rtmKit(_ kit: AgoraRtmKit, peersOnlineStatusChanged onlineStatus: [AgoraRtmPeerOnlineStatus]) {
        print(#function ,(onlineStatus))
    }
 
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit)
    {
        print(#function ,(kit))
    }
    
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        print(#function)
        print(reason)
        print(state)
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        
        print("\(message.text)")
        print(#function , (peerId))
        
    }
    
   
}
extension MessageVC:CallCenterDelegate
{
    func callCenter(_ callCenter: CallCenter, startCall session: String)
    {
        print(#function)
    }
    
    func callCenter(_ callCenter: CallCenter, answerCall session: String) {
        print(#function)
    }
    
    func callCenter(_ callCenter: CallCenter, muteCall muted: Bool, session: String) {
        print(#function)
    }
    
    func callCenter(_ callCenter: CallCenter, declineCall session: String) {
        print(#function)
    }
    
    func callCenter(_ callCenter: CallCenter, endCall session: String) {
        print(#function)
    }
    
    func callCenterDidActiveAudioSession(_ callCenter: CallCenter) {
        print(#function)
    }
    
    
}
