//
//  HomeUserTCell.swift
//  Flazhed
//
//  Created by IOS33 on 22/03/21.
//

import UIKit

class HomeUserTCell: UITableViewCell {
    @IBOutlet weak var imgCardJob: UIImageView!
    @IBOutlet weak var viewCard: UIView!
    @IBOutlet weak var imgCardLocation: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var viewImageCount: UIView!
    
    @IBOutlet weak var imgBlur: UIImageView!
    
    var UserData:UserListModel?
      //  @IBOutlet weak var attributeCollectionView: UICollectionView!
    var currentUserDetails:UserListModel?
    
    var userImageData:[ImageDataModel] = []
    var isAnoModeOn=true
    var delegate:openDetailProfileDlegate?
    
    @IBOutlet weak var usersCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        // Configure the view for the selected state
    }
    func reloadCollection(userDetails:UserListModel?,isAnoModeOn:Bool)
    {
        self.currentUserDetails=userDetails
        self.UserData = userDetails
        var name = ""
        
            let x = self.usersCollection.contentOffset.x
            let index = Int(x/usersCollection.frame.width) + 1
            let total = Int(usersCollection.contentSize.width/usersCollection.frame.width)
        let image = (self.UserData?.profile_data?.images?.count ?? 0)+1
        print("Index visible= ","\(index)/\(image)")
        self.lblImageCount.text = "\(index)/\(image)"
        
        
        
        
    
        if let username = self.UserData?.profile_data?.username
        {
          
            name = username
        }
        
        if let more_profile_details = self.UserData?.more_profile_details
       {
            
            if let age = more_profile_details.age
            {
              
                name = name + ", " + "\(age)"
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
                let job = more_profile_details.job_title ?? ""
            
                let company = more_profile_details.company_name ?? ""
              
                if job !=  "" && company != ""
                {
                    let job2 = (job )+" @ "+(company )
                    self.imgCardJob.isHidden=false
                    self.lblDesignation.text = job2.capitalized
                
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
           
       }
        self.lblUserName.text = name.capitalized
        
        self.isAnoModeOn=isAnoModeOn
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
            let x = scrollView.contentOffset.x
            let index = Int(x/usersCollection.frame.width) + 1
            let total = Int(usersCollection.contentSize.width/usersCollection.frame.width)
            
            print("INDEX",index)
            
            if index == 2
            {
                self.lblLocation.isHidden=true
                self.lblDesignation.isHidden=true
                self.lblUserName.isHidden=true
                self.viewCard.isHidden=true
                
                self.imgCardJob.isHidden=true
                self.imgCardLocation.isHidden=true
                
                self.imgBlur.isHidden=false
            }
            else
            {
                self.viewCard.isHidden=false
                self.lblLocation.isHidden=false
                self.lblDesignation.isHidden=false
                self.lblUserName.isHidden=false
                
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
  
        return  (self.currentUserDetails?.profile_data?.images?.count ?? 0) + 1
    }
    
    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
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
                  
                    name = name + ", " + "\(age)"
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
                    let job = more_profile_details.job_title ?? ""
                
                    let company = more_profile_details.company_name ?? ""
                  
                    if job !=  "" && company != ""
                    {
                        let job2 = (job )+" @ "+(company )
                        cell.imgJob.isHidden=false
                        cell.lblDesignation.text = job2.capitalized
                    
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
            
            cell.lblUserName.text = name.capitalized
            
            return cell
        }
        else
        {
            
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell
        
            var index = 0
            if indexPath.row>0
            {
                index=indexPath.row-1
            }
            
            if (self.currentUserDetails?.profile_data?.images?.count ?? 0)>index
            {
        let celldata = self.currentUserDetails?.profile_data?.images?[index]//self.userImageData[indexPath.row]

        if let img = celldata?.image
        {
            let url = URL(string: img)!

            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)

        }
        }
        //cell.viewBlur.isHidden=true
        

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
  
        
        NotificationCenter.default.post(name: Notification.Name("OpenProfileDetails"), object: nil, userInfo: ["userId":self.currentUserDetails?.user_id ?? ""])
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
