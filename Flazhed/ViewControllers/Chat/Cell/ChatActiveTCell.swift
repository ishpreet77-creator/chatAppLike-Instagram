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
        self.btnActive.setTitle(kActiveChats, for: .normal)
        self.btnInactive.setTitle(kInactiveChats, for: .normal)
        self.btnActive.setTitle(kActiveChats, for: .selected)
        self.btnInactive.setTitle(kInactiveChats, for: .selected)
        
        self.btnInactive.setTitleColor(PURPLECOLOR, for: .selected)
        self.btnInactive.setTitleColor(ENABLECOLOR, for: .normal)
        
        self.btnActive.setTitleColor(PURPLECOLOR, for: .selected)
        self.btnActive.setTitleColor(ENABLECOLOR, for: .normal)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
