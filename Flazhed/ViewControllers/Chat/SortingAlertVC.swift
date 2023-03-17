//
//  SortingAlertVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit

protocol chatSortDelegate {
    func SortOptionName(name:String)
}


class SortingAlertVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var unreadButton: UIButton!
    @IBOutlet weak var latestButton: UIButton!
    @IBOutlet weak var closetToMeButton: UIButton!
    @IBOutlet weak var unreadCheckUncheckImage: UIImageView!
    @IBOutlet weak var closetToMeCheckUncheckImage: UIImageView!
    @IBOutlet weak var latestCheckUncheckImage: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var delegate:chatSortDelegate?
    var selectedOption = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        let currentFilter = DataManager.chatFilter
        
        if currentFilter.equalsIgnoreCase(string: kCunread)
        {
            self.ShowSelectedOption(tag: 0)
        }
        else if currentFilter.equalsIgnoreCase(string: kClatest)
        {
            self.ShowSelectedOption(tag:1)
        }
        else if currentFilter.equalsIgnoreCase(string: kCclosest)
        {
            self.ShowSelectedOption(tag:2)
        }
        
        self.latestButton.setTitle(kLATEST, for: .normal)
        self.unreadButton.setTitle(kUNREAD, for: .normal)
        self.closetToMeButton.setTitle(kCLOSESTTOME, for: .normal)
        self.lblTitle.text = kSORT.capitalized
        self.btnApply.setTitle(kAPPLY, for: .normal)
        self.btnApply.backgroundColor = ENABLECOLOR
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

  
    @IBAction func sortingSelectionBUttonAction(_ sender: UIButton) {
        self.ShowSelectedOption(tag: sender.tag)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ApplyButtonAction(_ sender: UIButton)
    {
        self.dismiss(animated: true)
        {
            DataManager.chatFilter=self.selectedOption
            self.delegate?.SortOptionName(name: self.selectedOption)
        }
     }
    
    
    func ShowSelectedOption(tag:Int)
    {
        if  tag == 0
        {
            if  self.unreadButton.titleColor(for: .normal) == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //self.unreadButton.isSelected==false
            {
                unreadButton.setTitleColor(PURPLECOLOR, for: .normal)
//            unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1), for: .normal)
            latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                              
            unreadCheckUncheckImage.image = #imageLiteral(resourceName: "SelectedCheck")
            closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            self.selectedOption = kCunread
            }
            else
            {
                unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                
                unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                self.selectedOption = kEmptyString
            }
            
        }else if tag == 1{
            if  self.latestButton.titleColor(for: .normal) == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            {
            
            unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    latestButton.setTitleColor(PURPLECOLOR, for: .normal)
//            latestButton.setTitleColor(#colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1), for: .normal)
//
            closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                
            unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            latestCheckUncheckImage.image = #imageLiteral(resourceName: "SelectedCheck")
            closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            
            self.selectedOption = kClatest
            }
            
            else
            {
                unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                
                unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                self.selectedOption = kEmptyString
            }
            
            
        }else{
            if  self.closetToMeButton.titleColor(for: .normal) == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            {
            unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                closetToMeButton.setTitleColor(PURPLECOLOR, for: .normal)
//            closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1), for: .normal)
            unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "SelectedCheck")
            self.selectedOption = kCclosest
                
            }
            else
            {
                unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                
                unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
                self.selectedOption = kEmptyString
                self.selectedOption = kEmptyString

            }
        }

       
    }
    
   }
