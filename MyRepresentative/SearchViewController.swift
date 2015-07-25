//
//  SearchViewController.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
//  Search UI to feed into http://whoismyrepresentative.com API
//
//  Known bug with ios 7.1 simulator when navigating back to this view controller from the RepresentativeListViewController where the layout gets messed up on at least the 4S model.  In ios 8.4 this problem doesn't exist

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var portraitView: UIView!
    @IBOutlet weak var landscapeView: UIView!
    
    @IBOutlet weak var zipCodeTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var searchByStateButton: UIButton!

    @IBOutlet weak var statePicker: UIPickerView!

    @IBOutlet var statePickerDataSource: StatePickerDataSource!
    var bgGradLayer = CAGradientLayer()
    var numberPadBar = UIToolbar()
    
    enum SegueId: String
    {
        case ZipCode = "search.by.zip.code.segue"
        case LastName = "search.by.last.name.segue"
        case State = "search.by.state.segue"
    }
    
    func updateHiddenViews() {
        //let orientation = UIDevice.currentDevice().orientation
        let orientation = UIApplication.sharedApplication().statusBarOrientation

        if orientation == UIInterfaceOrientation.Portrait {
            portraitView.hidden = false
            landscapeView.hidden = true
        } else {
            portraitView.hidden = true
            landscapeView.hidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHiddenViews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateHiddenViews", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        let colors = UIColor.gradientColorsForSearch()
        doBackgroundGradientWithColors(colors[0], endColor: colors[1])

        prettifySearchByStateButton()
        createNumberPadDoneBar()
        
        // dismiss keyboard if user taps outside of keyboard area
        let tap = UITapGestureRecognizer(target: self, action: "outsideTap:")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        // auto clear fields when coming back from list view controller
        zipCodeTextField.text = ""
        lastNameTextField.text = ""
        view.endEditing(true)
    }
    
    func prettifySearchByStateButton()
    {
        searchByStateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        searchByStateButton.backgroundColor = UIColor.whiteColor()
        searchByStateButton.layer.cornerRadius = 5.0
        searchByStateButton.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        searchByStateButton.layer.shadowColor = UIColor.blackColor().CGColor
        searchByStateButton.layer.shadowOpacity = 0.5
    }
    
    func createNumberPadDoneBar()
    {
        // numberPadBar is for dismissing the number pad which normally doesn't have a "return" or "done" button
        numberPadBar.barStyle = UIBarStyle.Default
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "dismissNumberPad:")
        numberPadBar.items = [flexibleSpace, doneButton]
        numberPadBar.sizeToFit()
        
        zipCodeTextField.inputAccessoryView = numberPadBar
    }
    
    func outsideTap(sender: UITapGestureRecognizer!) {
        view.endEditing(true)
    }
    
    func dismissNumberPad(sender: UIBarButtonItem!)
    {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        // needed because layers don't do autolayout so must update frames manually
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss keyboard when return is hit
        textField.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        // check for invalid input and present alert to user to correct it instead of feeding the list view controller bad search input
        if let id = identifier {
            if id == SegueId.ZipCode.rawValue {
                if zipCodeTextField.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) != 5 {
                    zipCodeTextField.text = ""
                    
                    alertWithTitle("Zip Code Must Be 5 Digits Long", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else if containsLetters(zipCodeTextField.text) {
                    zipCodeTextField.text = ""
                    
                    alertWithTitle("Zip Codes Can't Contain Letters", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else {
                    return true
                }
            } else if id==SegueId.LastName.rawValue {
                return lastNameTextField.text != ""
            } else if id==SegueId.State.rawValue {
                // will always have valid data from the picker
                return true
            } else {
                alertWithTitle("Invalid segue id", message: "", dismissText: "Okay", viewController: self)
                return false
            }
        } else {
            alertWithTitle("nil segue id", message: "", dismissText: "Okay", viewController: self)
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let destinationViewController = segue.destinationViewController as? RepresentativeListViewController {
            if segue.identifier == SegueId.ZipCode.rawValue {
            destinationViewController.searchType = SearchType.ZipCode
        } else if segue.identifier == SegueId.LastName.rawValue {
            destinationViewController.searchType = SearchType.LastName
        } else if segue.identifier == SegueId.State.rawValue {
            destinationViewController.searchType = SearchType.State
        } else {
                alertWithTitle("Invalid segue.identifier", message: "", dismissText: "Okay", viewController: self)
            }
            
            destinationViewController.zipCode = zipCodeTextField.text
            destinationViewController.lastName = lastNameTextField.text
            let pickerIndex = statePicker.selectedRowInComponent(0)
            destinationViewController.state = statePickerDataSource.stateList[pickerIndex]
        } else {
            alertWithTitle("Dest VC Cast Failed in Search VC", message: "", dismissText: "Okay", viewController: self)
        }
    }        
    
    func containsLetters(testString: String) -> Bool
    {
        let letters = NSCharacterSet.letterCharacterSet()
        let range = testString.rangeOfCharacterFromSet(letters)
        
        // range will be nil if no letters is found
        if let test = range {
            return true
        }
            else {
            return false
        }
    }
}
