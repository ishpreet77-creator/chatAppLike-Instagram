//
//  GIFTCell.swift
//  Flazhed
//
//  Created by IOS33 on 29/04/21.
//

import UIKit

class GIFTCell: UITableViewCell {
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    @IBOutlet weak var rightConst: NSLayoutConstraint!
    @IBOutlet weak var leftConst: NSLayoutConstraint!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgGif: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
