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
    var searchBy : Int = 0
    var senatorArr = [Representative]()
    var representativeArr = [Representative]()
    let cellId = "representative.cell.id"
    var timeoutTimer : NSTimer!
    let kQueryTimeoutInSeconds : NSTimeInterval = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryRepresentatives()
    }
    
    func searchTimedOut(sender: NSTimer!)
    {
        sender.invalidate()
        
        let alertController = UIAlertController(title: "Search Timed Out", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let retryOption = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default)
        { _ -> Void in
            self.queryRepresentatives()
        }
        
        let giveUpOption = UIAlertAction(title: "Give Up", style: UIAlertActionStyle.Default)
        { _ -> Void in
            
        }
        alertController.addAction(retryOption)
        alertController.addAction(giveUpOption)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func queryRepresentatives()
    {
        println("my zipCode is \(zipCode)")
        println("my lastName is \(lastName)")
        println("my state is \(state)")
        println("my searchBy is \(searchBy)")
        
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
        
        if searchBy == 0
        {
            if zipCode == ""
            {
                fatalError("attempted to search for empty zip code string")
            }
            let urlString = String(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zipCode)
            doQueryWithUrlString(urlString)
        }
        else if searchBy == 1
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
        else if searchBy == 2
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
        
        timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(kQueryTimeoutInSeconds, target: self, selector: "searchTimedOut:", userInfo: nil, repeats: false)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("representative.cell.id", forIndexPath: indexPath) as! UITableViewCell
        
        let rep : Representative!
        if indexPath.section == 0
        {
            rep = senatorArr[indexPath.row]
        }
        else
        {
            rep = representativeArr[indexPath.row]
        }
        
        /*cell.name.text = rep.name
        cell.partyStateDistrict.text = String(format:"%@, %@, District %@", rep.party!, rep.state!, rep.district!)
        cell.phoneNumber.text = rep.phone
        cell.address.text = rep.office
        cell.webAddress.text = rep.link*/
        cell.textLabel!.text = rep.name
        cell.detailTextLabel!.text = String(format:"%@, %@", rep.party!, rep.state!)
        cell.detailTextLabel!.textColor = UIColor.blackColor()
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
        
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
    
    func doQueryWithUrlString(urlString : String)
    {
        //self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kParksQueryTimeoutTimeInSeconds target:self selector:@selector(searchTimedOut:) userInfo:timerArgDict repeats:NO];
        
        /*NSMutableDictionary *timerArgDict = [NSMutableDictionary new];
        [timerArgDict setObject:perkArr forKeyedSubscript:kQueryForPerksPerkArr];
        NSValue *regionWrap = [NSValue value:(const void *)&region withObjCType:@encode(typeof(MKCoordinateRegion))];
        [timerArgDict setObject:regionWrap forKeyedSubscript:kQueryForPerksRegion];*/
        //let timerArgDict = NSMutableDictionary()
        //timerArgDict.setObject(<#anObject: AnyObject#>, forKey: <#NSCopying#>)
        
        if let nsUrl = NSURL(string: urlString)
        {
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(nsUrl, completionHandler:
                {(data, response, error) -> Void in
                    self.timeoutTimer.invalidate()
                    
                    //println("error: \(error)")
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
                                        //println("dictArr=\(dictArr)")
                                        self.title = "List"
                                        
                                        var repArr = [Representative]()
                                        for dict in dictArr
                                        {
                                            if let dict = dict as? NSDictionary
                                            {
                                                //println("dict=\(dict)")
                                                let rep = Representative(dict: dict)
                                                rep.print()
                                                repArr.append(rep)
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
                            }
                        }
                    }
            })
            dataTask.resume()
        }
        else
        {
            fatalError("failed to create nsUrl from urlString \(urlString)")
        }
    }
    
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelect")
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
