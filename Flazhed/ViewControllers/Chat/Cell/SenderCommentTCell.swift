//
//  SenderCommentTCell.swift
//  Flazhed
//
//  Created by IOS33 on 06/08/21.
//

import UIKit
class SenderCommentTCell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var viewMessageBack: UIView!
    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var lblCommentText: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var constLeft: NSLayoutConstraint!
    
    @IBOutlet weak var constRight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMessageText.addInterlineSpacing(spacingValue: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
