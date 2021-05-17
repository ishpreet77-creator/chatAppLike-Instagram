//
//  NoHangoutVC.swift
//  Flazhed
//
//  Created by IOS22 on 08/01/21.
//

import UIKit
//import RangeSeekSlider
import IQKeyboardManagerSwift

class NoHangoutVC: BaseVC {

    @IBOutlet var txtViewDesc:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : style,NSAttributedString.Key.foregroundColor :UIColor.init(red: 176/255, green: 185/255, blue: 200/255, alpha: 1),NSAttributedString.Key.font : UIFont(name: AppFontName.regular, size: 14)!]
        
        txtViewDesc.attributedText = NSAttributedString(string: txtViewDesc.text!, attributes: attributes)
        txtViewDesc.textAlignment = .center
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    
    @IBAction func nextAct(_ sender: UIButton)
    {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MyHangoutVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
   

}

