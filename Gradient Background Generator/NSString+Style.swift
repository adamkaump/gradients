//
//  NSString+Style.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/23/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit

extension NSString {
    class func attributedStringForText(text: String) -> NSAttributedString {
        var attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSStrokeColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length: countElements(text)))
        attributeString.addAttribute(NSStrokeWidthAttributeName, value: -2, range: NSRange(location: 0, length: countElements(text)))

        return attributeString
    }
}