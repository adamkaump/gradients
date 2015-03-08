//
//  GradientView.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/23/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
//        gradientLayer.frame = self.bounds
    }
    
    override func drawRect(rect: CGRect) {
        
        var ref = UIGraphicsGetCurrentContext()
        
        let primaryColor = UIColor.randomColor().CGColor
        let secondaryColor = UIColor.randomColor().CGColor
        
        var locations = [0.0, 1.0]
        var colors = [primaryColor, secondaryColor]
        let startPoint = CGPoint(x:0.0, y: 0.0)
        let endPoint = CGPoint(x:0, y: self.bounds.size.height)
        
        var colorSpc = CGColorSpaceCreateDeviceRGB();
        var gradient = CGGradientCreateWithColors(colorSpc, colors, nil)
        
        CGContextDrawLinearGradient(ref, gradient, startPoint, endPoint, 3)
    }

}
