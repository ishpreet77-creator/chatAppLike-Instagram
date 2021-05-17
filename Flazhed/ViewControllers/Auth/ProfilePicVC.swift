//
//  ProfilePicVC.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//
import UIKit
import CountryPickerView
import SDWebImage

class ProfilePicVC: BaseVC {
    //MARK:- All outlets  🍎
    
    @IBOutlet weak var lblOtpSent: UILabel!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var sendButtonConst: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView:DragDropCollectionView!
    var images = [#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage"),#imageLiteral(resourceName: "addImage")]
    var imageArray1:[UIImage] = []
    
    var SelectedImages:[UIImage]=[]
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    
    var userName  = ""
    var imageUrlArray:[URL]=[]
    var userProfile:URL!
    @IBOutlet weak var viewAddImage: UIView!
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var imageHeight:CGFloat = 120.0
    var imageWidth:CGFloat = 120.0
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userName)
        print(userProfile)
        setUpUI()
    }
    
    func setUpUI()
    {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: lblOtpSent.text ?? "")
        attributedString.setColorForText(textForAttribute: "Adding at least 3 pictures increases your chance by ", withColor: UIColor.black)
        attributedString.setColorForText(textForAttribute: "20x.", withColor: TEXTCOLOR)
     

        lblOtpSent.attributedText = attributedString
        
        self.setCustomHeader(title: "Profile Picture", showBack: false, showMenuButton: false)
        
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
            self.topConst.constant = TOPSPACING+TOPLABELSAPACING
        }
        
        imageCollectionView.register(UINib(nibName: "EditProfileCell", bundle: nil), forCellWithReuseIdentifier: "EditProfileCell")
        imageCollectionView.delegate=self
        imageCollectionView.dataSource=self
    

            screenSize = UIScreen.main.bounds
            screenWidth = screenSize.width-6
           
        if userProfile != nil
        {
            self.imageCollectionView.isHidden=false
            self.viewAddImage.isHidden=true
        }
        else
        {
            self.imageCollectionView.isHidden=true

            self.viewAddImage.isHidden=false
        }

      //  self.imageCollectionView.dragInteractionEnabled = true
      //  self.imageCollectionView.dragDelegate = self
      //  self.imageCollectionView.dropDelegate = self
      //  imageCollectionView.reorderingCadence = .fast
        
        imageCollectionView.draggingDelegate = self
        imageCollectionView.enableDragging(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.endEditing(true)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
   
    
    @IBAction func AddPicAct(_ sender: UIButton)
    {
        
        if self.SelectedImages.count<9
        {
            self.showImagePicker(showVideo: false, showDocument: false)
            
            CustomImagePickerView.sharedInstace.delegate = self
        }
        else
        {
            self.openSimpleAlert(message: kMaxImageAlert)
        }
      
    }
    
    @IBAction func NextAct(_ sender: UIButton)
    {
      
        print(self.SelectedImages)
        if let message = validateData()
        {
            self.openSimpleAlert(message: message)
        }
        else
        {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserNameVC") as! UserNameVC
            vc.imageArray1=self.SelectedImages
                vc.userName=self.userName
            
                    self.navigationController?.pushViewController(vc, animated: true)
        }
        
        

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
        else
        {
            self.sendButtonConst.constant = keyboardHeight+26+20
        }
        
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        sendButtonConst.constant = 26
    }
    // MARK:- validateData Functions
    private func validateData () -> String?
    {
        if self.SelectedImages.count == 0 {
            return kEmptyImageAlert
        }
       
    
        return nil
     }
    
    @objc func addImageAct(_ sender:UIButton)
    {
        self.showImagePicker(showVideo: false, showDocument: false)
        
        CustomImagePickerView.sharedInstace.delegate = self
    }

}

extension ProfilePicVC:CountryPickerViewDataSource,CustomImagePickerDelegate
{
    
    func didImagePickerFinishPicking(_ image: UIImage)
    {
    
    //BackImage.image = image
      
        
        
        let dataImage =  image.jpegData(compressionQuality: 0.7) ?? Data()
        
         APIManager.callApiForImageCheck(image1: dataImage,imageParaName1: kMedia, api: "",successCallback: {
             
             (responseDict) in
             print(responseDict)
            let data =   self.parseImageCheckData(response: responseDict)
            
             if responseDict[ApiKey.kStatus] as? String == kSucess
             {
                 print(data)
                 if data?.weapon ?? 0.0 > kNudityCheck
                 {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                 }
//                 else if  data?.alcohol ?? 0.0 > kNudityCheck
//                 {
//                     self.openSimpleAlert(message: kImageCkeckAlert)
//                 }
                 else if  data?.drugs ?? 0.0 > kNudityCheck
                 {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                 }
                 else if  data?.nudity?.partial ?? 0.0 > kNudityCheck
                 {
                     self.openSimpleAlert(message: kImageCkeckAlert)
                 }
                 else
                 {
                    self.SelectedImages.append(image)
                    self.imageCollectionView.reloadData()
                    
                    if self.SelectedImages.count>0
                    {
                        self.imageCollectionView.isHidden=false
                        self.viewAddImage.isHidden=true
                    }
                    else
                    {
                        self.imageCollectionView.isHidden=true

                        self.viewAddImage.isHidden=false
                    }
                 }
                 
             }
             else
             {
                 let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
                if  data?.error?.message != ""
                {
                   
                    self.openSimpleAlert(message:  data?.error?.message)
                }
                else
                {
                    self.openSimpleAlert(message: message)
                }
                 
             }
             
             
             
         },  failureCallback: { (errorReason, error) in
             print(APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
             
         })
                
    }
    
   
    
}

// MARK:- Extension UICollectionViewDataSource,UICollectionViewDelegate
extension ProfilePicVC:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        /*
        if SelectedImages.count == 0//userProfile != nil
        {
            if userProfile != nil
            {
                return 1
            }
            else
            {
                return 9
            }
            
        }
        else
        {
            if userProfile != nil
            {
                return SelectedImages.count+1
            }
            else
            {
                return SelectedImages.count
            }
           
        }
        
        */
    
        
        return 9
            
  
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileCell", for: indexPath) as! EditProfileCell
        
        
        cell.profileImage.contentMode = .scaleAspectFill
        if SelectedImages.count == 0
        {
            if userProfile != nil
            {
                if indexPath.row==0
                {
                cell.profileImage.sd_setImage(with: userProfile) { (img, error, type, url) in
                 //   self.imageArray1.append(img!)
                    self.SelectedImages.append(img!)
                    
                    cell.addButton.isHidden = true
                    cell.crossButton.isHidden = false
                    
                    
                    cell.crossButton.addTarget(self, action: #selector(self.DeleteImageAct), for: UIControl.Event.touchUpInside)
                }
                }
                else
                {
                    cell.profileImage.image=images[indexPath.row]
                }
            }
            
            
        }
        else
        {
            if userProfile != nil
            {
                if indexPath.row == 0
                {
                    cell.profileImage.sd_setImage(with: userProfile, completed: nil)
                }
                else
                {
                    if indexPath.row<self.SelectedImages.count-1
                    {
                        cell.profileImage.image = SelectedImages[indexPath.row-1]
                    }
                
                   
                }
                
            }
            else
            {
                if indexPath.row < self.SelectedImages.count
                {
                    cell.profileImage.image = SelectedImages[indexPath.row]
                }
                
            }
            
       }
        if indexPath.row <  self.SelectedImages.count
        {
            cell.addButton.isHidden = true
            cell.crossButton.isHidden = false
            cell.profileImage.image = SelectedImages[indexPath.row]
           
            
            cell.crossButton.addTarget(self, action: #selector(DeleteImageAct), for: UIControl.Event.touchUpInside)
        }
        else {


            cell.addButton.isHidden = false
            cell.crossButton.isHidden = true
            cell.profileImage.image = images[indexPath.row]
            if indexPath.row == self.SelectedImages.count
            {
                cell.addButton.isEnabled = true
            }
            else
            {
                if userProfile != nil
                {
                    if indexPath.row == 1
                    {
                        cell.addButton.isEnabled = true
                    }
                    else
                    {
                        cell.addButton.isEnabled = false
                    }
                
                }
                else
                
                {
                    cell.addButton.isEnabled = false
                }
            }
            cell.addButton.addTarget(self, action: #selector(addImageAct), for: .touchUpInside)


        }
        
        
        if cell.profileImage.image != UIImage(named: "addImage")
        {
          
        if !self.SelectedImages.contains(cell.profileImage.image!)//self.imageArray1.contains(cell.profileImage.image!)
            {
            self.imageArray1.append(cell.profileImage.image!)
            }
           
        }
      
        cell.crossButton.tag=indexPath.row
        DataManager.imageCount=self.SelectedImages.count
        
        
        return cell
  
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileCell", for: indexPath) as! EditProfileCell
        if indexPath.row <  self.SelectedImages.count
        {
        cell.crossButton.isHidden = false
        cell.crossButton.tag=indexPath.row
        cell.crossButton.addTarget(self, action: #selector(DeleteImageAct), for: UIControl.Event.touchUpInside)
        self.imageCollectionView.reloadData()
        }

    }
    
    @objc func DeleteImageAct(_ sender:UIButton)
    {

        
        if self.SelectedImages.count>0

        {
            self.SelectedImages.remove(at: sender.tag)

            if sender.tag==0
            {
                self.userProfile=nil
            }


       }
        if SelectedImages.count>0
        {
            self.imageCollectionView.isHidden=false
            self.viewAddImage.isHidden=true
        }
        else
        {
            self.imageCollectionView.isHidden=true

            self.viewAddImage.isHidden=false
        }
        self.imageCollectionView.reloadData()
        DataManager.imageCount=self.SelectedImages.count
    }
    
}

// MARK:- Extension UICollectionViewDelegateFlowLayout
extension ProfilePicVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
            let size = collectionView.frame.size
        self.imageHeight = (size.height/3-3)
        self.imageWidth = (size.width/3-3)
            return CGSize(width:size.width/3-3  , height: (size.height/3-3))
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
        
    }
    
}

extension ProfilePicVC:DrapDropCollectionViewDelegate
{
    
    func dragDropCollectionViewDidMoveCellFromInitialIndexPath(_ initialIndexPath: IndexPath, toNewIndexPath newIndexPath: IndexPath)
    {
        if initialIndexPath.row < self.SelectedImages.count
        {
        let colorToMove = self.SelectedImages[initialIndexPath.row]
       
        if newIndexPath.row < self.SelectedImages.count
        {
            SelectedImages.remove(at: initialIndexPath.row)

            SelectedImages.insert(colorToMove, at: newIndexPath.row)
           
        }
            if initialIndexPath.row < self.imageArray1.count
            {
            let colorToMove = self.imageArray1[initialIndexPath.row]
                if newIndexPath.row < self.imageArray1.count
                {
                    imageArray1.remove(at: initialIndexPath.row)
                    imageArray1.insert(colorToMove, at: newIndexPath.row)
                }
              
            }
        }
       
    }
}
/*
    // MARK: - UICollectionViewDragDelegate Methods
    extension ProfilePicVC : UICollectionViewDragDelegate
    {
        func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
        {
            if indexPath.row<self.SelectedImages.count
            {
            let item = collectionView == imageCollectionView ? self.SelectedImages[indexPath.row] : self.SelectedImages[indexPath.row]
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
            }
            else
            {
                return []
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
        {
            if indexPath.row<self.SelectedImages.count
            {
            let item = collectionView == imageCollectionView ? self.SelectedImages[indexPath.row] : self.SelectedImages[indexPath.row]
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
            }
            else
            {
                return []
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?
        {
            
                let previewParameters = UIDragPreviewParameters()
                previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.imageWidth, height: self.imageHeight))
                return previewParameters
            
        }
    }

// MARK: - UICollectionViewDropDelegate Methods
extension ProfilePicVC : UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
    
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break

//        case .copy:
//            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)

        default:
            return
        }
    }

    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
               
                    if dIndexPath.row<self.SelectedImages.count
                    {
                        
                        self.SelectedImages.insert(item.dragItem.localObject as! UIImage, at: dIndexPath.row)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [dIndexPath])
                        coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
                    }
                   
                

           
            })
           
        }
    }

    /// This method copies a cell from source indexPath in 1st collection view to destination indexPath in 2nd collection view. It works for multiple items.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === self.imageCollectionView
                {
                    self.SelectedImages.insert(item.dragItem.localObject as! UIImage, at: indexPath.row)
                }

                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
}
/*
extension ProfilePicVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        switch coordinator.proposal.operation {
            case .move:
                reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            case .copy:
                copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            default: return
        }
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool { return true }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag, let destinationIndexPath = destinationIndexPath {
            switch SelectedImages[destinationIndexPath.section][destinationIndexPath.row]
            {
                case .simple:
                    return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                case .availableToDrop:
                    return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
            }
        } else { return UICollectionViewDropProposal(operation: .forbidden) }
    }

    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if  items.count == 1, let item = items.first,
            let sourceIndexPath = item.sourceIndexPath,
            let localObject = item.dragItem.localObject as? CellModel {

            collectionView.performBatchUpdates ({
                data[sourceIndexPath.section].remove(at: sourceIndexPath.item)
                data[destinationIndexPath.section].insert(localObject, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
        }
    }

    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                if let localObject = item.dragItem.localObject as? CellModel {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    data[indexPath.section].insert(localObject, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
}
 */

 
 */
