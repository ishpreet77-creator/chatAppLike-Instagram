//
//  PostHangoutVC.swift
//  Flazhed
//
//  Created by IOS22 on 08/01/21.
//

import UIKit
import SkeletonView

//import CLImageEditor
import IQKeyboardManagerSwift

//MARRK:- First vc to create hangout

class PostHangoutVC: BaseVC, UITextViewDelegate {
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var hangoutTypeLbl: UILabel!
    @IBOutlet weak var scrollPost: UIScrollView!
    @IBOutlet weak var btnAddimg: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var viewhangoutHeading: UIView!
    @IBOutlet weak var lblHangoutImg: UILabel!
    
    @IBOutlet weak var viewHangoutType: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var descHeightConst: NSLayoutConstraint!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtHeading: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
   
    @IBOutlet weak var imgView: UIImageView!
    var hangoutImage = UIImage()
    
    var HangoutDetail:HangoutDataModel?
    var fromEdit = false
    @IBOutlet weak var topConst: NSLayoutConstraint!
    var imageData = Data()
    
    
    var comeFrom = ""
    var view_user_id = ""
    var hangout_id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDesc.text = "Description"
        txtDesc.textColor = PLACEHOLDERCOLOR
        txtDesc.delegate = self
        self.imgView.image = UIImage(named: "NewAddImage")
   
        self.scrollPost.delegate=self
        if comeFrom.equalsIgnoreCase(string: kAppDelegate)
        {
            self.callGetHangoutDetailApi(hangoutId: hangout_id)
        }
        else
        {
            setUI()
        }
        
      
    }
    
    
    func setUI()
    {
        self.tabBarController?.tabBar.isHidden = true
        // setcolor
        lblHangoutImg.textColor = PURPLECOLOR
        hangoutTypeLbl.textColor = PURPLECOLOR
        headingLbl.textColor = PURPLECOLOR
        descriptionLbl.textColor = PURPLECOLOR
        lblHangoutImg.text = kHangoutImahe
        hangoutTypeLbl.text = kHangouttype
        headingLbl.text = kHeading
        descriptionLbl.text = kDESCRIPTION
        btnNext.setTitle(kNEXT, for: .normal)
  
        txtType.attributedPlaceholder = NSAttributedString(string:"Hangout Type", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
        txtHeading.attributedPlaceholder = NSAttributedString(string:"Heading", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
        txtType.delegate = self
        txtHeading.delegate = self
        txtDesc.delegate = self

        if fromEdit
        {
            self.hangout_id=self.HangoutDetail?._id ?? kEmptyString
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
              //let url = URL(string: img)!
              DispatchQueue.main.async {
                  self.imgView.setImage(imageName: img, isStory: false, isHangout: true)//.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
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
       
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
        
        if self.comeFrom.equalsIgnoreCase(string: kAppDelegate)
        {
           
//            let vc = OldTapControllerVC.instantiate(fromAppStoryboard: .Main)
//            vc.selectedIndex=0
//            self.navigationController?.pushViewController(vc, animated: true)
            self.goToHangout()

        }
        else //if self.appdel.equalsIgnoreCase(string: kMessage)
        {
            DataManager.comeFrom=kViewProfile
            DataManager.fromHangout=kCreate
            self.navigationController?.popViewController(animated: true)

        }
    
       
    }
    
    @IBAction func addImageAct(_ sender: UIButton)
    {
        self.showImagePicker(showVideo: false, showDocument: false)
        
        CustomImagePickerView.sharedInstace.delegate = self
    }
    
    
    @IBAction func nextAct(_ sender: UIButton)
    {
        debugPrint(view.selectedTextField)
        
        if view.selectedTextField == self.txtType
        {
            self.txtType.endEditing(true)
        }
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
     
        else
        {
          
            let vc = CreateHangoutVC.instantiate(fromAppStoryboard: .Hangouts)

            if self.fromEdit
            {
                vc.HangoutDetail=self.HangoutDetail
                vc.imageData = self.imgView.image?.jpegData(compressionQuality: 1) ?? Data()
            }
            else
            {
                vc.imageData = self.imageData
            }
            vc.fromEdit=self.fromEdit
            
            vc.hangoutType=self.txtType.text!
            vc.hangoutHeading=self.txtHeading.text!
            vc.hangoutDesc=self.txtDesc.text!
            //self.imgView.image?.jpegData(compressionQuality: 1) ?? Data()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
   
    
    func showLoader()
    {
        
        self.btnAddimg.clipsToBounds=true
        self.lblHangoutImg.clipsToBounds=true
        self.imgView.clipsToBounds=true
        self.viewDesc.clipsToBounds=true
        self.viewhangoutHeading.clipsToBounds=true
        self.viewHangoutType.clipsToBounds=true
        self.btnNext.clipsToBounds=true

        self.btnAddimg.showAnimatedGradientSkeleton()
        self.lblHangoutImg.showAnimatedGradientSkeleton()
        self.imgView.showAnimatedGradientSkeleton()
        self.viewDesc.showAnimatedGradientSkeleton()
        self.viewhangoutHeading.showAnimatedGradientSkeleton()
        self.viewHangoutType.showAnimatedGradientSkeleton()
        self.btnNext.showAnimatedGradientSkeleton()
    

    }
    func hideLoader()
    {
        
        self.btnAddimg.hideSkeleton()
        self.lblHangoutImg.hideSkeleton()
        self.imgView.hideSkeleton()
        self.viewDesc.hideSkeleton()
        self.viewhangoutHeading.hideSkeleton()
        self.viewHangoutType.hideSkeleton()
        self.btnNext.hideSkeleton()
    

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
        if Connectivity.isConnectedToInternet {
                       
            self.showImageCheckLoader(vc: self)

    debugPrint("Image details: = \(image)")
        let dataImage1 =  image.jpegData(compressionQuality: 1) ?? Data()
        let imageSize1: Int = dataImage1.count
        let size = Double(imageSize1) / 1000.0
        var  dataImage = Data()
          
            if size>500
                    {
                        dataImage =  image.jpegData(compressionQuality: kImageCompressGreaterThan500) ?? Data()
                    }
                    else
                    {
                        dataImage =  image.jpegData(compressionQuality: kImageCompressLessThan500) ?? Data()
                    }
            /*
        if size>1500
        {
            dataImage =  image.jpegData(compressionQuality: 0.03) ?? Data()
        }
        else if size>1000
        {
            dataImage =  image.jpegData(compressionQuality: 0.04) ?? Data()
        }
        
        else if size>500
        {
         dataImage =  image.jpegData(compressionQuality: 0.05) ?? Data()
        }
      else if size>100
       {
        dataImage =  image.jpegData(compressionQuality: 0.2) ?? Data()
       }
      else if size>50
       {
        dataImage =  image.jpegData(compressionQuality: 0.5) ?? Data()
       }
        else
       {
        dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
       }
        debugPrint("actual size of image in KB: %f ", Double(imageSize1) / 1000.0)
            
            */
        self.imageData = dataImage

       // var imageSize: Int = dataImage.count
       // debugPrint("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        
//        if image.size.height > SCREENHEIGHT
//        {
//            let image2 = (self.resizeImage(image: image, targetSize: CGSize(width: SCREENWIDTH, height: SCREENHEIGHT)))
//            dataImage =  image2.jpegData(compressionQuality: 0.7) ?? Data()
//        }
//        else
//        {
//            dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
//        }
        
        
   
        
       
        
        
        //let dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
        
        
         APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
             
             (responseDict) in
             debugPrint(responseDict)
            let data =   self.parseImageCheckData(response: responseDict)

            if kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")
             {
                //self.dismiss(animated: true, completion: nil)

                let weapon = data?.weapon ?? 0.0
                let drugs = data?.drugs ?? 0.0
                let partial = data?.nudity?.partial ?? 0.0
                if weapon>kNudityCheck || drugs>kNudityCheck || partial>kNudityCheck
                {
                    self.dismiss(animated: true) {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                    }
                }
                else
                {
                   self.dismiss(animated: true, completion: nil)
                   self.imgView.image = image
                }
                /*
                 debugPrint(data)
                 if data?.weapon ?? 0.0 > kNudityCheck
                 {
                    self.dismiss(animated: true) {
 self.dismiss(animated: true)
                        {
                        self.openSimpleAlert(message: kImageCkeckAlert)

                    }
                    }
                 }
//                 else if  data?.alcohol ?? 0.0 > kNudityCheck
//                 {
//                     self.openSimpleAlert(message: kImageCkeckAlert)
//                 }
                 else if  data?.drugs ?? 0.0 > kNudityCheck
                 {
                    self.dismiss(animated: true) {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                    }
                 }
                 else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
                 {
                    self.dismiss(animated: true) {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                    }
                 }
                
                */
                
                 
             }
             else
             {
                self.dismiss(animated: true, completion: nil)

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
            self.dismiss(animated: true, completion: nil)

             debugPrint(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
             
         })
           
        } else {
            
            self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
        }
           
    }
    
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtType
        {
           
            
            var index = 0
            if let unit = textField.text {
                index = kHangoutType.firstIndex(where: {$0 == unit}) ?? 0
            }
                 pickerDelegate=self
      
            setPickerView(textField: textField, array: kHangoutType, selectedIndex: index)
           // self.callGetHangoutLimitApi()
        }
      
        
    }
    
  
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        //debugPrint(#function)
       // debugPrint(reason)
        
        if textField == self.txtType
        {
                if self.fromEdit
                {
                    self.callGetHangoutLimitApi(hangoutId: hangout_id)
                }
            else
            {
                
                self.callGetHangoutLimitApi()
            }
            
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

extension PostHangoutVC:PickerDelegate,UIScrollViewDelegate
{

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        debugPrint(#function)
        self.txtType.endEditing(true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint(#function)
    }
    func didSelectItem(at index: Int, item: String) {
        
        debugPrint("didSelectItem \(index) \(item)")
        
//        if self.fromEdit
//        {
//            self.callGetHangoutLimitApi(hangoutId: hangout_id)
//        }
//    else
//    {
//        self.callGetHangoutLimitApi()
//    }
    }
}

extension PostHangoutVC { //CLImageEditorDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == self.txtType
        {
            debugPrint(textField.text!)
            self.txtType.text=textField.text!

        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
//    func imageEditorDidCancel(_ editor: CLImageEditor!) {
//        debugPrint(#function)
//        self.imageCheck(image: self.hangoutImage)
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!)
//    {
//        debugPrint(#function)
//
//        debugPrint(image)
//        self.hangoutImage =  image
//
//        self.dismiss(animated: true) {
//            self.imageCheck(image: self.hangoutImage)
//        }
//    }
    
  //  func imageCheck(image:UIImage)
//    {
//        self.showImageCheckLoader(vc: self)
//
//        var dataImage  = Data()
//
//        if image.size.height > SCREENHEIGHT
//        {
//            let image2 = (self.resizeImage(image: image, targetSize: CGSize(width: SCREENWIDTH, height: SCREENHEIGHT)))
//            dataImage =  image2.jpegData(compressionQuality: 1) ?? Data()
//        }
//        else
//        {
//            dataImage =  image.jpegData(compressionQuality: 1) ?? Data()
//        }
//
//
//
//
//        debugPrint("Image details 2: = \(image)")
//
//
//        //let dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
//
//         APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
//
//             (responseDict) in
//             debugPrint(responseDict)
//            let data =   self.parseImageCheckData(response: responseDict)
//
//             if responseDict[ApiKey.kStatus] as? String == kSucess
//             {
//                self.dismiss(animated: true, completion: nil)
//
//
//                 debugPrint(data)
//                 if data?.weapon ?? 0.0 > kNudityCheck
//                 {
//                     self.openSimpleAlert(message: kImageCkeckAlert)
//                 }
////                 else if  data?.alcohol ?? 0.0 > kNudityCheck
////                 {
////                     self.openSimpleAlert(message: kImageCkeckAlert)
////                 }
//                 else if  data?.drugs ?? 0.0 > kNudityCheck
//                 {
//                     self.openSimpleAlert(message: kImageCkeckAlert)
//                 }
//                 else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
//                 {
//                     self.openSimpleAlert(message: kImageCkeckAlert)
//                 }
//                 else
//                 {
//                    self.imgView.image = image
//                 }
//
//             }
//             else
//             {
//                self.dismiss(animated: true, completion: nil)
//
////                let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
////               if  data?.error?.message != ""
////               {
////
////                   self.openSimpleAlert(message:  data?.error?.message)
////               }
////               else
////               {
////                   self.openSimpleAlert(message: message)
////               }
//             }
//
//
//
//         },  failureCallback: { (errorReason, error) in
//            self.dismiss(animated: true, completion: nil)
//
//             debugPrint(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
//
//         })
//    }
}


// MARK:- Extension Api Calls
extension PostHangoutVC
{
    
    func callGetHangoutDetailApi(hangoutId: String)
    {
      
        var data = JSONDictionary()
        data[ApiKey.kHangout_id] = hangoutId
            
            if Connectivity.isConnectedToInternet {
           
                self.callApiForHangoutDetail(data: data)
             } else {
          
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForHangoutDetail(data:JSONDictionary)
    {
        self.showLoader()
        HangoutVM.shared.callApiGetHangoutDetail(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.hideLoader()
                self.showErrorMessage(error: error)
            }
            else
            {
            
                self.HangoutDetail=HangoutVM.shared.hangoutDetail?.hangout_details
                
                self.setUI()
                self.hideLoader()
            }
        })
    }
    
    
    func callGetHangoutLimitApi(hangoutId: String=kEmptyString)
    {
      
        var data = JSONDictionary()
        data[ApiKey.kHangout_type] = self.txtType.text ?? kSocial
        data[ApiKey.kTimezone] = TIMEZONE
       
        if self.fromEdit
        {
            data[ApiKey.kAction_type] = "Change"
            data[ApiKey.kHangout_id] = hangoutId
        }
        else
        {
            data[ApiKey.kAction_type] = "Addition"
        }
        
            if Connectivity.isConnectedToInternet {
           
                self.callApiForHangoutLimt(data: data)
             } else {
          
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForHangoutLimt(data:JSONDictionary)
    {
   
        HangoutVM.shared.callApiGetHangoutLimit(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.txtType.endEditing(true)
             
                if self.fromEdit
                {
                    self.txtType.text = self.HangoutDetail?.hangout_type
                }
                else
                {
                    self.txtType.text = kEmptyString
                }
                
                
                self.showNewErrorMessage(error: error)
            }
            else
            {
              
            }
        })
    }
    
    func showNewErrorMessage(error:Error?)
    {

        let code = (error! as NSError).code
      debugPrint("ERROR CODE \(code)")
    
   
   if code == 408
   {
       let message = (error! as NSError).userInfo[ApiKey.kMessage] as? String ?? kSomethingWentWrong
       let vc = DeleteAccountPopUpVC.instantiate(fromAppStoryboard: .Account)
       vc.comeFrom = kRunningOut
       vc.message=message
       vc.messageTitle=kHangoutTypes
       vc.delegate=self
       vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
       vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
       if let tab = self.tabBarController
       {
           tab.present(vc, animated: true, completion: nil)
       }
       else
       {
           self.present(vc, animated: true, completion: nil)
       }
       
   }
   else
   {
       self.showErrorMessage(error: error)
   }

}

}

extension PostHangoutVC:deleteAccountDelegate
{
   
    func deleteAccountFunc(name: String) {
        
        
        if name.equalsIgnoreCase(string: kRunningOut)
        {
    
            let destVC = NewPremiumVC.instantiate(fromAppStoryboard: .Account)
            destVC.type = .Hangout
            destVC.subscription_type=kHangout
          //  destVC.delegate=self
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
            if let tab = self.tabBarController
            {
                tab.present(destVC, animated: true, completion: nil)
            }
            else
            {
                self.present(destVC, animated: true, completion: nil)
            }
            
        }
    }



}
