//
//  UnitsVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit
import IQKeyboardManagerSwift

class UnitsVC: BaseVC {

    //MARK:-  IBOutlets
    @IBOutlet weak var txtFieldUnits: UITextField!
    
    var changesMade = false
    //MARK:- Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getUnit()
        
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    //MARK:- Functions
    
    
    //MARK:-IBActions
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        if changesMade
        {
            DataManager.comeFrom = kEmptyString
         self.updateUnit()
        }
        else
        {
            DataManager.comeFrom = kViewProfile
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    

}

//MARK:- Extension
extension UnitsVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        if textField == txtFieldUnits
        {
            self.changesMade=true
            var index = 0
            if let unit = textField.text {
                index = unitsArray.firstIndex(where: {$0 == unit}) ?? 0
            }
            setPickerView(textField: textField, array: unitsArray, selectedIndex: index)
        }
    }
}
extension UnitsVC
{
    //MARK:- Get unit details
    
    func getUnit()
    {
    
            if Connectivity.isConnectedToInternet {
              
                self.getUnitApi()
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func getUnitApi()
    {
        AccountVM.shared.callApiGetUnit(response: { (message, error) in
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
              
                 if AccountVM.shared.unitData.count>0
                  {
                    self.txtFieldUnits.text = AccountVM.shared.unitData[0].unit
                  }
 
            }
        })
    }
    
    func updateUnit()
    {
    
        var data = JSONDictionary()
    
        data[ApiKey.kUnit] = txtFieldUnits.text!
            if Connectivity.isConnectedToInternet {
              
                self.updateUnitApi(data: data)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    
    func updateUnitApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdateUnit(data: data, response: { (message, error) in
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

