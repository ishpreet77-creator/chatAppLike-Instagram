//
//  DeleteAccountPopUpVC.swift
//  Flazhed
//
//  Created by IOS20 on 07/01/21.
//

import UIKit


protocol deleteAccountDelegate {
    func deleteAccountFunc(name:String)
}
class DeleteAccountPopUpVC: BaseVC {
    
    //MARK:-  IBOutlets
    @IBOutlet weak var Lbldelete: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Variables
    var comeFrom = ""
    var delegate:deleteAccountDelegate?
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK:- Class Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.comeFrom == kChat
        {
            lblMessage.isHidden=true
            lblTitle.text = "Are You Sure?"
            Lbldelete.text = "YES"
        }
        if self.comeFrom == kAccount
        {
            lblMessage.isHidden=false
            lblMessage.text=kLogoutMessage
            lblTitle.text = "Confirm Logout"
            Lbldelete.text = "YES"
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
    //MARK:-IBActions
    @IBAction func btnAction(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            
            
            if comeFrom==kAccount
            {
    
                self.dismiss(animated: true)
                {
                    self.delegate?.deleteAccountFunc(name: kAccount)
                }
            }
            else if comeFrom==kDelete
            {
                self.dismiss(animated: true)
                {
                    self.delegate?.deleteAccountFunc(name: kDelete)
                }

            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
        else
        
        {
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    
}
