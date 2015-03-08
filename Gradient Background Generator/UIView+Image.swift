//
//  UIView+Image.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 3/8/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import Foundation

extension UIView {
    func image() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 2.0);
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
        /*
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
        UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshotImage;
        */
    }
}