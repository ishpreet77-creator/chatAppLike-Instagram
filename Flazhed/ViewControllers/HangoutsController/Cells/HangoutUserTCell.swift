//
//  HangoutUserTCell.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit

class HangoutUserTCell: UITableViewCell {
    

    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lmgLocation: UIImageView!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var imgDelete: UIImageView!
    
    @IBOutlet weak var lblDelete: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var viewHangoutType: UIView!
    @IBOutlet weak var viewDelete: UIView!
    
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnImageTap: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var lblHangoutType: UILabel!
    @IBOutlet weak var imgHangoutType: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgHangout: UIImageView!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var btnThreeDot: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
     // self.layoutIfNeeded()
        
        //super.awakeFromNib()
          //  self.layoutIfNeeded()
    }

    override func didMoveToSuperview() {
       // super.didMoveToSuperview()
       // layoutIfNeeded()
        
        self.lblLocation.textColor=UIColor.darkGray
        self.lblDateTime.textColor=UIColor.darkGray
        
//        self.imgCalender.image = self.imgCalender.image?.tinted(color: UIColor.darkGray)
//        self.lmgLocation.image = self.lmgLocation.image?.tinted(color: UIColor.darkGray)
    
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
