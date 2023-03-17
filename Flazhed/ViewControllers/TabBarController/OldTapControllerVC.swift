//
//  OldTapControllerVC.swift
//  Flazhed
//
//  Created by IOS20 on 05/01/21.
//

import UIKit

class OldTapControllerVC: BaseVC {
    
    //MARK: - All outlets
    
    @IBOutlet weak var hangoutButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
   
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var storiesButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeCameraBackView: UIView!
    @IBOutlet weak var RoundRedView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    var gameTimer: Timer?
    var cameraScreenPushes=false
    //MARK: - All Variable  
    
    lazy var hangoutVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HangoutListVC" ) as! HangoutListVC
        return vc
    }()
    
    lazy var chatVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewChatSectionVC") as!  NewChatSectionVC//ChatScreenVC
        return vc
    }()
    
    lazy var homeVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        return vc
    }()
    
    lazy var storiesVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StoriesVC") as! StoriesVC
        return vc
    }()
    
    lazy var profileVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Profile", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        return vc
    }()
    
    
    var buttonCenter: CGPoint = .zero
    var index = 0
    var selectedIndex = 2
    var comeFrom = ""
    var push=false
    
    //MARK: - View Lifecycle   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocketIOManager.shared.initializeSocket()
        // gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        DataManager.isMessagePageOpen=false
        
        
        
        
        if self.getDeviceModel() == "iPhone 6"
        {
            
            TOPSPACING = CGFloat(STATUSBARHEIGHT+8)
        }
        else
        {
            TOPSPACING = CGFloat(56)
            
        }
        
        STATUSBARHEIGHT=getStatusBarHeight()
        
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        
        
        
        self.RoundRedView.isHidden=true
        
        self.topHeight.constant = 106//STATUSBARHEIGHT+44+20
        
        //        topView.layer.masksToBounds = false
        //        topView.layer.shadowRadius = 5
        //        topView.layer.shadowOpacity = 5
        //        topView.layer.shadowColor = UIColor.black.cgColor
        //        topView.layer.shadowOffset = CGSize(width: 10 , height:5)
        //        topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 1)
        
        topView.borderWidth=0.2
        topView.borderColor=HOMESADOWCOLOR
        self.topView.addBottomShadow()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panButton(pan:)))
        homeButton.addGestureRecognizer(pan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MusicPlayer.instance.pause()
       // APPDEL.timerTimeLeftCheck?.invalidate()
        self.cameraScreenPushes=false
        
        debugPrint("Tap controller appear")
     //   self.selfJoinSocketEmit()
       // self.badgeCountIntervalCheckEmit()
        self.badgeCountIntervalCheckON()
        //MARK: -Uncomment when done
        
       // APPDEL.timerBudgeCount = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        //  RunLoop.main.add(APPDEL.timerBudgeCount ?? Timer(), forMode: RunLoop.Mode.common)
        super.viewWillAppear(true)
        self.RoundRedView.isHidden=true
        changeVC(index: selectedIndex)
        DataManager.isPrefrenceSet = true
        DataManager.isEditProfile=true
        APPDEL.timerTimeLeftCheck?.invalidate()
        
        
        if selectedIndex == 0
        {
            
            hangoutButton.setImage(#imageLiteral(resourceName: "hangout-Blue"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        }
        else if  selectedIndex == 1
        {
            
            
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "stories-blue"), for: .normal)
            
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        }
        else if  selectedIndex == 2
        {
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            homeButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
            
            
        }
        
        else if  selectedIndex == 3
        {
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            //self.RoundRedView.isHidden=true
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat-Blue"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        }
        
        else if  selectedIndex == 4
        {
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile-Blue"), for: .normal)
        }
        
        
        DataManager.comeFromPage=selectedIndex
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        debugPrint("Tap controller disappear")
        
        APPDEL.timerBudgeCount?.invalidate()
        
    }
//    @objc func runTimedCode()
//    {
//        DispatchQueue.main.async {
//            self.selfJoinSocketEmit()
//            self.badgeCountIntervalCheckEmit()
//            self.badgeCountIntervalCheckON()
//        }
//
//    }
    //MARK: - Home,camera switch getsture   
    
    @objc func panButton(pan: UIPanGestureRecognizer) {
        MusicPlayer.instance.pause()
        DataManager.currentScreen=kCamera
        if pan.state == .began {
            buttonCenter = homeButton.center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            homeButton.center = buttonCenter // restore button center
        } else {
            let location = pan.location(in: self.homeCameraBackView) // get pan location
            
            debugPrint("location = \(location)")
            debugPrint(location.x)
            
            if (location.x>0 && location.y<30)
            {
                homeButton.center = location
            }
            
            if location.x>50
            {
                
                debugPrint("is push =\(push)")
                if !self.cameraScreenPushes
                {
                    self.cameraScreenPushes=true
                    hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
                    chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
                    homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
                    storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
                    profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
                    DataManager.comeFromPage=selectedIndex
                    let vc = NewStoryCameraVC.instantiate(fromAppStoryboard: .Stories)

                    vc.selectedIndex = self.selectedIndex
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            // set button to where finger is
        }
        // debugPrint(" pan.state  = \(pan.state)")
        
    }
    
    //MARK: - All Top Tab Button action  
    
    //MARK: - Hangout button action  
    @IBAction func hangoutBtnAction(_ sender: UIButton) {
        MusicPlayer.instance.pause()
        selectedIndex  = 0
        DataManager.comeFrom = kEmptyString
        DataManager.comeFromPage=selectedIndex
        DataManager.currentScreen=kStory
        changeVC(index: 0)
        sender.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: kButtonDisableSec, repeats: false, block: { _ in
            sender.isUserInteractionEnabled = true
        })
        hangoutButton.setImage(#imageLiteral(resourceName: "hangout-Blue"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        DataManager.comeFromPage=selectedIndex
        SocketIOManager.shared.initializeSocket()
        
        //self.badgeCountIntervalCheckEmit()
        // self.badgeCountIntervalCheckON()
        
    }
    
    //MARK: - Story button action  
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        MusicPlayer.instance.pause()
        
        DataManager.currentScreen=kHangout
        DataManager.comeFrom = kEmptyString
        selectedIndex  = 1
        DataManager.comeFrom = ""
        DataManager.comeFromPage=selectedIndex
        changeVC(index: 1)
        
        sender.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: kButtonDisableSec, repeats: false, block: { _ in
            sender.isUserInteractionEnabled = true
        })
        
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "stories-blue"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        
        SocketIOManager.shared.initializeSocket()
        //  self.badgeCountIntervalCheckEmit()
        // self.badgeCountIntervalCheckON()
        
    }
    //MARK: - Home button action  
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        DataManager.comeFrom=kEmptyString
        MusicPlayer.instance.pause()
        DataManager.comeFrom = kEmptyString
        DataManager.comeFromTag=5
        DataManager.HomeRefresh = true
        selectedIndex  = 2
        DataManager.comeFromPage=selectedIndex
        DataManager.currentScreen=kHomePage
        changeVC(index: 2)
        sender.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: kButtonDisableSec, repeats: false, block: { _ in
            sender.isUserInteractionEnabled = true
        })
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        SocketIOManager.shared.initializeSocket()
        //self.badgeCountIntervalCheckEmit()
        // self.badgeCountIntervalCheckON()
        
        
    }
    //MARK: - Camera button action  
    
    @IBAction func camerButtonAction(_ sender: UIButton) {
        MusicPlayer.instance.pause()
        if !cameraScreenPushes
        {
            self.cameraScreenPushes=true
        DataManager.currentScreen=kCamera
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        DataManager.comeFromPage=selectedIndex
        let vc = NewStoryCameraVC.instantiate(fromAppStoryboard: .Stories)
        vc.selectedIndex = self.selectedIndex
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //MARK: - Chat button action  
    
    @IBAction func storiesButtonAction(_ sender: UIButton) {
     
        MusicPlayer.instance.pause()
        selectedIndex  = 3
        DataManager.comeFrom = kEmptyString
        DataManager.comeFromPage=selectedIndex
        DataManager.currentScreen=kChat
        changeVC(index: 3)
        sender.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: kButtonDisableSec, repeats: false, block: { _ in
            sender.isUserInteractionEnabled = true
        })
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        // self.RoundRedView.isHidden=true
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat-Blue"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        SocketIOManager.shared.initializeSocket()
        // self.badgeCountIntervalCheckEmit()
        // self.badgeCountIntervalCheckON()
        
    }
    
    //MARK: - profile button action  
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        MusicPlayer.instance.pause()
        selectedIndex  = 4
        DataManager.comeFromPage=selectedIndex
        DataManager.comeFrom = kEmptyString
        DataManager.currentScreen=kProfile
        changeVC(index: 4)
        sender.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: kButtonDisableSec, repeats: false, block: { _ in
            sender.isUserInteractionEnabled = true
        })
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile-Blue"), for: .normal)
        SocketIOManager.shared.initializeSocket()
        // self.badgeCountIntervalCheckEmit()
        //self.badgeCountIntervalCheckON()
        
    }
}

//MARK: Container Setup and Methods   

extension OldTapControllerVC  {
    
    // change viewController in container view
    private func changeVC(index: Int) {
        switch index {
        case 0:
            addchildVC(childVC: hangoutVC)
        case 1:
            addchildVC(childVC: storiesVC)
        case 2 :
            addchildVC(childVC: homeVC)
        case 3:
            addchildVC(childVC:chatVC)
        case 4:
            addchildVC(childVC:profileVC)
        default:
            break
        }
        //        createButton.isSelected = index == 0 //In case of create Selected
        //        ongoingButton.isSelected = index == 1 //In case of ongoing Selected
        //        completedButton.isSelected = index == 2 //In case of Completed Selected
        
    }
    
    // add a view controller to containerView
    private func addchildVC(childVC: UIViewController){
        self.removeAllChildVC()
        self.addChild(childVC)
        self.containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.view.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromLeft, animations: {
            childVC.view.alpha = 1.0
        }) { (true) in
            childVC.didMove(toParent: self)
        }
    }
    
    // remove child viewControllers
    private func removeAllChildVC(){
        self.remove(childVC: hangoutVC)
        self.remove(childVC: storiesVC)
        self.remove(childVC: homeVC)
        self.remove(childVC: chatVC)
        self.remove(childVC: profileVC)
    }
    
    // remove a viewcontroller from containerview
    private func remove(childVC: UIViewController){
        childVC.willMove(toParent: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
}


//MARK: - Socket method

//extension OldTapControllerVC
//{
//    func selfJoinSocketEmit()
//    {
//
//        let JoinDict = ["selfUserId":DataManager.Id]
//        SocketIOManager.shared.selfJoinSocket(MessageChatDict: JoinDict)
//
//    }
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
//    func badgeCountIntervalCheckON2()
//    {
//        SocketIOManager.shared.socket.on("receivedBadgeCount", callback: { (data, error) in
//
//            self.RoundRedView.isHidden=true
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
//                        self.RoundRedView.isHidden=false
//                    }
//                    else
//                    {
//                        self.RoundRedView.isHidden=true
//                    }
//                }
//            }
//            else
//            {
//                self.RoundRedView.isHidden=true
//            }
//
//            //  debugPrint("receivedBadgeCount = \(data) \(error)")
//        })
//
//    }
//
//}
