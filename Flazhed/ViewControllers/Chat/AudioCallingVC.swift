//
//  AudioCallingVC.swift
//  Flazhed
//
//  Created by IOS25 on 07/01/21.
//

import UIKit

class AudioCallingVC: UIViewController {

    @IBOutlet weak var backBUtton: UIButton!
    @IBOutlet weak var decliineButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func declineCallButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
