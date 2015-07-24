//
//  WebViewController.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/23/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    // due to checking logic in previous view controller, htmlString is guaranteed to not be nil
    var htmlString : String!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("htmlString=\(htmlString)")
        
        if let url = NSURL(string: htmlString)
        {
            /*- (void)viewDidLoad {
                [super viewDidLoad];
                NSString *fullURL = @"http://conecode.com";
                NSURL *url = [NSURL URLWithString:fullURL];
                NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                [_viewWeb loadRequest:requestObj];
            }*/
            //webView.loadHTMLString(htmlString, baseURL: url)
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        } else {
            doAlertWithTitle("Could not make a valid url out of input htmlString", message: "", dismissText: "Okay")
        }
    }
    
    func doAlertWithTitle(title: String, message: String, dismissText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissOption = UIAlertAction(title: dismissText, style: UIAlertActionStyle.Default)
            { _ -> Void in }
        
        alertController.addAction(dismissOption)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
