//
//  Button.swift
//  Vadi New
//
//  Created by ios2 on 22/06/20.
//  Copyright © 2020 ios2. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomButton: UIButton {
    @IBInspectable var leftImage: UIImage? = nil
    @IBInspectable var rightImage: UIImage? = nil
    @IBInspectable var gapPadding: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {

        if(leftImage != nil) {
            let imageView = UIImageView(image: leftImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(imageView)

            let length = CGFloat(15)
            titleEdgeInsets.left += length

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: gapPadding),
                imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: -2),
                imageView.widthAnchor.constraint(equalToConstant: length),
                imageView.heightAnchor.constraint(equalToConstant: length),
            ])
        }

        if(rightImage != nil) {
            let imageView = UIImageView(image: rightImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            addSubview(imageView)

            let length = CGFloat(20)
            titleEdgeInsets.right += length

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: gapPadding),
                imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                imageView.widthAnchor.constraint(equalToConstant: length),
                imageView.heightAnchor.constraint(equalToConstant: length)
            ])
        }
    }
}

