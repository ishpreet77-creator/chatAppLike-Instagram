//
//  UserNameVC.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//

import UIKit
import CountryPickerView

class UserNameVC: BaseVC {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var constTopLbl: NSLayoutConstraint!
    @IBOutlet weak var constScrollView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var lblBirthDayShow: UILabel!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var txtYear: customTextField!
    @IBOutlet weak var txtMonth: customTextField!
    @IBOutlet weak var txtDay: customTextField!
    @IBOutlet weak var btnContinue: UIButton!

    @IBOutlet weak var txtUserName: UITextField!
    
    var imageArray1:[UIImage] = []
    var userName = ""
    var userGender  = ""
    var userBirthDay  = ""
    var userSelectedDate=""
    let dateFormatter2 = DateFormatter()
    var maxDate = Date()
    
    var selectedAge = 0
    var typeDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
        
        scrollView.isScrollEnabled=false
        self.txtUserName.autocapitalizationType = .words
    }
    
    func setUpUI()
    {
        
        txtUserName.attributedPlaceholder = NSAttributedString(string:kusername, attributes:[NSAttributedString.Key.foregroundColor: PLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 18)!])
        txtUserName.delegate=self
       // self.txtUserName.text = userName
        if DataManager.userNameType != kEmptyString
        {
            self.txtUserName.text=DataManager.userNameType
        }
        self.txtDay.delegate=self
        self.txtYear.delegate=self
        
        self.txtMonth.delegate=self
        
        txtDay.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txtMonth.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txtYear.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        self.lblBirthDayShow.text = kWeDonotShow
        
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
        self.constScrollView.constant = SCREENHEIGHT-(BOTTOMSPACING)
        self.validationNexButton()
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .normal)
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.disableIQKeyboard()
        //txtUserName.text = ""
        txtUserName.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        
    }
    
    //MARK: - backBtnAction
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let vc = GenderVC.instantiate(fromAppStoryboard: .Main)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormatter.date(from: self.typeDate) ?? Date()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            self.userSelectedDate=dateFormatter2.string(from: date)
            
            vc.userName=self.txtUserName.text ?? kEmptyString
            vc.userGender=self.userGender
            vc.userBirthDay=self.userBirthDay
            vc.imageArray1=self.imageArray1
            
            vc.userDOB=self.userSelectedDate
            DataManager.Selected_DateOfBirth=self.userSelectedDate
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
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
//        if UIDevice.current.hasNotch
//        {
//
//            self.sendButtonConst.constant = keyboardHeight+26+20
//            self.constTopLbl.constant = 8
//            self.constScrollView.constant = SCREENHEIGHT-(BOTTOMSPACING-STATUSBARHEIGHT)
//        }
//        else
//        {
            sendButtonConst.constant = 0
            self.constTopLbl.constant = 90

            self.constScrollView.constant = SCREENHEIGHT-(BOTTOMSPACING)
       // }
     
       
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 0
        self.constTopLbl.constant = 90
        // scrollView.setContentOffset(CGPoint(x: 0, y: 26), animated: true)
        self.constScrollView.constant = SCREENHEIGHT-(BOTTOMSPACING)
    }
    
    
    // MARK: - validateData Functions
    private func validateData () -> String?
    {
        if txtUserName.isEmpty {
            return kEmptyUserNameAlert
        }
        if txtUserName.text?.count ?? 0 < 2 {
            return kMinUserNameAlert
        }
        if ((self.txtDay.text?.count ?? 0==0) && (self.txtMonth.text?.count ?? 0 == 0) && (self.txtYear.text?.count ?? 0 == 0))
        {
            return kEmptyDOBAlert5
            
        }
        else
        {
            if txtDay.isEmpty {
                return kEmptyDOBAlert1
            }
            if txtMonth.isEmpty {
                return kEmptyDOBAlert2
            }
            if txtYear.isEmpty {
                return kEmptyDOBAlert3
            }
            if self.selectedAge<16 || self.selectedAge>100
            {
                return kEmptyDOBAlert4
            }
            return nil
        }
        
       
    }
    
    //MARK: - validationNexButton
    
    func validationNexButton(count:Int=0)
    {
        debugPrint("text count = \(count) \(validateData())")
        
        if validateData() == kEmptyDOBAlert4
        {
            self.btnContinue.backgroundColor = ENABLECOLOR
            self.btnContinue.isEnabled=true
        }
        else if validateData() != nil || count < 2
        {
            self.btnContinue.isEnabled=false
            self.btnContinue.backgroundColor = DISABLECOLOR
        }
        else
        {
            self.btnContinue.backgroundColor = ENABLECOLOR
            self.btnContinue.isEnabled=true
         }
    }
    func calcAge(birthday: String) -> String
    {
        let dateFormater = DateFormatter()
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
//MARK: - Extension  UITextFieldDelegate

extension UserNameVC:UITextFieldDelegate, PickerDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func didSelectDate() {
        
        let DOB1 = (self.txtDay.text ?? "") + "/" + (self.txtMonth.text ?? "") + "/"
        
        let DOB = DOB1 + (self.txtYear.text ?? "")
        
        self.typeDate = DOB
        
        self.calcAge(birthday: DOB)
        
        //self.lblAge.text = "You are " + "\(self.calcAge(birthday: DOB))" + " old."
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        let maxLength = 50
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
            else if textField == self.txtYear
            {
                return newString.length <= 4
            }
            else
            {
                self.validationNexButton(count: newString.length)
                return newString.length <= maxLength
                
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
            
            else if count == 0
            {
                txtMonth.becomeFirstResponder()
                
            }
        }
        
        if ((self.txtDay.text?.count ?? 0>0) && (self.txtMonth.text?.count ?? 0 > 0) && (self.txtYear.text?.count ?? 0 > 0))
        {
            self.didSelectDate()
            self.validationNexButton(count: count)
        }
    }
}
