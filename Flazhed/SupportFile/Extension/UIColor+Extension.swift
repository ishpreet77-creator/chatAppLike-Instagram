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

extension UIColor {

    func getComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let color = self.components
        return (color.red, color.green, color.blue, color.alpha)
    }
    
    class func colorWithHexString (hex: String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    static func randomColor() -> UIColor {
        return UIColor(red: self.random(), green: self.random(), blue: self.random(), alpha: 1.0)
    }
    
    private static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
    class func color(fromDictionary dictionary: [String: Any]) -> UIColor {
        let red = dictionary["red"] as? CGFloat ?? 0.0
        let green = dictionary["green"] as? CGFloat ?? 0.0
        let blue = dictionary["blue"] as? CGFloat ?? 0.0
        let alpha = dictionary["alpha"] as? CGFloat ?? 1.0
        return UIColor(red: red/256.0, green: green/256.0, blue: blue/256.0, alpha: alpha)
    }
  
   
}
