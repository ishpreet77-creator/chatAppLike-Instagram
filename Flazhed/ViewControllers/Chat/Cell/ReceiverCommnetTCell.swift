//
//  ReceiverCommnetTCell.swift
//  Flazhed
//
//  Created by IOS33 on 06/08/21.
//

import UIKit
class ReceiverCommnetTCell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    
    @IBOutlet weak var imgComment: UIImageView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMessage.addInterlineSpacing(spacingValue: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
