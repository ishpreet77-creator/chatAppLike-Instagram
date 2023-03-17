//
//  UITabBarController+Extension.swift
//  Flazhed
//
//  Created by ios2 on 26/04/22.
//

import Foundation
import UIKit

extension UITabBarController {
    func addRedDotAtTabBarItemIndex(index: Int) {
        let RedDotRadius: CGFloat = 6
        let RedDotDiameter = RedDotRadius * 2
        let TopMargin:CGFloat = 8 //5
        let TabBarItemCount = CGFloat(4)//CGFloat(self.tabBar.items!.count)
        let screenSize = UIScreen.main.bounds
       // let HalfItemWidth = (screenSize.width) / (TabBarItemCount * 2)
       // let xOffset = HalfItemWidth * CGFloat(index * 2 + 2)
       // let imageHalfWidth: CGFloat = (self.tabBar.items![index]).selectedImage?.size.width ?? 0 / 2
        var constant = 47
        if self.getDeviceModel() == "iPhone 6" {
            constant = 46
            //        } else if self.getDeviceModel() == "iPhone 8+" {
            //            constant = 47
            //        } else if self.getDeviceModel() == "iPhone 10" {
            //            constant = 47
        } else {
            constant = 47
        }
        // xOffset + imageHalfWidth - CGFloat(constant)
        let redDot = UIView(frame: CGRect(x: (screenSize.width/4)+40, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        
        if index == 0 {
            redDot.tag = 10
        } else {
            redDot.tag = index
        }
        redDot.backgroundColor = UIColor.red
        redDot.layer.cornerRadius = RedDotRadius
        self.tabBar.addSubview(redDot)
    }
    
    func removeDotAtTabBarItemIndex(index: Int) {
        for subview in self.tabBar.subviews {
            if let subview = subview as? UIView {
                var tag = index
                if index == 0 {
                    tag = 10
                }
                if subview.tag == tag {
                    subview.removeFromSuperview()
                    break
                }
            }
        }
    }
    
    // MARK: Get Device Model
    func getDeviceModel() -> String
    {
        if UIDevice().userInterfaceIdiom == .phone
        {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return "iPhone 6"
            case 1334:
                return "iPhone 6"
            case 1920, 2208:
                return "iPhone 8+"
            case 2436:
                return "iPhone 10"
            case 2688:
                return "iPhone 11"
            case 1792:
                return "iPhone 12"
            default:
                debugPrint("Unknown")
            }
        }
        return "iPhone 8+"
    }
}


