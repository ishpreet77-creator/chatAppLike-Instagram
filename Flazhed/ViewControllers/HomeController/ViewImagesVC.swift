//
//  ViewImagesVC.swift
//  Flazhed
//
//  Created by ios2 on 21/12/21.
//

import UIKit

class ViewImagesVC: UIViewController {
    @IBOutlet weak var viewImageCount: UIView!
    @IBOutlet weak var lblImageCount: UILabel!
    @IBOutlet weak var PostCollection: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var imagesArray:[String] = []
    var pageTitle = ""
    var imageIndex = 0
    var fromDisScrollCount=0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = pageTitle
        
       
        self.setupCollection()
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        fromDisScrollCount=0
        self.tabBarController?.tabBar.isHidden = true
    
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func BackAct(_ sender: UIButton)
    {
        DataManager.comeFrom = kViewProfile
    self.navigationController?.popViewController(animated: true)
    }

//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     debugPrint("self.imageIndex \(self.imageIndex)")

        self.PostCollection.scrollToItem(at: IndexPath(item: self.imageIndex, section: 0), at: .right, animated: false)
        PostCollection.layoutSubviews()
        
        if self.imagesArray.count>1
        {
            viewImageCount.isHidden=false
            self.lblImageCount.text = "\(self.imageIndex+1)/\(self.imagesArray.count)"
        }
        else
        {
            viewImageCount.isHidden=true
        }
    }
    
//    override func viewDidLayoutSubviews() {
//            super.viewDidLayoutSubviews()
//        PostCollection.collectionViewLayout.invalidateLayout()
//        }
    func scrollToIndex(index:Int) {
         let rect = self.PostCollection.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
         self.PostCollection.scrollRectToVisible(rect!, animated: true)
     }
}
//MARK: - Collection view setup and show post,attribute data

extension ViewImagesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func setupCollection()
    {
        self.PostCollection.delegate=self
        self.PostCollection.dataSource=self
     


        self.PostCollection.register(UINib(nibName: "HomeCardCCell", bundle: nil), forCellWithReuseIdentifier: "HomeCardCCell")
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.imagesArray.count>1)
        {
            return self.imagesArray.count+1
        }
        else
        {
            return self.imagesArray.count
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCCell", for: indexPath) as! HomeCardCCell
        
        var img = kEmptyString
        
        if self.imagesArray.count>(indexPath.row)
        {
            img = self.imagesArray[indexPath.row]
        }

        
        if  img  != kEmptyString
        {
            cell.userImage.setImage(imageName: img)
        }
        cell.userImage.contentMode = .scaleAspectFit
        cell.viewBlur.isHidden=true
        cell.viewBlur.alpha = BLUR_ALPHA
        
        return cell
        
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        DataManager.comeFrom = kViewProfile
    self.navigationController?.popViewController(animated: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      

        return  self.PostCollection.frame.size//CGSize(width:size.width , height: size.height)//CGSize(width: SCREENWIDTH,
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == PostCollection
        {
            /*
            let x = scrollView.contentOffset.x
            var index = Int(x/PostCollection.frame.width) + 1
            let total = Int(PostCollection.contentSize.width/PostCollection.frame.width)-1
           
            if (total>1) && index > total
            {
                self.PostCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
                index = 1
                self.lblImageCount.text = "\(index)/\(total)"
            } else {
                self.lblImageCount.text = "\(index)/\(total)"
            }
            
            self.fromDisScroll=true
            self.PostCollection.reloadData()
            */
        }
    }
        
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     if scrollView == self.PostCollection
     {

             let x = scrollView.contentOffset.x
             var index = Int(x/PostCollection.frame.width) + 1
             let total = Int(PostCollection.contentSize.width/PostCollection.frame.width)-1
 //            self.counterLabel.text = "\(index)/\(total)"
    
             // debugPrint("image index = \(index)")
             
             if (total>1) && index > total
             {
                 self.PostCollection.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: false)
                 index = 1
                 self.lblImageCount.text = "\(index)/\(total)"
               //  self.counterLabel.text = "\(index)/\(total)"
                // pageControlle.currentPage = index-1//Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
               
             } else {
                 self.lblImageCount.text = "\(index)/\(total)"
                 
                 //pageControlle.currentPage = index-1//Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
             }
             self.PostCollection.reloadData()
         

         
         
        // self.updatePage(page: pageControlle.currentPage)
     }
    }
  
}

