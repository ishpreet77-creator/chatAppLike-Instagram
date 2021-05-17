//
//  RegretPopUpVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class RegretPopUpVC: BaseVC {
    
    
    //MARK:- Variables
    var selectedIndex = 1
    var comeFrom2 = ""
    var list = ["The \"Ice Breaker\"","The \"Romantique\"","The \"Connoisseur\""]
    var dayPackList = ["1 extra per day","3 extra per day","5 extra per day"]
    var monthPackList = ["1 month starter pack","6 months basic pack","12 months premium pack"]
    var amountlistForRegret = ["20","35","50"]
    var amountListForExtraShake = ["10","25","50"]
    var amountListForProlongChats = ["1","4","7"]
    
    
    //MARK:- variable
    var validatePurchase:Bool!
    var comeform3:String!
    var image:UIImage?
    var purchase = String()
    
    var listIcons = [#imageLiteral(resourceName: "IceBreaker"),#imageLiteral(resourceName: "HeartArrow"),#imageLiteral(resourceName: "StarIcon")]
    
    var paymentType = "Monthly"
    var subscription_id = "601bd7697e02cb0f3ce6b087"

    
    //MARK:-  IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblRegret: UILabel!
    @IBOutlet weak var lblPremium: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK:- Class Life Cycle
    var type : PaymentScreenType = .kExtraShakes
    
    
    
    var transaction_id=""
    var amount=0
    var subscription_type=""
    var name=""
    var extra_shake=0
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPHandler.shared.getProducts()
        
        self.purchase = "yearly"
    
        IAPHandler.shared.validatePurchase { (status) in
            
            if status
            {
              print(status)
            }
        }
        
        
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
    }
    override func viewDidLayoutSubviews() {
           
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -headerView.bounds.height, right: 0)
    }
    
    //MARK:- Select premium action
    
    
    //
    @objc func btnAction(sender:UIButton)
    {
        selectedIndex = sender.tag
        
        if selectedIndex == 3
        {
            self.purchase=kYearly
            
        }
        else if selectedIndex == 2
        {
            self.purchase=kSixMonthly
            
        }
        else
        {
            self.purchase=kMonthly
        }
        tableView.reloadData()
      
       
    
    }
    //MARK:-IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }

    @IBAction func restoreBtnAction(_ sender: UIButton) {
        IAPHandler.shared.restoreProducts()
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK- extension UITableViewDelegate, UITableViewDataSource
extension RegretPopUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
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
        
        if type == .Regret {
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = monthPackList[indexPath.row]
            cell.lblAmount.text = amountlistForRegret[indexPath.row]
        } else if  type == .kExtraShakes{
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = dayPackList[indexPath.row]
            cell.lblAmount.text = amountListForExtraShake[indexPath.row]
        } else if  type == .Prolong {
            cell.lblIcebreaker.text = list[indexPath.row]
            cell.lblPack.text = monthPackList[indexPath.row]
            cell.lblAmount.text = amountListForProlongChats[indexPath.row]
        }
        
        if selectedIndex == indexPath.row {
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
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
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
    //MARK:- Buy button action  🍎
    
    @objc func premiumBtnAction(sender:UIButton) {

        print("come from = \(type)")
        
        
        
        if type == .Regret
        {
            if self.purchase == kYearly {
                Indicator.sharedInstance.showIndicator()
                IAPHandler.shared.purchase(product: .swipeYearly)
                
            }else if self.purchase == kSixMonthly {
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
                IAPHandler.shared.purchase(product: .shakeOne)
                
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
            if self.purchase == kYearly {
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

// MARK:- Extension Api Calls
extension RegretPopUpVC
{

    @objc func methodOfReceivedPaymentDone(notification: Notification) {
      // Take Action on Notification
        
        print(notification)
        
//        if let dict = notification as? [String:String]
//        {
//            self.transaction_id =  dict["transactionId"] as? String ?? ""
//        }
        
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
             
                let storyBoard = UIStoryboard(name: kAccount, bundle: nil)
        
                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsVC
                vc.comeFromVerify=true
                self.navigationController?.pushViewController(vc, animated: false)

            }
            
            
        })
    }
}

enum PaymentScreenType: String{
    
    case Regret = "Regret"
    case kExtraShakes = "Extra Shakes"
    case Prolong = "Prolong"
}

