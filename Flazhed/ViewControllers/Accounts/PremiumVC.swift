
//
//  RegretPopUpVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class PremiumVC: BaseVC {
    
    
    //MARK: - Variables
    var selectedIndex = 1
    var comeFrom2 = ""
    var list = ["The \"Ice Breaker\"","The \"Romantique\"","The \"Connoisseur\""]
    var dayPackList = ["1 extra per day","3 extra per day","5 extra per day"]
    var monthPackList = ["1 month starter pack","6 months basic pack","12 months premium pack"]
    var amountlistForRegret = [20,35,50]
    var NoListForExtraShake = [1,3,5]
    var amountListForExtraShake = [10,25,50]
    var amountListForProlongChats = [1,4,7]
    
    
    //MARK: - variable
    var validatePurchase:Bool!
    var comeform3:String!
    var image:UIImage?
    var purchase = String()
    
    var listIcons = [#imageLiteral(resourceName: "IceBreaker"),#imageLiteral(resourceName: "HeartArrow"),#imageLiteral(resourceName: "StarIcon")]
    
    var paymentType = "Monthly"
    var subscription_id = "601bd7697e02cb0f3ce6b087"

    
    //MARK: -  IBOutlets
    @IBOutlet weak var pageControlle: UIPageControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblRegret: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var premCollection: UICollectionView!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK: - Class Life Cycle
    var type : PaymentScreenType = .kExtraShakes
    
    
    
    var transaction_id="1000000859449277"
    var amount=25
    var subscription_type=kShake
    var name="Shake"
    var extra_shake=3
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPHandler.shared.getProducts()
 
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedPaymentDone(notification:)), name: Notification.Name("PaymentPremiumNoti"), object: nil)
        
        
        
        imgHeader.image = #imageLiteral(resourceName: "ExtraShake")
        lblRegret.text = "Extra Shakes"
        lblPremium.text = "Don't bother about shake limits anymore."
        type = .kExtraShakes
        self.btnRestore.isHidden=true
        self.setupCollection()

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
        
        self.purchase = kSixMonthly
        self.pageControlle.numberOfPages=5
        
//        IAPHandler.shared.validatePurchase { (status,productId) in
//            debugPrint("Payment buy status = \(status) \(productId)")
//            if status
//            {
//
//            }
//        }
        /*
        
        self.purchase = kSixMonthly
        tableView.tableHeaderView = headerView
        tableView.roundCorners(corners: [.topLeft,.topRight], radius: 32)
        tableView.register(UINib(nibName: "FootView", bundle: nil), forCellReuseIdentifier: "FootView")
        tableView.register(UINib(nibName: "GoPremiumCell", bundle: nil), forCellReuseIdentifier: "GoPremiumCell")
       
        
        if type == .Regret
        {
            imgHeader.image = #imageLiteral(resourceName: "yellow")
            lblRegret.text = "Regret Swiping Right?"
            lblPremium.text = "Get Premium and never regret swiping."
        }
        else if  type == .kExtraShakes{
            imgHeader.image = #imageLiteral(resourceName: "ExtraShake")
            lblRegret.text = "Extra Shakes"
            lblPremium.text = "Don't bother about shake limits anymore."
        } else if  type == .Prolong {
            imgHeader.image = #imageLiteral(resourceName: "Prolong")
            lblRegret.text = "Prolong Chats"
            lblPremium.text = "Get more time to know more about the\n other person."
        }
        
        */
    }
    override func viewDidDisappear(_ animated: Bool) {
        
            NotificationCenter.default.removeObserver(self, name: Notification.Name("PaymentDoneNoti"), object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IAPHandler.shared.getProducts()
    }
    override func viewDidLayoutSubviews() {
           
        super.viewDidLayoutSubviews()
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -headerView.bounds.height, right: 0)
    }
    
    //MARK: - Select premium action
    
    
    //
    @objc func btnAction(sender:UIButton)
    {
        selectedIndex = sender.tag
        
        if type == .Regret
        {
            
            self.amount = amountlistForRegret[selectedIndex]
            self.subscription_type = kSwiping
        }
        else if  type == .kExtraShakes
        {
            self.amount = amountListForExtraShake[selectedIndex]
            self.subscription_type = kShake
            self.extra_shake = NoListForExtraShake[selectedIndex]
            
        } else if  type == .Prolong {
            self.subscription_type = kProlong
            self.amount = amountListForProlongChats[selectedIndex]
    
        }
        
        
        
        if selectedIndex == 2
        {
            self.purchase=kYearly
            
        }
        else if selectedIndex == 1
        {
            self.purchase=kSixMonthly
            
        }
        else
        {
            self.purchase=kMonthly
        }
        self.premCollection.reloadData()
      
       
    
    }
    //MARK: -IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }

    @IBAction func restoreBtnAction(_ sender: UIButton) {
        debugPrint("restore purchase")
        if Connectivity.isConnectedToInternet {
            IAPHandler.shared.restoreProducts()
         } else {
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }

//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - Buy button action
    
    @IBAction func premiumBtnAction(sender:UIButton) {
        /*
        if Connectivity.isConnectedToInternet {
                    
        IAPHandler.shared.getProducts()
        debugPrint("come from = \(type) \(self.purchase)")
        
        
        
        if type == .Regret
        {
            if self.purchase == kYearly
            {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeYearly,fromScreen: kPremium)
                
            }else if self.purchase == kSixMonthly
            {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeHalfYear,fromScreen: kPremium)
            }else{
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeMonthly,fromScreen: kPremium)
            }
        }
        else if  type == .kExtraShakes
        {
            if self.purchase == kYearly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .shakeFive,fromScreen: kPremium)
                
            }else if self.purchase == kSixMonthly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .shakeThree,fromScreen: kPremium)
            }
            else{
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .shakeOne,fromScreen: kPremium)
            }
            
            
        }
        else if  type == .Prolong {
            if self.purchase == kYearly
            {
                Indicator.sharedInstance.showIndicator()
              //  IAPHandler.shared.delegate=self
                IAPHandler.shared.purchase(product: .prolongYearly,fromScreen: kPremium)
                
            }else if self.purchase == kSixMonthly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .ProlongHalfyearly,fromScreen: kPremium)
            }else{
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .prolongMonthly,fromScreen: kPremium)
            }
        }
    
        } else {

           self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
       }
        */
    }
    @IBAction func noThanksBtnAction(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
}
extension PremiumVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
            self.premCollection.delegate=self
            self.premCollection.dataSource=self
            self.premCollection.register(UINib(nibName: "PremiumCCell", bundle: nil), forCellWithReuseIdentifier: "PremiumCCell")
        self.premCollection.register(UINib(nibName: "NewPremiumCCell", bundle: nil), forCellWithReuseIdentifier: "NewPremiumCCell")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return  5
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
    
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
        cell.btn1.tag = 0
        cell.btn1.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        cell.btn2.tag = 1
        cell.btn2.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        cell.btn3.tag = 2
        cell.btn3.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
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
        pageControlle.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
       // self.updatePage(page: pageControlle.currentPage)
    }
   }

   func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    if scrollView == self.premCollection
    {
        pageControlle.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
       // self.updatePage(page: pageControlle.currentPage)
    }
   }
    
    func updatePage(page:Int)
    {
        if page == 0
        {
            type = .kExtraShakes
            self.btnRestore.isHidden=true
        }
        else if  page == 1
        {
            type = .Regret
            self.btnRestore.isHidden=false
        }
        else if  page == 2
        {
            type = .Prolong
            self.btnRestore.isHidden=false
        }
        
        else if  page == 3
        {
            type = .Hangout
            self.btnRestore.isHidden=false
        }
        else
        {
            type = .Story
            self.btnRestore.isHidden=false
        }
        
        
        if type == .Regret
        {
            imgHeader.image = #imageLiteral(resourceName: "yellow")
            lblRegret.text = kRegretSwipe
            lblPremium.text = kRegretSwipeMessage
            
            
            self.transaction_id="1000000859449277"
            self.amount=35
            self.subscription_type=kSwiping
            self.name="Regret"
            self.purchase=kSixMonthly
        }
        else if  type == .kExtraShakes{
            imgHeader.image = #imageLiteral(resourceName: "ExtraShake")
            lblRegret.text = kExtraShake
            lblPremium.text = kExtraShakeMessage
            self.transaction_id="1000000859449277"
            self.amount=25
            self.subscription_type=kShake
            self.name="Shake"
            self.extra_shake=3
            self.purchase=kSixMonthly
        }
        else if  type == .Prolong {
            imgHeader.image = #imageLiteral(resourceName: "Prolong")
            lblRegret.text = kProlongChats
            lblPremium.text = kProlongChatsMessage
            
            self.transaction_id="1000000859449277"
            self.amount=35
            self.subscription_type=kProlong
            self.name="Prolong"
            self.purchase=kSixMonthly
            
        }
        
        else if  type == .Hangout {
            imgHeader.image = #imageLiteral(resourceName: "Prolong")
            lblRegret.text = kHangout
            lblPremium.text = kEmptyString
            
            self.transaction_id="1000000859449277"
            self.amount=35
            self.subscription_type=kHangout
            self.name="Prolong"
            self.purchase=kSixMonthly
            
        }
        
        else if  type == .Story {
            imgHeader.image = #imageLiteral(resourceName: "Prolong")
            lblRegret.text = kStory
            lblPremium.text = kEmptyString
            
            self.transaction_id="1000000859449277"
            self.amount=35
            self.subscription_type=kStory
            self.name="Prolong"
            self.purchase=kSixMonthly
            
        }
        
        
        self.premCollection.reloadData()
    }
}


/*

//MARK- extension UITableViewDelegate, UITableViewDataSource
extension PremiumVC: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable()
    {
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.tableView.register(UINib(nibName: "PremiumTCell", bundle: nil), forCellReuseIdentifier: "PremiumTCell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumTCell", for: indexPath) as! PremiumTCell//GoPremiumCell
        
//        cell.iceBreakerImage.image = listIcons[indexPath.row]
//        if type == .Regret && indexPath.row == 2 {
//            cell.discountView.isHidden = false
//            cell.lblDiscount.text = "SAVE 25%"
//        } else if type == .kExtraShakes && indexPath.row == 1 {
//            cell.discountView.isHidden = false
//            cell.lblDiscount.text = "SAVE $5"
//        } else if type == .Prolong && indexPath.row == 1 {
//            cell.discountView.isHidden = false
//            cell.lblDiscount.text = "SAVE 20%"
//        } else {
//            cell.discountView.isHidden = true
//        }
//        if indexPath.row == 1 {
//            cell.discountView.isHidden = false
//        } else {
//            cell.discountView.isHidden = true
//        }
        /*
        if type == .Regret {
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = monthPackList[indexPath.row]
            cell.lblAmount.text = "\(amountlistForRegret[indexPath.row])"
        } else if  type == .kExtraShakes{
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = dayPackList[indexPath.row]
            cell.lblAmount.text = "\(amountListForExtraShake[indexPath.row])"
        } else if  type == .Prolong {
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = monthPackList[indexPath.row]
            cell.lblAmount.text = "\(amountListForProlongChats[indexPath.row])"
        }
        
        if selectedIndex == indexPath.row
        {
            cell.cellBG.backgroundColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblIcebreaker.textColor = .white
            cell.lblPack.textColor = .white
            cell.lblDollar.textColor = .white
            cell.lblAmount.textColor = .white
        } else {
            cell.lblIcebreaker.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblPack.textColor = #colorLiteral(red: 0.6901960784, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
            cell.cellBG.backgroundColor = .white
            cell.lblDollar.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            cell.lblAmount.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
        }
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        */
        return cell
       
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        221
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableCell(withIdentifier: "FootView") as! FootView
        footerView.btnPremium.addTarget(self, action: #selector(premiumBtnAction), for: .touchUpInside)
        footerView.btnNoThanks.addTarget(self, action: #selector(noThanksBtnAction), for: .touchUpInside)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280//94
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 196
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    //MARK: - Buy button action
    
    @objc func premiumBtnAction(sender:UIButton) {

        debugPrint("come from = \(type)")
        
        
        
        if type == .Regret
        {
            if self.purchase == kYearly
            {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeYearly)
                
            }else if self.purchase == kSixMonthly
            {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeHalfYear)
            }else{
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeMonthly)
            }
        }
        else if  type == .kExtraShakes
        {
            if self.purchase == kYearly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .shakeFive)
                
            }else if self.purchase == kSixMonthly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .shakeThree)
            }
            else{
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .shakeOne)
            }
            
            
        }
        else if  type == .Prolong {
            if self.purchase == kYearly
            {
                Indicator.sharedInstance.showIndicator()
              //  IAPHandler.shared.delegate=self
                IAPHandler.shared.purchase(product: .prolongYearly)
                
            }else if self.purchase == kSixMonthly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .ProlongHalfyearly)
            }else{
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .prolongMonthly)
            }
        }
        
        
    
    }
    @objc func noThanksBtnAction(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    // MARK:- Private Functions
    private func validateData () -> String?
    {
        if paymentType.isEmpty  {
            return kEmptyOTPAlert
        }
        
        return nil
    }
   
    
}

*/

// MARK:- Extension Api Calls
extension PremiumVC
{

    @objc func methodOfReceivedPaymentDone(notification: Notification) {
      // Take Action on Notification
        
        debugPrint(notification)
        
        if let dict = notification.userInfo as? [String:Any]
        {
            self.transaction_id =  dict["transactionId"] as? String ?? ""
            
            var data = JSONDictionary()
            data[ApiKey.kTransaction_id] = self.transaction_id
            data[ApiKey.kAmount] = self.amount
            data[ApiKey.kSubscription_type] = self.subscription_type
            
            data[ApiKey.kSubName] = "for "+self.subscription_type
           
            
            if self.subscription_type == kShake
            {
                data[ApiKey.kExtra_shake] = self.extra_shake
            }
            else
            {
                if self.purchase == kYearly
                {
                    data[ApiKey.kMonth_up_to] = 12
                    
                }else if self.purchase == kSixMonthly
                {
                    data[ApiKey.kMonth_up_to] = 6
                }else{
                    data[ApiKey.kMonth_up_to] = 1
                }
                
            }
            
            debugPrint("Payment para = \(data)")
            
            if Connectivity.isConnectedToInternet {

                self.updatePaymentApi(data: data)
            } else {

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
                self.showErrorMessage(error: error)
            }
            else{
                self.dismiss(animated: true, completion: nil)
             
                /*
                
                if self.type == .Prolong
                {
                    self.dismiss(animated: true)
                    {
                        if #available(iOS 13.0, *)
                        {
                            SCENEDEL?.navigateToChat()
                        } else {
                            // Fallback on earlier versions
                            APPDEL.navigateToChat()
                    }
                    }
                }
               else if self.type == .kExtraShakes
                {
                    self.dismiss(animated: true)
                    {
                        if #available(iOS 13.0, *)
                        {
                            SCENEDEL?.navigateToProfile()
                        } else {
                            // Fallback on earlier versions
                            APPDEL.navigateToProfile()
                    }
                    }
                }
               else if self.type == .Regret
                {
                    self.dismiss(animated: true)
                    {
                        if #available(iOS 13.0, *)
                        {
                            SCENEDEL?.navigateToHome()
                        } else {
                            // Fallback on earlier versions
                            APPDEL.navigateToHome()
                    }
                    }
                }
                else
                {
                
                let storyBoard = UIStoryboard(name: kAccount, bundle: nil)
        
                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsVC
                vc.comeFromVerify=true
                self.navigationController?.pushViewController(vc, animated: false)
                }
                
                */

            }
            
            
        })
    }
}

