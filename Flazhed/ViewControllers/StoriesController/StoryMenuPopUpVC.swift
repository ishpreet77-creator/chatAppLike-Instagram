//
//  StoryMenuPopUpVC.swift
//  Flazhed
//
//  Created by IOS22 on 05/01/21.
//

import UIKit

protocol threeDotMenuDelegate
{
    func ClickNameAction(name:String)
    
}


class StoryMenuPopUpVC: BaseVC {
    

    @IBOutlet weak var viewProfileBUtton: UIButton!
    @IBOutlet weak var reportPostBUtton: UIButton!
    @IBOutlet weak var viewProfileButtonBGImage: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var delegate:threeDotMenuDelegate?
    var type: ScreenType = .storiesScreen
    var view_user_id = ""
    var post_id = ""
    var user_name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .messageScreen
        {
            viewProfileBUtton.setTitle("BLOCK AND REPORT", for: .normal)
            reportPostBUtton.setTitle("REMOVE MATCH", for: .normal)
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal) //= #colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        }
        else if type == .chatScreen
        {
           
            viewProfileBUtton.setTitle("PROLONG CHAT", for: .normal)
            reportPostBUtton.setTitle("DELETE CHAT", for: .normal)
            reportPostBUtton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
        }
  
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        self.dismiss(animated: true)
    }
    
    @IBAction func reportAct(_ sender: UIButton)
    {

        if type == .messageScreen
        {

            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "StoryDiscardVC") as!  StoryDiscardVC
            destVC.type = .blockRemoveAlert
            destVC.User_Id=self.view_user_id
            destVC.User_Name=self.user_name
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
            
        }
        else if type == .chatScreen
        {
          
            //delete alert
            let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "DeleteAccountPopUpVC") as!  DeleteAccountPopUpVC
            destVC.comeFrom = kChat
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
           
        }
        else{
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
           // var vc = storyboard.instantiateViewController(withIdentifier: "BlockReportPopUpVC") as!  StoriesVC
            let destVC = storyboard.instantiateViewController(withIdentifier: "BlockReportPopUpVC") as!  BlockReportPopUpVC
            destVC.postID=self.post_id
            destVC.user_name=self.user_name
            destVC.UserID=self.view_user_id
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(destVC, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func viewProfileAct(_ sender: UIButton)
    {
        if type == .messageScreen
        {
            let storyboard: UIStoryboard = UIStoryboard(name: "Stories", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "BlockReportPopUpVC") as!  BlockReportPopUpVC
            destVC.type = .messageScreen
            destVC.UserID=self.view_user_id
            destVC.user_name=self.user_name
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(destVC, animated: true, completion: nil)
            
        }else if type == .chatScreen{
            let storyboard: UIStoryboard = UIStoryboard(name: "Account", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "RegretPopUpVC") as!  RegretPopUpVC
            destVC.type = .Prolong
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
        }
        else{
            self.dismiss(animated: false) {
                self.delegate?.ClickNameAction(name: kViewProfile)
            }
         
        }
        
    }
}
// MARK:- Extension Api Calls
extension StoryMenuPopUpVC
{
    //MARK:-  shake user like
    
    func likeUnlikeAPI(other_user_id:String,action:String,like_mode:String,type:String)
    {
        var data = JSONDictionary()

        data[ApiKey.kOther_user_id] = other_user_id
        data[ApiKey.kAction] = action
        data[ApiKey.kLike_mode] = like_mode
        data[ApiKey.kTimezone] = TIMEZONE
       
            if Connectivity.isConnectedToInternet {
              
                self.callApiForLikeUnlike(data: data,type: type)
             } else {
                
                self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
        
    }
    
    func callApiForLikeUnlike(data:JSONDictionary,type:String)
    {
        HomeVM.shared.callApiForLikeUnlikeUser(data: data, response: { (message, error) in
            
            if error != nil
            {
               
                self.showErrorMessage(error: error)
               
            }
            else{
            }
        })
    }
}
