//
//  NewPremiumVC.swift
//  Flazhed
//
//  Created by ios2 on 16/11/21.
//

import UIKit

protocol paymentScreenOpenFrom
{
    func FromScreenName(name:String,ActiveDay:Int)
}

class NewPremiumVC: BaseVC {
    
    //MARK: -  IBOutlets
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTerm: UIButton!
    @IBOutlet weak var btnGetNoew: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewCollectionBack: UIView!
    @IBOutlet weak var pageControlle: UIPageControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblRegret: UILabel!
    @IBOutlet weak var premCollection: UICollectionView!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK: - Class Life Cycle
    
    //MARK: - Variables
    var selectedIndex = 1
    var comeFrom2 = ""
    var amountlistForRegret = [20,35,50]
    var NoListForExtraShake = [1,3,5]
    var amountListForExtraShake = [10,25,50]
    var amountListForProlongChats = [1,4,7]
    
    //MARK: - Hangout array
    var basicHagoutArray = [1,5,5]
    var plusHagoutArray = [2,7,7]
    var goldHagoutArray = [3,14,14]
    var platinumHagoutArray = ["5","∞","∞"]
    
    //MARK: - Chat array
    var basicChatArray = [kEmptyString,"3","3x30\""]
    var plusChatArray = [kEmptyString,"5","3x60\""]
    var goldChatArray = [kEmptyString,"7","5x60\""]
    var platinumChatArray = [kEmptyString,"∞","10x60\""]
    
    //MARK: - Story array
    var basicStoryArray = ["2","-","3"]
    var plusStoryArray = [3,1,5]
    var goldStoryArray = [5,2,7]
    var platinumStoryArray = [7,3,10]
    
    
    //MARK: - Shake array
    var basicShakeArray = ["-","200","3"]
    var plusShakeArray = ["∞","300","5"]
    var goldShakeArray = ["∞","500","7"]
    var platinumShakeArray = ["∞","1000","10"]
    
    var fromUpdatePage=false
    var validatePurchase:Bool!
    var comeform3:String!
    var image:UIImage?
    var purchase = String()
    
    var listIcons = [#imageLiteral(resourceName: "IceBreaker"),#imageLiteral(resourceName: "HeartArrow"),#imageLiteral(resourceName: "StarIcon")]
    
    var paymentType = "Monthly"
    var subscription_id = "601bd7697e02cb0f3ce6b087"

    var type : PaymentScreenType = .kExtraShakes
    
    
    var transaction_id="1000000859449277"
    var amount="25"
    var subscription_type=kHangout
    var name=kHangout
    var extra_shake=3
    
    var same_hangout=2
    var hangout_days_active=7
    var number_of_interested_hangouts=7
    
    
    var picture_per_day=3
    var video_per_day=1
    var video_length=5
    
    
    var simultaneously_chat=5
    var monthly_video_call=3
    var max_video_call=3
    
    var shake_radius=300
    var extra_shake2=5
    
  
    var typeArray = [kShake]//[kHangout,kChat,kStory,kShake]
    var delegate:paymentScreenOpenFrom?
    var popupShowIndex=0
    var currentSubscriptionType=kBasicFree
    
    var hangouCurrentIndex=0
    var chatCurrentIndex=0
    var storyCurrentIndex=0
    var shakeCurrentIndex=0
    var tapIndex=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.btnTerm.underline()
        self.btnPrivacy.underline()
        DispatchQueue.main.async{
            if IAPHandler.shared.hanoutPriceArray.count==0
            {
                
                IAPHandler.shared.getProducts()
            }
        }
 
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedPaymentDone(notification:)), name: Notification.Name("PaymentPremiumNoti"), object: nil)
        
//
//
//        imgHeader.image = #imageLiteral(resourceName: "hangoutPre")
//        lblRegret.text = kHangout
//       // lblPremium.text = "Don't bother about shake limits anymore."
//        type = .Hangout
   
        self.setupCollection()
        if Connectivity.isConnectedToInternet
        {
            
            self.getMySubscriptionApi()
        } else {
        
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
      

    }
    override var prefersStatusBarHidden: Bool {
           return true
    }
    
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
        self.fromUpdatePage=false
        self.purchase = kPlus
        self.pageControlle.hidesForSinglePage=true
        self.pageControlle.numberOfPages=self.typeArray.count
       
        
//        IAPHandler.shared.validatePurchase { (status,productId) in
//            debugPrint("Payment buy status = \(status) \(productId)")
//            if status
//            {
//
//            }
//        }
    
        self.btnRestore.isHidden=false
    }
    override func viewDidDisappear(_ animated: Bool) {
        
            NotificationCenter.default.removeObserver(self, name: Notification.Name("PaymentPremiumNoti"), object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async{
            if IAPHandler.shared.hanoutPriceArray.count==0
            {
                
                IAPHandler.shared.getProducts()
            }
        }
        //self.premCollection.scrollToItem(at: IndexPath(item: self.popupShowIndex, section: 0), at: .centeredHorizontally, animated: false)
        
       
        
        
    }
    override func viewDidLayoutSubviews() {
           
        super.viewDidLayoutSubviews()
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -headerView.bounds.height, right: 0)
    }
    
    
    func setUpUI()
    {
     
        self.btnGetNoew.setTitle(kGetNow, for: .normal)
        self.btnGetNoew.setTitle(kGetNow, for: .selected)
        self.btnGetNoew.backgroundColor = ENABLECOLOR
        self.btnRestore.setTitle(kRESTORE, for: .normal)
        self.btnRestore.setTitle(kRESTORE, for: .selected)
        self.btnRestore.backgroundColor = ENABLECOLOR
    }
    
    //MARK: - Select premium action
    
    
    //
    @objc func btnAction(_ sender:UIButton)
    {
        selectedIndex = sender.tag
        self.tapIndex=sender.tag
        if type == .Hangout
        {

            //self.amount = amountlistForRegret[selectedIndex]
            self.subscription_type = kHangout
        }
        else if  type == .Chat
        {
            //self.amount = amountListForExtraShake[selectedIndex]
            self.subscription_type = kChating
            //self.extra_shake = NoListForExtraShake[selectedIndex]

        } else if  type == .Story {
            self.subscription_type = kStory
           // self.amount = amountListForProlongChats[selectedIndex]

        }
        else if  type == .Shake {
            self.subscription_type = kShake
            //self.amount = amountListForProlongChats[selectedIndex]

        }

        if selectedIndex == 3
        {
            self.purchase=kPlatinum

        }
        else if selectedIndex == 2
        {
            self.purchase=kGold

        }
        else  if selectedIndex == 0
        {
            self.purchase=kFree
            self.hangout_days_active=5
        }
        else
        {
            self.purchase=kPlus
        }
        
        self.fromUpdatePage=true
        self.premCollection.reloadData()
      
       
    
    }
    //MARK: -IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.goToShake()
    }
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
        self.goToShake()
    }

    @IBAction func restoreBtnAction(_ sender: UIButton) {
        debugPrint("restore purchase")
        if Connectivity.isConnectedToInternet {
            IAPHandler.shared.delegate=self
            self.showLoader()
            IAPHandler.shared.restoreProducts()
         
         } else {
             self.hideLoader()
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }

//        self.dismiss(animated: true) {
//            if self.type == .Hangout
//            {
//            self.delegate?.FromScreenName(name: self.subscription_type, ActiveDay:  self.hangout_days_active)
//            }
//        }
//
    }
    //MARK: - Buy button action
    
    @IBAction func premiumBtnAction(sender:UIButton) {
        
        
      

        
        if Connectivity.isConnectedToInternet {
                    
            if IAPHandler.shared.hanoutPriceArray.count==0
            {
                IAPHandler.shared.getProducts()
                debugPrint("come from = \(type) \(self.purchase)")
            }
       
            debugPrint("come from = \(currentSubscriptionType) \(self.purchase)")
            
            if self.currentSubscriptionType.contains(self.purchase)//(string: self.purchase)
            {
                self.openSimpleAlert(message: kAlredaySubscribe)
            }
            else if (self.currentSubscriptionType.contains(kGold) &&  (self.purchase.contains(kPlus)))//(string: self.purchase)
            {
                self.openSimpleAlert(message: kSubscribeDegrate)
            }
            else if (self.currentSubscriptionType.contains(kPlatinum) &&  (self.purchase.contains(kPlus)||self.purchase.contains(kGold)))//(string: self.purchase)
            {
                self.openSimpleAlert(message: kSubscribeDegrate)
            }
            
            else
            {
                
                
                self.showLoader()
                if self.purchase == kPlatinum
                {
        
                    IAPHandler.shared.purchase(product: .kPlatinum,fromScreen: kPremium)
                    
                }
                else if self.purchase == kGold
                {
        
                    IAPHandler.shared.purchase(product: .kGold,fromScreen: kPremium)
                }
                else if self.purchase == kFree
                {
                    self.endSubscription()
                }

                else
                {

                    IAPHandler.shared.purchase(product: .kPlus,fromScreen: kPremium)
                }
                
                
                
                /*
                if type == .Hangout
                {
                    self.showLoader()
                    if self.purchase == kPlatinum
                    {
                        //Indicator.sharedInstance.showIndicator()
                       
                        IAPHandler.shared.purchase(product: .hangoutPlatinum,fromScreen: kPremium)
                            
                        
                    }
                    else if self.purchase == kGold
                    {
                        //Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .hangoutGold,fromScreen: kPremium)
                    }
                    else if self.purchase == kFree
                    {
                        self.endSubscription()
                    }
                
                    else //if self.purchase == kPlus
                    {
                       // Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .hangoutPlus,fromScreen: kPremium)
                    }
                    
                    
                }
                else if  type == .Chat
                {
                    self.showLoader()
                    if self.purchase == kPlatinum
                    {
                        Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .chatPlatinum,fromScreen: kPremium)
                        
                    }else if self.purchase == kGold
                    {
                        Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .chatGold,fromScreen: kPremium)
                    }
                    else if self.purchase == kFree
                    {
                        self.endSubscription()
                    }
                    
                    else
                    {
                        Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .chatPlus,fromScreen: kPremium)
                    }
                    
                    
                }
                else if  type == .Story
                {
                    self.showLoader()
                    if self.purchase == kPlatinum
                    {
                        Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .storyPlatinum,fromScreen: kPremium)
                        
                    }else if self.purchase == kGold
                    {
                        Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .storyGold,fromScreen: kPremium)
                    }
                    else if self.purchase == kFree
                    {
                        self.endSubscription()
                    }
                    
                    else
                    {
                        Indicator.sharedInstance.showIndicator()
                        IAPHandler.shared.purchase(product: .storyPlus,fromScreen: kPremium)
                    }
                }
                    else if  type == .Shake
                    {
                        self.showLoader()
                        if self.purchase == kPlatinum
                        {
                            Indicator.sharedInstance.showIndicator()
                            IAPHandler.shared.purchase(product: .shakePlatinum,fromScreen: kPremium)
                            
                        }else if self.purchase == kGold
                        {
                            Indicator.sharedInstance.showIndicator()
                            IAPHandler.shared.purchase(product: .shakeGold,fromScreen: kPremium)
                        }
                        else if self.purchase == kFree
                        {
                            self.endSubscription()
                        }
                        
                        else
                        {
                            Indicator.sharedInstance.showIndicator()
                            IAPHandler.shared.purchase(product: .shakePlus,fromScreen: kPremium)
                        }
                    }
                
                */
                    IAPHandler.shared.delegate=self
            }
            
        } else {
            self.hideLoader()
           self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
       }
        
        

        
    
    }
    @IBAction func noThanksBtnAction(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    //MARK: - Term & condition button action
    
    @IBAction func termCondtionAct(_ sender: Any)
    {
        let vc = WebVC.instantiate(fromAppStoryboard: .Account)
        vc.pageTitle=kTermOfService
        vc.pageUrl=TERM_URL
       // self.navigationController?.pushViewController(vc, animated: true)
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    //MARK: - Privacy policy button action
    
    @IBAction func privacyPolicyAct(_ sender: Any)
    {
        let vc = WebVC.instantiate(fromAppStoryboard: .Account)
        vc.pageTitle=kPrivacyPolicy
        vc.pageUrl=Privacy_Policy_URL
        //self.navigationController?.pushViewController(vc, animated: true)
        if let tab = self.tabBarController
        {
            tab.present(vc, animated: true, completion: nil)
        }
        else
        {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.premCollection,self.btnGetNoew,self.btnRestore,self.imgHeader])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.premCollection,self.btnGetNoew,self.btnRestore,self.imgHeader])
    }
         
    
}
extension NewPremiumVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
            self.premCollection.delegate=self
            self.premCollection.dataSource=self
            self.premCollection.register(UINib(nibName: "NewPremiumCCell", bundle: nil), forCellWithReuseIdentifier: "NewPremiumCCell")
 
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return  self.typeArray.count//+1
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewPremiumCCell", for: indexPath)
                as! NewPremiumCCell

      
        
       // if indexPath.row == 1
       // {
            cell.constPremCenter.constant = 0
            cell.constTopWidthLbl2.constant = 90
            cell.constTopWidthLbl3.constant = 90
//        }
//        else
//        {
//            cell.constPremCenter.constant = 45
//            cell.constTopWidthLbl2.constant = 60
//            cell.constTopWidthLbl3.constant = 60
//        }
        
    
        var AmountModel:premiumModel?
        
        
        if type == .Hangout
        {
          
            cell.lblTop1.text = kSameHangouts
            cell.lblTop2.text = kDaysActive
            cell.lblTop3.text = kNumberOfInterested
            
            
            cell.lbl1Basic.text = "\(self.basicHagoutArray[0])"
            cell.lbl2Basic.text = "\(self.basicHagoutArray[1])"
            cell.lbl3Basic.text = "\(self.basicHagoutArray[2])"
            
            
            cell.lb1Plus.text = "\(self.plusHagoutArray[0])"
            cell.lbl2Plus.text = "\(self.plusHagoutArray[1])"
            cell.lbl3Plus.text = "\(self.plusHagoutArray[2])"
            
            cell.lbl1Gold.text = "\(self.goldHagoutArray[0])"
            cell.lbl2Gold.text = "\(self.goldHagoutArray[1])"
            cell.lbl3Gold.text = "\(self.goldHagoutArray[2])"
            
            
            cell.lbl1Pla.text = "\(self.platinumHagoutArray[0])"
            cell.lbl2Pla.text = "\(self.platinumHagoutArray[1])"
            cell.lbl3Pla.text = "\(self.platinumHagoutArray[2])"
        }
        else if  type == .Chat
        {
            
            cell.lblTop1.text = kEmptyString
            cell.lblTop2.text = kSimultaneousChats
            cell.lblTop3.text = kVideoCallsPerMonth
            
            
            cell.lbl1Basic.text = "\(self.basicChatArray[0])"
            cell.lbl2Basic.text = "\(self.basicChatArray[1])"
            cell.lbl3Basic.text = "\(self.basicChatArray[2])"
            
            
            cell.lb1Plus.text = "\(self.plusChatArray[0])"
            cell.lbl2Plus.text = "\(self.plusChatArray[1])"
            cell.lbl3Plus.text = "\(self.plusChatArray[2])"
            
            cell.lbl1Gold.text = "\(self.goldChatArray[0])"
            cell.lbl2Gold.text = "\(self.goldChatArray[1])"
            cell.lbl3Gold.text = "\(self.goldChatArray[2])"
            
            
            cell.lbl1Pla.text = "\(self.platinumChatArray[0])"
            cell.lbl2Pla.text = "\(self.platinumChatArray[1])"
            cell.lbl3Pla.text = "\(self.platinumChatArray[2])"

        }
        else if  type == .Story
        {
            cell.lblTop1.text = kPicturesPerDay
            cell.lblTop2.text = kVideosPerDay
            cell.lblTop3.text = kVideoLengthNew
            
            cell.lbl1Basic.text = "\(self.basicStoryArray[0])"
            cell.lbl2Basic.text = "\(self.basicStoryArray[1])"
            cell.lbl3Basic.text = "\(self.basicStoryArray[2])"
            
            
            cell.lb1Plus.text = "\(self.plusStoryArray[0])"
            cell.lbl2Plus.text = "\(self.plusStoryArray[1])"
            cell.lbl3Plus.text = "\(self.plusStoryArray[2])"
            
            cell.lbl1Gold.text = "\(self.goldStoryArray[0])"
            cell.lbl2Gold.text = "\(self.goldStoryArray[1])"
            cell.lbl3Gold.text = "\(self.goldStoryArray[2])"
            
            
            cell.lbl1Pla.text = "\(self.platinumStoryArray[0])"
            cell.lbl2Pla.text = "\(self.platinumStoryArray[1])"
            cell.lbl3Pla.text = "\(self.platinumStoryArray[2])"
   
    
        }
        else
        {
            //cell.lblTop1.text = kRegretSwipeNew
            cell.lblTop2.text = kExpandRadius
            cell.lblTop3.text = kDailyShakesNew
            
            cell.lbl1Basic.text = "\(self.basicShakeArray[0])"
            cell.lbl2Basic.text = "\(self.basicShakeArray[1])"
            cell.lbl3Basic.text = "\(self.basicShakeArray[2])"
            
            
            cell.lb1Plus.text = "\(self.plusShakeArray[0])"
            cell.lbl2Plus.text = "\(self.plusShakeArray[1])"
            cell.lbl3Plus.text = "\(self.plusShakeArray[2])"
            
            cell.lbl1Gold.text = "\(self.goldShakeArray[0])"
            cell.lbl2Gold.text = "\(self.goldShakeArray[1])"
            cell.lbl3Gold.text = "\(self.goldShakeArray[2])"
            
            
            cell.lbl1Pla.text = "\(self.platinumShakeArray[0])"
            cell.lbl2Pla.text = "\(self.platinumShakeArray[1])"
            cell.lbl3Pla.text = "\(self.platinumShakeArray[2])"
        }
        
        
        if !self.fromUpdatePage
        {
         for modelData in IAPHandler.shared.hanoutPriceArray
        {
            AmountModel = modelData
        
        let typeAmount = AmountModel?.type ?? kEmptyString
        let price = AmountModel?.price
        
             if productIDs.kPlus.rawValue.equalsIgnoreCase(string: typeAmount)
        {
            cell.lblPlusAmount.attributedText = self.setPrice(amount: price ?? kP9)
        }
          else if productIDs.kGold.rawValue.equalsIgnoreCase(string: typeAmount)
        {
            cell.lblGoldAmount.attributedText = self.setPrice(amount: price ?? kP15)
        }
      else if  productIDs.kPlatinum.rawValue.equalsIgnoreCase(string: typeAmount)
        {
            cell.lblPlaAmoount.attributedText = self.setPrice(amount: price ?? kP22)
        }
       
        }
        }
      
        var chooseIndex = 0
        if self.fromUpdatePage
        {
            chooseIndex = self.tapIndex
        }
        else
        {
            chooseIndex = self.selectedIndex
        }
        
      
            if chooseIndex == 3 //tapIndex selectedIndex//self.purchase.equalsIgnoreCase(string: kPlatinum)//
            {
                cell.viewPlatBack.borderColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                self.amount=cell.lblPlaAmoount.text ?? kFree
                self.name=kPlatinum
                self.purchase=kPlatinum
                self.hangout_days_active=kPInfinity
                
            }
            else
            {
                cell.viewPlatBack.borderColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            }
            if chooseIndex == 1 //self.purchase.equalsIgnoreCase(string: kPlus)//
            {
                cell.viewPlusBack.borderColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                self.amount=cell.lblPlusAmount.text ?? kFree
                self.name=kPlus
                self.purchase=kPlus
                self.hangout_days_active=7
            }
            else
            {
                cell.viewPlusBack.borderColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            }
            
            if chooseIndex == 2//self.purchase.equalsIgnoreCase(string: kGold)//
            {
                cell.viewGoldBack.borderColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                self.amount=cell.lblGoldAmount.text ?? kFree
                self.name=kGold
                self.purchase=kGold
                self.hangout_days_active=14
            }
            else
            {
                cell.viewGoldBack.borderColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            }
            if chooseIndex == 0//self.purchase.equalsIgnoreCase(string: kFree)
            {
                cell.viewBasicBack.borderColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                self.amount=cell.lblFreeAmount.text ?? kFree
                self.name=kBasicFree
                self.purchase=kFree
                self.hangout_days_active=5
            }
            else
            {
                cell.viewBasicBack.borderColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            }
        
        
        
        cell.viewPlusBack.borderWidth=1
        cell.viewBasicBack.borderWidth=1
        cell.viewGoldBack.borderWidth=1
        cell.viewPlatBack.borderWidth=1
        
        cell.btnBasic.tag = 0
        cell.btnBasic.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        cell.btnPlus.tag = 1
        cell.btnPlus.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        cell.btnGold.tag = 2
        cell.btnGold.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        cell.btnPla.tag = 3
        cell.btnPla.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
            return cell
            /*
        }
        else
        {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PremiumCCell", for: indexPath)
            as! PremiumCCell
        

            cell.iceBreakerImage1.image = listIcons[0]
            cell.iceBreakerImage2.image = listIcons[1]
            cell.iceBreakerImage3.image = listIcons[2]
        
        
        
        if selectedIndex == 0
        {
            cell.cellBG1.backgroundColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblIcebreaker1.textColor = .white
            cell.lblPack1.textColor = .white
            cell.lblDollar1.textColor = .white
            cell.lblAmount1.textColor = .white
            
        }
        else
        {
            cell.lblIcebreaker1.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblPack1.textColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            cell.cellBG1.backgroundColor = .white
            cell.lblDollar1.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblAmount1.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
        }
        if selectedIndex == 1
        {
            cell.cellBG2.backgroundColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblIcebreaker2.textColor = .white
            cell.lblPack2.textColor = .white
            cell.lblDollar2.textColor = .white
            cell.lblAmount2.textColor = .white
            
        }
        else
        {
            cell.lblIcebreaker2.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblPack2.textColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            cell.cellBG2.backgroundColor = .white
            cell.lblDollar2.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblAmount2.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
        }
        if selectedIndex == 2
        {
            cell.cellBG3.backgroundColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblIcebreaker3.textColor = .white
            cell.lblPack3.textColor = .white
            cell.lblDollar3.textColor = .white
            cell.lblAmount3.textColor = .white
            
        }
        
        else {
            cell.lblIcebreaker3.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblPack3.textColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            cell.cellBG3.backgroundColor = .white
            cell.lblDollar3.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblAmount3.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            
            
        }
       
        
        if type == .Regret
        {
            cell.lblIcebreaker1.text = list[0]
            cell.lblPack1.text = monthPackList[0]
            cell.lblAmount1.text = "\(amountlistForRegret[0])"
            
            cell.lblIcebreaker2.text = list[1]
            cell.lblPack2.text = monthPackList[1]
            cell.lblAmount2.text = "\(amountlistForRegret[1])"
            
            cell.lblIcebreaker3.text = list[2]
            cell.lblPack3.text = monthPackList[2]
            cell.lblAmount3.text = "\(amountlistForRegret[2])"
            
        } else if  type == .kExtraShakes{
            cell.lblIcebreaker1.text = list[0]
            cell.lblPack1.text = dayPackList[0]
            cell.lblAmount1.text = "\(amountListForExtraShake[0])"
            
            cell.lblIcebreaker2.text = list[1]
            cell.lblPack2.text = dayPackList[1]
            cell.lblAmount2.text = "\(amountListForExtraShake[1])"
            
            
            cell.lblIcebreaker3.text = list[2]
            cell.lblPack3.text = dayPackList[2]
            cell.lblAmount3.text = "\(amountListForExtraShake[2])"
            
        }
        else if  type == .Prolong
        {
            cell.lblIcebreaker1.text = list[0]
            cell.lblPack1.text = monthPackList[0]
            cell.lblAmount1.text = "\(amountListForProlongChats[0])"
            
            cell.lblIcebreaker2.text = list[1]
            cell.lblPack2.text = monthPackList[1]
            cell.lblAmount2.text = "\(amountListForProlongChats[1])"
            
            cell.lblIcebreaker3.text = list[2]
            cell.lblPack3.text = monthPackList[2]
            cell.lblAmount3.text = "\(amountListForProlongChats[2])"
        }
        
        
       
        if type == .Regret
        {
            cell.discountView3.isHidden = false
            cell.lblDiscount3.text = "SAVE 25%"
            
            cell.discountView1.isHidden=true
            cell.discountView2.isHidden=true
        }
        else if type == .kExtraShakes
        {
            cell.discountView2.isHidden = false
            cell.lblDiscount2.text = "SAVE $5"
            
            cell.discountView1.isHidden=true
            cell.discountView3.isHidden=true
        }
        else if type == .Prolong {
            cell.discountView2.isHidden = false
            cell.lblDiscount2.text = "SAVE 20%"
            
            cell.discountView1.isHidden=true
            cell.discountView3.isHidden=true
            
        } else {
            cell.discountView1.isHidden = true
            cell.discountView2.isHidden = true
            cell.discountView3.isHidden = true
        }
        return cell
        }
        
        */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return self.premCollection.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        
//        NotificationCenter.default.post(name: Notification.Name("OpenProfileDetails"), object: nil, userInfo: ["userId":self.currentUserDetails?.user_id ?? ""])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      
            return 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
            return 0
       
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == self.premCollection
        {
    
       let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
       let index = scrollView.contentOffset.x / witdh
       let roundedIndex = round(index)
       self.pageControlle.currentPage = Int(roundedIndex)
            self.updatePage(page: pageControlle.currentPage)
            
        }
   }
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == self.premCollection
    {

            let x = scrollView.contentOffset.x
            var index = Int(x/premCollection.frame.width) + 1
            let total = Int(premCollection.contentSize.width/premCollection.frame.width)-1
//            self.counterLabel.text = "\(index)/\(total)"
            
            // debugPrint("image index = \(index)")
            
            if (total>1) && index > total
            {
                self.premCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
                index = 1
              //  self.counterLabel.text = "\(index)/\(total)"
                pageControlle.currentPage = index-1//Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            } else {
               // self.counterLabel.text = "\(index)/\(total)"
                
                pageControlle.currentPage = index-1//Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            }
            self.premCollection.reloadData()
        

        
        
       // self.updatePage(page: pageControlle.currentPage)
    }
   }

   func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//    if scrollView == self.premCollection
//    {
//        pageControlle.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//       // self.updatePage(page: pageControlle.currentPage)
//    }
   }
    
    func updatePage(page:Int)
    {
   
        if page == 0
        {
            type = .Hangout
            self.btnRestore.isHidden=false
            self.currentSubscriptionType = AccountVM.shared.Hangout_Subsription_Data?.name ?? kBasicFree
            
            
        }
        else if  page == 1
        {
            type = .Chat
            self.btnRestore.isHidden=false
            self.currentSubscriptionType = AccountVM.shared.Chating_Subsription_Data?.name ?? kBasicFree
        }
        else if  page == 2
        {
            type = .Story
            self.btnRestore.isHidden=false
            self.currentSubscriptionType = AccountVM.shared.Story_Subsription_Data?.name ?? kBasicFree
        }
        
        else if  page == 3
        {
            type = .Shake
            self.btnRestore.isHidden=false
            self.currentSubscriptionType = AccountVM.shared.Shake_Subsription_Data?.name ?? kBasicFree
        }
        else
        {
            type = .Hangout
            self.btnRestore.isHidden=false
        }
        
        
        if type == .Hangout
        {
            imgHeader.image = #imageLiteral(resourceName: "hangoutPre")
            lblRegret.text = kHangout

            self.transaction_id="1000000859449277"
            
            self.subscription_type=kHangout
//            self.amount=35
//            self.name=kHangout
//            self.purchase=kPlus
        }
        else if  type == .Chat{
           imgHeader.image = #imageLiteral(resourceName: "charPre")
            lblRegret.text = kChat
           // lblPremium.text = kExtraShakeMessage
            self.transaction_id="1000000859449277"
           
            self.subscription_type=kChating
//            self.amount=25
//            self.name=kChat
//
//            self.purchase=kPlus
        }
        else if  type == .Story {
            imgHeader.image = #imageLiteral(resourceName: "storyPre")
            lblRegret.text = kStories
           // lblPremium.text = kProlongChatsMessage
            
            self.transaction_id="1000000859449277"
          
            self.subscription_type=kStory
//            self.amount=35
//            self.name=kStory
//            self.purchase=kPlus
            
        }
        
        else if  type == .Shake {
            imgHeader.image = #imageLiteral(resourceName: "shakePre")
            lblRegret.text = kShake
           // lblPremium.text = kEmptyString
            
            self.transaction_id="1000000859449277"
           
            self.subscription_type=kShake
//            self.amount=35
//            self.name=kShake
//            self.purchase=kPlus
            
        }
    
       if self.currentSubscriptionType.equalsIgnoreCase(string: kBasicFree)
        {
           self.selectedIndex=0
           
        }
        else if self.currentSubscriptionType.equalsIgnoreCase(string: kPlus)
         {
            self.selectedIndex=1
         }
        else if self.currentSubscriptionType.equalsIgnoreCase(string: kGold)
         {
            self.selectedIndex=2
         }
        else if self.currentSubscriptionType.equalsIgnoreCase(string: kPlatinum)
         {
            self.selectedIndex=3
         }
        else
        {
            self.selectedIndex=1
        }
        //self.purchase = self.currentSubscriptionType
        self.premCollection.reloadData()
        
       
    }
    
    func setPrice(priceSign:String="$",amount:String,type:String="/mo") -> NSAttributedString
    {
       // let attrs1 = [NSAttributedString.Key.font : UIFont(name: AppFontName.Semibold, size: 13), NSAttributedString.Key.foregroundColor : TEXTFILEDPLACEHOLDERCOLOR]

        let attrs2 = [NSAttributedString.Key.font : UIFont(name: AppFontName.ExtraBold, size: 18), NSAttributedString.Key.foregroundColor : UIColor.black]
        let myMutableString = NSMutableAttributedString(string: amount+type, attributes: attrs2)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: TEXTFILEDPLACEHOLDERCOLOR, range: NSRange(location:0,length:1))
        myMutableString.addAttribute(NSAttributedString.Key.font, value:  UIFont(name: AppFontName.Semibold, size: 13)!, range: NSRange(location:0,length:1))
        
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value:  TEXTFILEDPLACEHOLDERCOLOR, range: NSRange(location:(amount+type).count-(type.count),length:(type.count)))
        
        myMutableString.addAttribute(NSAttributedString.Key.font, value:  UIFont(name: AppFontName.Semibold, size: 13)!, range: NSRange(location:(amount+type).count-(type.count),length:(type.count)))
        
        return myMutableString
        
    }
}


// MARK:- Extension Api Calls
extension NewPremiumVC
{
    
    
    
    func endSubscription()
    {
        self.showLoader()
        var data = JSONDictionary()
        data["subscription_end_date"] = Date().string(format: .newsimpledate, type: .local)
        data["subscription_end_time"] = Date().string(format: .longTime, type: .local)
        data[ApiKey.kTimezone] = TIMEZONE
        data[ApiKey.kSubscription_type] = "Shake_Hangout_Story_Chating"//self.subscription_type
        data[ApiKey.kSubName] = "for "+self.subscription_type
    
        debugPrint("Payment para = \(data)")
        
        if Connectivity.isConnectedToInternet {

            self.endSubscriptionApi(data: data)
        } else {
            self.hideLoader()
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
    }
    
    
    
    
    
    

    @objc func methodOfReceivedPaymentDone(notification: Notification) {
      // Take Action on Notification
        
        debugPrint(notification)
        
        if let dict = notification.userInfo as? [String:Any]
        {
            self.showLoader()
            self.transaction_id =  dict["transactionId"] as? String ?? ""

            
            var data = JSONDictionary()
            data[ApiKey.kTransaction_id] = self.transaction_id
            data[ApiKey.kAmount] = self.amount
            data[ApiKey.kSubscription_type] = "Shake_Hangout_Story_Chating" //self.subscription_type
            data[ApiKey.kSubName] = self.purchase
            
        
            if self.purchase == kPlus
           {
                data["same_hangout"] = 2
                data["hangout_days_active"] = 7
                data["number_of_interested_hangouts"] = 7
                data["picture_per_day"] = 3
                data["video_per_day"] = 1
                data["video_length"] = 5
                data["simultaneously_chat"] = 5
                data["monthly_video_call"] = 3
                data["call_max_duration"] = 60
                
                data[ApiKey.kExtra_shake] = 5
                data[ApiKey.kShake_radius] = 300
                
                self.hangout_days_active = 7
           }
           
           else if self.purchase == kGold
           {
               data["same_hangout"] = 3
               data["hangout_days_active"] = 14
               data["number_of_interested_hangouts"] = 14
               data["picture_per_day"] = 5
               data["video_per_day"] = 2
               data["video_length"] = 7
               data["simultaneously_chat"] = 7
               data["monthly_video_call"] = 5
               data["call_max_duration"] = 60
               
               data[ApiKey.kExtra_shake] = 7
               data[ApiKey.kShake_radius] = 500
               
               self.hangout_days_active =  14
           }
           else
           {
               data["same_hangout"] = 5
               data["hangout_days_active"] = kPInfinity
               data["number_of_interested_hangouts"] = kPInfinity
               data["picture_per_day"] = 7
               data["video_per_day"] = 3
               data["video_length"] = 10
               data["simultaneously_chat"] = kPInfinity
               data["monthly_video_call"] = 10
               data["call_max_duration"] = 60
               
               data[ApiKey.kExtra_shake] = 10
               data[ApiKey.kShake_radius] = 1000
               self.hangout_days_active = kPInfinity
           }
            debugPrint(data)
            
            
           /*
            
                        var data = JSONDictionary()
                        data[ApiKey.kTransaction_id] = self.transaction_id
                        data[ApiKey.kAmount] = self.amount
                        data[ApiKey.kSubscription_type] = "Shake_Hangout_Story_Chating" //self.subscription_type
                        data[ApiKey.kSubName] = self.purchase
            
             if self.subscription_type == kHangout
            {
                 data["same_hangout"] = self.same_hangout
                 data["hangout_days_active"] = self.hangout_days_active
                 data["number_of_interested_hangouts"] = self.number_of_interested_hangouts
            }
            
            else if self.subscription_type == kStory
            {
                data["picture_per_day"] = self.picture_per_day
                data["video_per_day"] = self.video_per_day
                data["video_length"] = self.video_length
            }
            else if self.subscription_type == kChating
            {
                data["simultaneously_chat"] = self.simultaneously_chat
                data["monthly_video_call"] = self.monthly_video_call
                data["call_max_duration"] = self.max_video_call
            }
        
            
            else //if self.subscription_type == kShake
            {
                data[ApiKey.kExtra_shake] = self.extra_shake2
                data[ApiKey.kShake_radius] = self.shake_radius
            }
            
           
            */
            
            debugPrint("Payment para = \(data)")
            
            if Connectivity.isConnectedToInternet {

                self.updatePaymentApi(data: data)
            } else {
                self.hideLoader()
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
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
                
                self.dismiss(animated: true) {
                 
                    self.delegate?.FromScreenName(name: self.subscription_type, ActiveDay:  self.hangout_days_active)
                  
                }

            }
            
            
        })
    }
    

    func endSubscriptionApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiEndMySubscription(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                
                self.dismiss(animated: true) {
        
                    self.delegate?.FromScreenName(name: self.subscription_type, ActiveDay:  self.hangout_days_active)
                 
                }
            
            }
            
            
        })
    }
    
    func getMySubscriptionApi()
    {
        self.showLoader()
        AccountVM.shared.callApiGetMySubscription(response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                self.updatePage(page: self.popupShowIndex)
                
            }
        })
    }
    
}
 
extension NewPremiumVC:NavigateToPaymentPopup
{
    func NavigateToPayment(name: String, transactionId: String?) {
        if name.equalsIgnoreCase(string: kHideIndicator)
        {
            self.hideLoader()
        }
    }
    
  
    
    
}
