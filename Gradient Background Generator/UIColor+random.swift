//
//  UIColor+random.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/23/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        
        let r = Float(arc4random_uniform(255))
        let g = Float(arc4random_uniform(255))
        let b = Float(arc4random_uniform(255))
        
        let randomColor = UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha:1)
        
        return randomColor
    }
}