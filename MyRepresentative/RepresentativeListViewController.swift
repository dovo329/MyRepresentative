//
//  RepresentativeListViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
//  Searches for representatives using the input from the previous SearchViewController.  Presents alerts to user if search times out for either Senator or House Of Representatives search, as well as if no search results returned all (no match).
//  I thought it clearer and simpler to include the tableview datasource in the same file as the view controller as well as the search functions.

import UIKit

class RepresentativeListViewController: UITableViewController {
    
    // Following vars should be populated by previous view controller on segue
    var zipCode : String = ""
    var lastName : String = ""
    var state : String = ""
    var searchType : SearchType?
    
    // arrays to hold search results
    var senatorArr = [Representative]()
    var representativeArr = [Representative]()
    
    // for tableView
    let kCellReuseId = "representative.cell.id"
    
    // time out timers to present alert to user to either retry search or give up
    var repSearchTimer : NSTimer!
    var senSearchTimer : NSTimer!
    
    let kQueryTimeoutInSeconds : NSTimeInterval = 4.0
    
    // flags to check for if no match (both searches are complete and no results returned for either senator or house
    var senSearchDone = false
    var repSearchDone = false
    
    enum SectionId: Int
    {
        case Senator = 0
        case Representative = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchType = searchType {
            searchForRepresentativesBy(searchType)
        } else {
            // searchType should always be vaid from segue from SearchViewController, kick user back out if it isn't, since without this data the I can't search
            // navigationController is guaranteed to be non nil since that's how we got into this view controller
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("Search Type Is Not Valid", message: "", dismissText: "Okay", viewController: self)
        }
    }
    
    func searchForRepresentativesBy(searchType: SearchType)
    {
        senSearchDone = false
        repSearchDone = false

        // let user know we're doing something
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
                // this should never happen, but if it does...
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("ZipCode Is Not Valid", message: "", dismissText: "Okay", viewController: self)
            }
            let urlString = String(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zipCode)
            queryWithUrlString(urlString)
        }
        else if searchType == SearchType.LastName
        {
            if lastName == ""
            {
                // this should never happen, but if it does...
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("Last Name Is Not Valid", message: "", dismissText: "Okay", viewController: self)
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
                // this should never happen, but if it does...
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("State Is Not Valid", message: "", dismissText: "Okay", viewController: self)
            }
            let senatorUrlString = String(format:"http://whoismyrepresentative.com/getall_sens_bystate.php?state=%@&output=json", state)
            queryWithUrlString(senatorUrlString)
            
            let representativeUrlString = String(format:"http://whoismyrepresentative.com/getall_reps_bystate.php?state=%@&output=json", state)
            queryWithUrlString(representativeUrlString)
        }
        else
        {
            // this should never happen, but if it does...
                navigationController?.popViewControllerAnimated(true)
            alertWithTitle("Unknown Search Type", message: "", dismissText: "Okay", viewController: self)
        }
        
        // start both search timeout timers
        senSearchTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "senSearchTimedOut:", userInfo: nil, repeats: false)
        
        repSearchTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "repSearchTimedOut:", userInfo: nil, repeats: false)
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
                    // this should never happen, but if it does...
                    self.navigationController?.popViewControllerAnimated(true)
                    alertWithTitle("Retry Senator Search SearchType Error", message: "", dismissText: "Okay", viewController: self)
                }
            }
        
            let giveUpOption = UIAlertAction(title: "Don't", style: UIAlertActionStyle.Default)
            { _ -> Void in }
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
                        // this should never happen, but if it does...
                        self.navigationController?.popViewControllerAnimated(true)
                        alertWithTitle("Retry House Search SearchType Error", message: "", dismissText: "Okay", viewController: self)
                    }
            }
            
            let giveUpOption = UIAlertAction(title: "Don't", style: UIAlertActionStyle.Default)
                { _ -> Void in }
            alertController.addAction(retryOption)
            alertController.addAction(giveUpOption)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // since using storyboards and segues this will always succeed
        let cell =
        tableView.dequeueReusableCellWithIdentifier(kCellReuseId, forIndexPath: indexPath) as! UITableViewCell
        
        var testRep : Representative? = nil
        if indexPath.section == SectionId.Senator.rawValue {
            if indexPath.row < senatorArr.count {
                testRep = senatorArr[indexPath.row]
            } else {
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("Out Of Bounds Senator Access", message: "", dismissText: "Okay", viewController: self)
            }
        } else if indexPath.section == SectionId.Representative.rawValue {
            if indexPath.row < representativeArr.count {
                testRep = representativeArr[indexPath.row]
            } else {
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("Out Of Bounds Representative Access", message: "", dismissText: "Okay", viewController: self)
            }
        } else {
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("Invalid Section In TableView", message: "", dismissText: "Okay", viewController: self)
        }
        
        if let rep = testRep {
            cell.textLabel!.text = rep.name
            cell.detailTextLabel!.text = String(format:"%@, %@", rep.party!, rep.state!)
            cell.detailTextLabel!.textColor = UIColor.blackColor()
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            // pastel party colors to improve readability over just straight red or blue
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
        } else {
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("Representative is Nil", message: "", dismissText: "Okay", viewController: self)
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
                                                self.navigationController?.popViewControllerAnimated(true)
                                                alertWithTitle("JSON Dictionary Cast Failed", message: "", dismissText: "Okay", viewController: self)
                                            }
                                        }
                                        
                                        let testSenArr = self.getSenators(repArr)
                                        // check if any senators returned, if not not this could be a representative only search so we don't want to clobber the senatorArr
                                        if testSenArr.count > 0 {
                                            self.senatorArr = testSenArr
                                        }
                                        
                                        if urlString.lowercaseString.rangeOfString("getall_sens") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.senSearchDone = true
                                            //println("sen search done")
                                            self.senSearchTimer.invalidate()
                                        }
                                        
                                        let testRepArr = self.getRepresentatives(repArr)
                                        // check if any representatives returned, if not not this could be a representative only search so we don't want to clobber the senatorArr
                                        if testRepArr.count > 0 {
                                            self.representativeArr = testRepArr
                                            self.repSearchDone = true
                                            //println("rep search done")
                                            self.repSearchTimer.invalidate()
                                        }
                                        
                                        if urlString.lowercaseString.rangeOfString("getall_reps") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.repSearchDone = true
                                        }

                                        self.tableView.reloadData()
                                    }
                                )
                            } else {
                                self.navigationController?.popViewControllerAnimated(true)
                                alertWithTitle("JSON Array Cast Failed", message: "", dismissText: "Okay", viewController: self)
                            }
                        } else {
                            // no data returned from server
                            // check for No Match case (both sen and rep searches complete with no results on either)
                            
                            // update UI is on the main thread
                            dispatch_async(dispatch_get_main_queue(),
                                { () -> Void in
                                    // no results returned, set search to done based on url to get search type and invalidate timers
                                    if urlString.lowercaseString.rangeOfString("getall_sens") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.senSearchDone = true
                                            //println("sen search done")
                                            self.senSearchTimer.invalidate()
                                    }
                                    
                                    if urlString.lowercaseString.rangeOfString("getall_reps") != nil || urlString.lowercaseString.rangeOfString("getall_mems") != nil {
                                            self.repSearchDone = true
                                            //println("rep search done")
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
                        self.navigationController?.popViewControllerAnimated(true)
                        alertWithTitle("NSURLSession Error", message: "", dismissText: "Okay", viewController: self)
                    }
            })
            dataTask.resume()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
            alertWithTitle("NSURL Creation Failed", message: "", dismissText: "Okay", viewController: self)
        }
    }
    
    func getSenators(repArr: [Representative]) -> [Representative] {
        // look in search result array and return only senators based on the web address
        var senatorArr = [Representative]()
        for rep in repArr {
            if let link = rep.link {
                if link.rangeOfString("senate.gov") != nil {
                    senatorArr.append(rep)
                }
            } else {
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("getSenators rep.link doesn't exist", message: "", dismissText: "Okay", viewController: self)
            }
        }
        return senatorArr
    }
    
    func getRepresentatives(repArr: [Representative]) -> [Representative] {
        // look in search result array and return only representatives based on the web address
        var representativeArr = [Representative]()
        for rep in repArr {
            if let link = rep.link {
                if link.rangeOfString("house.gov") != nil {
                    representativeArr.append(rep)
                }
            } else {
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("getRepresentatives rep.link doesn't exist", message: "", dismissText: "Okay", viewController: self)
            }
        }
        return representativeArr
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == SectionId.Senator.rawValue {
            return senatorArr.count
        } else if section == SectionId.Representative.rawValue {
            return representativeArr.count
        } else {
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("invalid section in numberOfRowsInSection", message: "", dismissText: "Okay", viewController: self)
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionId.Senator.rawValue {
            return "Senators"
        } else if section == SectionId.Representative.rawValue {
            return "Representatives"
        } else {
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("invalid section in titleForHeaderInSection", message: "", dismissText: "Okay", viewController: self)
            return "Error"
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Always Two sections: Senators and House of Representatives
        return 2
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? RepresentativeDetailViewController {
            if let sender = sender as? UITableViewCell {
                if let repIndexPath = tableView.indexPathForCell(sender) {
                    if repIndexPath.section == SectionId.Senator.rawValue {
                        destinationViewController.representative = senatorArr[repIndexPath.row]
                    } else if repIndexPath.section == SectionId.Representative.rawValue {
                        destinationViewController.representative = representativeArr[repIndexPath.row]
                    } else {
                        navigationController?.popViewControllerAnimated(true)
                        alertWithTitle("invalid section in prepareForSegue", message: "", dismissText: "Okay", viewController: self)
                    }
                } else {
                    navigationController?.popViewControllerAnimated(true)
                    alertWithTitle("Failed to get indexPathForCell", message: "", dismissText: "Okay", viewController: self)
                }
            } else {
                navigationController?.popViewControllerAnimated(true)
                alertWithTitle("prepareForSegue Sender Wrong Type", message: "", dismissText: "Okay", viewController: self)
            }
        } else {
            navigationController?.popViewControllerAnimated(true)
            alertWithTitle("prepareForSegue wrong Dest VC Type", message: "", dismissText: "Okay", viewController: self)
        }
    }
}
