//
//  NotificationVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class NotificationVC: BaseVC {
    
    // MARK:- Variables
    var list = ["NEW MATCHES","NEW MESSAGES","NEW LIKES"]//,"HANGOUT REQUESTS"]
    var selectedIndexPushTable:[Int] = []
    var selectedIndexEmailTable = [Int]()
    
    // MARK:- IBOutlets
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
    
    var changesMade = false
    
    
    // MARK:- Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topConst.constant = 0
        // Do any additional setup after loading the view.
        tableViewPushNotification.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        tableViewEmail.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        
        self.getNotificationSetup()
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
            lblFlazhed.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
            imageFlazhed.image = #imageLiteral(resourceName: "SelectedCheck")
            self.team_flazhed=1
            
        } else {
            lblFlazhed.textColor = UIColor.black
            imageFlazhed.image = #imageLiteral(resourceName: "unselectedCheck")
            self.team_flazhed=0
        }
        
    }
}

//MARK- extension UITableViewDelegate, UITableViewDataSource
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewPushNotification {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            
            cell.lbl.text = list[indexPath.row]
          
            if indexPath.row==0
            {
            if self.new_matches_push==1
            {
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
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
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
            }
            else{
                cell.lbl.textColor = UIColor.black
                cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
            }
            }
            else if indexPath.row==2
            {
            if self.new_like_push==1
            {
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
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
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
            }
            else{
                cell.lbl.textColor = UIColor.black
                cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
            }
            }
            
            
            if indexPath.row == self.list.count-1 {
                cell.bottomLineView.isHidden = true
            } else {
                cell.bottomLineView.isHidden = false
            }
            
            return cell
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
            cell.lbl.text = list[indexPath.row]
//            if selectedIndexEmailTable.contains(indexPath.row) {
//                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
//                cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
//            } else {
//                cell.lbl.textColor = UIColor.black
//                cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
//            }
            
            if indexPath.row==0
            {
            if self.new_matches_mail==1
            {
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
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
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
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
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
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
                cell.lbl.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
                cell.selectImage.image = #imageLiteral(resourceName: "SelectedCheck")
            }
            else{
                cell.lbl.textColor = UIColor.black
                cell.selectImage.image = #imageLiteral(resourceName: "unselectedCheck")
            }
            }
            
            
            if indexPath.row == self.list.count-1 {
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
                if self.new_like_push==0
                {
                    self.new_like_push=1
                }
                else
                {
                    self.new_like_push=0
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
    //MARK:- Get notification  details
    
    func getNotificationSetup()
    {
        
        if Connectivity.isConnectedToInternet {
            
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
                self.showErrorMessage(error: error)
            }
            else{
                self.new_message_push=AccountVM.shared.notificationSetupData?.new_message_push ?? 0
                self.new_matches_push=AccountVM.shared.notificationSetupData?.new_matches_push ?? 0
                
                self.new_like_push=AccountVM.shared.notificationSetupData?.new_like_push ?? 0
                self.new_hangout_push=AccountVM.shared.notificationSetupData?.new_hangout_push ?? 0
                
                self.new_message_mail=AccountVM.shared.notificationSetupData?.new_message_mail ?? 0
                self.new_matches_mail=AccountVM.shared.notificationSetupData?.new_matches_mail ?? 0
                
                self.new_like_mail=AccountVM.shared.notificationSetupData?.new_like_mail ?? 0
                self.new_hangout_mail=AccountVM.shared.notificationSetupData?.new_hangout_mail ?? 0
                self.team_flazhed=AccountVM.shared.notificationSetupData?.team_flazhed ?? 0
                
                if  self.team_flazhed == 1 {
                    self.lblFlazhed.textColor = #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1)
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
            
                if Connectivity.isConnectedToInternet {
    
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
                    self.showErrorMessage(error: error)
                }
                else{
    
                    self.navigationController?.popViewController(animated: true)
                }
    
    
            })
        }
    
}

