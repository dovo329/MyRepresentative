//
//  Global.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/23/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
// functions used by more than one view controller

import Foundation
import UIKit

enum SearchType: Int {
    case ZipCode = 0
    case LastName = 1
    case State = 2
}

func alertWithTitle(title: String, #message: String, #dismissText: String, #viewController: UIViewController) {
    
    // make sure alert controller/alert view is on main thread to avoid crashing
    dispatch_async(dispatch_get_main_queue(),
        { () -> Void in
            // only present new alert if no existing alerts
            if viewController.presentedViewController == nil {
                if objc_getClass("UIAlertController") != nil {
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissOption = UIAlertAction(title: dismissText, style: UIAlertActionStyle.Default)
                        { _ -> Void in }
                    
                    alertController.addAction(dismissOption)
                    
                    if let appDelegate  = UIApplication.sharedApplication().delegate as? AppDelegate {
                        if let rootViewController = appDelegate.window!.rootViewController {
                            rootViewController.presentViewController(alertController, animated:true, completion: nil)
                        } else {
                            fatalError("Failed to access rootViewController from appDelegate")
                        }
                    } else {
                        fatalError("Failed to get access to appDelegate in alertWithTitle")
                    }
                    
                } else {
                    let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: dismissText)
                    alertView.show()
                }
            }
    })
}
