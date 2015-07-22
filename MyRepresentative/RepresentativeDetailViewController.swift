//
//  RepresentativeDetailViewController.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/22/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class RepresentativeDetailViewController: UIViewController {

    var representative : Representative?
    var scrollView = UIScrollView()
    var nameLabel = UILabel()
    var partyStateDistrictLabel = UILabel()
    var webLink = UIButton()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orangeColor()
        representative?.print()
    }

    func autoLayoutConstraints()
    {
        
    }
}
