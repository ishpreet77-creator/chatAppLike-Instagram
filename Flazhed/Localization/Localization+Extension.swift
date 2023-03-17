//
//  Localization+Extension.swift
//  Flazhed
//
//  Created by ios2 on 26/04/22.
//

import Foundation
extension String {
    
    var currentLanguage: String {
        Locale.current.languageCode ?? "en"
    }
    
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localized, value: "", comment: "")
    }
}
extension Bundle {
    static var localized: Bundle {
        guard let path = Bundle.main.path(forResource: DataManager.Language ?? "en" , ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}
