//
//  GoPremiumCell.swift
//  Flazhed
//
//  Created by IOS20 on 09/01/21.
//

import UIKit

class GoPremiumCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var lblDollar: UILabel!
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var cellBGImage: UIImageView!
    @IBOutlet weak var iceBreakerImage: UIImageView!
    @IBOutlet weak var lblIcebreaker: UILabel!
    @IBOutlet weak var lblPack: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

