//
//  UILabel+Extension.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation
import UIKit


extension UILabel {

    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 10) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }

}

extension UITextView {

    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 10) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }

}

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

       
    }

}
extension UILabel {
    func underlineMyText(range1:String, range2:String) {
        if let textString = self.text {
            let str = NSString(string: textString)
            let firstRange = str.range(of: range1)
            let secRange = str.range(of: range2)
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: firstRange)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: secRange)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attributedString.length
            ))
//            attributedString.addAttribute(
//                .font,
//                value: UIFont.CustomFont.regular.fontWithSize(size: 13),
//                range: NSRange(location: 0, length: attributedString.length
//            ))
            attributedText = attributedString
            
        }
    }
    
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
    
    func makeBoldText(withString string: String, boldString: String, normalfont: UIFont=UIFont.CustomFont.regular.fontWithSize(size: 16), boldfont: UIFont=UIFont.CustomFont.bold.fontWithSize(size: 16))  {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: normalfont])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: boldfont]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        self.attributedText = attributedString
        
    }
}


extension UILabel {
    func underline() {
        if let textString = self.text
        {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
