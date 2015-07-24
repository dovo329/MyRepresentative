//
//  WebViewController.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/23/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
//  Shows a webview with the URL passed in by the previous Detail View Controller

import UIKit

class WebViewController: UIViewController {

    // due to checking logic in previous view controller, htmlString is guaranteed to not be nil
    var htmlString : String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: htmlString) {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        } else {
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("Not a valid URL", message: "", dismissText: "Okay", viewController: self)
        }
    }
}
