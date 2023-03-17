//
//  CustomTextFieldWithImage.swift
//  Flazhed
//
//  Created by ios2 on 19/04/22.
//

import Foundation
import UIKit

@IBDesignable class CustomTextFieldWithImage: UITextField, UITextFieldDelegate {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var changeHeight: Bool = false {
        didSet {
            updateView()
        }
    }
    @IBInspectable var isCameraImage: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var imageColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImageHeight: Double = 15 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImageWidth: Double = 15 {
        didSet {
            updateView()
        }
    }
    @IBInspectable var selectedBorderColor: UIColor? {
          didSet {
                self.delegate = self
              layer.borderColor = selectedBorderColor?.cgColor
          }
      }

    
    @IBInspectable var copyPaste: Bool = true {
        didSet {
            updateView()
        }
    }
    
    // Provides padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return copyPaste
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    //Update Views
    func updateView() {
        
        //Left Image
        if let image = leftImage {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20+leftPadding, height: 25))
            let paddingImage = UIImageView()
            paddingImage.image = image
            paddingImage.tintColor = imageColor
            paddingImage.contentMode = .scaleAspectFit
            paddingImage.frame = CGRect(x: 3, y: 3, width: 20, height: 18)
            paddingView.addSubview(paddingImage)
            leftView = paddingView
            leftViewMode = UITextField.ViewMode.always
        }
        else {
            let paddingView = UIView(frame: CGRect(x: 0, y: 2, width: leftPadding, height: 0))
            self.leftView = paddingView
            leftViewMode = UITextField.ViewMode.always
        }
        
        //Right Image
        if let image = rightImage {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightImageWidth+leftPadding, height: rightImageHeight))
            let paddingImage = UIImageView()
            paddingImage.image = image
            paddingImage.tintColor = imageColor
            paddingImage.contentMode = .scaleAspectFit
        
            paddingImage.frame = CGRect(x: leftPadding, y: 0, width: rightImageWidth, height: rightImageHeight)
            
           // paddingImage.frame = CGRect(x: 8, y: 6, width: rightImageWidth, height: rightImageHeight)
           
            paddingView.addSubview(paddingImage)
            rightView = paddingView
            rightView?.isUserInteractionEnabled = false
            rightViewMode = UITextField.ViewMode.always

        }
        else {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
            self.rightView = paddingView
            rightViewMode = UITextField.ViewMode.always
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : kEmptyString, attributes:[NSAttributedString.Key.foregroundColor: placeholderColor])
    }
}
