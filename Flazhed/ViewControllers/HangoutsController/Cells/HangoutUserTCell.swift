//
//  HangoutUserTCell.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit

class HangoutUserTCell: UITableViewCell {
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var viewHangoutType: UIView!
    @IBOutlet weak var viewDelete: UIView!
    
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
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
