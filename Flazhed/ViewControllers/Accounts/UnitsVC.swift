//
//  UnitsVC.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit
import IQKeyboardManagerSwift

class UnitsVC: BaseVC {

    //MARK: -  IBOutlets
    @IBOutlet weak var txtFieldUnits: UITextField!
    @IBOutlet weak var viewUnit: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUnitText: UILabel!
    
    var changesMade = false
    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getUnit()
        self.tabBarController?.tabBar.isHidden = true

        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setUpUI()
    {
        self.lblTitle.text = kUNITS
        self.lblUnitText.textColor = PURPLECOLOR
        self.lblUnitText.text = kUNITS.capitalized
     
    }
    //MARK: -IBActions
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        if changesMade
        {
            DataManager.comeFrom = kOTPValidAlert
         self.updateUnit()
        }
        else
        {
            DataManager.comeFrom = kViewProfile
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.viewUnit])

    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.viewUnit])
    }
    

}

//MARK: - Extension
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
    //MARK: - Get unit details
    
    func getUnit()
    {
    
            if Connectivity.isConnectedToInternet {
                self.showLoader()
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
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
              
                 if AccountVM.shared.unitData.count>0
                  {
                    let unit = AccountVM.shared.unitData[0].unit ?? ""
                    if unit != ""
                    {
                        self.txtFieldUnits.text = AccountVM.shared.unitData[0].unit
                    }
                     else
                    {
                       self.txtFieldUnits.text = kCentimeters
                    }
                    
                  }
                else
                 {
                    self.txtFieldUnits.text = kCentimeters
                 }
 
            }
        })
    }
    
    func updateUnit()
    {
    
        var data = JSONDictionary()
    
        data[ApiKey.kUnit] = txtFieldUnits.text!
            if Connectivity.isConnectedToInternet {
                self.showLoader()
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
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else{
                self.hideLoader()
                DataManager.comeFrom = kOTPValidAlert
                self.navigationController?.popViewController(animated: true)
            }
            
            
        })
    }

}

