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
        
        let currentFilter = DataManager.chatFilter
        
        if currentFilter == kCunread
        {
            self.ShowSelectedOption(tag: 0)
        }
       else if currentFilter == kClatest
        {
            self.ShowSelectedOption(tag:1)
        }
       else if currentFilter == kCclosest
        {
            self.ShowSelectedOption(tag:2)
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
        self.dismiss(animated: true) {
            DataManager.chatFilter=self.selectedOption
            self.delegate?.SortOptionName(name: self.selectedOption)
        }
     }
    
    
    func ShowSelectedOption(tag:Int)
    {
        if  tag == 0
        {
            unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1), for: .normal)
            latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            unreadCheckUncheckImage.image = #imageLiteral(resourceName: "SelectedCheck")
            closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            self.selectedOption = kCunread
            
        }else if tag == 1{
            unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            latestButton.setTitleColor(#colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1), for: .normal)
            closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            latestCheckUncheckImage.image = #imageLiteral(resourceName: "SelectedCheck")
            closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            
            self.selectedOption = kClatest
        }else{
            unreadButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            latestButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            closetToMeButton.setTitleColor(#colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1), for: .normal)
            unreadCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            latestCheckUncheckImage.image = #imageLiteral(resourceName: "unselectedCheck")
            closetToMeCheckUncheckImage.image = #imageLiteral(resourceName: "SelectedCheck")
            self.selectedOption = kCclosest
        }

       
    }
    
   }
