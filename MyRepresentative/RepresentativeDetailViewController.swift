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
    var nameLabel = UILabel()
    var partyStateDistrictLabel = UILabel()
    var webLink = UIButton()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    let veryLongTestString = "asdfkjopwieuroicviopu4r9087qwe0f98jasdf0jh9820hr98qnef980nwdf980jhq893ru98uf89djas89df0j8902qjr98qner98nwd98js98vj98as0dj980n98rnq98efj98asdnv98asdjf89jasd98fj98qj34r89jq98ef98sandv98asnre89fjq3948jr9ajdv9izxjv98jzx98cvu98sudf98u4iortjfghiuoasdhfguiay89buzx98cvz9xnv98uasdnf98awhef98hq98etu98wrty98adfhvushvu9bncv9uhzxc98vua980ertuy89qy89shdvuishdfv9ubnxcz9ub9adsfh98wuert89uwe89fhas9va98sdhv98ashd98hw98eru89duf98shd98asdf98absd89va89fuq89eruy89duf98ashdf98asd98fas98vuas89dfu98qweyr89ahsdv98absd9f8asdf89045879048970897023489u0890g8usiofjodfbijodf0ub089udsfu80gsdfiongjnopsdfghiu0sdf90u8biuh0sdfbinuinu0u0tgiu03rginuosfinougiu0sdfgju3ju90rginu0wiu54g"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rep = representative
        {
            rep.print()
            nameLabel.text = rep.name
            nameLabel.numberOfLines = 0
            
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

            webLink.setTitle(rep.link, forState: UIControlState.Normal)
            webLink.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            webLink.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            webLink.backgroundColor = UIColor.whiteColor()
            webLink.layer.cornerRadius = 5.0
            webLink.layer.shadowOffset = CGSizeMake(5.0, 5.0)
            webLink.layer.shadowColor = UIColor.blackColor().CGColor
            webLink.layer.shadowOpacity = 0.5
            webLink.layer.borderWidth = 1.0
            webLink.layer.borderColor = UIColor.blackColor().CGColor
            
            webLink.addTarget(self, action: "openWebLink:", forControlEvents: UIControlEvents.TouchUpInside)
            
            phoneLabel.text = rep.phone
            phoneLabel.numberOfLines = 0
            
            addressLabel.text = rep.office
            addressLabel.numberOfLines = 0
            
            contentView.addSubview(nameLabel)
            contentView.addSubview(partyStateDistrictLabel)
            contentView.addSubview(webLink)
            contentView.addSubview(phoneLabel)
            contentView.addSubview(addressLabel)
            scrollView.addSubview(contentView)
            view.addSubview(scrollView)
            autoLayoutConstraints()
        }
        else
        {
            fatalError("Representative in Detail View Controller is nil")
        }
    }
    
    func openWebLink(sender: UIButton!) {
        println("weblink opened")
        
        if let nsUrl = NSURL(string: sender.titleLabel!.text!)
        {
            UIApplication.sharedApplication().openURL(nsUrl)
        }
        else
        {
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("Failed to open url");
            alertView.title = "link could be broken";
            alertView.message = "Okay";
            alertView.show();
        }
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com"]];
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
        view.layer.addSublayer(bgGradLayer)
    }
    
    func autoLayoutConstraints()
    {
        scrollViewConstraints()
        contentViewConstraints()
        nameLabelConstraints()
        partyStateDistrictLabelConstraints()
        webLinkConstraints()
        phoneLabelConstraints()
        addressLabelConstraints()
    }
    
    func scrollViewConstraints()
    {
        // pin scrollView to edges of viewcontroller's view

        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: scrollView,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Left,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: scrollView,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Right,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: scrollView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin bottom
        view.addConstraint(
            NSLayoutConstraint(
                item: scrollView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0))
    }

    func contentViewConstraints()
    {
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin contentView to edges of scrollview
        // Scrollviews are special in that pinning the edges of a contentview to the scrollview doesn't mean what it normally does, but rather tells the scrollView to use this view for it's contentsize.  See http://stackoverflow.com/questions/16825189/auto-layout-uiscrollview-with-subviews-with-dynamic-heights/30282707#30282707
        
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: scrollView,
                attribute: .Left,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: scrollView,
                attribute: .Right,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: scrollView,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin bottom
        view.addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: scrollView,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0.0))
        
        // needs width constraint
        // height is handled by height of labels it contains
        view.addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Width,
                multiplier: 1.0,
                constant: 0.0))
    }
    
    func nameLabelConstraints()
    {
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: nameLabel,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: nameLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: nameLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .TopMargin,
                multiplier: 1.0,
                constant: 0.0))
    }
    
    func partyStateDistrictLabelConstraints()
    {
        partyStateDistrictLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: partyStateDistrictLabel,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: partyStateDistrictLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: partyStateDistrictLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: nameLabel,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: kLabelVertSpacing))
    }
    
    func phoneLabelConstraints()
    {
        phoneLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: phoneLabel,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: phoneLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: phoneLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: partyStateDistrictLabel,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: kLabelVertSpacing))
    }
    
    func addressLabelConstraints()
    {
        addressLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: addressLabel,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: addressLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: addressLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: phoneLabel,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: kLabelVertSpacing))
    }
    
    func webLinkConstraints()
    {
        webLink.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: view,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: view,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: addressLabel,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: kLabelVertSpacing))
        
        // pin bottom
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .BottomMargin,
                multiplier: 1.0,
                constant: 0.0))
    }
}
