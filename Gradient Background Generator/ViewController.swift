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
        if (backgroundsGenerated > 20) {
            self.performSegueWithIdentifier("shareOrBuySegue", sender: nil)
            return
        }
        backgroundsGenerated++;
        
        //generate a new background
        self.generateNewBackground()
    }
    
    func generateNewBackground() {
        
        let primaryColor = UIColor.randomColor().CGColor
        let secondaryColor = UIColor.randomColor().CGColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [primaryColor, secondaryColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.transitionView.gradientLayer.removeFromSuperlayer()
        self.transitionView.layer.insertSublayer(gradient, atIndex: 0)
        self.transitionView.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.transitionView.alpha = 1
            }) { (Bool) -> Void in
                self.gradientView.gradientLayer.removeFromSuperlayer()
                self.gradientView.layer.insertSublayer(gradient, atIndex: 0)
                self.gradientView.gradientLayer = gradient
                self.transitionView.alpha = 0
        }
        
        //animate away the ok button
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.okImageView.alpha = 0
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.saveButton.alpha = 1
                })
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        
        //generate image
        UIGraphicsBeginImageContext(self.gradientView.gradientLayer.frame.size)
        self.gradientView.gradientLayer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //save
        ALAssetsLibrary.addImage(image, metaData:nil, toAlbum:"Gradient Backgrounds", handler: { (success) -> Void in
            
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
        })
    }
}

