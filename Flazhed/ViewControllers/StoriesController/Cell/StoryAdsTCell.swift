//
//  StoryAdsTCell.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import UIKit
import GoogleMobileAds

class StoryAdsTCell: UITableViewCell {

    @IBOutlet weak var btnThreeDot: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewAds: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAds.isHidden=true
        // Initialization code
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func cellBannerView(rootVC: UIViewController, frame: CGRect) -> GADBannerView {

        let bannerView = GADBannerView(frame: frame)

        bannerView.frame = frame
      
           bannerView.rootViewController = rootVC
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
//            ["2077ef9a63d2b398840261c8221a0c9b"] // Sample device ID
         //
        
      //  bannerView.adUnitID = "ca-app-pub-9730116356670864~3963495235"
       // GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["b9c134a943232ab79bdde611c1ab45f6"];
        bannerView.adUnitID = APP_ADS_ID
        //bannerView.adUnitID =  "ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-3940256099942544/2934735716"
 //       bannerView.delegate = self
        
        
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height:ADSWIDTH)) //600
        
//        <Google> To get test ads on this device, set:
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [(kGADSimulatorID as! String)]

        //320x480
        
       // 300 x 600
        //336 x 280
        //300 x 250
        //bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(SCREENWIDTH)
        DispatchQueue.main.async {
            bannerView.adSize=adSize//kGADAdSizeMediumRectangle//adSize
            bannerView.load(GADRequest())
        }
        
    
           return bannerView
    
       }
 
    
}
