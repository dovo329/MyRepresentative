//
//  DetailViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var zipCode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        view.backgroundColor = UIColor.greenColor()
        queryRepresentatives()
    }
    
    func queryRepresentatives()
    {
        println("my zipCode is \(zipCode)")

        // by your zip code
        
        // reps by last name
        //http://whoismyrepresentative.com/getall_reps_byname.php?name=smith

        // by user's current location (to get zip code)
        
        // reps by state
        // http://whoismyrepresentative.com/getall_reps_bystate.php?state=CA
        
        // sens by last name
        // http://whoismyrepresentative.com/getall_sens_byname.php?name=johnson
        
        // sens by state
        // http://whoismyrepresentative.com/getall_sens_bystate.php?state=ME
        
        let urlString = String(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zipCode)
        if let nsUrl = NSURL(string: urlString)
        {
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(nsUrl, completionHandler:
                { (data, response, error) -> Void in
                    
                    /*if let resultDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    {
                        println("\(resultDictionary)")
                    }
                    else
                    {
                        fatalError("json serialization failed")
                    }*/
                    
                    if let serverResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                    {
                        println("server Response = \(serverResponse)")
                    }
                    
                    println("error: \(error)")
                    if error == nil
                    {
                        /*
                        var jsonSerializationError = NSErrorPointer()
                        //let resultDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: jsonSerializationError) as? NSDictionary
                        let resultDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: jsonSerializationError)
                        println("error: \(jsonSerializationError)")
                        println("dict: \(resultDictionary)")
                        */
                        
                        var jsonError:NSError? = nil
                        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error:&jsonError) {
                            if let dict = jsonObject as? NSDictionary {
                                println(dict)
                            } else {
                                println("not a dictionary")
                            }
                        } else {
                            println("Could not parse JSON: \(jsonError!)")
                        }
                    }
                    else
                    {
                        fatalError("Got an error back")
                    }
                }
            )
            dataTask.resume()
        }
        else
        {
            fatalError("failed to create nsUrl from urlString \(urlString)")
        }
    }
}
