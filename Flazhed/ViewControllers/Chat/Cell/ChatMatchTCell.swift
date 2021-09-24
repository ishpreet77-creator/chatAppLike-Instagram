//
//  ChatMatchTCell.swift
//  Flazhed
//
//  Created by IOS33 on 31/05/21.
//

import UIKit

class ChatMatchTCell: UITableViewCell {
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var lblNewMatch: UILabel!
    @IBOutlet weak var collectiomMatch: UICollectionView!
    
    var viewController = UIViewController()

    var MatchArray:[UserListModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.collectiomMatch.register(UINib(nibName: "ActiveInactiveCCell", bundle: nil), forCellWithReuseIdentifier: "ActiveInactiveCCell")
                // Initialization code
        
        self.collectiomMatch.delegate=self
        self.collectiomMatch.dataSource=self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadCollection(userArray:[UserListModel])
    {
        self.MatchArray = userArray
        
        if self.MatchArray.count>0
        {
            self.lblNoDataFound.isHidden=true
        }
        else
        {
            self.lblNoDataFound.isHidden=false
        }
        
        
        self.collectiomMatch.reloadData()
    }
    
}
extension ChatMatchTCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.MatchArray.count //UserNameArray.count //
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveInactiveCCell", for: indexPath) as! ActiveInactiveCCell
        

        cell.progressView.trackClr = .white
    
        cell.progressView.progressClr = #colorLiteral(red: 0, green: 0.5077332854, blue: 1, alpha: 1)

        var cellData:UserListModel?
        
        if self.MatchArray.count>indexPath.row
        {
            cellData = self.MatchArray[indexPath.row]
        }
         
        
        let  enable_red_dot = cellData?.enable_red_dot ?? 0
        
        if enable_red_dot == 1
        {
            cell.heighLightColorView.isHidden = false
        }
        else
        {
            cell.heighLightColorView.isHidden = true
        }
        
        
        let dif  = "".checkHoursLeftForRing(startTime: cellData?.like_dislikeData?.chat_start_time_active ?? "2021-05-20T04:55:50.706Z")
        print("time check = \(dif)")
        
        
        let flo = Float(kTimeRing)
        
        let ring = (1.0/flo)*Float(dif)
        
        
        if (dif > 0) && (dif <= kTimeRing)
        {
            cell.progressView.isHidden=false
            if dif <= 1440//24
            {
                cell.progressView.setProgressWithAnimation(duration: 1.0, value: ring)
                cell.progressView.progressClr = UIColor.red
            }
            else
            {
                
               
                cell.progressView.setProgressWithAnimation(duration: 1.0, value: ring)
                cell.progressView.progressClr = LINECOLOR
            }
        }
        else
        {
            cell.progressView.setProgressWithAnimation(duration: 1.0, value: 1)
            cell.progressView.progressClr = LINECOLOR
            cell.progressView.isHidden=true
        }
        
        if DataManager.purchaseProlong
        {
            cell.progressView.isHidden=true
        }
        else
        {
            cell.progressView.isHidden=false
        }
        
        if cellData?.profile_data?.images?.count ?? 0>0
            {
            if let img = cellData?.profile_data?.images?[0].image
              {
                DispatchQueue.main.async {
                let url = URL(string: img)!
                cell.storyImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"), options: .refreshCached, completed: nil)
                }
              }
            }
        
 
        cell.userName.text = cellData?.profile_data?.username ?? ""
        cell.storyImageView.cornerRadius = cell.storyImageView.frame.height/2
        cell.storyImageView.contentMode = .scaleAspectFill
    
    
        
      
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectiomMatch.bounds.width //collectionWidth/4 - 10   65
        var width = collectionWidth/4 - 10
        print("Width \(width)")
        return CGSize(width: 106, height: collectiomMatch.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     
        
        let collectionWidth = collectiomMatch.bounds.width //collectionWidth/4 - 10   65
        var width = collectionWidth/4 - 10
        /*
        var cellData:UserListModel?
        
        if self.MatchArray.count>indexPath.row
        {
            cellData = self.MatchArray[indexPath.row]
        }

        let label = UILabel(frame: CGRect.zero)
        label.text = cellData?.profile_data?.username ?? ""
                label.sizeToFit()
        var width = collectionWidth/4 - 10
        
        if label.frame.width>width
        {
            width = label.frame.width
            
                
        }
       
        */
        return CGSize(width: width, height: collectiomMatch.bounds.height)
    
        //return CGSize(width: collectionWidth/4 - 10 , height: collectionWidth/4) //collectionWidth/4  110
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        var cellData:UserListModel?

        if self.MatchArray.count>indexPath.row
        {
            cellData = self.MatchArray[indexPath.row]
        }

        let storyBoard = UIStoryboard.init(name: "Chat", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC//MessageVC


        vc.view_user_id=cellData?.user_id ?? ""
        vc.profileName=cellData?.profile_data?.username ?? ""

        if cellData?.profile_data?.images?.count ?? 0>0
            {
            if let img = cellData?.profile_data?.images?[0].image
              {
           vc.profileImage=img
            }
        }

        self.viewController.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
extension ChatMatchTCell
{
    func callGetAllMatch(page: Int=0,showIndiacter:Bool=true)
    {
        var data = JSONDictionary()

        data[ApiKey.kOffset] = "\(page)"
  
            if Connectivity.isConnectedToInternet {
                
                self.getMatchesApi(data: data,showIndiacter:showIndiacter,page: page)
             } else {
                
               // self.openSimpleAlert(message: APIManager.INTERNET_ERROR)
            }
    }
    func getMatchesApi(data:JSONDictionary,showIndiacter:Bool=true,page:Int)
    {
        ChatVM.shared.callApiMatchesProfile(showIndiacter: showIndiacter, data: data, response: { (message, error) in
            if error != nil
            {
                //self.showErrorMessage(error: error)
            }
            else
            {
  
                if page == 0
                {
                    self.MatchArray.removeAll()
                }
                
                for dict in ChatVM.shared.MatchUserDataArray
                {
                    self.MatchArray.append(dict)
                }
                
              //  self.MatchPage=self.MatchArray.count
              // self.chatTableView.reloadData()
            }
     
        })
    }
}
