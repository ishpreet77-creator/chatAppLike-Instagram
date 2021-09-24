//
//  ReceiverTCell.swift
//  Flazhed
//
//  Created by IOS33 on 24/03/21.
//

import UIKit

class ReceiverTCell: UITableViewCell {
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    
    @IBOutlet weak var imgGif: UIImageView!
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
