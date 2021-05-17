//
//  HangoutAdsTCell.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit

class HangoutAdsTCell: UITableViewCell {

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
