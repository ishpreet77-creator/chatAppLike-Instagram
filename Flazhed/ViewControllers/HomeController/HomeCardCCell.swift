//
//  HomeCardCCell.swift
//  Flazhed
//
//  Created by IOS22 on 11/01/21.
//

import UIKit

class HomeCardCCell: UICollectionViewCell {
    @IBOutlet weak var viewBlur: UIVisualEffectView!
    
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        userImage.isUserInteractionEnabled=true
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
//        tapGestureRecognizer.numberOfTapsRequired=1
//        tapGestureRecognizer.numberOfTouchesRequired=1
//
//        userImage.addGestureRecognizer(tapGestureRecognizer)

      //  userImage.roundSelectedCorners(corners: [.topLeft,.topRight], radius: 20)
       // userImage.clipsToBounds=true
        // Initialization code
    }
//    @objc func didTapImageView(_ sender: UITapGestureRecognizer) {
//           print("did tap image view", sender)
//       }
}
