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
    var bgGradLayer = CAGradientLayer()
    var scrollView = UIScrollView()
    var contentView = UIView()
    let kLabelVertSpacing : CGFloat = 15.0
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var partyStateDistrictLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var openInAppButton: UIButton!
    
    @IBOutlet weak var openInSafariButton: UIButton!
    
    enum SegueId: String
    {
        case ToWeb = "to.web.segue"
    }
    
    let veryLongTestString = "asdfkjopwieuroicviopu4r9087qwe0f98jasdf0jh9820hr98qnef980nwdf980jhq893ru98uf89djas89df0j8902qjr98qner98nwd98js98vj98as0dj980n98rnq98efj98asdnv98asdjf89jasd98fj98qj34r89jq98ef98sandv98asnre89fjq3948jr9ajdv9izxjv98jzx98cvu98sudf98u4iortjfghiuoasdhfguiay89buzx98cvz9xnv98uasdnf98awhef98hq98etu98wrty98adfhvushvu9bncv9uhzxc98vua980ertuy89qy89shdvuishdfv9ubnxcz9ub9adsfh98wuert89uwe89fhas9va98sdhv98ashd98hw98eru89duf98shd98asdf98absd89va89fuq89eruy89duf98ashdf98asd98fas98vuas89dfu98qweyr89ahsdv98absd9f8asdf89045879048970897023489u0890g8usiofjodfbijodf0ub089udsfu80gsdfiongjnopsdfghiu0sdf90u8biuh0sdfbinuinu0u0tgiu03rginuosfinougiu0sdfgju3ju90rginu0wiu54g"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rep = representative
        {
            rep.print()
            nameLabel.text = rep.name
            
            if rep.link!.rangeOfString("house.gov") != nil
            {
                partyStateDistrictLabel.text = String(format: "%@, %@, District %@", rep.party!, rep.state!, rep.district!)
            }
            else
            {
                partyStateDistrictLabel.text = String(format: "%@, %@, %@", rep.party!, rep.state!, rep.district!)
            }
            
            if rep.party == "D"
            {
                doBackgroundGradientWithColors(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                    endColor: UIColor(red: 0.9, green: 0.9, blue: 1.0, alpha: 1.0))
            }
            else if rep.party == "R"
            {
                doBackgroundGradientWithColors(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                    endColor: UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0))
            }
            else
            {
                doBackgroundGradientWithColors(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                    endColor: UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0))
            }
            
            phoneLabel.text = rep.phone
            
            addressLabel.text = rep.office
            
            openInAppButton.setTitle(rep.link, forState: UIControlState.Normal)
            openInAppButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            openInAppButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            openInAppButton.backgroundColor = UIColor.whiteColor()
            openInAppButton.layer.cornerRadius = 5.0
            openInAppButton.layer.shadowOffset = CGSizeMake(1.0, 1.0)
            openInAppButton.layer.shadowColor = UIColor.blackColor().CGColor
            openInAppButton.layer.shadowOpacity = 0.5
            
            openInSafariButton.setTitle(rep.link, forState: UIControlState.Normal)
            openInSafariButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            openInSafariButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            openInSafariButton.backgroundColor = UIColor.whiteColor()
            openInSafariButton.layer.cornerRadius = 5.0
            openInSafariButton.layer.shadowOffset = CGSizeMake(1.0, 1.0)
            openInSafariButton.layer.shadowColor = UIColor.blackColor().CGColor
            openInSafariButton.layer.shadowOpacity = 0.5
            
            openInSafariButton.addTarget(self, action: "openInSafari:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // detect if ios 8.0 or greater
            if floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 {
                // ios 8.0 or > can use autolayout with auto number of lines
                nameLabel.numberOfLines = 0
                partyStateDistrictLabel.numberOfLines = 0
                phoneLabel.numberOfLines = 0
                addressLabel.numberOfLines = 0
            }
            else
            {
                // ios is < 8.0 so can't use numberOfLine = 0
            }
            
        }
        else
        {
            fatalError("Representative in Detail View Controller is nil")
        }
    }
    
    func openInSafari(sender: UIButton!) {
        if let nsUrl = NSURL(string: sender.titleLabel!.text!)
        {
            UIApplication.sharedApplication().openURL(nsUrl)
        }
        else
        {
            let alertController = UIAlertController(title: "Failed to open URL", message: "Link could be broken", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissOption = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default)
                { _ -> Void in }
            alertController.addAction(dismissOption)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        bgGradLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    }
    
    func doBackgroundGradientWithColors(startColor: UIColor, endColor: UIColor)
    {
        bgGradLayer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        bgGradLayer.colors = [
            startColor.CGColor,
            endColor.CGColor
        ]
        bgGradLayer.startPoint = CGPoint(x:0.0, y:0.0)
        bgGradLayer.endPoint = CGPoint(x:0.0, y:1.0)
        bgGradLayer.shouldRasterize = true
        view.layer.insertSublayer(bgGradLayer, atIndex: 0)
    }
    
    func doAlertWithTitle(title: String, message: String, dismissText: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let dismissOption = UIAlertAction(title: dismissText, style: UIAlertActionStyle.Default)
            { _ -> Void in }
        
        alertController.addAction(dismissOption)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == SegueId.ToWeb.rawValue
        {
            if let label = openInAppButton.titleLabel
            {
                if let webString = label.text {
                    return true
                } else {
                    // do alert that the text is nil
                    doAlertWithTitle("Open In App Button text doesn't exist", message: "", dismissText: "Okay")
                    return false
                }
            } else {
                // do alert that the webLink label is nil
                doAlertWithTitle("Open In App Button label is nil", message: "", dismissText: "Okay")
                return false
            }
            
        } else {
            fatalError("unknown segue identifier in RepresentativeDetailViewController")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationViewController = segue.destinationViewController as? WebViewController
        {
            // okay force unwrapping webLink.titleLabel.text here because check that it exists has already been performed in shouldPerformSegueWithIdentifier
            destinationViewController.htmlString = openInAppButton.titleLabel!.text!
        }
        else
        {
            fatalError("Wrong destination view controller type, expected RepresentativeDetailViewController, cast failed")
        }
    }
}
