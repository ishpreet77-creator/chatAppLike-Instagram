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
    func customFontText(boldSting:String,regularSting:String,fontSize:CGFloat=14.0,spacing:CGFloat=8)
    {

//        let attributedText = NSMutableAttributedString(string: boldSting, attributes: [NSAttributedString.Key.font: UIFont(name: "Averta-Semibold", size: fontSize!)!])
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9.5
        
        let attributedText = NSMutableAttributedString(string: boldSting, attributes: [NSAttributedString.Key.font: UIFont.CustomFont.bold.fontWithSize(size: fontSize),
          NSAttributedString.Key.paragraphStyle : style])

       // attributedText.append(NSAttributedString(string: regularSting, attributes: [NSAttributedString.Key.font: UIFont(name: "Averta-Regular", size: 14)!]))
        
        attributedText.append(NSAttributedString(string: regularSting, attributes: [NSAttributedString.Key.font: UIFont.CustomFont.regular.fontWithSize(size: 14),NSAttributedString.Key.paragraphStyle : style]))
             
        //, NSAttributedStringKey.foregroundColor: UIColor.blue

        self.attributedText = attributedText

       
    }
    
    func TextSpacing(text:String,fontSize:CGFloat=14.0,spacing:CGFloat=8)
    {

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9.5
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.CustomFont.SemiBold.fontWithSize(size: fontSize),
          NSAttributedString.Key.paragraphStyle : style])

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
