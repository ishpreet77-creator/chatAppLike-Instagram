//
//  ListCell.swift
//  Flazhed
//
//  Created by IOS20 on 08/01/21.
//

import UIKit

class ListCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var bottomLineView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
