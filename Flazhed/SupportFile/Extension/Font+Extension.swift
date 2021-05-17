//
//  CustomFont.swift
//  Flazhed
//
//  Created by IOS22 on 31/12/20.
//

import Foundation
import UIKit

extension UIFont {
//    static let regular = "Averta-Regular"
//    static let bold = "Averta-Bold"
//    static let italic = "Averta-RegularItalic"
    enum CustomFont: String {
        case bold = "Averta-Bold"
        case regular = "Averta-Regular"
        
        func fontWithSize(size: CGFloat) -> UIFont {
            return UIFont(name: rawValue, size: size)!
        }
    }
}

