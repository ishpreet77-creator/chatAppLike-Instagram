//
//  StorySortPopupVC.swift
//  Flazhed
//
//  Created by IOS22 on 14/01/21.
//

import UIKit

protocol storySortDelegate {
    func selectedOption()
}

class StorySortPopupVC: UIViewController {
    
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var imgImage: UIImageView!
    
    
    @IBOutlet weak var lblVideo: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    
    @IBOutlet weak var lblOnlyMatch: UILabel!
    @IBOutlet weak var imgOnlyMatch: UIImageView!
    
    
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    
    @IBOutlet weak var lblAllPost: UILabel!
    @IBOutlet weak var imgAllPost: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var delegate:storySortDelegate?
    
    var img = ""
    var video = ""
    var match = ""
    var myPost = ""
    var allPost = ""
    var didUpdate=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
       
            if DataManager.storyImageSelected=="1"
            {
                
                
                imgImage.image = UIImage(named: "SelectedCheck")
                self.lblImage.textColor = PURPLECOLOR
                self.img="1"
            }
            else
            {
                imgImage.image = UIImage(named: "unselectedCheck")
                self.lblImage.textColor = UIColor.black
                self.img="0"
            }
        
        if DataManager.storyVideoSelected=="1"
        {
          
            imgVideo.image = UIImage(named: "SelectedCheck")
            self.lblVideo.textColor = PURPLECOLOR
            self.video="1"
        }
        else
        {
            imgVideo.image = UIImage(named: "unselectedCheck")
            self.lblVideo.textColor = UIColor.black
            self.video="0"
        }
        
        if DataManager.storyMyPostSelected=="1"
        {
           
            
            imgPost.image = UIImage(named: "SelectedCheck")
            self.lblPost.textColor = PURPLECOLOR
            self.myPost="1"
        }
        else
        {
            imgPost.image = UIImage(named: "unselectedCheck")
            self.lblPost.textColor = UIColor.black
            self.myPost="0"
        }
    
        
        if DataManager.storyMatchSelected=="1"
        {
          
            
            imgOnlyMatch.image = UIImage(named: "SelectedCheck")
            self.lblOnlyMatch.textColor = PURPLECOLOR
            self.match="1"
        }
        else
        {
            imgOnlyMatch.image = UIImage(named: "unselectedCheck")
            self.lblOnlyMatch.textColor = UIColor.black
            self.match="0"
        }
        
        if DataManager.storyAllPostSelected=="1"
        {
            
            
            imgAllPost.image = UIImage(named: "SelectedCheck")
            self.lblAllPost.textColor = PURPLECOLOR
            self.allPost="1"
        }
        else
        {
            imgAllPost.image = UIImage(named: "unselectedCheck")
            self.lblAllPost.textColor = UIColor.black
           self.allPost="0"
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc
    private func dismissPresentedView(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func hidePopupAct(_ sender: UIButton)
    {
        if didUpdate
        {
            DataManager.storyImageSelected=self.img
            DataManager.storyVideoSelected=self.video
            DataManager.storyMatchSelected=self.match
            DataManager.storyMyPostSelected=self.myPost
            DataManager.storyAllPostSelected=self.allPost
            
            delegate?.selectedOption()
            self.dismiss(animated: true, completion: nil)
            
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func BackAct(_ sender: UIButton)
    {
        if didUpdate
        {
            DataManager.storyImageSelected=self.img
            DataManager.storyVideoSelected=self.video
            DataManager.storyMatchSelected=self.match
            DataManager.storyMyPostSelected=self.myPost
            DataManager.storyAllPostSelected=self.allPost
            
            delegate?.selectedOption()
            self.dismiss(animated: true, completion: nil)
            
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    

    @IBAction func ApplyAct(_ sender: UIButton)
    {
//        DataManager.storyImageSelected=self.img
//        DataManager.storyVideoSelected=self.video
//        DataManager.storyMatchSelected=self.match
//        DataManager.storyMyPostSelected=self.myPost
//        DataManager.storyAllPostSelected=self.allPost
//
//        delegate?.selectedOption()
//        self.dismiss(animated: true, completion: nil)
//
        
    }
    
    //MARK: - CategoryAct
    
    @IBAction func categoryAct(_ sender: UIButton)
    {
        self.didUpdate=true
        if sender.tag == 0
        {
            if imgImage.image == UIImage(named: "SelectedCheck")
            {
                imgImage.image = UIImage(named: "unselectedCheck")
                self.lblImage.textColor = UIColor.black
                self.img="0"
                
            }
            else
            {
                imgImage.image = UIImage(named: "SelectedCheck")
                self.lblImage.textColor = PURPLECOLOR
                self.img="1"
                
                imgVideo.image = UIImage(named: "unselectedCheck")
                self.lblVideo.textColor = UIColor.black
                self.video="0"
            }
        }
        
        else if sender.tag == 1
        {
            if imgVideo.image == UIImage(named: "SelectedCheck")
            {
                imgVideo.image = UIImage(named: "unselectedCheck")
                self.lblVideo.textColor = UIColor.black
                self.video="0"
            }
            else
            {
                imgVideo.image = UIImage(named: "SelectedCheck")
                self.lblVideo.textColor = PURPLECOLOR
                self.video="1"
                
                imgImage.image = UIImage(named: "unselectedCheck")
                self.lblImage.textColor = UIColor.black
                self.img="0"
            }
        }
        
        
        
        
        else if sender.tag == 2
        {
            if imgOnlyMatch.image == UIImage(named: "SelectedCheck")
            {
                imgOnlyMatch.image = UIImage(named: "unselectedCheck")
                self.lblOnlyMatch.textColor = UIColor.black
                self.match="0"
                
                
            }
            else
            {
                imgOnlyMatch.image = UIImage(named: "SelectedCheck")
                self.lblOnlyMatch.textColor = PURPLECOLOR
                self.match="1"
                
                imgPost.image = UIImage(named: "unselectedCheck")
                self.lblPost.textColor = UIColor.black
                self.myPost="0"
                
                
                imgAllPost.image = UIImage(named: "unselectedCheck")
                self.lblAllPost.textColor = UIColor.black
                self.allPost="0"
                
            }
        }
        else if sender.tag == 3
        {
            if imgPost.image == UIImage(named: "SelectedCheck")
            {
                imgPost.image = UIImage(named: "unselectedCheck")
                self.lblPost.textColor = UIColor.black
                self.myPost="0"
                
            }
            else
            {
                imgPost.image = UIImage(named: "SelectedCheck")
                self.lblPost.textColor = PURPLECOLOR
                self.myPost="1"
                
                imgOnlyMatch.image = UIImage(named: "unselectedCheck")
                self.lblOnlyMatch.textColor = UIColor.black
                self.match="0"
                
                imgAllPost.image = UIImage(named: "unselectedCheck")
                self.lblAllPost.textColor = UIColor.black
                self.allPost="0"
                
            }
        }
        else
        {
            if imgAllPost.image == UIImage(named: "SelectedCheck")
            {
                imgAllPost.image = UIImage(named: "unselectedCheck")
                self.lblAllPost.textColor = UIColor.black
                self.allPost="0"
            }
            else
            {
                imgAllPost.image = UIImage(named: "SelectedCheck")
                self.lblAllPost.textColor = PURPLECOLOR
                self.allPost="1"
                
                imgPost.image = UIImage(named: "unselectedCheck")
                self.lblPost.textColor = UIColor.black
                self.myPost="0"
                
                imgOnlyMatch.image = UIImage(named: "unselectedCheck")
                self.lblOnlyMatch.textColor = UIColor.black
                self.match="0"
                
                
            }
        }

        if self.match=="0" && self.myPost=="0"
        {
            imgAllPost.image = UIImage(named: "SelectedCheck")
            self.lblAllPost.textColor = PURPLECOLOR
            
            self.allPost="1"
        }
    }
    

}
