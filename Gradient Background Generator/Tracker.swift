//
//  Tracker.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 3/1/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import Foundation
import StoreKit

class Tracker {

    class func incrementBackgroundsGenerated() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var backgroundsGenerated = userDefaults.valueForKey("backgroundsGenerated")?.integerValue
        backgroundsGenerated = backgroundsGenerated != nil ? backgroundsGenerated : 0
        backgroundsGenerated = backgroundsGenerated! + 1
        userDefaults.setValue(backgroundsGenerated, forKey: "backgroundsGenerated")
        userDefaults.synchronize()
    }
    
    class func backgroundsGenerated() -> Int {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        var backgroundsGenerated = userDefaults.valueForKey("backgroundsGenerated")?.integerValue
        backgroundsGenerated = backgroundsGenerated != nil ? backgroundsGenerated : 0
        return backgroundsGenerated!
    }
    
    class func proVersionIsPurchased() -> Bool {
        let productString = "psfgbiap001"
        let products = NSSet(array: [productString])
        let iapHelper = MFIAPHelper(productIdentifiers: products)
        let purchasedProducts = iapHelper.purchasedProductIdentifiers
        
        if (purchasedProducts.containsObject(productString)) {
             return true
        } else {
            return false
        }
    }

    class func buyProVersion() {
        let productString = "psfgbiap001"
        let products = NSSet(array: [productString])
        let iapHelper = MFIAPHelper(productIdentifiers: products)
        
        let product = SKProduct()
        iapHelper.buyProduct(product)
    }
}