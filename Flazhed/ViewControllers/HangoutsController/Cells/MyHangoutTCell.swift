//
//  MyHangoutTCell.swift
//  Flazhed
//
//  Created by IOS33 on 24/02/21.
//

import UIKit

class MyHangoutTCell: UITableViewCell {

    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var txtTitle: UITextView!
    @IBOutlet weak var imgHangout: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblHanoutType: UILabel!
    @IBOutlet weak var imgHangoutTypeIcon: UIImageView!
    @IBOutlet weak var viewHangoutType: UIView!

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!

    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var imgSport: UIImageView!
    @IBOutlet weak var imgTraveler: UIImageView!
    @IBOutlet weak var imgSocial: UIImageView!
    @IBOutlet weak var imgSocila: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
