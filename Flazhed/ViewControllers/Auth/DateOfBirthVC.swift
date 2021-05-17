//
//  DateOfBirthVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//


import UIKit
import IQKeyboardManagerSwift

class DateOfBirthVC: BaseVC {
   
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewProgress: NSLayoutConstraint!
    
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var lblAge: UILabel!
    var imageArray1:[UIImage] = []
    var userName=""
    var userSelectedDate=""
    let dateFormatter2 = DateFormatter()
    var maxDate = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    func setUpUI()
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lblOtpSent.text ?? "")
        
        attributedString.setColorForText(textForAttribute: "We will connect you with ", withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "like-minded", withColor: TEXTCOLOR)
        attributedString.setColorForText(textForAttribute: " people.", withColor: UIColor.black)

        lblOtpSent.attributedText = attributedString
        
        self.setCustomHeader(title: "Date of Birth", showBack: true, showMenuButton: false)
        
        if self.getDeviceModel() == "iPhone 6"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+TOPLABELSAPACING
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+TOPLABELSAPACING
        }
        else
        {
            self.topConst.constant = TOPSPACING+20
        }
        
        
    
        txtDateOfBirth.attributedPlaceholder = NSAttributedString(string:"Date of Birth", attributes:[NSAttributedString.Key.foregroundColor: PLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
        self.txtDateOfBirth.delegate=self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared.enableAutoToolbar = true
        //self.txtDateOfBirth.text = ""
        txtDateOfBirth.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    
    }
   
    
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/M/yyyy"
            let date = dateFormatter.date(from: self.txtDateOfBirth.text!) ?? Date()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            self.userSelectedDate=dateFormatter2.string(from: date)
            
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenderVC") as! GenderVC
        vc.userName=self.userName
        vc.imageArray1=self.imageArray1
            
        vc.userDOB=self.userSelectedDate
        
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
        if txtDateOfBirth.isEmpty {
            return kEmptyDOBAlert
        }
        
        return nil
     }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        if self.getDeviceModel() == "iPhone 6"
        {
            sendButtonConst.constant = keyboardHeight+26
            viewProgress.constant = keyboardHeight
        }
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+20+16
            viewProgress.constant = keyboardHeight+16+20
        }
        
        
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
        viewProgress.constant = 0
    }
    func calcAge(birthday: String) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components([.day,.month,.year], from: birthdayDate!, to: now, options: [])
        let year = calcAge.year
        let month = calcAge.month
        let day = calcAge.day
        var age = "0 day"
        
        if  day != nil && day != 0
        {
            let day1 = (day ?? 0)
            if day1 == 1  && day1 != 0
            {
                age = "\(day1)" + " day"
            }
            else
            {
                age = "\(day1)" + " days"
            }
        }
        if  month != nil && month != 0
        {
           
            
            let month1 = (month ?? 0)
            if month1 == 1  && month1 != 0
            {
                age = "\(month1)" + " month"
            }
            else
            {
                age = "\(month1)" + " months"
            }
        }
        
        if  year != nil && year != 0
        {
            
            let year1 = (year ?? 0)
            if year1 == 1  && year1 != 0
            {
                age = "\(year1)" + " year"
            }
            else
            {
                age = "\(year1)" + " years"
            }
            
        }
       
       
        
        return age //?? 18
    }

}
extension DateOfBirthVC: UITextFieldDelegate,PickerDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

     
        if textField == txtDateOfBirth {
          
            self.pickerDelegate=self
            setDatePicker4(textField: textField, datePickerMode: .date, maximunDate: nil, minimumDate: nil)
            
        }
    }
    
    func didSelectDate(date: Date) {
        self.lblAge.text = "You are " + "\(self.calcAge(birthday: self.txtDateOfBirth.text!))" + " old."
    }
}
