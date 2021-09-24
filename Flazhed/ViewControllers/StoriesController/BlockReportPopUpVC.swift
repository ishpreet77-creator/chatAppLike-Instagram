//
//  BlockReportPopUpVC.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit

protocol BlockReportPopUpDelegate{
    func ClickNameAction(name:String)
}


class BlockReportPopUpVC: BaseVC {
    
    var delegate:BlockReportPopUpDelegate?

    @IBOutlet weak var tableReport: UITableView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var type: ScreenType = .storiesScreen
var titleArray = ["BLOCK ONLY","INAPPROPRIATE CONTENT","PERSON IS MINOR","BAD OFFLINE BEHAVIOR","FEELS LIKE SPAM","OTHER"]
    var comeFrom = ""
    var fromBlock = false
    var blockReason = ""
    var postID = ""
    var UserID = ""
    var user_name = ""
    var from_user_id = ""
    var fromFeedback = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
     
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
    
    @IBAction func reportAct(_ sender: UIButton){
        delegate?.ClickNameAction(name: kReportPost)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewProfileAct(_ sender: UIButton){
        delegate?.ClickNameAction(name: kViewProfile)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func otherButtonAction(_ sender: UIButton) {
//        self.dismiss(animated: true) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "SendFeedbackAlertVC") as!  SendFeedbackAlertVC
              destVC.type = type
            destVC.user_name=self.user_name
        destVC.UserID=self.UserID
        destVC.type = self.type
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(destVC, animated: true, completion: nil)
//        }
        
       
    }
}
extension BlockReportPopUpVC:UITableViewDelegate,UITableViewDataSource
{
   
    
    func setUpTable()
    {
        self.tableReport.register(UINib(nibName: "BloackResonTCell", bundle: nil), forCellReuseIdentifier: "BloackResonTCell")
        
        self.tableReport.register(UINib(nibName: "ReportHeaderTCell", bundle: nil), forCellReuseIdentifier: "ReportHeaderTCell")
        self.tableReport.rowHeight = 100
        self.tableReport.estimatedRowHeight = UITableView.automaticDimension
        self.tableReport.allowsSelection=true
        self.tableReport.delegate = self
        self.tableReport.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BloackResonTCell") as! BloackResonTCell
        cell.lblReason.text = self.titleArray[indexPath.row]
        if indexPath.row == 0
        {
            cell.imgLine.isHidden=false
            cell.lblReason.textColor = LINECOLOR
        }
        else
        {
            cell.imgLine.isHidden=true
            cell.lblReason.textColor = UIColor.black
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportHeaderTCell") as! ReportHeaderTCell
        cell.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.blockReason = self.titleArray[indexPath.row]
        
        if indexPath.row == 0
        {
            self.fromBlock = true
         
            if type == .messageScreen
            {
                self.call_User_Report_Block_Api(reason: self.blockReason)
            }
            else
            {
            self.callReportBlockApi(reason: self.blockReason)
            }
        }
        else if indexPath.row==self.titleArray.count-1
        {
            self.fromBlock = false
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "SendFeedbackAlertVC") as!  SendFeedbackAlertVC
            destVC.delegate=self
            destVC.postID=self.postID
            destVC.user_name=self.user_name
            destVC.UserID=self.UserID
            destVC.type = self.type
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(destVC, animated: true, completion: nil)
        }
        else
        {
            self.fromBlock = false
           
            if type == .messageScreen
            {
                self.call_User_Report_Block_Api(reason: self.blockReason)
            }
            else
            {
            self.callReportBlockApi(reason: self.blockReason)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 115
        }
        else
        {
     
            return 65
        }
    }
    
    @objc func goBack(_ sender: UIButton){

            self.dismiss(animated: true, completion: nil)

    }
    
}
// MARK:- Extension Api Calls
extension BlockReportPopUpVC:SendFeedbackDelegate
{
    func feedbackText(text: String)
    {
        
        if type == .messageScreen
        {
            if text.equalsIgnoreCase(string: kfromBack)
            {
                self.tableReport.reloadData()
            }
            else
            {
            self.dismiss(animated: false) {
                self.fromBlock=false
                self.fromFeedback=true
                self.call_User_Report_Block_Api(reason: text)
            }
            }
        }
        else
        {
            if text.equalsIgnoreCase(string: kfromBack)
        {
            self.tableReport.reloadData()
        }
        else
        {
        self.dismiss(animated: false) {
            self.fromBlock=false
            self.fromFeedback=true
            self.callReportBlockApi(reason: text)
        }
        }
        }
    }

    func callReportBlockApi(reason:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kPost_id] = self.postID
   
        if  self.fromBlock
        {
            data[ApiKey.kBlock_status] = "1"
        }
        else
        {
            data[ApiKey.kReason_text] = reason
        }
            
            if Connectivity.isConnectedToInternet {

                self.callApiForReportBlock(data: data)
             } else {

                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForReportBlock(data:JSONDictionary)
    {
    
        StoriesVM.shared.callApiReportBlock(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.tableReport.reloadData()
                if self.fromFeedback
                {
                    self.dismiss(animated: true) {
                        self.showErrorMessage(error: error)
                        
                    }
                }
                else
                {
                    self.showErrorMessage(error: error)
                }
               
               
                
            }
            else{
             
                    let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                    let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                    destVC.type = .sendFeedback
              
                    destVC.user_name=self.user_name
                if  self.fromBlock
                {
                destVC.fromBlock="blocked"
                }
                else
                {
                    destVC.fromBlock="reported"
                }
                    destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(destVC, animated: true, completion: nil)
                
                          
            }

         
        })
        
    }
    

    
    func call_User_Report_Block_Api(reason:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kUser_id] = self.UserID
   
        if  self.fromBlock
        {
            data[ApiKey.kBlock_status] = "1"
        }
        else
        {
            data[ApiKey.kReason_text] = reason
        }
            
            if Connectivity.isConnectedToInternet {
              
                self.call_Api_For_User_Report_Block(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func call_Api_For_User_Report_Block(data:JSONDictionary)
    {
    
        ChatVM.shared.callApiReportBlockUser(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.tableReport.reloadData()
                if self.fromFeedback
                {
                    self.dismiss(animated: true) {
                        self.showErrorMessage(error: error)
                    }
                }
                else
                {
                    self.showErrorMessage(error: error)
                }
               
               
                
            }
            else{
             
                    let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
                    let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
                    destVC.type = .sendFeedback
                    destVC.Alerttype = .messageScreen
                    destVC.user_name=self.user_name
                if  self.fromBlock
                {
                destVC.fromBlock="blocked"
                    
                    self.sendMatchBlockNoti_Method()
                }
                else
                {
                    destVC.fromBlock="reported"
                }
                    destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    self.present(destVC, animated: true, completion: nil)
                
                          
            }

         
        })
        
    }
    
    func sendMatchBlockNoti_Method()
    {
        print("sendSMS ")
    
        let dict2 = ["from_user_id":self.from_user_id,"to_user_id":self.UserID,"alert_type":"removematch"]
        SocketIOManager.shared.sendMatchBlockNoti(MessageChatDict: dict2)
    }
    
}
