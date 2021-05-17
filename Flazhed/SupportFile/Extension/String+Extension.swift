//
//  String+Extension.swift
//  Flazhed
//
//  Created by IOS33 on 08/04/21.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
