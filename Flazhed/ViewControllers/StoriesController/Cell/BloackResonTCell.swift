//
//  BloackResonTCell.swift
//  Flazhed
//
//  Created by IOS32 on 08/02/21.
//

import UIKit

class BloackResonTCell: UITableViewCell {

    @IBOutlet weak var imgLine: UIImageView!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
