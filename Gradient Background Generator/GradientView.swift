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
        gradientLayer.frame = self.bounds
    }

}
