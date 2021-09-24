//
//  HomeUserTCell.swift
//  Flazhed
//
//  Created by IOS33 on 22/03/21.
//

import UIKit
import SDWebImage

class  HomeUserTCell: UITableViewCell {
    
    @IBOutlet weak var lblTitleComment: UILabel!
    @IBOutlet weak var imgLikeMode: UIImageView!
    @IBOutlet weak var companyButtomConst: NSLayoutConstraint!
    @IBOutlet weak var companyTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var lblCompanyName: UILabel!
    
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var imgCardJob: UIImageView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var imgCardLocation: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var viewImageCount: UIView!
    
    @IBOutlet weak var imgBlur: UIImageView!
    
    var viewProfileVC = UIViewController()

    var UserData:UserListModel?
      //  @IBOutlet weak var attributeCollectionView: UICollectionView!
    var currentUserDetails:UserListModel?
    
    var userImageData:[ImageDataModel] = []
    var isAnoModeOn=true
    var delegate:openDetailProfileDlegate?
    
    @IBOutlet weak var usersCollection: UICollectionView!
    var rightScroll = true
    override func awakeFromNib() {
        super.awakeFromNib()
      
        setupCollection()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }
    func reloadCollection(userDetails:UserListModel?,isAnoModeOn:Bool,VC:UIViewController)
    {
        //self.startTimer()
        self.viewProfileVC=VC
        self.currentUserDetails=userDetails
        self.UserData = userDetails
        var name = ""
        
            let x = self.usersCollection.contentOffset.x
            let index = Int(x/usersCollection.frame.width) + 1
        //    let total = Int(usersCollection.contentSize.width/usersCollection.frame.width)
            let image = (self.UserData?.profile_data?.images?.count ?? 0)+1
       // print("Index visible= ","\(index)/\(image)")
        self.lblImageCount.text = "\(index)/\(image)"
        
        
        
        
    
        if let username = self.UserData?.profile_data?.username
        {
          
            name = username
        }
        else
        {
            name = ""
        }
        print("user name = \(self.UserData?.profile_data?.username)")
   // print("More details = \(self.UserData?.more_profile_details)")
        
        if let more_profile_details = self.UserData?.more_profile_details
       {
            
            if let age = more_profile_details.age
            {
              
                self.lblAge.text = ", " + "\(age)"
            }
            else
            {
                self.lblAge.text = ""
            }
            
            if let city = more_profile_details.city
            {
                self.lblLocation.text = city
    
                self.imgCardLocation.isHidden=false
            }
            else
            {
                self.lblLocation.text = ""
                self.imgCardLocation.isHidden=true
            }
               if let job = more_profile_details.job_title
               {
                self.imgCardJob.isHidden=false
                self.lblDesignation.isHidden=false
                self.lblDesignation.text = job.capitalized
               }
            else
               {
                self.imgCardJob.isHidden=true
                self.lblDesignation.isHidden=true
               }
            
                if let company = more_profile_details.company_name
                {
                    self.lblCompanyName.isHidden=false
                    self.lblCompanyName.text = "@ "+company.capitalized
                    self.companyTopConst.constant = 12
                    self.companyButtomConst.constant = 12
                }
               else
                {
                    self.lblCompanyName.isHidden=true
                    self.companyTopConst.constant = 0
                    self.companyButtomConst.constant = 0
                }
              /*
                if job !=  "" && company != ""
                {
                    let job2 = (job )+"\n@ "+(company )
                    self.imgCardJob.isHidden=false
                    self.lblDesignation.text = job2.capitalized
                    self.lblDesignation.addInterlineSpacing(spacingValue: 4)
                }
                else  if job !=  ""
                {
                    self.imgCardJob.isHidden=false
                    self.lblDesignation.text = job.capitalized
            
                }
               else if company != ""
                {
                self.imgCardJob.isHidden=false
                self.lblDesignation.text = company.capitalized
                }
             else
               {
                self.lblDesignation.text =  ""
                self.imgCardJob.isHidden=true
               }
            */
       
     
            self.viewImageCount.isHidden=false
            self.viewCard.isHidden=false
       }
        else
        {
            self.imgCardJob.isHidden=true
            self.lblAge.text = ""
            self.lblDesignation.text =  ""
            self.lblUserName.text = ""
            self.lblCompanyName.text = ""
            self.lblLocation.text = ""
            self.imgCardLocation.isHidden=true
            self.viewImageCount.isHidden=true
            self.viewCard.isHidden=true
        }
        self.lblUserName.text = name.capitalized
        self.lblUserName.numberOfLines=1
       
        self.isAnoModeOn=isAnoModeOn
        
        
        if let data = self.UserData?.second_table_like_dislike  //self.UserData?.is_liked_by_other_user_id == 1
        {
            if let mode = data.by_like_mode //self.UserData?.like_mode_by_other_user
            {
                // self.lblLikeMode.text = "  " + mode + "  "
                if mode.equalsIgnoreCase(string: kAnonymous)
                {
                    self.imgLikeMode.image = UIImage(named: "profile")
                    self.imgLikeMode.isHidden=true
                    self.viewCard.isHidden=true
                    self.lblTitleComment.text = kEmptyString
                }
                else
                {
                    self.viewCard.isHidden=false
                    if mode.equalsIgnoreCase(string: kHangout)
                    {
                        self.imgLikeMode.image = UIImage(named: "smile")
                        self.lblTitleComment.text = self.UserData?.Single_Hangout_Details?.heading ?? ""
                    }
                    else  if mode.equalsIgnoreCase(string: kStory)
                    {
                        self.imgLikeMode.image = UIImage(named: "Stories")
                        self.lblTitleComment.text = self.UserData?.Single_Story_Details?.post_text ?? ""
                    }
                    else  if mode.equalsIgnoreCase(string: kShake)
                    {
                        self.imgLikeMode.image = UIImage(named: "playing-cards")
                        self.lblTitleComment.text = kEmptyString
                    }
                    else  if mode.equalsIgnoreCase(string: kProfile) 
                    {
                        self.imgLikeMode.image = UIImage(named: "profile")
                        self.lblTitleComment.text = kEmptyString
                    }
                    self.imgLikeMode.isHidden=false
                    
                }
                self.imgLikeMode.image = self.imgLikeMode.image?.tinted(color: UIColor.white)
                
            }
            else
            {
                self.lblTitleComment.text = kEmptyString
                self.imgLikeMode.isHidden=true
                self.viewCard.isHidden=true
            }
            
        }
        else
        {
            self.lblTitleComment.text = kEmptyString
            self.imgLikeMode.isHidden=true
            self.viewCard.isHidden=true
        }
        
        
        
        
//        if self.isAnoModeOn
//        {
//            self.viewCard.isHidden=true
//        }
//        else
//        {
//            self.viewCard.isHidden=false
//        }

        self.lblAge.textAlignment = .left
        self.usersCollection.showsVerticalScrollIndicator=false
        self.usersCollection.showsHorizontalScrollIndicator=false
        
        self.usersCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
        self.usersCollection.reloadData()
        
       

        
        
//        if self.usersCollection.numberOfSections>0
//        {
//        if (self.usersCollection.numberOfItems(inSection: 0) != 0)
//        {
//            self.usersCollection.reloadData()
//            self.usersCollection?.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
//        }
//        else
//        {
//            self.usersCollection.reloadData()
//        }
//        }
//        else
//        {
//            self.usersCollection.reloadData()
//        }
        

       //
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == usersCollection
        {
            if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0)
                {
                
                self.rightScroll = false
                }
               else
               {
                 
                
                self.rightScroll = true
               }
            
               
            
            let x = scrollView.contentOffset.x
            var index = Int(x/usersCollection.frame.width) + 1
            
            let total = Int(usersCollection.contentSize.width/usersCollection.frame.width)-1
            
           // print("INDEX",index)
          let count = (self.currentUserDetails?.profile_data?.images?.count ?? 0) + 1
            if index > count
            {
                self.usersCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
                index = 1
            }
            
            if index == 2
            {
                self.lblLocation.isHidden=true
                self.lblDesignation.isHidden=true
                self.lblUserName.isHidden=true
                self.viewCard.isHidden=true
                self.lblAge.isHidden=true
                self.imgCardJob.isHidden=true
                self.imgCardLocation.isHidden=true
                self.lblCompanyName.isHidden=true
                self.imgBlur.isHidden=true
                self.lblTitleComment.isHidden=true
              
            }
            else
            {
                self.lblTitleComment.isHidden=false
                self.lblAge.isHidden=false
                
                if self.isAnoModeOn
                {
                    self.viewCard.isHidden=true

                }
                else
                {
                    if imgLikeMode.isHidden
                    {
                        self.viewCard.isHidden=true
                    }
                    else
                    {
                        self.viewCard.isHidden=false
                    }
                
                }
                
                self.lblLocation.isHidden=false
                self.lblDesignation.isHidden=false
                self.lblUserName.isHidden=false
                self.lblCompanyName.isHidden=false
                if (self.lblDesignation.text?.count ?? 0)>0
                {
                    self.imgCardJob.isHidden=false
                }
                if (self.lblLocation.text?.count ?? 0)>0
                {
                    self.imgCardLocation.isHidden=false
                }
               
                self.imgBlur.isHidden=true
            }
            
            
         
            
            self.lblImageCount.text = "\(index)/\(total)"
            
            
           
            
          
          
         
        }
        
    }
    
    
    /*
    func scrollViewDidEndDecelerating (_ scrollview:UIScrollView) {
    ///When uiscrollview slides to the first stop,Change the offset position of uiscrollview
        
        
        if scrollview == self.usersCollection
        {
            let count = self.currentUserDetails?.profile_data?.images?.count ?? 0
       
        
//                if count>1
//                {
//                    self.viewCounter.isHidden=false
//
//                }
//                else
//                {
//                    self.viewCounter.isHidden=true
//                }
        if (scrollview.contentOffset.x == 0)
    {
            scrollview.contentOffset = CGPoint(x:CGFloat(count) * UIScreen.main.bounds.width, y:0)
    
     //self.pagecontrol.currentpage=self.myArray.count
     ///When uiscrollview slides to the last stop,Change the offset position of uiscrollview
           // counterlabel = "\(count)/\(count)"
           // self.counterLabel.text = counterlabel
            print("scroll index =\(count)")
            
    } else if
        (scrollview.contentOffset.x == CGFloat (count + 1) * UIScreen.main.bounds.width) {
     scrollview.contentOffset=CGPoint(x:UIScreen.main.bounds.width, y:0)
        
       let page = Int(scrollview.contentOffset.x/UIScreen.main.bounds.width)
        print("scroll index =\(page)")
        //counterlabel = "\(page+1)/\(count)"
       // self.counterLabel.text = counterlabel
        
    // self.pagecontrol.currentpage=0
    } else {
    let index = Int(scrollview.contentOffset.x/UIScreen.main.bounds.width)-1
        
        print("scroll index =\(index)")
       // counterlabel = "\(index)/\(count)"
        //self.counterLabel.text = counterlabel
    }
        
      
            for cell in self.usersCollection.visibleCells {
                let indexPath = self.usersCollection.indexPath(for: cell)
               // print(indexPath)
               var index = indexPath?.row ?? 0
                
                print("index =  \(index) \(count)")
                if index == 0
                {
                    index = 1
                }
                else if index>count
                {
                    index = 1
                }
                var counterlabel = "\(index)/\(count)"
                self.lblImageCount.text = counterlabel
            }
        
        }
    }
    
    */

   
    
}
extension HomeUserTCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
            self.usersCollection.delegate=self
            self.usersCollection.dataSource=self
            self.usersCollection.register(UINib(nibName: "HomeCardCCell", bundle: nil), forCellWithReuseIdentifier: "HomeCardCCell")
        self.usersCollection.register(UINib(nibName: "HomeUserDetailsTCell", bundle: nil), forCellWithReuseIdentifier: "HomeUserDetailsTCell")
       
     
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return  (self.currentUserDetails?.profile_data?.images?.count ?? 0) + 2
        
//        let count = self.currentUserDetails?.profile_data?.images?.count ?? 0
//        if (count != 1) {
//            return count + 3
//        }
//        return count+1
    }
    

    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        /*
        if indexPath.row == 1
        
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserDetailsTCell", for: indexPath) as! HomeUserDetailsTCell
            
            
            cell.reloadCollection(userDetails: self.currentUserDetails, isAnoModeOn: true)
            var name = ""
            
            if let username = self.UserData?.profile_data?.username
            {
              
                name = username
            }
            
            if let more_profile_details = self.UserData?.more_profile_details
           {
                
                if let bio = more_profile_details.bio
                {
                  
                    cell.txtBio.text = bio
                }
                else
                {
                    cell.txtBio.text = ""
                }
                
                if let age = more_profile_details.age
                {
                  
                    cell.lblAge.text =  ", " + "\(age)"
                }
                
                
                if let city = more_profile_details.city
                {
                    cell.lblLocation.text = city
        
                    cell.imgLocation.isHidden=false
                }
                else
                {
                    cell.lblLocation.text = ""
                    cell.imgLocation.isHidden=true
                }
                    if let job = more_profile_details.job_title
                    {
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.isHidden=false
                        cell.lblDesignation.text = job.capitalized
                    }
                   else
                    {
                        cell.imgJob.isHidden=true
                        cell.lblDesignation.isHidden=true
                    }
                
                   if let company = more_profile_details.company_name
                   {
                    cell.lblCompanyName.text = "@ "+company
                    cell.lblCompanyName.isHidden=false
                    cell.companyTopConst.constant=12
                    cell.companyButtomConst.constant = 12
                   }
                else
                   {
                    cell.lblCompanyName.isHidden=true
                    cell.companyTopConst.constant=0
                    cell.companyButtomConst.constant = 0
                   }
                  /*
                
                    if job !=  ""// && company != ""
                    {
                        let job2 = (job )//+"\n@ "+(company )
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.text = job2.capitalized
                        cell.lblDesignation.addInterlineSpacing(spacingValue: 4)
                    }
                    else  if job !=  ""
                    {
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.text = job.capitalized
                
                    }
                   else if company != ""
                    {
                    cell.imgJob.isHidden=false
                    cell.lblDesignation.text = company.capitalized
                    }
                 else
                   {
                    cell.lblDesignation.text =  ""
                    cell.imgJob.isHidden=true
                   }
                */
               
           }
            else
            {
                cell.lblDesignation.text =  ""
                cell.imgJob.isHidden=true
                cell.lblLocation.text = ""
                cell.imgLocation.isHidden=true
            }
            
            if cell.lblLocation.text?.count==0
            {
                cell.bioTopConst.constant=0
            }
            else
            {
                cell.bioTopConst.constant=16
            }
            if cell.txtBio.text?.count==0
            {
                cell.attTopConst.constant=8
            }
            else
            {
                cell.bioTopConst.constant=32
            }
            
            cell.BtnTap.tag=indexPath.row
            cell.BtnTap.addTarget(self, action: #selector(btnTapAct), for: .touchUpInside)
            
            
            cell.lblUserName.text = name.capitalized
            cell.lblUserName.numberOfLines=1
            return cell
        }
        else
        {
            
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell

            var index = 0
            if indexPath.row>0
            {
                index = indexPath.row-1
            }
            var celldata:ImageDataModel?
            
            if (indexPath.row == 0) {
            //  cell.imagename=imagenamelist.last
               // cell.img.image = UIImage(named: self.myArray.last ?? "")
                celldata = self.currentUserDetails?.profile_data?.images?.last
                
            } else if (indexPath.row == ((self.currentUserDetails?.profile_data?.images?.count ?? 0) + 1)) {
             // cell.imagename=myArray.first
               // cell.img.image = UIImage(named: self.myArray.first ?? "")
                celldata = self.currentUserDetails?.profile_data?.images?.first
             } else {
             // cell.imagename=myArray[indexPath.row-1]
                
               // cell.img.image = UIImage(named: self.myArray[indexPath.row-1])
                
                celldata = self.currentUserDetails?.profile_data?.images?[indexPath.row-1]
             }
            
            
            
            //if (self.currentUserDetails?.profile_data?.images?.count ?? 0)>index
            //{
       // let celldata = self.currentUserDetails?.profile_data?.images?[index]//self.userImageData[indexPath.row]

        if let img = celldata?.image
        {
            cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url = URL(string: img)!
          
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
            //cell.userImage.sd_imageIndicator?.stopAnimatingIndicator()

        }
        else
        {
            cell.userImage.image = nil
        }
//        }
//            else
//            {
//            cell.userImage.image = nil
//            }
        //cell.viewBlur.isHidden=true
            cell.viewBlur.alpha = BLUR_ALPHA

        if self.isAnoModeOn
        {
            cell.viewBlur.isHidden=false
           
        }
        else
        {
            cell.viewBlur.isHidden=true
        }
            
        
        return cell
        }
        
        */
        
        if indexPath.row == 1
        
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserDetailsTCell", for: indexPath) as! HomeUserDetailsTCell
            
            
            cell.reloadCollection(userDetails: self.currentUserDetails, isAnoModeOn: true)
            var name = ""
            
            if let username = self.UserData?.profile_data?.username
            {
              
                name = username
            }
            
            if let more_profile_details = self.UserData?.more_profile_details
           {
                
                if let bio = more_profile_details.bio
                {
                  
                    cell.txtBio.text = bio
                }
                else
                {
                    cell.txtBio.text = ""
                }
                
                if let age = more_profile_details.age
                {
                  
                    cell.lblAge.text =  ", " + "\(age)"
                }
                
                
                if let city = more_profile_details.city
                {
                    cell.lblLocation.text = city
        
                    cell.imgLocation.isHidden=false
                }
                else
                {
                    cell.lblLocation.text = ""
                    cell.imgLocation.isHidden=true
                }
                    if let job = more_profile_details.job_title
                    {
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.isHidden=false
                        cell.lblDesignation.text = job.capitalized
                    }
                   else
                    {
                        cell.imgJob.isHidden=true
                        cell.lblDesignation.isHidden=true
                    }
                
                   if let company = more_profile_details.company_name
                   {
                    cell.lblCompanyName.text = "@ "+company
                    cell.lblCompanyName.isHidden=false
                    cell.companyTopConst.constant=12
                    cell.companyButtomConst.constant = 12
                   }
                else
                   {
                    cell.lblCompanyName.isHidden=true
                    cell.companyTopConst.constant=0
                    cell.companyButtomConst.constant = 0
                   }
                  /*
                
                    if job !=  ""// && company != ""
                    {
                        let job2 = (job )//+"\n@ "+(company )
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.text = job2.capitalized
                        cell.lblDesignation.addInterlineSpacing(spacingValue: 4)
                    }
                    else  if job !=  ""
                    {
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.text = job.capitalized
                
                    }
                   else if company != ""
                    {
                    cell.imgJob.isHidden=false
                    cell.lblDesignation.text = company.capitalized
                    }
                 else
                   {
                    cell.lblDesignation.text =  ""
                    cell.imgJob.isHidden=true
                   }
                */
               
           }
            else
            {
                cell.lblDesignation.text =  ""
                cell.imgJob.isHidden=true
                cell.lblLocation.text = ""
                cell.imgLocation.isHidden=true
            }
            
            if cell.lblLocation.text?.count==0
            {
                cell.bioTopConst.constant=0
            }
            else
            {
                cell.bioTopConst.constant=16
            }
            if cell.txtBio.text?.count==0
            {
                cell.attTopConst.constant=8
            }
            else
            {
                cell.bioTopConst.constant=32
            }
            
            cell.BtnTap.tag=indexPath.row
            cell.BtnTap.addTarget(self, action: #selector(btnTapAct), for: .touchUpInside)
            
            
            cell.lblUserName.text = name.capitalized
            cell.lblUserName.numberOfLines=1
            return cell
        }
        else
        {
            
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell
           
            
           

            var index = 0
            if indexPath.row>0
            {
                index = indexPath.row-1
            }
            
            if (self.currentUserDetails?.profile_data?.images?.count ?? 0)>index
            {
        let celldata = self.currentUserDetails?.profile_data?.images?[index]//self.userImageData[indexPath.row]

        if let img = celldata?.image
        {
            cell.userImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let url = URL(string: img)!
          
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: [], completed: nil)
            //cell.userImage.sd_imageIndicator?.stopAnimatingIndicator()

        }
        else
        {
            cell.userImage.image = nil
        }
        }
            else
            {
            cell.userImage.image = nil
            }
        //cell.viewBlur.isHidden=true
            cell.viewBlur.alpha = BLUR_ALPHA

        if self.isAnoModeOn
        {
            cell.viewBlur.isHidden=false
           
        }
        else
        {
            cell.viewBlur.isHidden=true
        }
            
        
        return cell
        }
     
        
        
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return self.usersCollection.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var isOpen = false
        
        if isOpen == false
        {
            isOpen = true
            let id = self.UserData?.user_id ?? ""
            let hangoutId = self.UserData?.second_table_like_dislike?.hangout_id ?? ""
            let storyId = self.UserData?.second_table_like_dislike?.story_id ?? ""
            self.openDetailPage(userId: id,hangoutId: hangoutId,StoryId: storyId)
        }

    }
    @objc func btnTapAct(_ sender:UIButton)
    {
    var isOpen = false
    
    if isOpen == false
    {
       // isOpen = true
        let id = self.UserData?.user_id ?? ""
        let hangoutId = self.UserData?.second_table_like_dislike?.hangout_id ?? ""
        let storyId = self.UserData?.second_table_like_dislike?.story_id ?? ""
        self.openDetailPage(userId: id,hangoutId: hangoutId,StoryId: storyId)
    }
    }
    
    func openDetailPage(userId:String,hangoutId:String,StoryId:String)
    {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        vc.view_user_id = userId
        vc.hangout_id = hangoutId
        vc.story_id = StoryId
            vc.isAnoModeOn=isAnoModeOn
            if self.isAnoModeOn
            {
                vc.likeMode = kAnonymous
                
            }
            else
            {
                vc.likeMode = kShake
            }
      
        DataManager.comeFrom = ""
        
        self.viewProfileVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      
            return 0
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
            return 0
       
    }
    
func scrollToNextCell(){

        //get cell size
        let cellSize = CGSize(width: self.usersCollection.frame.width, height: self.usersCollection.frame.height);

        //get current content Offset of the Collection view
        let contentOffset = usersCollection.contentOffset;

        if usersCollection.contentSize.width <= usersCollection.contentOffset.x + cellSize.width
        {
            usersCollection.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);

        } else {
            usersCollection.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);

        }

    }
    func startTimer() {
       // Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }

//    @objc func playAct(_ sender: UIButton)
//    {
//
//
//            let model = self.UserData?.arrAllPostCollection[sender.tag]
//
//
//            if model?.type == .story{
//
//                if  let url = model?.PostData?.file_name //self.postImageData[sender.tag].file_name
//            {
//                self.postCollectionCell?.img.playVideoOnImage(URL(string: url)!, VC: self)
//            }
//            }
//    }
}
protocol openDetailProfileDlegate {
    func userIdToOpenDetails(userId:String)
}
extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}
