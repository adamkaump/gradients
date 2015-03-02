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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Flurry.startSession(kFlurryKey)
        Flurry.setCrashReportingEnabled(true)
        
        return true
    }
}

