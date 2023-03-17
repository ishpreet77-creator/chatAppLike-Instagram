//
//  GenderVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit

class GenderVC: BaseVC {
    
    @IBOutlet weak var lblLookingFor: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnMen: UIButton!
    @IBOutlet weak var viewWomen: UIView!
    @IBOutlet weak var viewMen: UIView!
    @IBOutlet weak var btnWomenLookingFor: UIButton!
    @IBOutlet weak var btnMenLookingFor: UIButton!
    @IBOutlet weak var viewWomenLookingFor: UIView!
    @IBOutlet weak var viewMenLookingFor: UIView!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtLookingFor: UITextField!

    var imageArray1:[UIImage] = []
    var userName=""
    var userDOB=""
    var userGender  = ""
    var userLookingFor = ""
    var userBirthDay  = ""
    var selectedLookingFor = kFemale
    var checkProfileAllValidation = true
    var fromTextField = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.checkProfileUpdateCounter()
        // Do any additional setup after loading the view.
        
        setUpUI()
    }
    
    func setUpUI()
    {
        
        //self.txtGender.delegate=self
        // self.txtLookingFor.delegate=self
        self.maleSeleted(gender: self.userGender)
        
        self.btnMen.setTitle(kMan1.localized(), for: .normal)
        self.btnWomen.setTitle(kWoman1.localized(), for: .normal)
        
        if DataManager.Language == LANG_CODE_DA
        {
            self.btnMenLookingFor.setTitle("Mænd", for: .normal)
            self.lblTitle.text = "Interesseret i?"
           
            self.lblLookingFor.text = "Jeg er interesseret i..."
        }
        else
        {
            self.btnMenLookingFor.setTitle("Men", for: .normal)
            self.lblTitle.text = "Interested In?"
            self.lblLookingFor.text = "Im interested in..."
        }
        
       
        self.btnWomenLookingFor.setTitle(kWomenShort.localized(), for: .normal)
        self.imgBackground.loadingGif(gifName: "backgound_Gif",placeholderImage: "NewLoginBackground")
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .normal)
        self.btnContinue.setTitle(self.btnContinue.titleLabel?.text?.uppercased(), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.enbleIQKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.validationNexButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
        self.disableIQKeyboard()
        
    }
    //MARK: - backBtnAction
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - genderSelectAction
    
    @IBAction func genderSelectAction(_ sender: UIButton) {
        
        if sender.tag == 0
        {
            self.maleSeleted(gender: kMale)
        }
        else
        {
            self.maleSeleted(gender: kFemale)
            
        }
    }
    
    //MARK: - genderSelectAction
    
    @IBAction func lookingForSelectAction(_ sender: UIButton) {
        
        if sender.tag == 0
        {
            self.lookingSeleted(gender: kMale)
        }
        else
        {
            self.lookingSeleted(gender: kFemale)
            
        }
    }
    
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        
        self.goToNext()
        
    }
    
    // MARK: - validateData Functions
    private func validateData () -> String?
    {
        if self.userGender.count == 0   { //&& self.checkProfileAllValidation
            return kEmptyGenderAlert
        }
        if  self.userLookingFor.count == 0  { //&& self.checkProfileAllValidation
            return kEmptyLookingForAlert
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
            //sendButtonConst.constant = keyboardHeight+26
        }
        else if self.getDeviceModel() == "iPhone 8+"
        {
            // self.topConst.constant = TOPSPACING+STATUSBARHEIGHT+TOPLABELSAPACING
        }
        else
        {
            // self.sendButtonConst.constant = keyboardHeight+26+TOPLABELSAPACING
        }
        
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
    }
    
    func goToNext()
    {
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
            let vc = AddVoiceVC.instantiate(fromAppStoryboard: .Main)
            vc.userName=self.userName
            vc.imageArray1=self.imageArray1
            vc.userDOB=self.userDOB
            vc.userGender = self.userGender
            DataManager.Selected_Gender=self.userGender
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func maleSeleted(gender:String)
    {
        
        if gender.equalsIgnoreCase(string: kFemale)
        {
            self.viewWomen.backgroundColor = ENABLECOLOR
            self.btnWomen.setTitleColor(UIColor.white, for: .normal)
            self.btnWomen.setTitleColor(UIColor.white, for: .selected)
            
            self.viewMen.backgroundColor = UIColor.white
            self.btnMen.setTitleColor(UIColor.black, for: .normal)
            self.btnMen.setTitleColor(UIColor.black, for: .selected)
            
            self.userGender = kFemale
        }
        else if gender.equalsIgnoreCase(string: kMale)
        {
            self.viewWomen.backgroundColor = UIColor.white
            self.btnWomen.setTitleColor(UIColor.black, for: .normal)
            self.btnWomen.setTitleColor(UIColor.black, for: .selected)
            
            self.viewMen.backgroundColor = ENABLECOLOR
            self.btnMen.setTitleColor(UIColor.white, for: .normal)
            self.btnMen.setTitleColor(UIColor.white, for: .selected)
            self.userGender = kMale
        }
        else
        {
            self.viewWomen.backgroundColor = UIColor.white
            self.btnWomen.setTitleColor(UIColor.black, for: .normal)
            self.btnWomen.setTitleColor(UIColor.black, for: .selected)
            
            self.viewMen.backgroundColor = UIColor.white
            self.btnMen.setTitleColor(UIColor.black, for: .normal)
            self.btnMen.setTitleColor(UIColor.black, for: .selected)
            self.userGender = kEmptyString
            
        }
        self.validationNexButton()
        
    }
    
    func lookingSeleted(gender:String)
    {
        
        if gender.equalsIgnoreCase(string: kFemale)
        {
            self.viewWomenLookingFor.backgroundColor = ENABLECOLOR
            self.btnWomenLookingFor.setTitleColor(UIColor.white, for: .normal)
            self.btnWomenLookingFor.setTitleColor(UIColor.white, for: .selected)
            
            self.viewMenLookingFor.backgroundColor = UIColor.white
            self.btnMenLookingFor.setTitleColor(UIColor.black, for: .normal)
            self.btnMenLookingFor.setTitleColor(UIColor.black, for: .selected)
            
            self.userLookingFor = kFemale
        }
        else if gender.equalsIgnoreCase(string: kMale)
        {
            self.viewWomenLookingFor.backgroundColor = UIColor.white
            self.btnWomenLookingFor.setTitleColor(UIColor.black, for: .normal)
            self.btnWomenLookingFor.setTitleColor(UIColor.black, for: .selected)
            
            self.viewMenLookingFor.backgroundColor = ENABLECOLOR
            self.btnMenLookingFor.setTitleColor(UIColor.white, for: .normal)
            self.btnMenLookingFor.setTitleColor(UIColor.white, for: .selected)
            self.userLookingFor = kMale
        }
        else
        {
            self.viewWomenLookingFor.backgroundColor = UIColor.white
            self.btnWomenLookingFor.setTitleColor(UIColor.black, for: .normal)
            self.btnWomenLookingFor.setTitleColor(UIColor.black, for: .selected)
            
            self.viewMenLookingFor.backgroundColor = UIColor.white
            self.btnMenLookingFor.setTitleColor(UIColor.black, for: .normal)
            self.btnMenLookingFor.setTitleColor(UIColor.black, for: .selected)
            self.userLookingFor = kEmptyString
        }
        self.validationNexButton()
        
    }
    
    //MARK: - validationNexButton
    
    func validationNexButton(count:Int=0)
    {
        debugPrint("text count = \(count) \(validateData())")
        if validateData() != nil
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
}

//MARK: - Textfiled, Textview and picker delegate

extension GenderVC:UITextFieldDelegate,UITextViewDelegate{
    
    
    
}

extension GenderVC
{
    func checkProfileUpdateCounter()
    {
        AccountVM.shared.callApiProfileValidationCounter(response: { (message, error) in
            if error != nil
            {
                //self.showErrorMessage(error: error)
            }
            else{
                
                let value = AccountVM.shared.User_Profile_Update_Counter_Data?.count ?? 0
                debugPrint("checkProfileUpdateCounter \(value)")
                if value == 1
                {
                    self.checkProfileAllValidation=true
                }
                else
                {
                    self.checkProfileAllValidation=false
                }
                
            }
            
            
        })
    }
}
