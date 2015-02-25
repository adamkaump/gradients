//
//  ALAssetsLibrary+Album.swift
//  Gradient Background Generator
//
//  Created by Adam Kaump on 2/24/15.
//  Copyright (c) 2015 Adam Kaump. All rights reserved.
//

import UIKit
import AssetsLibrary

extension ALAssetsLibrary {
    
    typealias CompletionHandler = (success:Bool!) -> Void
    class func addImage(image:UIImage, metaData:NSDictionary?, toAlbum albumName:String, handler:CompletionHandler){
        
        var library = ALAssetsLibrary()
        library.addAssetsGroupAlbumWithName(albumName, resultBlock: {(group:ALAssetsGroup!) -> Void in
            //        print("\nAlbum Created:=  \(albumName)");
            var groupToAddTo:ALAssetsGroup?;
            
            library.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupAlbum),
                usingBlock: { (group:ALAssetsGroup?, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    if(group != nil){
                        
                        if group!.valueForProperty(ALAssetsGroupPropertyName) as String == albumName{
                            groupToAddTo = group;
                            
                            //                        print("\nGroup Found \(group!.valueForProperty(ALAssetsGroupPropertyName))\n");
                            
                            library.writeImageToSavedPhotosAlbum(image.CGImage, metadata:metaData, completionBlock: {(assetURL:NSURL!,error:NSError!) -> Void in
                                
                                if(error == nil){
                                    library.assetForURL(assetURL,
                                        resultBlock: { (asset:ALAsset!) -> Void in
                                            var yes:Bool? = groupToAddTo?.addAsset(asset);
                                            if (yes == true){
                                                handler(success: true);
                                            }
                                        },
                                        failureBlock: { (error2:NSError!) -> Void in
                                            print("Failed to add asset");
                                            handler(success: false);
                                    });
                                }
                            });
                        }
                    } /*Group Is Not nil*/
                },
                failureBlock: { (error:NSError!) -> Void in
                    print("Failed to find group");
                    handler(success: false);
            });
            
            }, failureBlock: { (error:NSError!) -> Void in
                print("Failed to create \(error)");
                handler(success: false);
        });
    }
    
}