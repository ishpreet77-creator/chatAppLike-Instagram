//
//  StoryDiscardVC.swift
//  Flazhed
//
//  Created by IOS22 on 07/01/21.
//

import UIKit


protocol DiscardDelegate
{
    func ClickNameAction(name:String)
    
}


class StoryDiscardVC: BaseVC {
        
    @IBOutlet weak var backButtonImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnfirst: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    var delegate:DiscardDelegate?
    var type: ScreenType = .storyTab
    var User_Id = ""
    var User_Name = ""
    var postType = "Photo"
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if type == .blockRemoveAlert{
            lblMessage.numberOfLines = 1
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
            lblTitle.text = "Remove Match?"
            lblMessage.text = "Are you sure you want to remove this user? "
            btnfirst.setTitle("CANCEL", for: .normal)
            btnSecond.setTitle("YES, REMOVE", for: .normal)
            btnSecond.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
            
        }else if type == .continueChat{
            self.backButton.isHidden = false
            self.backButtonImage.isHidden = false
            lblMessage.numberOfLines = 0
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
            lblTitle.text = "Continue Chat?"
            
           // lblMessage.text = "Your chat with Chelsea has run out of time.\nYou have 5 hours 23 minutes to decide if\n you want to continue."
            
    
            
            let attrs1 = [NSAttributedString.Key.font : UIFont(name: AppFontName.regular, size: 17), NSAttributedString.Key.foregroundColor : UIColor.black]

            let attrs2 = [NSAttributedString.Key.font : UIFont(name: AppFontName.bold, size: 18), NSAttributedString.Key.foregroundColor : UIColor.black]

                let attributedString1 = NSMutableAttributedString(string:"Your chat with Chelsea has run out of time.You have", attributes:attrs1)

                let attributedString2 = NSMutableAttributedString(string:" 5 hours 23 minutes ", attributes:attrs2)

            let attributedString3 = NSMutableAttributedString(string:" to decide if you want to continue.", attributes:attrs1)
            
                attributedString1.append(attributedString2)
               attributedString1.append(attributedString3)
                self.lblMessage.attributedText = attributedString1
            
           
            
            btnfirst.setTitle("CONTINUE", for: .normal)
            btnSecond.setTitle("END CHAT", for: .normal)
         
            btnSecond.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.2901960784, blue: 0.2901960784, alpha: 1), for: .normal)
            
            
        }else if type == .delete{
            lblTitle.text = "Confirm Delete"
            lblMessage.text = "Are you sure you want to delete this post? "
        
            btnfirst.setTitle("DELETE POST", for: .normal)
            btnSecond.setTitle("CANCEL", for: .normal)
            lblMessage.numberOfLines = 1
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        else if type == .deleteHangout
        {
            lblTitle.text = "Confirm Delete"
            lblMessage.text = "Are you sure you want to delete this Hangout?"
        
            btnfirst.setTitle("DELETE HANGOUT", for: .normal)
            btnSecond.setTitle("CANCEL", for: .normal)
            lblMessage.numberOfLines = 0
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        
        else if type == .shakeSent
        {
            lblTitle.text = "Shake Sent"
            lblMessage.text = "Request has been sent to the nearby users. You will be able to see the list once they like your profile. Till then, do you want to Play Anonymous?"
        
            btnfirst.setTitle("PLAY ANONYMOUS", for: .normal)
            btnSecond.setTitle("CANCEL", for: .normal)
            lblMessage.numberOfLines = 0
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        
        else if type == .deleteStory{
            
            lblTitle.text = "Confirm Delete"
            lblMessage.text = "Are you sure you want to delete this Story?"
        
            btnfirst.setTitle("DELETE STORY", for: .normal)
            btnSecond.setTitle("CANCEL", for: .normal)
            lblMessage.numberOfLines = 1
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        
        
        
        else if type == .discardPost
        {
            lblTitle.text = "Discard \(postType)"
            lblMessage.text = "Are you sure you want to discard? This \(postType) has not been saved."
        
            btnfirst.setTitle("CONTINUE", for: .normal)
            btnSecond.setTitle("DISCARD", for: .normal)
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
        else if type == .ShareStory
        {
            lblTitle.text = "Post your story to Facebook"
            lblMessage.text = "Do you want to share this post on facebook?"
        
            btnfirst.setTitle("SHARE POST", for: .normal)
            btnSecond.setTitle("CANCEL", for: .normal)
            lblMessage.numberOfLines = 2
            lblMessage.font = UIFont(name: AppFontName.regular, size: 14)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        //self.dismiss(animated: true)
        
        if type  == .delete{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .deleteHangout{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .deleteStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .shakeSent{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .ShareStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            delegate?.ClickNameAction(name: kDiscard)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Discard Act
    
    @IBAction func reportAct(_ sender: UIButton)
    {
        if type  == .delete{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .deleteHangout{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .deleteStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .shakeSent{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .ShareStory{
            delegate?.ClickNameAction(name: kCancel)
            self.dismiss(animated: true, completion: nil)
        }
       else if type  == .blockRemoveAlert{
           // delegate?.ClickNameAction(name: kRemove)
           self.dismiss(animated: true) {
               self.likeUnlikeAPI(other_user_id: self.User_Id, action: "2", like_mode: "Shake", type: "Shake")
           }
        }
        else
        {
            delegate?.ClickNameAction(name: kDiscard)
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    //MARK:- continue Act
    //Delete post
    
    @IBAction func viewProfileAct(_ sender: UIButton)
    {
        if type  == .delete{
            delegate?.ClickNameAction(name: kDeletePost)
            self.dismiss(animated: true, completion: nil)
        }
        else if type  == .deleteHangout{
             delegate?.ClickNameAction(name: kDelete)
             self.dismiss(animated: true, completion: nil)
         }
        else if type  == .deleteStory{
             delegate?.ClickNameAction(name: kDelete)
             self.dismiss(animated: true, completion: nil)
         }
        else if type  == .ShareStory{
             delegate?.ClickNameAction(name: kShare)
             self.dismiss(animated: true, completion: nil)
         }
      

        else
        {
            delegate?.ClickNameAction(name: kContinue)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
//MARK:- Api call

extension StoryDiscardVC
{
    //MARK:-  user like
    
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
                if #available(iOS 13.0, *) {
                    SCENEDEL?.navigateToChat()
                } else {
                    // Fallback on earlier versions
                    APPDEL.navigateToChat()
                }
              
            }

         
        })
    }
    
}
