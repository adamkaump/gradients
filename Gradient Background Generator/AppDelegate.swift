//
//  AppDelegate.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/20/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var iapHelper: MFIAPHelper?
    var iapProducts: NSArray?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Flurry.startSession(kFlurryKey)
        Flurry.setCrashReportingEnabled(true)
        
        let productString = Constants.proVersionIapId
        let products = NSSet(array: [productString])
        iapHelper = MFIAPHelper(productIdentifiers: products)
        iapHelper?.requestProductsWithCompletionHandler({ (success, products) -> () in
            self.iapProducts = products
        })
        
        return true
    }
}