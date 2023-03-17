//
//  UITextField.swift
//  Twiva
//
//  Created by Deftsoft on 30/08/19.
//  Copyright © 2019 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UITextField {
    
    @IBInspectable var rightAccessory: UIImage? {
        set {
            if newValue != nil {
                let iv = UIImageView(frame: CGRect(x: 16, y: 8, width: 24, height: 24))
                iv.image = newValue
                iv.contentMode = .scaleAspectFit
                let viewRight: UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: 56, height: 40))// set per your requirement
                viewRight.addSubview(iv)
                rightViewMode = .always
                rightView = viewRight
            } else {
                rightViewMode = .never
                rightView = nil
            }
        }
        get {
            if let imageView = self.rightView as? UIImageView {
                return imageView.image
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable var leftAccessary: UIImage? {
        set {
            if newValue != nil {
                let iv = UIImageView(frame: CGRect(x: 16, y: 8, width: 24, height: 24))
                iv.image = newValue
                iv.contentMode = .scaleAspectFit
                let viewLeft: UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: 56, height: 40))// set per your requirement
                viewLeft.addSubview(iv)
                self.leftView = viewLeft
                self.leftViewMode = .always
            } else {
                leftViewMode = .never
                leftView = nil
            }
        }
        get {
            if let imageView = self.leftView as? UIImageView {
                return imageView.image
            } else {
                return nil
            }
        }
    }
}

//class TextField: UITextField {
//
//    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.inset(by: padding)
//    }
//}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension UITextField {
    
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1.5)
        bottomLine.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
}
extension UITextView{
    func addbottomLine(){
        let view = UIView(frame: CGRect(x: self.frame.origin.x, y: self.frame.size.height - 1 + self.frame.origin.y, width: self.frame.size.width, height: 1.5))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.superview!.insertSubview(view, aboveSubview: self)
    }
}

extension UITextField {
    
    var isEmpty: Bool {
        return self.text?.trimmingCharacters(in: .whitespaces).count == 0 ? true: false
    }
    
    var count: Int {
        return self.text?.count ?? 0
    }
    //    func setPlaceholder(placholder: String? = nil, color: UIColor, size: CGFloat, style: UIFont.CustomFont.regular) {
    //
    //        let myPlaceholder = placholder ?? self.placeholder!
    //        let attributedString = NSAttributedString(string: myPlaceholder, attributes:[NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: style.fontWithSize(size: size)])
    //        self.tintColor = color
    //        self.font = style.fontWithSize(size: size)
    //        self.attributedPlaceholder = attributedString
    //    }
    
    
    //MARK: - Validations
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var isValidPassword: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 6 ? true: false
    }
    
    var isValidName: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 < 2 ?  true: false
    }
    
    var isValidPhone: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ??  0 < 8 || 0 >= 15 ? true: false
    }
    var isValidPrice: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 10 ? true: false
    }
    
    var isValidPostOrGigName: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 30 ? true: false
    }

    var isValidCardNumber: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 8 ? true: false
    }
    
    var isValidCVV: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 3 ? true: false
    }
    
    var isValidAccountNumber: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 7 ? true: false
    }
    
    var isValidBSBNumber: Bool {
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 >= 3 ? true: false
    }
    
    
}


extension String{
    var isValidPhoneString: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 ? true: false
    }
    
   
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
//
//  UITextField+Extension.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation
import UIKit





extension UITextField
{

    func addInputViewDatePicker(target: Any, selector: Selector,datePickerMode: UIDatePicker.Mode = .dateAndTime,maximunDate: Date? = nil, minimumDate: Date? = nil) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    if #available(iOS 13.4, *) {
        datePicker.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -110
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 0
        
        datePicker.datePickerMode = datePickerMode
        
       // maximunDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())

        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())//maximunDate
        if minimumDate == nil
        {
            datePicker.minimumDate = minDate
        }
        
       
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

    
    func addInputViewDatePicker2(target: Any, selector: Selector,datePickerMode: UIDatePicker.Mode = .dateAndTime,maximunDate: Date? = nil, minimumDate: Date? = Date()) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    if #available(iOS 13.4, *) {
        datePicker.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
      
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = 121
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 0
        
        datePicker.datePickerMode = datePickerMode
        datePicker.minimumDate = currentDate
       
            datePicker.maximumDate = maxDate
        
        
       
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
    
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }
    func addInputViewTimePicker(target: Any, selector: Selector,datePickerMode: UIDatePicker.Mode = .time,maximunDate: Date? = nil, minimumDate: Date? = nil) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    if #available(iOS 13.4, *) {
        datePicker.preferredDatePickerStyle = .wheels
    } else {
        // Fallback on earlier versions
    }
        
//        let currentDate = Date()
//        var dateComponents = DateComponents()
//        let calendar = Calendar.init(identifier: .gregorian)
//        dateComponents.year = -121
//        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
//        dateComponents.year = 0
//
        datePicker.datePickerMode = datePickerMode
//        datePicker.maximumDate = maximunDate
//
        datePicker.minimumDate = Date()
      
        
       
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

    
    
    
    
    
    
    
    
   @objc func cancelPressed()
   {
     self.resignFirstResponder()
   }
}



class customTextField:UITextField
{
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


class langField: UITextField {
    var languageCode:String? {
        didSet {
            if self.isFirstResponder {
                self.resignFirstResponder()
                self.becomeFirstResponder()
            }
        }
    }

    override var textInputMode: UITextInputMode? {
        if let language_code = self.languageCode {
            for keyboard in UITextInputMode.activeInputModes
            {
                if let language = keyboard.primaryLanguage {
                    let locale = Locale.init(identifier: language)
                    if locale.languageCode == language_code {
                        return keyboard
                    }
                }
            }
        }
        return super.textInputMode
    }
}

//public extension UITextField
//{
//    // ⚠️ Prefer english keyboards
//    //
//    override var textInputMode: UITextInputMode?
//    {
//        let locale = Locale(identifier: "en_US") // your preferred locale
//
//        return
//            UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.languageCode })
//            ??
//            super.textInputMode
//    }
//}


//class CustomLanguageTextField: UITextField {
//
//    // ru, en, ....
//    var languageCode:String?{
//        didSet{
//            if self.isFirstResponder{
//                self.resignFirstResponder();
//                self.becomeFirstResponder();
//            }
//        }
//    }
//
//    override var textInputMode: UITextInputMode?{
//        if let language_code = self.languageCode{
//            for keyboard in UITextInputMode.activeInputModes{
//                if let language = keyboard.primaryLanguage{
//                    let locale = Locale.init(identifier: language);
//                    if locale.languageCode == language_code{
//                        return keyboard;
//                    }
//                }
//            }
//        }
//        return super.textInputMode;
//    }
//}
