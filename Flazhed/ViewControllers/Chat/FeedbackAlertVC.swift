//
//  FeedbackAlertVC.swift
//  Flazhed
//
//  Created by IOS25 on 08/01/21.
//

import UIKit

class FeedbackAlertVC: BaseVC {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descrptionLbel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var alertHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomContarint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    var type : ScreenType = .feedbackScreen
    var Alerttype : ScreenType = .storiesScreen
    var user_name = ""
    var fromBlock = "reported"
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .feedbackScreen {
            alertHeightContraint.constant = 375
            titleBottomContarint.constant = 75
            doneButton.setTitle("OKAY", for: .normal)
            titleLabel.text = "Uh Oh!"
            descrptionLbel.text = "Chelsea hasn't accepted your chat request yet."
            buttonView.isHidden = false
            labelBottomConstraints.constant = 42
        }else{
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false){ (timer) in
                
                if self.Alerttype == .messageScreen
                {
                    if #available(iOS 13.0, *) {
                        SCENEDEL?.navigateToChat()
                    } else {
                        // Fallback on earlier versions
                        APPDEL.navigateToChat()
                    }
                }
                else
                {
                    if #available(iOS 13.0, *) {
                        SCENEDEL?.navigateToStories()
                    } else {
                        // Fallback on earlier versions
                        APPDEL.navigateToStories()
                    }
                }
               
            }
            alertHeightContraint.constant = 290
            titleBottomContarint.constant = 75
            titleLabel.text = "Feedback Received"
            if self.Alerttype == .messageScreen
            {
                descrptionLbel.text = "Thank you for your time. \(user_name) has been \(fromBlock)."
            }
            else
            
            {
                descrptionLbel.text = "Thank you for your time. \(user_name) 's post has been \(fromBlock)."
            }
           
            buttonView.isHidden = true
            labelBottomConstraints.constant = -16
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
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
