//
//  RoundedShadowView.swift
//  Flazhed
//
//  Created by IOS22 on 04/01/21.
//

import UIKit

class RoundedShadowView: UIView {
    private var shadowLayer: CAShapeLayer!
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
  
    }
    override func layoutSubviews() {
           super.layoutSubviews()

           if shadowLayer == nil {
               shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height/2).cgPath
               shadowLayer.fillColor = UIColor.white.cgColor
          
            shadowLayer.shadowColor = SADOWCOLOR.cgColor
               shadowLayer.shadowPath = shadowLayer.path
               shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.2)
            shadowLayer.shadowOpacity = 1.7
            shadowLayer.shadowRadius = 5

               layer.insertSublayer(shadowLayer, at: 0)
               //layer.insertSublayer(shadowLayer, below: nil) // also works
           }
       }
  
}
