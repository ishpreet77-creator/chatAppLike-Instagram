//
//  HomeUserDetailsTCell.swift
//  Flazhed
//
//  Created by IOS33 on 22/03/21.


import UIKit

class HomeUserDetailsTCell: UICollectionViewCell {
    @IBOutlet weak var bioTopConst: NSLayoutConstraint!
    @IBOutlet weak var attTopConst: NSLayoutConstraint!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var imgJob: UIImageView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    
    @IBOutlet weak var txtBio: UILabel!
    @IBOutlet weak var attributeCollectionView: UICollectionView!
    @IBOutlet weak var attributeCollHeightConst: NSLayoutConstraint!
    var currentUserDetails:UserListModel?
    var attCollectionHeight = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
        // Initialization code
    }
    func reloadCollection(userDetails:UserListModel?,isAnoModeOn:Bool)
    {
        self.currentUserDetails=userDetails
        
        let count = Double(self.currentUserDetails?.more_profile_details?.arrCollection.count ?? 0)
        
        let noOfCell = ceil(Double(count/2.0))
        
        if noOfCell==1
        {
            self.attCollectionHeight=100
        }
        else if noOfCell>1
        {
            self.attCollectionHeight=Int(CGFloat(50.0*noOfCell))
        }
        
        else
        {
            self.attCollectionHeight=100
        }
        self.attributeCollHeightConst.constant = CGFloat(self.attCollectionHeight)
        
        self.attributeCollectionView.reloadData()
    }
    func showFootAndInchesFromCm(_ cms: Double) -> String {

          let feet = cms * 0.0328084
          let feetShow = Int(floor(feet))
          let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
          let inches = Int(round(feetRest * 12))

          return "\(feetShow)' \(inches)\""
    }
}
extension HomeUserDetailsTCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
            self.attributeCollectionView.delegate=self
            self.attributeCollectionView.dataSource=self
           self.attributeCollectionView.register(UINib(nibName: "ProfileAttributeCCell", bundle: nil), forCellWithReuseIdentifier: "ProfileAttributeCCell")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return  self.currentUserDetails?.more_profile_details?.arrCollection.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAttributeCCell", for: indexPath) as! ProfileAttributeCCell
        
        let model = self.currentUserDetails?.more_profile_details?.arrCollection[indexPath.row]
        
        if model?.type == .education{
            cell.imgIcon.image = UIImage(named: "Graduate")
            cell.lblTitle.text = model?.education_selected?.education_name
            cell.lblTitle.text = cell.lblTitle.text?.capitalized
        }else if model?.type == .height{
            cell.imgIcon.image = UIImage(named: "scaleIcon")
            
            let unit = DataManager.currentUnit //self.UserData?.unit_settings?.unit ?? ""
            if let height  = model?.height
            {
            if  unit == kFeet
            {
                cell.lblTitle.text = self.showFootAndInchesFromCm(Double(height))
                
            }
             else
            {
                cell.lblTitle.text = "\(height)"+" cm"
            }
            }
     
        }else if model?.type == .hairColor{
            cell.imgIcon.image = UIImage(named: "faceIcon")
            cell.lblTitle.text = model?.hair_selected?.hair_name
            cell.lblTitle.text = cell.lblTitle.text?.capitalized
        }else{
            
            if let img = model?.children_selected?.image
            {
                let url = URL(string: img)!
                
                cell.imgIcon.sd_setImage(with: url, placeholderImage: UIImage(named: "toddlerIcon"), options: .refreshCached) { (img, error, type, url) in
                    
                    cell.imgIcon.image = cell.imgIcon.image?.tinted(color:  #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1))
                }
            }
            
            cell.lblTitle.text = model?.children_selected?.children_name
            cell.lblTitle.text = cell.lblTitle.text?.capitalized
        }

        
        cell.imgIcon.image = cell.imgIcon.image?.tinted(color:  #colorLiteral(red: 0, green: 0.4078431373, blue: 1, alpha: 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //MARK:- child changes
    
        return CGSize(width: ((Int(self.attributeCollectionView.frame.width)/2)-4), height: 46)
            
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