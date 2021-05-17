//
//  ToTestVC.swift
//  Flazhed
//
//  Created by IOS33 on 24/03/21.
//

import UIKit

class ToTestVC: ViewController,UITextFieldDelegate {

    @IBOutlet weak var txtUser: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        txtUser.delegate=self
   
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
   
       // self.setPicker(textFild: txtUser, pickerArray: ["Amar","Dev"])
    }
    

}
