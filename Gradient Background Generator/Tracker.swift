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
    
    class func hasSharedAppToday() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()

        if let lastAppShareDate = userDefaults.valueForKey("lastAppShareDate") as NSDate? {
            let today = NSDate()
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let dif = calendar.compareDate(lastAppShareDate, toDate: today, toUnitGranularity: NSCalendarUnit.DayCalendarUnit)
            return dif == NSComparisonResult.OrderedSame
        } else {
            return false
        }
    }
    
    class func sharedApp() {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(NSDate(), forKey: "lastAppShareDate")
    }
    
    class func proVersionIsPurchased() -> Bool {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let purchasedProducts = appDelegate.iapHelper!.purchasedProductIdentifiers
        
        if (purchasedProducts.containsObject(Constants.proVersionIapId)) {
             return true
        } else {
            return false
        }
    }

    class func buyProVersion() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let iapHelper = appDelegate.iapHelper!
        let proVersion = appDelegate.iapProducts!.firstObject as SKProduct
        iapHelper.buyProduct(proVersion)
    }
}