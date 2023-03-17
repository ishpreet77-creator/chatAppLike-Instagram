//
//  NotificationVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class NotificationVC: BaseVC {
    
    // MARK: - Variables
    var email = ["NEW MATCHES","NEW MESSAGES","NEW LIKES"]//,"HANGOUT REQUESTS"]
    var notification = [kNEWMATCHES,kNEWMESSAGESL,kNewShakes]
    
    var selectedIndexPushTable:[Int] = []
    var selectedIndexEmailTable = [Int]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewPromotion: UIView!
    @IBOutlet weak var lblPromotion: UILabel!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewPush: UIView!
    @IBOutlet weak var lblPush: UILabel!
    @IBOutlet weak var lblFlazhed: UILabel!
    @IBOutlet weak var imageFlazhed: UIImageView!
    @IBOutlet weak var tableViewPushNotification: UITableView!
    @IBOutlet weak var tableViewEmail: UITableView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    
    var new_message_push = 0
    var new_matches_push = 0
    var new_like_push = 0
    var new_hangout_push = 0
    
    var new_message_mail = 0
    var new_matches_mail = 0
    var new_like_mail = 0
    var new_hangout_mail = 0
    var team_flazhed = 0
    var new_shake_push = 0
    var changesMade = false
    
    
    // MARK:- Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topConst.constant = 0
        // Do any additional setup after loading the view.
        tableViewPushNotification.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        tableViewEmail.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        self.getNotificationSetup()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK: - Hide for CF
        
        self.viewPromotion.isHidden=true
        self.viewEmail.isHidden=true
        self.lblEmail.isHidden=true
        self.lblPromotion.isHidden=true
    }
    func setUpUI()
    {
        self.lblTitle.text = kNOTIFICATIONS.capitalized
        self.lblPush.text = kPUSHNOTIFICATIONS
        self.lblPush.textColor = PURPLECOLOR
        
       
        
        
    }
    
    // MARK:- IBActions
    @IBAction func backButtonAction(_ sender: UIButton)
    {
        DataManager.comeFrom = kViewProfile
        
        if changesMade
        {
            self.updateNotificationSetting()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
    
    @IBAction func flazhedBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            lblFlazhed.textColor = PURPLECOLOR
            imageFlazhed.image = #imageLiteral(resourceName: "SelectedCheck")
            self.team_flazhed=1
            
        } else {
            lblFlazhed.textColor = UIColor.black
            imageFlazhed.image = #imageLiteral(resourceName: "unselectedCheck")
            self.team_flazhed=0
        }
        
    }
    
    func showLoader()
    {
        
        Indicator.sharedInstance.showIndicator3(views: [self.tableViewEmail,self.tableViewPushNotification,self.viewPromotion])
        
    }
    func hideLoader()
    {
        
        Indicator.sharedInstance.hideIndicator3(views: [self.tableViewEmail,self.tableViewPushNotification,self.viewPromotion])
        
    }
}

//MARK: - extension UITableViewDelegate, UITableViewDataSource
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  tableView == tableViewPushNotification {
            return self.notification.count
        }
        return self.email.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewPushNotification {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            
            //kNEWMATCHES,kNEWMESSAGESL,kNewShakes
            cell.lbl.text = notification[indexPath.row].uppercased()
            
            if indexPath.row==0
            {
                if self.new_matches_push==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            else if indexPath.row==1
            {
                if self.new_message_push==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            else if indexPath.row==2
            {
                if self.new_shake_push==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            else if indexPath.row==3
            {
                if self.new_hangout_push==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            
            
            if indexPath.row == self.notification.count-1 {
                cell.bottomLineView.isHidden = true
            } else {
                cell.bottomLineView.isHidden = false
            }
            
            return cell
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            cell.lbl.text = email[indexPath.row]
            
            if indexPath.row==0
            {
                if self.new_matches_mail==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            else if indexPath.row==1
            {
                if self.new_message_mail==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            else if indexPath.row==2
            {
                if self.new_like_mail==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            else if indexPath.row==3
            {
                if self.new_hangout_mail==1
                {
                    cell.lbl.textColor = PURPLECOLOR
                    cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
                }
                else{
                    cell.lbl.textColor = UIColor.black
                    cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
                }
            }
            
            
            if indexPath.row == self.email.count-1 {
                cell.bottomLineView.isHidden = true
            } else {
                cell.bottomLineView.isHidden = false
            }
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.changesMade = true
        if tableView == tableViewPushNotification
        {
            
            if indexPath.row==0
            {
                if self.new_matches_push==0
                {
                    self.new_matches_push=1
                }
                else
                {
                    self.new_matches_push=0
                }
            }
            else if indexPath.row==1
            {
                if self.new_message_push==0
                {
                    self.new_message_push=1
                }
                else
                {
                    self.new_message_push=0
                }
            }
            else if indexPath.row==2
            {
                if self.new_shake_push==0
                {
                    self.new_shake_push=1
                }
                else
                {
                    self.new_shake_push=0
                }
            }
            else if indexPath.row==3
            {
                if self.new_hangout_push==0
                {
                    self.new_hangout_push=1
                }
                else
                {
                    self.new_hangout_push=0
                }
            }
            
            tableViewPushNotification.reloadData()
        }
        else if tableView == tableViewEmail {
            //            if !selectedIndexEmailTable.contains(indexPath.row) {
            //                selectedIndexEmailTable.append(indexPath.row)
            //            }else if let index = selectedIndexEmailTable.firstIndex(of: indexPath.row) {
            //                selectedIndexEmailTable.remove(at: index)
            //            }
            
            
            if indexPath.row==0
            {
                if self.new_matches_mail==0
                {
                    self.new_matches_mail=1
                }
                else
                {
                    self.new_matches_mail=0
                }
            }
            else if indexPath.row==1
            {
                if self.new_message_mail==0
                {
                    self.new_message_mail=1
                }
                else
                {
                    self.new_message_mail=0
                }
            }
            
            else if indexPath.row==2
            {
                if self.new_like_mail==0
                {
                    self.new_like_mail=1
                }
                else
                {
                    self.new_like_mail=0
                }
            }
            else if indexPath.row==3
            {
                if self.new_hangout_mail==0
                {
                    self.new_hangout_mail=1
                }
                else
                {
                    self.new_hangout_mail=0
                }
            }
            
            tableViewEmail.reloadData()
        }
    }
    
}
extension NotificationVC
{
    //MARK: - Get notification  details
    
    func getNotificationSetup()
    {
        
        if Connectivity.isConnectedToInternet {
            self.showLoader()
            self.getNotificationSetupApi()
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    func getNotificationSetupApi()
    {
        AccountVM.shared.callApiGetNotificationSetup(response: { (message, error) in
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                self.new_message_push=AccountVM.shared.notificationSetupData?.new_message_push ?? 0
                self.new_matches_push=AccountVM.shared.notificationSetupData?.new_matches_push ?? 0
                
                self.new_like_push=AccountVM.shared.notificationSetupData?.new_like_push ?? 0
                self.new_shake_push=AccountVM.shared.notificationSetupData?.new_shake_push ?? 0
                self.new_hangout_push=AccountVM.shared.notificationSetupData?.new_hangout_push ?? 0
                
                self.new_message_mail=AccountVM.shared.notificationSetupData?.new_message_mail ?? 0
                self.new_matches_mail=AccountVM.shared.notificationSetupData?.new_matches_mail ?? 0
                
                self.new_like_mail=AccountVM.shared.notificationSetupData?.new_like_mail ?? 0
                self.new_hangout_mail=AccountVM.shared.notificationSetupData?.new_hangout_mail ?? 0
                self.team_flazhed=AccountVM.shared.notificationSetupData?.team_flazhed ?? 0
                
                if  self.team_flazhed == 1 {
                    self.lblFlazhed.textColor = PURPLECOLOR
                    self.imageFlazhed.image = #imageLiteral(resourceName: "SelectedCheck")
                    self.team_flazhed=1
                    
                } else {
                    self.lblFlazhed.textColor = UIColor.black
                    self.imageFlazhed.image = #imageLiteral(resourceName: "unselectedCheck")
                    self.team_flazhed=0
                }
                self.tableViewEmail.reloadData()
                self.tableViewPushNotification.reloadData()
                
            }
        })
    }
    
    func updateNotificationSetting()
    {
        
        var data = JSONDictionary()
        
        data[ApiKey.knew_message_push] = self.new_message_push
        data[ApiKey.knew_matches_push] = self.new_matches_push
        data[ApiKey.knew_like_push] = self.new_like_push
        data[ApiKey.knew_hangout_push] = self.new_hangout_push
        
        data[ApiKey.knew_message_mail] = self.new_message_mail
        data[ApiKey.knew_matches_mail] = self.new_matches_mail
        data[ApiKey.knew_like_mail] = self.new_like_mail
        data[ApiKey.knew_hangout_mail] = self.new_hangout_mail
        data[ApiKey.kteam_flazhed] = self.team_flazhed
        data[ApiKey.knew_shake_push] = self.new_shake_push
        if Connectivity.isConnectedToInternet
        {
            self.showLoader()
            self.updateNotificationSettingApi(data: data)
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
        
    }
    
    
    func updateNotificationSettingApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdateNotificationSetup(data: data, response: { (message, error) in
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                self.navigationController?.popViewController(animated: true)
            }
            
            
        })
    }
    
}

