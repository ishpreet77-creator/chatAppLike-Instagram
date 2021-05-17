//
//  SenderTCell.swift
//  Flazhed
//
//  Created by IOS33 on 17/03/21.
//

import UIKit

class SenderTCell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
