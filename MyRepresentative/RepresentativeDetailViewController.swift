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
    var contentView = UIView()
    let kLabelVertSpacing : CGFloat = 15.0
    var nameLabel = UILabel()
    var partyStateDistrictLabel = UILabel()
    var webLink = UIButton()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orangeColor()
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

            webLink.setTitle(rep.link, forState: UIControlState.Normal)
            phoneLabel.text = rep.phone
            addressLabel.text = rep.office
            
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
                toItem: contentView,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: nameLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: contentView,
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
                toItem: contentView,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: partyStateDistrictLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: contentView,
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
    
    func webLinkConstraints()
    {
        webLink.setTranslatesAutoresizingMaskIntoConstraints(false)
        // pin left
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: webLink,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: partyStateDistrictLabel,
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
                toItem: contentView,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: phoneLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .RightMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin top
        view.addConstraint(
            NSLayoutConstraint(
                item: phoneLabel,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: webLink,
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
                toItem: contentView,
                attribute: .LeftMargin,
                multiplier: 1.0,
                constant: 0.0))
        
        // pin right
        view.addConstraint(
            NSLayoutConstraint(
                item: addressLabel,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: contentView,
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
        
        // pin bottom
        view.addConstraint(
            NSLayoutConstraint(
                item: addressLabel,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .BottomMargin,
                multiplier: 1.0,
                constant: 0.0))
    }
}
