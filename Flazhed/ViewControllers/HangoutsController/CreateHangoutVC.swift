//
//  CreateHangoutVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//

import UIKit
import SwiftRangeControl
import IQKeyboardManagerSwift
import CoreLocation
class CreateHangoutVC: BaseVC {

    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var addDescConst: NSLayoutConstraint!
    @IBOutlet weak var lblRange: UILabel!
   
    @IBOutlet weak var txtAdditionDes: UITextView!
    @IBOutlet weak var txtPlace: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!

    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgfemale: UIImageView!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var slider: RangeSlider!
    
    var lowerValue = String()
    var higherValue = String()
    var HangoutDetail:HangoutDataModel?
    var fromEdit = false
    var hangoutId = ""
    var hangoutType = ""
    var hangoutHeading = ""
    var hangoutDesc = ""
    var hangoutLookingFor = kFemale
    var hangoutDate = ""
    var hangoutTime = ""
    var hangoutLat = ""
    var hangoutLong = ""
    
    var imageData = Data()
    let locationmanager = CLLocationManager()
    
    var lookingForArray:[String] = []
    
    var hanoutSelectedDate = ""
    var currentDate = ""
    var hangoutSelectedTime = Date()
    var hangoutSelectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        txtAdditionDes.delegate = self
        
        
        // Do any additional setup after loading the view.
        
        setUI()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        let date2 = dateFormatter.string(from: Date())
        currentDate=date2
    }
    
    func setUI()
    {
        
     
        
        txtDate.attributedPlaceholder = NSAttributedString(string:"Date", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
        txtTime.attributedPlaceholder = NSAttributedString(string:"Time", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
        
        txtPlace.attributedPlaceholder = NSAttributedString(string:"Place", attributes:[NSAttributedString.Key.foregroundColor: TEXTFILEDPLACEHOLDERCOLOR,NSAttributedString.Key.font :UIFont(name: AppFontName.regular, size: 14)!])
    
        txtAdditionDes.delegate=self
     
        txtDate.tag = 0
        
        
       self.txtTime.delegate=self
      self.txtDate.delegate=self
        
        txtTime.tag = 1
       
        if fromEdit
        {
            txtDate.text=self.HangoutDetail?.date
            txtTime.text=self.HangoutDetail?.time
            txtPlace.text=self.HangoutDetail?.place
            
            
            txtAdditionDes.text=self.HangoutDetail?.aditional_description
            
            if let desc = self.HangoutDetail?.aditional_description
            {
                if desc.count>40
                {
                    self.addDescConst.constant=83
                    self.txtAdditionDes.isScrollEnabled=true
                }
                else
                {
                    self.addDescConst.constant=33
                    self.txtAdditionDes.isScrollEnabled=false
                }
                txtAdditionDes.textColor = UIColor.black
            }
            else
            {
                self.addDescConst.constant=33
                self.txtAdditionDes.isScrollEnabled=false
                txtAdditionDes.text = kEmptyPlaceDescAlert
                txtAdditionDes.textColor = PLACEHOLDERCOLOR
            }
            
            
            if let lat = self.HangoutDetail?.latitude
            {
                self.hangoutLat="\(lat)"
            }
            if let long = self.HangoutDetail?.longitude
            {
                self.hangoutLong="\(long)"
            }
            
            self.slider.lowerValue=Double(self.HangoutDetail?.age_from ?? 18)
            self.slider.upperValue=Double(self.HangoutDetail?.age_to ?? kMaxAge)
            let lower = Int(self.slider.lowerValue)
            let uper = Int(self.slider.upperValue)
            
            self.lblRange.text = "\(lower)-\(uper)"
            
            if  kMale.equalsIgnoreCase(string: self.HangoutDetail?.looking_for ?? "")
            {
                self.imgMale.image = UIImage(named: "maleSelected")
                self.lblMale.textColor = LINECOLOR
                lblMale.font = UIFont(name: AppFontName.Semibold, size: 14)
                hangoutLookingFor = kMale
                self.lookingForArray.append(kMale)
                
                
                lblFemale.font = UIFont(name: AppFontName.regular, size: 14)
                self.lblFemale.textColor = UIColor.black
                self.imgfemale.image = UIImage(named: "femaleUnselected")
                
                
            }
            
            else if  kBothGender.equalsIgnoreCase(string: self.HangoutDetail?.looking_for ?? "")
            {
                self.imgfemale.image = UIImage(named: "femaleSelected")
                self.lblFemale.textColor = LINECOLOR
                lblFemale.font = UIFont(name: AppFontName.Semibold, size: 14)
           
                
                self.imgMale.image = UIImage(named: "maleSelected")
                self.lblMale.textColor = LINECOLOR
                lblMale.font = UIFont(name: AppFontName.Semibold, size: 14)
               
                self.lookingForArray.append(kMale)
                self.lookingForArray.append(kFemale)
                hangoutLookingFor = kBothGender
            }
            
            else
            {
                self.imgfemale.image = UIImage(named: "femaleSelected")
                self.lblFemale.textColor = LINECOLOR
                lblFemale.font = UIFont(name: AppFontName.Semibold, size: 14)
                hangoutLookingFor = kFemale
                self.lookingForArray.append(kFemale)
                
                self.imgMale.image = UIImage(named: "maleUnselected")
                self.lblMale.textColor = UIColor.black
                    lblMale.font = UIFont(name: AppFontName.regular, size: 14)
            }
          
            
            
            
            if let time = self.HangoutDetail?.date
            {
              let time = time.dateFromString(format: .NewISO, type: .local)
                let date = time.string(format: .StoryDateFormat, type: .local)
                
                self.txtDate.text = date
            }
            if let time2 = self.HangoutDetail?.time
            {
                let time = time2.dateFromString(format: .NewISO, type: .local)
                let date = time.string(format: .localTime, type: .local)
                
            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                self.hangoutSelectedTime = dateFormatter.date(from: time2) ?? Date()
               
                
                
                self.txtTime.text = date
            }
            self.hanoutSelectedDate=self.txtDate.text!
            self.lbltitle.text = "Update Hangout"
            self.btnPost.setTitle("UPDATE", for: .normal)
        }
        else
        {
            self.imgfemale.image = UIImage(named: "femaleSelected")
            self.imgMale.image = UIImage(named: "maleUnselected")
                self.lblFemale.textColor = LINECOLOR
            lookingForArray.append(hangoutLookingFor)
            self.lbltitle.text = "Create Hangout"
            self.btnPost.setTitle("POST", for: .normal)
            txtAdditionDes.text = kEmptyPlaceDescAlert
            txtAdditionDes.textColor = PLACEHOLDERCOLOR
        }
        self.hangoutDate=txtDate.text!
        
        locationmanager.requestAlwaysAuthorization()
        locationmanager.delegate = self
        locationmanager.requestLocation()
        //locationmanager.startMonitoringSignificantLocationChanges()
        IQKeyboardManager.shared.enableAutoToolbar = true
        
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
        
      //  self.topConst.constant = STATUSBARHEIGHT
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//
//        if  STATUSBARHEIGHT == 0
//        {
//            self.topConst.constant = 40
//        }
//        else
//        {
//            self.topConst.constant = STATUSBARHEIGHT
//        }
        
        self.topConst.constant = STATUSBARHEIGHT
    }
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func LocationSelectAct(_ sender: UIButton)
    {
        let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        
        vc.oldLat=self.hangoutLat
        vc.oldLong=self.hangoutLong
        vc.oldAddress=self.txtPlace.text ?? ""
        vc.delegate=self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func postAct(_ sender: UIButton)
    {
        print(self.lookingForArray)
        
        var gender1=""
        var gender2=""
        
        if self.lookingForArray.count>0
        {
            gender1=self.lookingForArray[0]
            self.hangoutLookingFor=gender1
        }
        if self.lookingForArray.count>1
        {
            gender2=self.lookingForArray[1]
            
            self.hangoutLookingFor=kBothGender
        }
        print(hangoutLookingFor)
     
        
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            var data = JSONDictionary()
             data[ApiKey.kHangout_type] = self.hangoutType
            data[ApiKey.kHeading] = self.hangoutHeading
            data[ApiKey.kDescription] = self.hangoutDesc
            data[ApiKey.kHangout_type] = self.hangoutType
            
            
        
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, yyyy"
            let date = dateFormatter.date(from: self.txtDate.text!) ?? Date()
           
          let dateFormatter2 = DateFormatter()
          dateFormatter2.dateFormat = "yyyy-MM-dd"
          let hangDate=dateFormatter2.string(from: date)
            
            let time2 = hangDate.dateFromString(format: .StoryDateFormat, type: .local)
            let date12 = time2.string(format: .ymdDate, type: .gmt)
            
            
            data[ApiKey.kDate] = hangDate
            
                let dateFormatter3 = DateFormatter()
                dateFormatter3.dateFormat = "hh:mm a"
                dateFormatter3.timeZone = TimeZone.current
                dateFormatter3.locale = NSLocale(localeIdentifier: "en_US") as Locale
                
                
                let time = dateFormatter3.date(from: self.txtTime.text!) ?? Date()
                let dateFormatter4 = DateFormatter()
                dateFormatter4.dateFormat = "HH:mm:ss"
                let hangTime = dateFormatter4.string(from: time)
                data[ApiKey.kTime] = hangTime

            data[ApiKey.kPlace] = self.txtPlace.text!
            
            if self.txtAdditionDes.text==kEmptyPlaceDescAlert
            {
                data[ApiKey.kAditional_description] = ""
            }
          else
            {
                data[ApiKey.kAditional_description] = self.txtAdditionDes.text!
            }
           
                data[ApiKey.kLooking_for] = self.hangoutLookingFor
      
            data[ApiKey.kAge_from] = "\(Int(self.slider.lowerValue))"//self.lblRange.text!
            data[ApiKey.kAge_to] = "\(Int(self.slider.upperValue))"
        
            data[ApiKey.kTimezone] = TIMEZONE
            data[ApiKey.kLatitude] = self.hangoutLat
            data[ApiKey.kLongitude] = self.hangoutLong
            
            print(data)
                if Connectivity.isConnectedToInternet
                {
                    if fromEdit
                    {
                        self.UpdateHangoutApi(image: self.imageData, data: data, HangoutId: self.HangoutDetail?._id ?? "")
                    }
                    else
                    {
                        self.CreateHangoutApi(image: self.imageData, data: data)
                    }

                } else {

                    self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
                }
//
        }
        
        
 
    }
    @IBAction func maleAct(_ sender: UIButton)
    {

        if  self.imgMale.image == UIImage(named: "maleUnselected")
        {
                        self.imgMale.image = UIImage(named: "maleSelected")
                        self.lblMale.textColor = LINECOLOR
                        lblMale.font = UIFont(name: AppFontName.Semibold, size: 14)
   
            hangoutLookingFor = kMale
         
            if !self.lookingForArray.contains((kMale))
            {
                self.lookingForArray.append((kMale))
            }
        }
        else
        {
            self.imgMale.image = UIImage(named: "maleUnselected")
            self.lblMale.textColor = UIColor.black
                lblMale.font = UIFont(name: AppFontName.regular, size: 14)
            hangoutLookingFor = ""
 
            if let index = lookingForArray.firstIndex(of: kMale)
            {
                lookingForArray.remove(at: index)
            }

        }
        
     
    }
    
    @IBAction func femaleAct(_ sender: UIButton)
    {

        if  self.imgfemale.image == UIImage(named: "femaleUnselected")
        {
                        self.imgfemale.image = UIImage(named: "femaleSelected")
                        self.lblFemale.textColor = LINECOLOR
                 
                        lblFemale.font = UIFont(name: AppFontName.Semibold, size: 14)

            hangoutLookingFor = kFemale
            
            if !self.lookingForArray.contains(kFemale)
            {
                self.lookingForArray.append(kFemale)
            }
        }
        else
        {
                        self.imgfemale.image = UIImage(named: "femaleUnselected")
                        self.lblFemale.textColor = UIColor.black
                        lblFemale.font = UIFont(name: AppFontName.regular, size: 14)
                        hangoutLookingFor = ""
            
            
            if let index = lookingForArray.firstIndex(of: kFemale)
            {
                lookingForArray.remove(at: index)
            }

        }
      
    }
    
    @objc func doneButtonPressed(_ sender:UITextField)
    {
          if let  datePicker = self.txtDate.inputView as? UIDatePicker
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM, yyyy"
                self.txtDate.text = dateFormatter.string(from: datePicker.date)
                
              let dateFormatter2 = DateFormatter()
              dateFormatter2.dateFormat = "yyyy-MM-dd"
            self.hangoutDate=dateFormatter2.string(from: datePicker.date)
            self.hanoutSelectedDate=self.txtDate.text!
            }
       
        self.txtDate.resignFirstResponder()
     
      
    }
    @objc func doneButtonPressed2(_ sender:UITextField)
    {
        if let  datePicker = self.txtTime.inputView as? UIDatePicker
       {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "hh:mm a"
           var time = dateFormatter.string(from: datePicker.date)

            self.txtTime.text=time
           self.hangoutSelectedTime = dateFormatter.date(from: time) ?? Date()
           
           
           let dateFormatter2 = DateFormatter()
           dateFormatter2.dateFormat = "hh:mm:ss"
         self.hangoutTime=dateFormatter2.string(from: datePicker.date)

       }
      
   
    self.txtTime.resignFirstResponder()
    }

    @IBAction func ageSliderAction(_ sender: RangeSlider) {

        if (slider.upperValue-slider.lowerValue)<=5
        {
            if slider.maximumValue<=105
            {
                self.slider.upperValue = (slider.upperValue+5)
            }
            else if slider.maximumValue<=23
            {
                self.slider.upperValue = (slider.upperValue+5)
            }
            else
            {
                self.slider.upperValue = (slider.upperValue)
            }
            
            if slider.lowerValue>=105
            {
                self.slider.lowerValue = (slider.lowerValue-5)
            }
           else if slider.lowerValue<=5
            {
                //self.ageSlider.lowerValue = (ageSlider.lowerValue+5)
            }
            else
            {
                self.slider.lowerValue = (slider.lowerValue)
            }
          
        }
        if (slider.upperValue-slider.lowerValue)<=5
        {
            if (slider.lowerValue+5)>=18 && (slider.lowerValue+5)<=23
            {

                self.slider.lowerValue = (slider.lowerValue+5)
               
                    self.slider.upperValue = slider.lowerValue+5
            }
            else
            {
                if self.slider.upperValue>23
                {
                    self.slider.lowerValue = self.slider.upperValue-5
                    self.slider.upperValue = self.slider.upperValue
                }
                else
                {
                self.slider.lowerValue = 18
                self.slider.upperValue = 23
                }
            }
        }
        lowerValue = String(Int(slider.lowerValue))
        higherValue = String(Int(slider.upperValue))
        lblRange.text = "\(lowerValue)-\(higherValue)"
        

    }
    
    
 
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
 
        if txtDate.isEmpty {
            return kEmptyHangoutDateAlert
        }
        if txtTime.isEmpty {
            return kEmptyHangoutTimeAlert
        }
        if txtPlace.isEmpty {
            return kEmptyHangoutPlaceAlert
        }
        if hangoutLookingFor.isEmpty {
            return kEmptyLookingForAlert
        }
    
        return nil
     }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == PLACEHOLDERCOLOR {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Additional Description (optional)"
            textView.textColor = PLACEHOLDERCOLOR
        }
    }
    
    
}
extension CreateHangoutVC: UITextFieldDelegate,UITextViewDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == txtDate {

            setDatePicker2(textField: textField, datePickerMode: .date, maximunDate: nil, minimumDate: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, yyyy" 
            let date = dateFormatter.date(from: textField.text!) ?? Date()
            
            self.hangoutSelectedDate=date
        }
        else if textField == txtTime
        {
            setDatePicker3(textField: textField, datePickerMode: .time, maximunDate: nil, minimumDate: Date())
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        
        if numberOfChars>40
        {
            self.addDescConst.constant=83
            self.txtAdditionDes.isScrollEnabled=true
        }
        else
        {
            self.addDescConst.constant=33
            self.txtAdditionDes.isScrollEnabled=false
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
extension CreateHangoutVC:SelectedAddressDelegate
{
    func selectedAddress(address: String, lat: String, long: String) {
        self.txtPlace.text=address
        self.hangoutLat=lat
        self.hangoutLong=long
    }
    
}

extension CreateHangoutVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first
           {
               print("Found user's location: \(location)")
            CURRENTLAT=location.coordinate.latitude
            CURRENTLONG=location.coordinate.longitude
          
           }
       }

       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
       {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
}

// MARK:- Extension Api Calls

extension CreateHangoutVC
{

    
    func CreateHangoutApi(image : Data, data: JSONDictionary)
    {
        APIManager.callApiForImage(image1: image, imageParaName1: ApiKey.kImage, api: "create-hangout", data: data) { (responseDict) in
            print(responseDict)

            if  kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")
            {
//                let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "MyHangoutVC") as! MyHangoutVC
//                vc.fromCreateHangout=true
//                DataManager.fromHangout=kCreate
//                vc.hagoutTYpe=self.hangoutType
//                self.navigationController?.pushViewController(vc, animated: true)
//
                
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
                vc.selectedIndex=0
                DataManager.comeFromTag=5
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                self.openSimpleAlert(message: message)
            }
            
        } failureCallback: { (errorReason, error) in
            print(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
            self.navigationController?.popViewController(animated: true)
        }

        
    }
    
    func UpdateHangoutApi(image : Data, data: JSONDictionary,HangoutId:String)
    {
        APIManager.callApiForImage(image1: image, imageParaName1: ApiKey.kImage, api: ("update-hangout/"+HangoutId), data: data) { (responseDict) in
            print(responseDict)

            if  kSucess.equalsIgnoreCase(string: responseDict[ApiKey.kStatus] as? String ?? "")
            {
//                let storyBoard = UIStoryboard.init(name: "Hangouts", bundle: nil)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "MyHangoutVC") as! MyHangoutVC
//                vc.fromCreateHangout=true
//                vc.hagoutTYpe=self.hangoutType
//                DataManager.fromHangout=kCreate
//                self.navigationController?.pushViewController(vc, animated: true)
                
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TapControllerVC") as! TapControllerVC
                vc.selectedIndex=0
                DataManager.comeFromTag=5
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                self.openSimpleAlert(message: message)
            }
            
        } failureCallback: { (errorReason, error) in
            print(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
            self.navigationController?.popViewController(animated: true)
        }

        
    }
    
}
