//
//  UITextView+Extension.swift
//  Flazhed
//
//  Created by IOS22 on 06/01/21.
//

import Foundation
import UIKit

extension UITextView
{
    func customFontText(boldSting:String,regularSting:String,fontSize:CGFloat?=14.0)
    {

        let attributedText = NSMutableAttributedString(string: boldSting, attributes: [NSAttributedString.Key.font: UIFont(name: "Averta-Semibold", size: fontSize!)!])

        attributedText.append(NSAttributedString(string: regularSting, attributes: [NSAttributedString.Key.font: UIFont(name: "Averta-Regular", size: 14)!]))
        
        //, NSAttributedStringKey.foregroundColor: UIColor.blue

        self.attributedText = attributedText
    }
}
extension UITextView{

    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }

}
