//
//  RegretPopUpVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit
import SkeletonView

class RegretPopUpVC: BaseVC {
    
    
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
    var view_user_id = ""
    
    //MARK: -  IBOutlets
    @IBOutlet weak var viewBackTable: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblRegret: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK: - Class Life Cycle
    var type : PaymentScreenType = .kExtraShakes
    var comeFromScreen: ScreenType = .storiesScreen
    
    
    var transaction_id=""
    var amount=0
    var subscription_type=""
    var name=""
    var extra_shake=0
  
    var apiCalled=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IAPHandler.shared.prolongPriceArray.count==0
        {
            IAPHandler.shared.getProducts()
        }
        

       // NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedPaymentDone(notification:)), name: Notification.Name("PaymentDoneNoti"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedPaymentDone(notification:)), name: Notification.Name("PaymentDoneNoti"), object: nil)
        
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
      
      
        
        
//        IAPHandler.shared.validatePurchase { (status) in
//            debugPrint("Payment buy status = \(status)")
//            if status
//            {
//
//            }
//        }
        
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
        
        
        
        if type == .Regret
        {
            self.transaction_id="1000000859449277"
            self.amount=35
            self.subscription_type=kSwiping
            self.name="Regret"
            self.purchase=kSixMonthly
        }
        else if  type == .kExtraShakes{
            self.transaction_id="1000000859449277"
            self.amount=25
            self.subscription_type=kShake
            self.name="Shake"
            self.extra_shake=3
            self.purchase=kSixMonthly
        } else if  type == .Prolong {
            self.transaction_id="1000000859449277"
            self.amount=35
            self.subscription_type=kProlong
            self.name="Prolong"
            self.purchase=kSixMonthly
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
            NotificationCenter.default.removeObserver(self, name: Notification.Name("PaymentDoneNoti"), object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if IAPHandler.shared.prolongPriceArray.count==0
        {
            IAPHandler.shared.getProducts()
        }
     
    }
    override func viewDidLayoutSubviews() {
           
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -headerView.bounds.height, right: 0)
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
        tableView.reloadData()
      
       
    
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
        if Connectivity.isConnectedToInternet {
            IAPHandler.shared.restoreProducts()
         } else {
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
 
    }
    
    
}


//MARK- extension UITableViewDelegate, UITableViewDataSource
extension RegretPopUpVC: UITableViewDelegate, UITableViewDataSource{ //,SkeletonTableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "GoPremiumCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "GoPremiumCell", for: indexPath) as! GoPremiumCell
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoPremiumCell", for: indexPath) as! GoPremiumCell
        
        cell.iceBreakerImage.image = listIcons[indexPath.row]
        if type == .Regret && indexPath.row == 2 {
            cell.discountView.isHidden = false
            cell.lblDiscount.text = "SAVE 25%"
        } else if type == .kExtraShakes && indexPath.row == 1 {
            cell.discountView.isHidden = false
            cell.lblDiscount.text = "SAVE $5"
        } else if type == .Prolong && indexPath.row == 1 {
            cell.discountView.isHidden = false
            cell.lblDiscount.text = "SAVE 20%"
        } else {
            cell.discountView.isHidden = true
        }
//        if indexPath.row == 1 {
//            cell.discountView.isHidden = false
//        } else {
//            cell.discountView.isHidden = true
//        }
        
        
        debugPrint(IAPHandler.shared.prolongPriceArray)
        
        
        
        if type == .Regret {
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = monthPackList[indexPath.row]
           
            cell.lblAmount.text = "\(amountlistForRegret[indexPath.row])"
            
            
        } else if  type == .kExtraShakes{
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = dayPackList[indexPath.row]
            cell.lblAmount.text = "\(amountListForExtraShake[indexPath.row])"
        } else if  type == .Prolong {
      
            if IAPHandler.shared.prolongPriceArray.count>indexPath.row
            {
            
            if indexPath.row == 0
            {
                for model in IAPHandler.shared.prolongPriceArray
                {
                    let typeAmount = model.type ?? kEmptyString
                   if productIDs.kChat.rawValue.equalsIgnoreCase(string: typeAmount)
                    {
                       let price = model.price ?? kEmptyString
                       cell.lblAmount.text = price
                    }
                }
            }
            else if indexPath.row == 1
            {
                for model in IAPHandler.shared.prolongPriceArray
                {
                    let typeAmount = model.type ?? kEmptyString
                   if productIDs.kChat.rawValue.equalsIgnoreCase(string: typeAmount)
                    {
                       let price = model.price ?? kEmptyString
                       cell.lblAmount.text = price
                    }
                }
            }
            else
            {
                for model in IAPHandler.shared.prolongPriceArray
                {
                    let typeAmount = model.type ?? kEmptyString
                   if productIDs.kChat.rawValue.equalsIgnoreCase(string: typeAmount)
                    {
                       let price = model.price ?? kEmptyString
                       cell.lblAmount.text = price
                    }
                }
            }
            }
            else
            {
                cell.lblAmount.text = "$ \(amountListForProlongChats[indexPath.row])"
            }
            
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = monthPackList[indexPath.row]
                
           ///
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
        return 94
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 196
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    //MARK: - Buy button action  
    
    @objc func premiumBtnAction(sender:UIButton) {
        /*
        
        if Connectivity.isConnectedToInternet {
            
        
            if IAPHandler.shared.prolongPriceArray.count==0
            {
                IAPHandler.shared.getProducts()
            }
            
        debugPrint("come from = \(type)")
        
        
        
        if type == .Regret
        {
            self.showLoader()
            
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
            self.showLoader()
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
            self.showLoader()
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
            IAPHandler.shared.delegate=self
         } else {
             self.hideLoader()
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        */
    
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
   
    
    
    func showLoader()
    {
        
        Indicator.sharedInstance.showIndicator2()
//        self.viewBackTable.clipsToBounds=true
//        self.viewBackTable.isSkeletonable=true
//
//        self.viewBackTable.showAnimatedGradientSkeleton()
//       // self.tableView.showAnimatedGradientSkeleton()
//
        
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator2()
       // self.viewBackTable.hideSkeleton()

    }
    
    
    
    
}

// MARK:- Extension Api Calls
extension RegretPopUpVC
{

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
                if self.apiCalled == false
                {
                    self.updatePaymentApi(data: data)
                    self.apiCalled=true
                }
                self.hideLoader()
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
                        self.goToProfile()
                    }
                }
               else if self.type == .Regret
                {
                    self.dismiss(animated: true)
                    {
                        DataManager.HomeRefresh=true
                        //DataManager.purchasePlan=true
                        
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
    
                let vc = AccountsVC.instantiate(fromAppStoryboard: .Account)
                vc.comeFromVerify=true
                self.navigationController?.pushViewController(vc, animated: false)
                }

            }
            
            
        })
    }
}

extension RegretPopUpVC:NavigateToPaymentPopup
{
    func NavigateToPayment(name: String, transactionId: String?) {
        if name.equalsIgnoreCase(string: kHideIndicator)
        {
            self.hideLoader()
        }
        
    }

    
}

enum PaymentScreenType: String{
    
    case Regret = "Regret"
    case kExtraShakes = "Extra Shakes"
    case Prolong = "Prolong"
    case Hangout = "Hangout"
    case Story = "Story"
    case Chat = "Chat"
    case Shake = "Shake"
    case General = "General"
}

