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
    @IBOutlet var gradientView: GradientView!
    
    var backgroundsGenerated = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateNewBackground()
        self.titleLabel.attributedText = NSString.attributedStringForText(self.titleLabel.text!)
        self.adjustButton.titleLabel!.attributedText = NSString.attributedStringForText(self.adjustButton.titleLabel!.text!)
        self.randomButton.titleLabel!.attributedText = NSString.attributedStringForText(self.randomButton.titleLabel!.text!)
        self.saveButton.titleLabel!.attributedText = NSString.attributedStringForText(self.saveButton.titleLabel!.text!)
    }
    
    @IBAction func generateNewBackground() {
        
        if (backgroundsGenerated > 10) {
            self.performSegueWithIdentifier("shareOrBuySegue", sender: nil)
            return
        }
        backgroundsGenerated++;
        
        let primaryColor = UIColor.randomColor().CGColor
        let secondaryColor = UIColor.randomColor().CGColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [primaryColor, secondaryColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.gradientView.gradientLayer.removeFromSuperlayer()
        self.gradientView.layer.insertSublayer(gradient, atIndex: 0)
        self.gradientView.gradientLayer = gradient
    }
    
    @IBAction func save(sender: AnyObject) {
        
        var library = ALAssetsLibrary()
        var albumName = "Gradient Backgrounds"
        
        library.addAssetsGroupAlbumWithName(albumName, resultBlock: { (group) -> Void in
            UIGraphicsBeginImageContext(self.gradientView.gradientLayer.frame.size)
            self.gradientView.gradientLayer.renderInContext(UIGraphicsGetCurrentContext())
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                
                if(group != nil) {
                    if group!.valueForProperty(ALAssetsGroupPropertyName) as String == albumName {
                        
                        var metaData = NSDictionary()
                        library.writeImageToSavedPhotosAlbum(image.CGImage, metadata:metaData, completionBlock: {(assetURL:NSURL!,error:NSError!) -> Void in
                            
                            if (error == nil) {
                                
                                library.assetForURL(assetURL,
                                    resultBlock: { (asset: ALAsset!) -> Void in
                                        group.addAsset(asset)
                                        return
                                    },
                                    failureBlock: { (error2: NSError!) -> Void in
                                    
                                    }
                                )
                            }
                        });
                    }
                }
            }, failureBlock: { (error: NSError!) -> Void in
                
            })
            
        }) { (NSError) -> Void in
            print("Error")
        }
    }
}

