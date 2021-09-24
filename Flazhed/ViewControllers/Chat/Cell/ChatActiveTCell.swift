//
//  ChatActiveTCell.swift
//  Flazhed
//
//  Created by IOS33 on 31/05/21.
//

import UIKit

class ChatActiveTCell: UITableViewCell {

    @IBOutlet weak var btnInactive: UIButton!
    @IBOutlet weak var btnActive: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
