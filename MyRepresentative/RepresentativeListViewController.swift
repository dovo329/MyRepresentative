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
    var searchBy : Int = 0
    var senatorArr = [Representative]()
    var representativeArr = [Representative]()
    let cellId = "representative.cell.id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryRepresentatives()
    }
    
    func queryRepresentatives()
    {
        println("my zipCode is \(zipCode)")
        println("my lastName is \(lastName)")
        println("my searchBy is \(searchBy)")
        
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
        
        // urlString guaranteed to have a value after this if statements
        var urlString : String!
        if searchBy == 0
        {
            urlString = String(format:"http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=json", zipCode)
        }
        else
        {
            urlString = String(format:"http://whoismyrepresentative.com/getall_sens_byname.php?name=%@&output=json", lastName)
        }
        
        if let nsUrl = NSURL(string: urlString)
        {
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithURL(nsUrl, completionHandler:
                {(data, response, error) -> Void in
                    
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
                                        self.senatorArr = self.getSenators(repArr)
                                        self.representativeArr = self.getRepresentatives(repArr)
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