//
//  ActiveInactiveTCell.swift
//  Flazhed
//
//  Created by IOS33 on 31/05/21.
//

import UIKit

class ActiveInactiveTCell: UITableViewCell {

    @IBOutlet weak var grayView: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var menuBtn2: UIButton!
    @IBOutlet weak var rightUnreadConst: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var userProfileIMage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var userLastMessageLabel: UILabel!
    @IBOutlet weak var pendingMessagesNumberLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var imgRead: UIImageView!
    @IBOutlet weak var ConstLblMessge: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userNameLabel.numberOfLines=1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
