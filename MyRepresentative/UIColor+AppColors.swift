//
//  UIColor+AppColors.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/24/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
//  UIColor extension to define color scheme used in app in one place

import Foundation
import UIKit

extension UIColor {

    class func cellColorForParty(party: String) -> UIColor {
        switch party {
            case "D":
                return UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
            case "R":
                return UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
            case "I":
                return UIColor.whiteColor()
            default:
                return UIColor.whiteColor()
        }
    }
}

