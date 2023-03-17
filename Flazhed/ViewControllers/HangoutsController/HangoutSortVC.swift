//
//  HangoutSortVC.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit

protocol SortHangoutDelegate
{
    //Social:String,travel:String,sport:String,business:String,women:String,men:String,latest:String,oldest:String,ase:String,desc:String
    func SortHangoutOption()

}


class HangoutSortVC: UIViewController {
    
    var delegate:SortHangoutDelegate?

    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var tableSort: UITableView!
    var tableCell:SortHangout2TCell?
    var HeaderTableCell:SortHangoutTCell?
    
    var selectedOption:[Int]=[]
   var Social = "0"
    var travel = "0"
    var sport = "0"
     var business = "0"
    var women = "0"
     var men = "0"
     var latest = "0"
      var oldest = "0"
    var ase = "0"
     var desc = "0"

var isUpdate=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imgSocial.image = UIImage(named: "SelectedCheck")
//        imgBusiness.image = UIImage(named: "SelectedCheck")
//
//
//        imgWoman.image = UIImage(named: "SelectedCheck")
//        imglatest.image = UIImage(named: "SelectedCheck")
        setUpTable()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.isUpdate=false
       
        self.selectedOption.removeAll()
        
        if DataManager.social == "1"
        {
            self.selectedOption.append(0)
        }
        if DataManager.travel == "1"
        {
            self.selectedOption.append(1)
        }
        if DataManager.sport == "1"
        {
            self.selectedOption.append(2)
        }
        if DataManager.business == "1"
        {
            self.selectedOption.append(3)
        }
        
        if DataManager.women == "1" || DataManager.women == ""
        {
            self.selectedOption.append(4)
        }
        
        if DataManager.men == "1" ||  DataManager.men == ""
        {
            self.selectedOption.append(5)
        }
        
        if DataManager.latest == "1"
        {
            self.selectedOption.append(6)
        }
        if DataManager.oldest == "1"
        {
            self.selectedOption.append(7)
        }
        
        if DataManager.ase == "1"
        {
            self.selectedOption.append(8)
        }
        if DataManager.desc == "1"
        {
            self.selectedOption.append(9)
        }
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
        if isUpdate
        {
            self.dismiss(animated: true) {
                
                DataManager.social=self.Social
                DataManager.travel=self.travel
                DataManager.sport=self.sport
                DataManager.business=self.business
                
                DataManager.men=self.men
                DataManager.women=self.women
                
                DataManager.ase=self.ase
                DataManager.desc=self.desc
                
                DataManager.latest=self.latest
                DataManager.oldest=self.oldest
                
                
                self.delegate?.SortHangoutOption()
                //Social: self.Social, travel: self.travel, sport: self.sport, business: self.business, women: self.women, men: self.men, latest: self.latest, oldest: self.oldest, ase: self.ase, desc: self.desc
            }
        }
        else
        {
            self.dismiss(animated: true) {
                
    
            }
        }
    }
    
}
extension HangoutSortVC:UITableViewDelegate,UITableViewDataSource
{
   
    
    func setUpTable()
    {
        self.tableSort.register(UINib(nibName: "SortHangout2TCell", bundle: nil), forCellReuseIdentifier: "SortHangout2TCell")
        self.tableSort.register(UINib(nibName: "SortHangoutTCell", bundle: nil), forCellReuseIdentifier: "SortHangoutTCell")
        self.tableSort.register(UINib(nibName: "ReportHeaderTCell", bundle: nil), forCellReuseIdentifier: "ReportHeaderTCell")
        
        self.tableSort.register(UINib(nibName: "SortHangoutFooterTCell", bundle: nil), forCellReuseIdentifier: "SortHangoutFooterTCell")
        self.tableSort.rowHeight = 100
        self.tableSort.estimatedRowHeight = UITableView.automaticDimension
        self.tableSort.allowsSelection=true
        self.tableSort.delegate = self
        self.tableSort.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4//kHangoutSort.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if indexPath.row == 0
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SortHangoutTCell") as! SortHangoutTCell
            self.HeaderTableCell=cell
            cell.lbl1.text = kHangoutSort[0]
            cell.lbl2.text=kHangoutSort[1]
            cell.lbl3.text=kHangoutSort[2]
            cell.lbl4.text=kHangoutSort[3]
            if self.selectedOption.contains(0)
            {
                cell.img1.image=UIImage(named: "SelectedCheck")
               
                cell.lbl1.textColor=PURPLECOLOR
                self.Social="1"
                cell.btn1.isSelected=true
            }
            else
            {
                cell.img1.image=UIImage(named: "unselectedCheck")
                cell.lbl1.textColor=UIColor.black
                self.Social="0"
                cell.btn1.isSelected=false
            }
            if self.selectedOption.contains(1)
            {
                cell.img2.image=UIImage(named: "SelectedCheck")
               
                cell.lbl2.textColor=PURPLECOLOR
                self.travel="1"
                cell.btn2.isSelected=true
            }
            else
            {
                cell.img2.image=UIImage(named: "unselectedCheck")
                cell.lbl2.textColor=UIColor.black
                self.travel="0"
                cell.btn2.isSelected=false
            }
            if self.selectedOption.contains(2)
            {
                cell.img3.image=UIImage(named: "SelectedCheck")
                cell.lbl3.textColor=PURPLECOLOR
                self.sport="1"
               
                cell.btn3.isSelected=true
            }
            else
            {
                cell.img3.image=UIImage(named: "unselectedCheck")
                cell.lbl3.textColor=UIColor.black
                self.sport="0"
                cell.btn3.isSelected=false
            }
            if self.selectedOption.contains(3)
            {
               
                cell.img4.image=UIImage(named: "SelectedCheck")
                cell.lbl4.textColor=PURPLECOLOR
                self.business="1"
                cell.btn4.isSelected=true
            }
            else
            {
                cell.img4.image=UIImage(named: "unselectedCheck")
                cell.lbl4.textColor=UIColor.black
                self.business="0"
                cell.btn4.isSelected=false
            }
            
            cell.btn1.tag=0
            cell.btn2.tag=1
            cell.btn3.tag=2
            cell.btn4.tag=3
        
             cell.btn1.addTarget(self, action: #selector(TypeAct), for: UIControl.Event.touchUpInside)
            cell.btn2.addTarget(self, action: #selector(TypeAct), for: UIControl.Event.touchUpInside)
            cell.btn3.addTarget(self, action: #selector(TypeAct), for: UIControl.Event.touchUpInside)
           cell.btn4.addTarget(self, action: #selector(TypeAct), for: UIControl.Event.touchUpInside)
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
        
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortHangout2TCell") as! SortHangout2TCell
            self.tableCell=cell
            if indexPath.row==1
            {
                cell.lbl1.text = kHangoutSort[4]
                cell.lbl2.text = kHangoutSort[5]
                
                cell.btn1.tag=4
                cell.btn2.tag=5
                if self.selectedOption.contains(4)
                {
                    cell.img1.image=UIImage(named: "SelectedCheck")
                    cell.lbl1.textColor=PURPLECOLOR
                    self.women="1"

                }
                else
                {
                    cell.img1.image=UIImage(named: "unselectedCheck")
                    cell.lbl1.textColor=UIColor.black
                    self.women="0"
                    
                }
                if self.selectedOption.contains(5)
                {
                    cell.img2.image=UIImage(named: "SelectedCheck")
                    cell.lbl2.textColor=PURPLECOLOR
                    self.men="1"

                }
                else
                {
                    cell.img2.image=UIImage(named: "unselectedCheck")
                    cell.lbl2.textColor=UIColor.black
                    self.men="0"
                }
            }
           else if indexPath.row==2
            {
                cell.lbl1.text = kHangoutSort[6]
                cell.lbl2.text = kHangoutSort[7]
            cell.btn1.tag=6
            cell.btn2.tag=7
            
            if self.selectedOption.contains(6)
            {
                cell.img1.image=UIImage(named: "SelectedCheck")
                cell.lbl1.textColor=PURPLECOLOR
                self.latest="1"
            }
            else
            {
                cell.img1.image=UIImage(named: "unselectedCheck")
                cell.lbl1.textColor=UIColor.black
                self.latest="0"
                
            }
            if self.selectedOption.contains(7)
            {
                cell.img2.image=UIImage(named: "SelectedCheck")
                cell.lbl2.textColor=PURPLECOLOR
                self.oldest="1"
   
            }
            else
            {
                cell.img2.image=UIImage(named: "unselectedCheck")
                cell.lbl2.textColor=UIColor.black
                self.oldest="0"
            }
            }
           else if indexPath.row==3
            {
                cell.lbl1.text = kHangoutSort[8]
                cell.lbl2.text = kHangoutSort[9]
            cell.btn1.tag=8
            cell.btn2.tag=9
            if self.selectedOption.contains(8)
            {
                cell.img1.image=UIImage(named: "SelectedCheck")
                cell.lbl1.textColor=PURPLECOLOR
                self.ase="1"

            }
            else
            {
                cell.img1.image=UIImage(named: "unselectedCheck")
                cell.lbl1.textColor=UIColor.black
                self.ase="0"
                
            }
            if self.selectedOption.contains(9)
            {
                cell.img2.image=UIImage(named: "SelectedCheck")
                cell.lbl2.textColor=PURPLECOLOR
                self.desc="1"

            }
            else
            {
                cell.img2.image=UIImage(named: "unselectedCheck")
                cell.lbl2.textColor=UIColor.black
                self.desc="0"
            }
            }
            
            
            
                let bgColorView = UIView()
                bgColorView.backgroundColor = UIColor.clear
                cell.selectedBackgroundView = bgColorView
           
            cell.btn1.addTarget(self, action: #selector(btn1Act), for: UIControl.Event.touchUpInside)
            cell.btn2.addTarget(self, action: #selector(btn2Act), for: UIControl.Event.touchUpInside)

                return cell
        }

    

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportHeaderTCell") as! ReportHeaderTCell
        cell.lblabout.isHidden=true
        cell.lblTitle.text = "Sort"
        cell.btnBack.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 80
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SortHangoutFooterTCell") as! SortHangoutFooterTCell
//
//        cell.btnApply.addTarget(self, action: #selector(btnApplyAct), for: .touchUpInside)
//        return cell
//
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0//149
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 200
        }
        else
        {
     
            return 110
        }
    }
    
    @objc func goBack(_ sender: UIButton)
    {

            //self.dismiss(animated: true, completion: nil)
        
        if isUpdate
        {
            self.dismiss(animated: true) {
                
                DataManager.social=self.Social
                DataManager.travel=self.travel
                DataManager.sport=self.sport
                DataManager.business=self.business
                
                DataManager.men=self.men
                DataManager.women=self.women
                
                DataManager.ase=self.ase
                DataManager.desc=self.desc
                
                DataManager.latest=self.latest
                DataManager.oldest=self.oldest
                
                
                self.delegate?.SortHangoutOption()
                //Social: self.Social, travel: self.travel, sport: self.sport, business: self.business, women: self.women, men: self.men, latest: self.latest, oldest: self.oldest, ase: self.ase, desc: self.desc
            }
        }
        else
        {
            self.dismiss(animated: true) {
                
    
            }
        }
        
       

    }
    
    @objc func btnApplyAct(_ sender: UIButton)
    {
        

        self.dismiss(animated: true) {
            
            DataManager.social=self.Social
            DataManager.travel=self.travel
            DataManager.sport=self.sport
            DataManager.business=self.business
            
            DataManager.men=self.men
            DataManager.women=self.women
            
            DataManager.ase=self.ase
            DataManager.desc=self.desc
            
            DataManager.latest=self.latest
            DataManager.oldest=self.oldest
            
            
            self.delegate?.SortHangoutOption()
            //Social: self.Social, travel: self.travel, sport: self.sport, business: self.business, women: self.women, men: self.men, latest: self.latest, oldest: self.oldest, ase: self.ase, desc: self.desc
        }

    }
    
    @objc func TypeAct(_ sender: UIButton)
    {
        debugPrint(sender.tag)
        self.isUpdate=true
        if sender.isSelected
        {
            sender.isSelected=false
            if let index = selectedOption.firstIndex(of: sender.tag) {
                selectedOption.remove(at: index)
            }
        }
        else
        {
            
            sender.isSelected=true
            
            if !self.selectedOption.contains(sender.tag)
            {
                selectedOption.append(sender.tag)

            }
        }
        debugPrint(selectedOption)
        self.tableSort.reloadData()
    }
    
    
    @objc func btn1Act(_ sender: UIButton)
    {
        debugPrint(sender.tag)
        self.isUpdate=true
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableSort)
        let indexPath = self.tableSort.indexPathForRow(at:buttonPosition)
        let cell = self.tableSort.cellForRow(at: indexPath ?? IndexPath(item: 0, section: 0)) as! SortHangout2TCell
        self.tableCell = cell
        
        //cell.img1.image=UIImage(named: "SelectedCheck")
        if  self.tableCell?.img1.image == UIImage(named: "SelectedCheck")//self.//sender.isSelected
        {
            sender.isSelected=false
            if let index = selectedOption.firstIndex(of: sender.tag) {
              
                if sender.tag == 4
                {
                    selectedOption.remove(at: index)
                    
                    if !selectedOption.contains(5)
                    {
                    selectedOption.append(5)
                    }
                    
                }
                else
                {
                    selectedOption.remove(at: index)
                }
            }
        }
        else
        {
            
            sender.isSelected=true
            
            if !self.selectedOption.contains(sender.tag)
            {
                if sender.tag == 4
                {
                    if self.selectedOption.contains(5)
                    {
//                        if let index = selectedOption.firstIndex(of: 5) {
//                            selectedOption.remove(at: index)
//                            self.tableCell?.btn2.isSelected=false
//                        }
                        selectedOption.append(sender.tag)
                    }
                    else
                    {
                        selectedOption.append(sender.tag)
                    }
                }
               else if sender.tag == 6
                {
                    if self.selectedOption.contains(7)
                    {
                        if let index = selectedOption.firstIndex(of: 7) {
                            selectedOption.remove(at: index)
                            self.tableCell?.btn2.isSelected=false
                        }
                        selectedOption.append(sender.tag)
                    }
                    else
                    {
                        selectedOption.append(sender.tag)
                    }
                }
               else if sender.tag == 8
                {
                    if self.selectedOption.contains(9)
                    {
                        if let index = selectedOption.firstIndex(of: 9) {
                            selectedOption.remove(at: index)
                            self.tableCell?.btn2.isSelected=false
                        }
                        selectedOption.append(sender.tag)
                    }
                    else
                    {
                        selectedOption.append(sender.tag)
                    }
                }
                else
                {
                    selectedOption.append(sender.tag)
                }
            }
        }
        debugPrint(selectedOption)
        self.tableSort.reloadData()
    }
    
    @objc func btn2Act(_ sender: UIButton)
    {
        self.isUpdate=true
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableSort)
        let indexPath = self.tableSort.indexPathForRow(at:buttonPosition)
        let cell = self.tableSort.cellForRow(at: indexPath ?? IndexPath(item: 0, section: 0)) as! SortHangout2TCell
        self.tableCell = cell
        
        if self.tableCell?.img2.image == UIImage(named: "SelectedCheck")//sender.isSelected
        {
            sender.isSelected=false
            if let index = selectedOption.firstIndex(of: sender.tag) {
                if sender.tag == 5
                {
                    selectedOption.remove(at: index)
                    if !selectedOption.contains(4)
                    {
                    selectedOption.append(4)
                    }
                    
                }
                else
                {
                    selectedOption.remove(at: index)
                }
            }
        }
        else
        {
            sender.isSelected=true
            if !self.selectedOption.contains(sender.tag)
            {
                if sender.tag == 5
                {
                    if self.selectedOption.contains(4)
                    {
//                        if let index = selectedOption.firstIndex(of: 4) {
//                            selectedOption.remove(at: index)
//                            self.tableCell?.btn1.isSelected=false
//                        }
                        selectedOption.append(sender.tag)
                    }
                    else
                    {
                        selectedOption.append(sender.tag)
                    }
                }
               else if sender.tag == 7
                {
                    if self.selectedOption.contains(6)
                    {
                        if let index = selectedOption.firstIndex(of: 6) {
                            selectedOption.remove(at: index)
                            self.tableCell?.btn1.isSelected=false
                        }
                        selectedOption.append(sender.tag)
                    }
                    else
                    {
                        selectedOption.append(sender.tag)
                    }
                }
               else if sender.tag == 9
                {
                    if self.selectedOption.contains(8)
                    {
                        if let index = selectedOption.firstIndex(of: 8) {
                            selectedOption.remove(at: index)
                            self.tableCell?.btn1.isSelected=false
                        }
                        selectedOption.append(sender.tag)
                    }
                    else
                    {
                        selectedOption.append(sender.tag)
                    }
                }
                else
                {
                    selectedOption.append(sender.tag)
                }

            }
        }
        debugPrint(selectedOption)
        self.tableSort.reloadData()
        debugPrint(sender.tag)

    }
}
