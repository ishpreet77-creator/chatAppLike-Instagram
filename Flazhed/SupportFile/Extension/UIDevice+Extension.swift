//
//  UIDevice+Extension.swift
//  Flazhed
//
//  Created by ios2 on 25/04/22.
//

import Foundation
import UIKit
import AVFoundation

extension UIDevice {
    /// Returns `true` if the device has a notch
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}
extension UIDevice {
    static func vibrate()
    {
           AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
