//
//  Representative.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/21/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
//  Container class to hold myrepresentative API result data

import Foundation

class Representative : NSObject {
    
    var name : String?
    var party : String?
    var state : String?
    var district : String?
    var phone : String?
    var office : String?
    var link : String?
    
    init(dict: NSDictionary) {
        name = dict["name"] as? String
        party = dict["party"] as? String
        state = dict["state"] as? String
        district = dict["district"] as? String
        phone = dict["phone"] as? String
        office = dict["office"] as? String
        link = dict["link"] as? String
    }
    
    func print()
    {
        println("name: \(name)")
        println("party: \(party)")
        println("state: \(state)")
        println("district: \(district)")
        println("phone: \(phone)")
        println("office: \(office)")
        println("link: \(link)")
    }
}
