//
//  DateOfBirthVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//


import UIKit
import IQKeyboardManagerSwift

class DateOfBirthVC: BaseVC {
    
    @IBOutlet weak var txtYear: customTextField!
    @IBOutlet weak var txtMonth: customTextField!
    @IBOutlet weak var txtDay: customTextField!
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewProgress: NSLayoutConstraint!
    
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var lblAge: UILabel!
    var imageArray1:[UIImage] = []
    var userGender  = ""
    var userBirthDay  = ""
    var userName=""
    var userSelectedDate=""
    let dateFormatter2 = DateFormatter()
    var maxDate = Date()
    
    var selectedAge = 0
    var typeDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    func setUpUI()
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lblOtpSent.text ?? "")
        
        attributedString.setColorForText(textForAttribute: kWeWill, withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: klikeMinded, withColor: TEXTCOLOR)
        attributedString.setColorForText(textForAttribute: kPeople, withColor: UIColor.black)
        
        lblOtpSent.attributedText = attributedString
        
        self.setCustomHeader(title: kDateofBirth, showBack: true, showMenuButton: false)
        
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
        
        self.txtDay.delegate=self
        self.txtYear.delegate=self
        
        self.txtMonth.delegate=self
        
        txtDay.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txtMonth.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txtYear.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        
        if DataManager.Selected_DateOfBirth != kEmptyString
        {
            
            let dob=DataManager.Selected_DateOfBirth.components(separatedBy: "-")
            if dob.count>0
            {
                self.txtYear.text=dob[0]
            }
            
            if dob.count>1
            {
                self.txtMonth.text=dob[1]
            }
            if dob.count>2
            {
                self.txtDay.text=dob[2]
            }
            self.didSelectDate()
        }
        else
        {
            if DataManager.userNameType != kEmptyString
            {
                let dob=self.userBirthDay.components(separatedBy: "/")
                
                if dob.count>0
                {
                    self.txtMonth.text=dob[0]
                }
                
                if dob.count>1
                {
                    self.txtDay.text=dob[1]
                }
                if dob.count>2
                {
                    self.txtYear.text=dob[2]
                }
                self.didSelectDate()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared.enableAutoToolbar = true
        //self.txtDateOfBirth.text = ""
        txtDay.becomeFirstResponder()
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
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormatter.date(from: self.typeDate) ?? Date()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            self.userSelectedDate=dateFormatter2.string(from: date)
            
            let vc = GenderVC.instantiate(fromAppStoryboard: .Main)
            
            vc.userName=self.userName
            vc.userGender=self.userGender
            vc.userBirthDay=self.userBirthDay
            vc.imageArray1=self.imageArray1
            
            vc.userDOB=self.userSelectedDate
            DataManager.Selected_DateOfBirth=self.userSelectedDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
        
        if ((self.txtDay.text?.count ?? 0==0) && (self.txtMonth.text?.count ?? 0 == 0) && (self.txtYear.text?.count ?? 0 == 0))
        {
            return kEmptyDOBAlert5
            
        }
        else
        {
            if txtDay.isEmpty { //txtDateOfBirth.isEmpty
                return kEmptyDOBAlert1
            }
            if txtMonth.isEmpty { //txtDateOfBirth.isEmpty
                return kEmptyDOBAlert2
            }
            if txtYear.isEmpty { //txtDateOfBirth.isEmpty
                return kEmptyDOBAlert3
            }
            if self.selectedAge<18 || self.selectedAge>100
            {
                return kEmptyDOBAlert4
            }
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
        //dateFormater.dateFormat = "dd/MM/yyyy"
        dateFormater.dateFormat = "dd/MM/yyyy"
        
        let birthdayDate = dateFormater.date(from: birthday) ?? Date()
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components([.day,.month,.year], from: birthdayDate, to: now, options: [])
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
            else if day1 < 1 {
                age = "0 day"
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
            else if month1 < 1 {
                age = "0 month"
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
            else if year1 < 1 {
                age = "0 year"
            }
            else
            {
                age = "\(year1)" + " years"
            }
            self.selectedAge=year1
        }
        else
        {
            self.selectedAge = 0
        }
        
        
        
        return age //?? 18
    }
    
}
extension DateOfBirthVC: UITextFieldDelegate,PickerDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //
        //        if textField == txtDateOfBirth {
        //
        //            self.pickerDelegate=self
        //            setDatePicker4(textField: textField, datePickerMode: .date, maximunDate: nil, minimumDate: nil)
        //
        //        }
    }
    
    //func didSelectDate(date: Date) {
    func didSelectDate() {
        
        let DOB1 = (self.txtDay.text ?? "") + "/" + (self.txtMonth.text ?? "") + "/"
        
        let DOB = DOB1 + (self.txtYear.text ?? "")
        
        //        self.lblAge.text = "You are " + "\(self.calcAge(birthday: self.txtDateOfBirth.text!))" + " old."
        
        // debugPrint("Date of birth = \(DOB)")
        self.typeDate = DOB
        
        
        self.lblAge.text = "You are " + "\(self.calcAge(birthday: DOB))" + " old."
        
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        //Format Date of Birth dd-MM-yyyy
    //
    //        //initially identify your textfield
    //
    //        if textField == txtDay {
    //
    //            // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
    //            if (txtDay?.text?.count == 2) || (txtDay?.text?.count == 5) {
    //                //Handle backspace being pressed
    //                if !(string == "") {
    //                    // append the text
    //                    txtDay?.text = (txtDay?.text)! + "/"
    //                }
    //            }
    //            // check the condition not exceed 9 chars
    //            return !(textField.text!.count > 9 && (string.count ) > range.length)
    //        }
    //        else {
    //            return true
    //        }
    //    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        // let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        
        
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0
            
        {
            return false
        }
        else
            
        {
            textField.text = currentString.capitalized
            
            if textField == self.txtDay
            {
                return newString.length <= 2
            }
            else if textField == self.txtMonth
            {
                return newString.length <= 2
            }
            else
            {
                return newString.length <= 4
                
            }
            
            
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if ((self.txtDay.text?.count ?? 0>0) && (self.txtMonth.text?.count ?? 0 > 0) && (self.txtYear.text?.count ?? 0 > 0))
        {
            self.didSelectDate()
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text ?? ""
        let count = text.utf16.count
        
        
        if textField == self.txtDay
        {
            if count>=2
            {
                txtMonth.becomeFirstResponder()
                
            }
            else
            {
                txtDay.becomeFirstResponder()
            }
        }
        else  if textField == self.txtMonth
        {
            if count>=2
            {
                txtYear.becomeFirstResponder()
                
            }
            else if count == 0
            {
                txtDay.becomeFirstResponder()
                
            }
            
            else
            {
                txtMonth.becomeFirstResponder()
            }
        }
        else  if textField == self.txtYear
        {
            if count>=4
            {
                txtYear.resignFirstResponder()
                
            }
            //            else if count<4
            //            {
            //                txtYear.becomeFirstResponder()
            //            }
            else if count == 0
            {
                txtMonth.becomeFirstResponder()
                
            }
        }
        
        //
        //
        //        if count >= 2{
        //            switch textField
        //            {
        //            case txtDay:
        //                txtMonth.becomeFirstResponder()
        //            case txtMonth:
        //                txtYear.becomeFirstResponder()
        //
        //            case txtYear:
        //
        //                txtYear.resignFirstResponder()
        //                self.didSelectDate()
        //
        //            default:
        //                break
        //            }
        //        }
        //        else{
        //            switch textField
        //            {
        //            case txtDay:
        //                txtDay.resignFirstResponder()
        //            case txtMonth:
        //                txtDay.becomeFirstResponder()
        //            case txtYear:
        //                txtMonth.becomeFirstResponder()
        //
        //
        //            default:
        //                break
        //            }
        //        }
        //
        
        
        
        if ((self.txtDay.text?.count ?? 0>0) && (self.txtMonth.text?.count ?? 0 > 0) && (self.txtYear.text?.count ?? 0 > 0))
        {
            self.didSelectDate()
        }
    }
}
