//
//  ShareOrBuyViewController.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/23/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit

class ShareOrBuyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.attributedText = NSString.attributedStringForText(titleLabel.text!)
        buyLabel.attributedText = NSString.attributedStringForText(buyLabel.text!)
        shareLabel.attributedText = NSString.attributedStringForText(shareLabel.text!)
        backLabel.attributedText = NSString.attributedStringForText(backLabel.text!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"productPurchased", name: IAPHelperProductPurchaseNotification, object: nil)
        
        Flurry.logEvent("Buy Screen Shown")
    }
    
    @IBAction func goBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        Flurry.logEvent("Buy Screen Exited")
    }
    
    @IBAction func buy() {
        Tracker.buyProVersion()
        Flurry.logEvent("App Purchased")
    }
    
    @IBAction func share() {
        self.shareTextImageAndURL(sharingText: "Check out Gradient Backgrounds for iOS",
            sharingImage: nil,
            sharingURL: nil)
    }
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeCopyToPasteboard]
        activityViewController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            
            if ok {
                let parameters = ["Via": items]
                Flurry.logEvent("App Shared", withParameters: parameters)
            } else {
                Flurry.logEvent("App Share Canceled")
            }
            
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func productPurchased() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
