//
//  SortHangoutTCell.swift
//  Flazhed
//
//  Created by IOS33 on 26/02/21.
//

import UIKit

class SortHangoutTCell: UITableViewCell {

    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
