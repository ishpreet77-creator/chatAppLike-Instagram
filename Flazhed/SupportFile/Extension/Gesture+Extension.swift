//
//  Gesture+Extension.swift
//  Flazhed
//
//  Created by ios2 on 18/04/22.
//

import Foundation

extension UITapGestureRecognizer {
   
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
           guard let attributedText = label.attributedText else { return false }

           let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
           mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))
           
           // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.alignment = .center
           mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

           // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
           let layoutManager = NSLayoutManager()
           let textContainer = NSTextContainer(size: CGSize.zero)
           let textStorage = NSTextStorage(attributedString: mutableStr)
           
           // Configure layoutManager and textStorage
           layoutManager.addTextContainer(textContainer)
           textStorage.addLayoutManager(layoutManager)
           
           // Configure textContainer
           textContainer.lineFragmentPadding = 0.0
           textContainer.lineBreakMode = label.lineBreakMode
           textContainer.maximumNumberOfLines = label.numberOfLines
           let labelSize = label.bounds.size
           textContainer.size = labelSize
           
           // Find the tapped character location and compare it to the specified range
           let locationOfTouchInLabel = self.location(in: label)
           let textBoundingBox = layoutManager.usedRect(for: textContainer)
           let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                             y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
           let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                        y: locationOfTouchInLabel.y - textContainerOffset.y);
           let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
           return NSLocationInRange(indexOfCharacter, targetRange)
       }
}


class RangeGestureRecognizer: UITapGestureRecognizer {
    // Stored variables
    typealias MethodHandler = () -> Void
    static var stringRange: String?
    static var function: MethodHandler?
  
}
extension UILabel {
    typealias MethodHandler = () -> Void
    func addRangeGesture(stringRange: String, function: @escaping MethodHandler) {
        RangeGestureRecognizer.stringRange = stringRange
        RangeGestureRecognizer.function = function
        self.isUserInteractionEnabled = true
        let tapgesture: UITapGestureRecognizer = RangeGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
    }

    @objc func tappedOnLabel(_ gesture: RangeGestureRecognizer) {
        guard let text = self.text else { return }
        let stringRange = (text as NSString).range(of: RangeGestureRecognizer.stringRange ?? "")
        if gesture.didTapAttributedTextInLabel(label: self, inRange: stringRange) {
            guard let existedFunction = RangeGestureRecognizer.function else { return }
            existedFunction()
        }
    }
}
