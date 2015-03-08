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
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"productPurchaseFailed", name: IAPHelperProductPurchaseFailNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"iapRestoreFailed", name: IAPHelperProductRestoreFailNotification, object: nil)
        
        Flurry.logEvent("Buy Screen Shown")
    }
    
    @IBAction func goBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        Flurry.logEvent("Buy Screen Exited")
    }
    
    @IBAction func restoreInAppPurchases(sender: AnyObject) {
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeBlack)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let iapHelper = appDelegate.iapHelper!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            iapHelper.restoreCompletedTransactions()
        })
    }
    
    
    @IBAction func buy() {
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeBlack)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            Tracker.buyProVersion()
        })
    }
    
    @IBAction func share() {
        self.shareTextImageAndURL(sharingText: "Check out Gradient Backgrounds for iOS: www.gradientbackgrounds.co",
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
                Tracker.sharedApp()
                self.navigationController?.popToRootViewControllerAnimated(true)
                let parameters = ["Via": s]
                Flurry.logEvent("App Shared", withParameters: parameters)
            } else {
                Flurry.logEvent("App Share Canceled")
            }
            
        }
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func productPurchased() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    
    func productPurchaseFailed() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            var alert = UIAlertController(title: "Error", message: "Unable to purchase. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func iapRestoreFailed() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SVProgressHUD.dismiss()
            var alert = UIAlertController(title: "Error", message: "Unable to restore. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
