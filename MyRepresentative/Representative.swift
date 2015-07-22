//
//  Representative.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/21/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import Foundation

class Representative : NSObject {
    
    var district : String?
    var link : String?
    var name : String?
    var office : String?
    var party : String?
    var phone : String?
    var state : String?
    
    init(dict: NSDictionary) {
        district = dict["district"] as? String
        link = dict["link"] as? String
        name = dict["name"] as? String
        office = dict["office"] as? String
        party = dict["party"] as? String
        phone = dict["phone"] as? String
        state = dict["state"] as? String
    }
}
