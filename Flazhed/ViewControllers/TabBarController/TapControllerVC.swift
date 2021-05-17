//
//  TapControllerVC.swift
//  Flazhed
//
//  Created by IOS20 on 05/01/21.
//

import UIKit

class TapControllerVC: BaseVC {
    
    //MARK:- All outlets  🍎
    
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
    
    //MARK:- All Variable  🍎
    
    lazy var hangoutVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HangoutListVC" ) as! HangoutListVC
        return vc
    }()
    
    lazy var chatVC: UIViewController = {
        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatScreenVC") as!  ChatScreenVC
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
    var push=true
    
    //MARK:- View Lifecycle   🍎
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        
        self.RoundRedView.isHidden=false
        
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
        super.viewWillAppear(true)
        changeVC(index: selectedIndex)
        
        if selectedIndex == 0
        {
            self.RoundRedView.isHidden=false
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
            self.RoundRedView.isHidden=false
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        }
        else if  selectedIndex == 2
        {
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            self.RoundRedView.isHidden=false
            homeButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
            
            
        }
        
        else if  selectedIndex == 3
        {
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            self.RoundRedView.isHidden=true
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat-Blue"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        }
        
        else if  selectedIndex == 4
        {
            hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
            chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
            self.RoundRedView.isHidden=false
            homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
            storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
            profileButton.setImage(#imageLiteral(resourceName: "profile-Blue"), for: .normal)
        }
        
   
        DataManager.comeFromPage=selectedIndex
        
    }
    
    //MARK:- Home,camera switch getsture   🍎
    
    @objc func panButton(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            buttonCenter = homeButton.center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            homeButton.center = buttonCenter // restore button center
        } else {
            let location = pan.location(in: self.homeCameraBackView) // get pan location
            
            print("location = \(location)")
            print(location.x)
            
            if (location.x>0 && location.y<30)
            {
                homeButton.center = location
            }
            
            if location.x>50
            {
                
                print("is push =\(push)")
                if push
                {
                    push=false
                    hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
                    chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
                    self.RoundRedView.isHidden=false
                    homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
                    storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
                    profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
                    DataManager.comeFromPage=selectedIndex
                    let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "StoryCameraVC") as! StoryCameraVC
                    vc.selectedIndex = self.selectedIndex
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            // set button to where finger is
        }
        // print(" pan.state  = \(pan.state)")
        
    }
    
    //MARK:- All Top Tab Button action  🍎
    
    //MARK:- Hangout button action  🍎
    @IBAction func hangoutBtnAction(_ sender: UIButton) {
        selectedIndex  = 0
        DataManager.comeFrom = kEmptyString
        DataManager.comeFromPage=selectedIndex
        changeVC(index: 0)
        hangoutButton.setImage(#imageLiteral(resourceName: "hangout-Blue"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        self.RoundRedView.isHidden=false
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        DataManager.comeFromPage=selectedIndex
        
    }
    
    //MARK:- Story button action  🍎
    
    @IBAction func chatButtonAction(_ sender: UIButton) {
        DataManager.comeFrom = kEmptyString
        selectedIndex  = 1
        DataManager.comeFrom = ""
        DataManager.comeFromPage=selectedIndex
        changeVC(index: 1)
        
        
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "stories-blue"), for: .normal)
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        self.RoundRedView.isHidden=false
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        
        
    }
    //MARK:- Home button action  🍎
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        DataManager.comeFrom = kEmptyString
        DataManager.comeFromTag=5
        DataManager.HomeRefresh = "true"
        selectedIndex  = 2
        DataManager.comeFromPage=selectedIndex
        
        changeVC(index: 2)
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        self.RoundRedView.isHidden=false
        homeButton.setImage(#imageLiteral(resourceName: "Home"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        
        
    }
    //MARK:- Camera button action  🍎
    
    @IBAction func camerButtonAction(_ sender: UIButton) {
      
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        self.RoundRedView.isHidden=false
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        DataManager.comeFromPage=selectedIndex
        let storyBoard = UIStoryboard.init(name: "Stories", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StoryCameraVC") as! StoryCameraVC
        vc.selectedIndex = self.selectedIndex
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Chat button action  🍎
    
    @IBAction func storiesButtonAction(_ sender: UIButton) {
        selectedIndex  = 3
        DataManager.comeFrom = kEmptyString
        DataManager.comeFromPage=selectedIndex
        changeVC(index: 3)
        
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        self.RoundRedView.isHidden=true
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat-Blue"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile"), for: .normal)
        
    }
    
    //MARK:- profile button action  🍎
    
    @IBAction func profileButtonAction(_ sender: UIButton) {
        selectedIndex  = 4
        DataManager.comeFromPage=selectedIndex
        DataManager.comeFrom = kEmptyString
        changeVC(index: 4)
        hangoutButton.setImage(#imageLiteral(resourceName: "smile"), for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "Stories"), for: .normal)
        self.RoundRedView.isHidden=false
        homeButton.setImage(#imageLiteral(resourceName: "Home-gray"), for: .normal)
        storiesButton.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        profileButton.setImage(#imageLiteral(resourceName: "profile-Blue"), for: .normal)
    }
}

//MARK: Container Setup and Methods   🍎

extension TapControllerVC  {
    
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

