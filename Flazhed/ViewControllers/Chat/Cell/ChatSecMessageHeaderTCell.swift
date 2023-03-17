//
//  ChatSecMessageHeaderTCell.swift
//  Flazhed
//
//  Created by IOS33 on 31/05/21.
//

import UIKit

class ChatSecMessageHeaderTCell: UITableViewCell {

    @IBOutlet weak var lblShort: UILabel!
    @IBOutlet weak var sortIcon: UIImageView!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblMessage.text = "Chats"
        self.lblShort.text = kSORT
        self.sortIcon.tintColor = PURPLECOLOR
        self.lblMessage.textColor = PURPLECOLOR
        self.lblShort.textColor = PURPLECOLOR
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
