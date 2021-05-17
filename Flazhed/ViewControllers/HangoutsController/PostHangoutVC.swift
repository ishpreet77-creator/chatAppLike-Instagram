//
//  PostHangoutVC.swift
//  Flazhed
//
//  Created by IOS22 on 08/01/21.
//

import UIKit

import IQKeyboardManagerSwift

//MARRK:- First vc to create hangout

class PostHangoutVC: BaseVC, UITextViewDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var descHeightConst: NSLayoutConstraint!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtHeading: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
   
    @IBOutlet weak var imgView: UIImageView!
    var HangoutDetail:HangoutDataModel?
    var fromEdit = false
    @IBOutlet weak var topConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDesc.text = "Description"
        txtDesc.textColor = PLACEHOLDERCOLOR
        txtDesc.delegate = self
        self.imgView.image = UIImage(named: "NewcreateBack")
   
        setUI()
    }
    
    
    func setUI()
    {
  
        txtType.attributedPlaceholder = NSAttributedString(string:"Hangout Type", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
        txtHeading.attributedPlaceholder = NSAttributedString(string:"Heading", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
        txtType.delegate = self
        txtHeading.delegate = self
        txtDesc.delegate = self

        if fromEdit
        {
            self.txtType.text = self.HangoutDetail?.hangout_type
            self.txtHeading.text = self.HangoutDetail?.heading
            
            if let des = self.HangoutDetail?.description
            {
              
                    if des.count>40
                    {
                        self.descHeightConst.constant=143
                        self.txtDesc.isScrollEnabled=true
                    }
                    else
                    {
                        self.descHeightConst.constant=93
                        self.txtDesc.isScrollEnabled=false
                    }
                
            }
            else
            {
                self.descHeightConst.constant=93
                self.txtDesc.isScrollEnabled=false
            }
            self.txtDesc.text = self.HangoutDetail?.description
            
            if let img = self.HangoutDetail?.image
            {
              let url = URL(string: img)!
              DispatchQueue.main.async {
                self.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
              }
            }
            self.lblTitle.text = "Edit Hangout"
           
            txtDesc.textColor = UIColor.black
        }
        
        self.topConst.constant = STATUSBARHEIGHT
        
        IQKeyboardManager.shared.enableAutoToolbar = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if self.getDeviceModel() == "iPhone 6"
//        {
//            self.topConst.constant = STATUSBARHEIGHT+20
//        }
//        else if self.getDeviceModel() == "iPhone 8+"
//        {
//            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT
//        }
//        else
//        {
//            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT
//        }
       
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == PLACEHOLDERCOLOR {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = PLACEHOLDERCOLOR
        }
    }
    @IBAction func BackAct(_ sender: UIButton)
    {
        DataManager.comeFrom=kViewProfile
        DataManager.fromHangout=kCreate
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageAct(_ sender: UIButton)
    {
        self.showImagePicker(showVideo: false, showDocument: false)
        
        CustomImagePickerView.sharedInstace.delegate = self
    }
    
    
    @IBAction func nextAct(_ sender: UIButton)
    {
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "CreateHangoutVC") as! CreateHangoutVC
            if self.fromEdit
            {
                vc.HangoutDetail=self.HangoutDetail
            }
            vc.fromEdit=self.fromEdit
            
            vc.hangoutType=self.txtType.text!
            vc.hangoutHeading=self.txtHeading.text!
            vc.hangoutDesc=self.txtDesc.text!
            vc.imageData = self.imgView.image?.jpegData(compressionQuality: 1) ?? Data()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
   
    
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
      
        if self.imgView.image == UIImage(named: "NewcreateBack")
        {
            return kEmptyHangoutImageAlert
        }
        if txtType.isEmpty {
            return kEmptyHangoutTypeAlert
        }
        if txtHeading.isEmpty {
            return kEmptyHangoutHeadingAlert
        }
        if txtDesc.text.isEmpty || txtDesc.text == "Description" {
            return kEmptyHangoutDescAlert
        }
        if txtHeading.text?.count ?? 0 < 2 {
            return kMinHangoutHeadingAlert
        }
        if txtDesc.text?.count ?? 0 < 2 {
            return kMinHangoutDescAlert
        }
    
        return nil
     }

}
extension PostHangoutVC:CustomImagePickerDelegate,UITextFieldDelegate
{
    
    func didImagePickerFinishPicking(_ image: UIImage)
    {
        
    
        
        let dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
        
         APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
             
             (responseDict) in
             print(responseDict)
            let data =   self.parseImageCheckData(response: responseDict)

             if responseDict[ApiKey.kStatus] as? String == kSucess
             {
               
                 
                 print(data)
                 if data?.weapon ?? 0.0 > kNudityCheck
                 {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                 }
//                 else if  data?.alcohol ?? 0.0 > kNudityCheck
//                 {
//                     self.openSimpleAlert(message: kImageCkeckAlert)
//                 }
                 else if  data?.drugs ?? 0.0 > kNudityCheck
                 {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                 }
                 else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
                 {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                 }
                 else
                 {
                    self.imgView.image = image
                 }
                 
             }
             else
             {
//                let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
//               if  data?.error?.message != ""
//               {
//
//                   self.openSimpleAlert(message:  data?.error?.message)
//               }
//               else
//               {
//                   self.openSimpleAlert(message: message)
//               }
             }
             
             
             
         },  failureCallback: { (errorReason, error) in
             print(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
             
         })
                
    }
    
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtType
        {
           
            
            var index = 0
            if let unit = textField.text {
                index = kHangoutType.firstIndex(where: {$0 == unit}) ?? 0
            }
            setPickerView(textField: textField, array: kHangoutType, selectedIndex: index)
            
        }
        
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
            return newString.length <= maxLength
        }
        
   
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count 

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        
        
        if numberOfChars>40
        {
            self.descHeightConst.constant=143
            self.txtDesc.isScrollEnabled=true
        }
        else
        {
            self.descHeightConst.constant=93
            self.txtDesc.isScrollEnabled=false
        }
        
        if newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location == 0
        
        {
            return false
        }
        else
        {
        
        return numberOfChars <= 500;
        }
    }
}

extension PostHangoutVC {
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.txtType
        {
            print(textField.text!)
            self.txtType.text=textField.text!

        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
