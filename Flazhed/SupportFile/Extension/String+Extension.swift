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
}
