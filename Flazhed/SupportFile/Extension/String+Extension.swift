//
//  String+Extension.swift
//  Flazhed
//
//  Created by IOS33 on 08/04/21.
//

import Foundation
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
extension String{
  func equalsIgnoreCase(string:String) -> Bool{
    return self.caseInsensitiveCompare(string) == .orderedSame//self.uppercased() == string.uppercased()
  }
    
    func setPriceWithSign() -> String
    {
        
        return kEmptyString
    }
}
extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

}
extension String {
    
   func getRandomEmail(currentStringAsUsername: Bool = false) -> String {
        let providers = ["gmail.com", "hotmail.com", "icloud.com", "live.com"]
        let randomProvider = providers.randomElement()!
        if currentStringAsUsername && self.count > 0 {
            return "\(self)@\(randomProvider)"
        }
        let username = UUID.init().uuidString.replacingOccurrences(of: "-", with: "")
        return "\(username)@\(randomProvider)"
    }
}


