//
//  GenderVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit

class GenderVC: BaseVC {
    
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgfemale: UIImageView!
    
    var imageArray1:[UIImage] = []
    var userName=""
    var userDOB=""
    var selectedGender = "Female"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    func setUpUI()
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lblOtpSent.text ?? "")
        attributedString.setColorForText(textForAttribute: "Let us know your ", withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "gender.", withColor: TEXTCOLOR)
     

        lblOtpSent.attributedText = attributedString
        
        self.setCustomHeader(title: "Gender", showBack: true, showMenuButton: false)
        
//        if self.getDeviceModel() == "iPhone 6"
//        {
//            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+20
//        }
//        else
//        {
//            self.topConst.constant = TOPSPACING+20
//        }
        
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
        
        self.imgfemale.image = UIImage(named: "femaleSelected")
        self.imgMale.image = UIImage(named: "maleUnselected")
            self.lblFemale.textColor = LINECOLOR
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    
    }
   
    
    @IBAction func maleAct(_ sender: UIButton)
    {
          
                if  self.imgMale.image == UIImage(named: "maleUnselected")
                {
                                self.imgMale.image = UIImage(named: "maleSelected")
                                self.lblMale.textColor = LINECOLOR
                                lblMale.font = UIFont(name: AppFontName.Semibold, size: 14)
                    
                    lblFemale.font = UIFont(name: AppFontName.regular, size: 14)
                    self.lblFemale.textColor = UIColor.black
                    self.imgfemale.image = UIImage(named: "femaleUnselected")
                    self.selectedGender = "Male"
                }
                else
                {
                    self.imgMale.image = UIImage(named: "maleUnselected")
                    self.lblMale.textColor = UIColor.black
                  lblMale.font = UIFont(name: AppFontName.regular, size: 14)
                    self.selectedGender = ""
                }
     
    }
    
    @IBAction func femaleAct(_ sender: UIButton)
    {
        
        
        if  self.imgfemale.image == UIImage(named: "femaleUnselected")
        {
                        self.imgfemale.image = UIImage(named: "femaleSelected")
                        self.lblFemale.textColor = LINECOLOR
                      //  self.lblFemale.textColor = UIColor.black
                        lblFemale.font = UIFont(name: AppFontName.Semibold, size: 14)
            
            lblMale.font = UIFont(name: AppFontName.regular, size: 14)
            self.lblMale.textColor = UIColor.black
            self.imgMale.image = UIImage(named: "maleUnselected")
            self.selectedGender = "Female"
            
        }
        else
        {
                        self.imgfemale.image = UIImage(named: "femaleUnselected")
                        self.lblFemale.textColor = UIColor.black
                lblFemale.font = UIFont(name: AppFontName.regular, size: 14)
            self.selectedGender = ""
        }
        

    }
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVoiceVC") as! AddVoiceVC
            vc.userName=self.userName
            vc.imageArray1=self.imageArray1
            vc.userDOB=self.userDOB
            vc.userGender = self.selectedGender
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
     
    }
    
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
        if selectedGender == "" {
            return kEmptyGenderAlert
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
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+TOPLABELSAPACING
        }
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+TOPLABELSAPACING
        }
        
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
    }
   

}


