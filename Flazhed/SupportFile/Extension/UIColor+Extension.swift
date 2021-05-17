//
//  Extension+UIColor.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation
import Foundation
import UIKit

extension UIColor {
    
    enum AppColor  {
        
        case titleColor
        case navBarColor
        case placeHolderColor
        case instagramColor
        case tabbarItemColor
        
        func color(alpha: CGFloat = 1.0) -> UIColor
        {
            var colorToReturn:UIColor?
            switch self
            {
            case .titleColor:
                colorToReturn = UIColor(red: 239/255, green: 241/255, blue: 246/255, alpha: alpha)
                
            case .navBarColor:colorToReturn = APPCOLOR//.init(red: 0/255, green: 96/255, blue: 140/255, alpha: 1)//UIColor(red: 84/255, green: 9/255, blue: 57/255, alpha: alpha)
                
            case .placeHolderColor:colorToReturn = UIColor(red: 189/255, green: 167/255, blue: 179/255, alpha: alpha)
                
            case.instagramColor:
                colorToReturn = UIColor(red:0.22, green:0.40, blue:0.55, alpha:1.0)
            case.tabbarItemColor:
                colorToReturn = UIColor(red: 76/255, green: 179/255, blue: 166/255, alpha: 1.0)

            }
            return colorToReturn!
        }
    }
    
    //TO REMOVE THE NAVIGATION BAR LINE
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
