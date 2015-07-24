//
//  DetailViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class RepresentativeListViewController: UITableViewController {
    
    var zipCode : String = ""
    var lastName : String = ""
    var state : String = ""
    var searchType : SearchType?
    var senatorArr = [Representative]()
    var representativeArr = [Representative]()
    let kCellReuseId = "representative.cell.id"
    var repSearchTimer : NSTimer!
    var senSearchTimer : NSTimer!
    let kQueryTimeoutInSeconds : NSTimeInterval = 4.0
    var senSearchDone = false
    var repSearchDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let searchType = searchType {
            searchForRepresentativesBy(searchType)
        } else {
            fatalError("No searchType to search for")
        }
    }
    
    func searchForRepresentativesBy(searchType: SearchType)
    {
        senSearchDone = false
        repSearchDone = false
        
        println("searchType is \(searchType)")
        println("my zipCode is \(zipCode)")
        println("my lastName is \(lastName)")
        println("my state is \(state)")

        title = "Searching..."
        // by zip code
        // Or by user's current location (to get zip code)
        // http://whoismyrepresentative.com/getall_mems.php?zip=31023
        
        // reps by last name
        //http://whoismyrepresentative.com/getall_reps_byname.php?name=smith
        
        // sens by last name
        // http://whoismyrepresentative.com/getall_sens_byname.php?name=johnson
        
        // reps by state
        // http://whoismyrepresentative.com/getall_reps_bystate.php?state=CA
        
        // sens by state
        // http://whoismyrepresentative.com/getall_sens_bystate.php?state=ME
        
        if searchType == SearchType.ZipCode
        {
            if zipCode == ""
            {
                fatalError("attempted to search for empty zip code string")
            }
            let urlString = String(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zipCode)
            queryWithUrlString(urlString)
        }
        else if searchType == SearchType.LastName
        {
            if lastName == ""
            {
                fatalError("attempted to search for empty last name string")
            }
            let senatorUrlString = String(format:"http://whoismyrepresentative.com/getall_sens_byname.php?name=%@&output=json", lastName)
            queryWithUrlString(senatorUrlString)
            
            let representativeUrlString = String(format:"http://whoismyrepresentative.com/getall_reps_byname.php?name=%@&output=json", lastName)
            queryWithUrlString(representativeUrlString)
        }
        else if searchType == SearchType.State
        {
            if state == ""
            {
                fatalError("attempted to search for empty state string")
            }
            let senatorUrlString = String(format:"http://whoismyrepresentative.com/getall_sens_bystate.php?state=%@&output=json", state)
            queryWithUrlString(senatorUrlString)
            
            let representativeUrlString = String(format:"http://whoismyrepresentative.com/getall_reps_bystate.php?state=%@&output=json", state)
            queryWithUrlString(representativeUrlString)
        }
        else
        {
            fatalError("this search type not implemented")
        }
        
        senSearchTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "senSearchTimedOut:", userInfo: nil, repeats: false)
        repSearchTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "repSearchTimedOut:", userInfo: nil, repeats: false)
        //searchTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "searchTimedOut:", userInfo: nil, repeats: false)
    }
    
    func senSearchTimedOut(sender: NSTimer!)
    {
        sender.invalidate()
        
        // only present new alert if no existing alerts
        if presentedViewController == nil {
            let alertController = UIAlertController(title: "Senator Search Timed Out", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let retryOption = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default)
            { _ -> Void in
                if let searchType = self.searchType {
                    self.searchForRepresentativesBy(searchType)
                } else {
                    fatalError("Retry senator search no searchType to search for")
                }
            }
        
            let giveUpOption = UIAlertAction(title: "Don't", style: UIAlertActionStyle.Default)
            { _ -> Void in
                
            }
            alertController.addAction(retryOption)
            alertController.addAction(giveUpOption)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func repSearchTimedOut(sender: NSTimer!)
    {
        sender.invalidate()
        
        // only present new alert if no existing alerts
        if presentedViewController == nil {
            let alertController = UIAlertController(title: "House Search Timed Out", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let retryOption = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default)
                { _ -> Void in
                    if let searchType = self.searchType {
                        self.searchForRepresentativesBy(searchType)
                    } else {
                        fatalError("Retry house search no searchType to search for")
                    }
            }
            
            let giveUpOption = UIAlertAction(title: "Don't", style: UIAlertActionStyle.Default)
                { _ -> Void in
                    
            }
            alertController.addAction(retryOption)
            alertController.addAction(giveUpOption)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    /*func queryRepresentatives()
    {
        //println("my zipCode is \(zipCode)")
        //println("my lastName is \(lastName)")
        //println("my state is \(state)")
        //println("my searchBy is \(searchBy)")
        if let searchBy = searchBy {
        } else {
            fatalError("searchBy is nil!")
        }
        
        title = "Searching..."
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
        
        if searchBy == SearchBy.ZipCode
        {
            if zipCode == ""
            {
                fatalError("attempted to search for empty zip code string")
            }
            let urlString = String(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zipCode)
            doQueryWithUrlString(urlString)
        }
        else if searchBy == SearchBy.LastName
        {
            if lastName == ""
            {
                fatalError("attempted to search for empty last name string")
            }
            let senatorUrlString = String(format:"http://whoismyrepresentative.com/getall_sens_byname.php?name=%@&output=json", lastName)
            doQueryWithUrlString(senatorUrlString)
            
            let representativeUrlString = String(format:"http://whoismyrepresentative.com/getall_reps_byname.php?name=%@&output=json", lastName)
            doQueryWithUrlString(representativeUrlString)
        }
        else if searchBy == SearchBy.State
        {
            if state == ""
            {
                fatalError("attempted to search for empty state string")
            }
            let senatorUrlString = String(format:"http://whoismyrepresentative.com/getall_sens_bystate.php?state=%@&output=json", state)
            doQueryWithUrlString(senatorUrlString)
            
            let representativeUrlString = String(format:"http://whoismyrepresentative.com/getall_reps_bystate.php?state=%@&output=json", state)
            doQueryWithUrlString(representativeUrlString)
        }
        else
        {
            fatalError("this search type not implemented")
        }
        
        searchTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "searchTimedOut:", userInfo: nil, repeats: false)
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier(kCellReuseId, forIndexPath: indexPath) as! UITableViewCell
        
        let rep : Representative!
        if indexPath.section == 0
        {
            rep = senatorArr[indexPath.row]
        }
        else
        {
            rep = representativeArr[indexPath.row]
        }
        
        cell.textLabel!.text = rep.name
        cell.detailTextLabel!.text = String(format:"%@, %@", rep.party!, rep.state!)
        cell.detailTextLabel!.textColor = UIColor.blackColor()
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        // pastel party colors to improve readability
        if rep.party == "D"
        {
            cell.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0)
        }
        else if rep.party == "R"
        {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        }
        else if rep.party == "I"
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
        }

        return cell
    }
    
    func queryWithUrlString(urlString : String)
    {
        if let nsUrl = NSURL(string: urlString)
        {
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(nsUrl, completionHandler:
                {(data, response, error) -> Void in
                    //self.searchTimer.invalidate()
                    
                    if error == nil
                    {
                        var jsonError : NSError? = nil
                        let jsonObject : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error:&jsonError)
                        
                        if let jsonObject = jsonObject as? [String:AnyObject]
                        {
                            if let dictArr = jsonObject["results"] as? NSArray
                            {
                                // update UI is on the main thread
                                dispatch_async(
                                    dispatch_get_main_queue(),
                                    { () -> Void in
                                        self.title = "List"
                                        
                                        var repArr = [Representative]()
                                        for dict in dictArr
                                        {
                                            if let dict = dict as? NSDictionary
                                            {
                                                let rep = Representative(dict: dict)
                                                repArr.append(rep)
                                            } else {
                                                fatalError("cast to dictionary failed")
                                            }
                                        }
                                        
                                        let testSenArr = self.getSenators(repArr)
                                        // check if any senators returned, if not not this could be a representative only search so we don't want to clobber the senatorArr
                                        if testSenArr.count > 0 {
                                            self.senatorArr = testSenArr
                                        }
                                        
                                        if urlString.lowercaseString.rangeOfString("getall_sens") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.senSearchDone = true
                                            println("sen search done")
                                            self.senSearchTimer.invalidate()
                                        }
                                        
                                        let testRepArr = self.getRepresentatives(repArr)
                                        // check if any representatives returned, if not not this could be a representative only search so we don't want to clobber the senatorArr
                                        if testRepArr.count > 0 {
                                            self.representativeArr = testRepArr
                                            self.repSearchDone = true
                                            println("rep search done")
                                            self.repSearchTimer.invalidate()
                                        }
                                        
                                        if urlString.lowercaseString.rangeOfString("getall_reps") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.repSearchDone = true
                                        }

                                        self.tableView.reloadData()
                                    }
                                )
                            } else {
                                fatalError("Failed to cast JSON response to NSArray")
                            }
                        } else {
                            // no data returned from server so no matches
                            // update UI is on the main thread
                            dispatch_async(dispatch_get_main_queue(),
                                { () -> Void in
                                    // no results returned, set search to done based on url to get search type and invalidate timers
                                    if urlString.lowercaseString.rangeOfString("getall_sens") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.senSearchDone = true
                                            println("sen search done")
                                            self.senSearchTimer.invalidate()
                                    }
                                    
                                    if urlString.lowercaseString.rangeOfString("getall_reps") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.repSearchDone = true
                                            println("rep search done")
                                            self.repSearchTimer.invalidate()
                                    }

                                    // only alert for no matches if both searches are done (and no results from either search), as we wouldn't want to alert the user unless a representative was not found in both the Senate and the House
                                    if self.senSearchDone && self.repSearchDone {
                                        if self.senatorArr.count == 0 && self.representativeArr.count == 0 {
                                            self.title = "No Matches"
                                            alertWithTitle("No Matches", message: "", dismissText: "Okay", viewController: self)
                                        }
                                    }
                            })
                        }
                    } else {
                        println("error=\(error)")
                        fatalError("Error returned from nsurlsession")
                    }
            })
            dataTask.resume()
        }
        else
        {
            fatalError("failed to create nsUrl from urlString \(urlString)")
        }
    }
    
    /*func doQueryWithUrlString(urlString : String)
    {
        
        if let nsUrl = NSURL(string: urlString)
        {
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(nsUrl, completionHandler:
                {(data, response, error) -> Void in
                    self.searchTimer.invalidate()
                    
                    if error == nil
                    {
                        var jsonError:NSError? = nil
                        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error:&jsonError)
                        
                        if let jsonObject = jsonObject as? [String:AnyObject]
                        {
                            if let dictArr = jsonObject["results"] as? NSArray
                            {
                                // update UI is on the main thread
                                dispatch_async(
                                    dispatch_get_main_queue(),
                                    { () -> Void in
                                        self.title = "List"
                                        
                                        var repArr = [Representative]()
                                        for dict in dictArr
                                        {
                                            if let dict = dict as? NSDictionary
                                            {
                                                let rep = Representative(dict: dict)
                                                rep.print()
                                                repArr.append(rep)
                                            } else {
                                                fatalError("cast to dictionary failed")
                                            }
                                            
                                        }
                                        
                                        let testSenArr = self.getSenators(repArr)
                                        // check if any senators returned, if not not this could be a representative only search so we don't want to clobber the senatorArr
                                        if testSenArr.count > 0
                                        {
                                            self.senatorArr = testSenArr
                                        }
                                        
                                        let testRepArr = self.getRepresentatives(repArr)
                                        // check if any representatives returned, if not not this could be a representative only search so we don't want to clobber the senatorArr
                                        if testRepArr.count > 0
                                        {
                                            self.representativeArr = testRepArr
                                        }

                                        self.tableView.reloadData()
                                    }
                                )
                            } else {
                                fatalError("Failed to cast JSON response to NSArray")
                            }
                        } else {
                            // no data returned from server so no matches
                            // update UI is on the main thread
                            dispatch_async(dispatch_get_main_queue(),
                                { () -> Void in
                                    self.title = "No Matches"
                                    let alertController = UIAlertController(title: "No Matches", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                                    let dismissOption = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default)
                                        { _ -> Void in }
                                    alertController.addAction(dismissOption)
                                    self.presentViewController(alertController, animated: true, completion: nil)
                            })
                        }
                    } else {
                        println("error=\(error)")
                        fatalError("Error returned from nsurlsession")
                    }
            })
            dataTask.resume()
        }
        else
        {
            fatalError("failed to create nsUrl from urlString \(urlString)")
        }
    }*/
    
    func getSenators(repArr: [Representative]) -> [Representative]
    {
        var senatorArr = [Representative]()
        for rep in repArr
        {
            if rep.link!.rangeOfString("senate.gov") != nil
            {
                senatorArr.append(rep)
            }
        }
        return senatorArr
    }
    
    func getRepresentatives(repArr: [Representative]) -> [Representative]
    {
        var representativeArr = [Representative]()
        for rep in repArr
        {
            if rep.link!.rangeOfString("house.gov") != nil
            {
                representativeArr.append(rep)
            }
        }
        return representativeArr
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return senatorArr.count
        }
        else
        {
            return representativeArr.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Senators"
        }
        else
        {
            return "Representatives"
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Two sections: Senators and House of Representatives
        return 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? RepresentativeDetailViewController
        {
            if let sender = sender as? UITableViewCell
            {
                if let repIndexPath = tableView.indexPathForCell(sender)
                {
                    if repIndexPath.section == 0
                    {
                        destinationViewController.representative = senatorArr[repIndexPath.row]
                    }
                    else
                    {
                        destinationViewController.representative = representativeArr[repIndexPath.row]
                    }
                }
                else
                {
                    fatalError("Failed to get indexPathForCell")
                }
            }
            else
            {
                fatalError("prepareForSegue in RepresentativeListViewController expects sender to be a UITableViewCell but it isn't")
            }
        }
        else
        {
            fatalError("Wrong destination view controller type, expected RepresentativeDetailViewController, cast failed")
        }
    }
}
