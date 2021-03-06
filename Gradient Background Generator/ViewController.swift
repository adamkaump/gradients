//
//  ViewController.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/20/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var adjustButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var gradientView: UIView!
    @IBOutlet weak var transitionView: GradientView!
    @IBOutlet weak var okImageView: UIImageView!
    
    var backgroundsGenerated = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateNewBackground()
        self.titleLabel.attributedText = NSString.attributedStringForText(self.titleLabel.text!)
        self.randomButton.titleLabel!.attributedText = NSString.attributedStringForText(self.randomButton.titleLabel!.text!)
        self.saveButton.titleLabel!.attributedText = NSString.attributedStringForText(self.saveButton.titleLabel!.text!)
    }
    
    @IBAction func generateBackgroundButtonTapped() {
        
        //validation
        let backgroundsGenerated = Tracker.backgroundsGenerated()
        let proVersionPurchased = Tracker.proVersionIsPurchased()
        var hasSharedAppToday = Tracker.hasSharedAppToday()
        
        if (backgroundsGenerated >= 20 && !(proVersionPurchased || hasSharedAppToday)) {
            self.performSegueWithIdentifier("shareOrBuySegue", sender: nil)
            return
        }
        Tracker.incrementBackgroundsGenerated()
        
        //generate a new background
        self.generateNewBackground()
    }
    
    func generateNewBackground() {

        var newGradientView = GradientView()
        newGradientView.frame = self.view.frame
        
        let subviews = self.transitionView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
        self.transitionView.addSubview(newGradientView)
        self.transitionView.alpha = 0
        
        self.randomButton.userInteractionEnabled = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.transitionView.alpha = 1
            }) { (Bool) -> Void in
                
                for subview in self.gradientView.subviews {
                    subview.removeFromSuperview()
                }
                newGradientView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                self.gradientView.addSubview(newGradientView)
                self.transitionView.alpha = 0
                self.randomButton.userInteractionEnabled = true
        }
        
        //animate away the ok button
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.okImageView.alpha = 0
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.saveButton.alpha = 1
                })
        }
        
        Flurry.logEvent("Background Generated")
    }
    
    @IBAction func save(sender: AnyObject) {
        
        Flurry.logEvent("Image Saved")
        
        //generate image
        let image = self.gradientView.subviews[0].image()
        
        //save
        ALAssetsLibrary.addImage(image, metaData:nil, albumName:"Gradient Backgrounds", handler: { (success) -> Void in
            if !success! {
                self.showErrorMessage()
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: Selector("resetSaveButton"), userInfo: nil, repeats: false)
            }
        })
        
        //assume image saved for animation
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.saveButton.alpha = 0;
            }, completion: { (Bool) -> Void in
                
                let center = self.okImageView.center
                self.okImageView.frame.size = CGSize(width: 0, height: 0)
                self.okImageView.center = center
                
                UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: nil, animations: { () -> Void in
                    
                    self.okImageView.alpha = 1;
                    self.okImageView.frame.size = CGSize(width: 50, height: 50)
                    self.okImageView.center = center
                    
                    }, completion: { (Bool) -> Void in
                })
        })
    }
    
    func showErrorMessage() {
        var alert = UIAlertController(title: "Error", message: "Unable to save. Please make sure permission is granted in Settings > Privacy > Photos", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func resetSaveButton() {
        self.okImageView.alpha = 0
        self.saveButton.alpha = 1
    }
}

