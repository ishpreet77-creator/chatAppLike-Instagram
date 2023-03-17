//
//  ChatListingTVC.swift
//  Flazhed
//
//  Created by IOS25 on 07/01/21.
//

import UIKit

class ChatListingTVC: UITableViewCell {
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
        circularProgressView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
