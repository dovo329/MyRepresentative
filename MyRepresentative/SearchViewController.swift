//
//  SearchViewController.swift
//  MyRepresentative
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
//  Search UI to feed into http://whoismyrepresentative.com API
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // To support ios 7 can't use adaptive views so must make a separate portrait and landscape view and hide the appropriate one based on orientation.  Oy vey!
    @IBOutlet weak var portraitView: UIView!
    @IBOutlet weak var landscapeView: UIView!

    @IBOutlet weak var zipCodeTextFieldPortrait: UITextField!
    @IBOutlet weak var zipCodeTextFieldLandscape: UITextField!
    
    @IBOutlet weak var lastNameTextFieldPortrait: UITextField!
    @IBOutlet weak var lastNameTextFieldLandscape: UITextField!

    @IBOutlet weak var searchByStateButtonPortrait: UIButton!
    @IBOutlet weak var searchByStateButtonLandscape: UIButton!
    
    @IBOutlet weak var statePickerPortrait: UIPickerView!
    @IBOutlet weak var statePickerLandscape: UIPickerView!
    
    @IBOutlet var statePickerDataSource: StatePickerDataSource!
    var bgGradLayer = CAGradientLayer()
    var numberPadBar = UIToolbar()
    
    enum SegueId: String
    {
        case ZipCodePortrait = "search.by.zip.code.portrait.segue"
        case LastNamePortrait = "search.by.last.name.portrait.segue"
        case StatePortrait = "search.by.state.portrait.segue"
        case ZipCodeLandscape = "search.by.zip.code.landscape.segue"
        case LastNameLandscape = "search.by.last.name.landscape.segue"
        case StateLandscape = "search.by.state.landscape.segue"
    }
    
    func updateForOrientation() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation

        //hide/unhide portrait or landscape views
        //copy over input fields on orientation change
        if orientation == UIInterfaceOrientation.Portrait {
            
            portraitView.hidden = false
            landscapeView.hidden = true
            
            zipCodeTextFieldPortrait.text = zipCodeTextFieldLandscape.text
            lastNameTextFieldPortrait.text = lastNameTextFieldLandscape.text
            statePickerPortrait.selectRow(statePickerLandscape.selectedRowInComponent(0), inComponent: 0, animated: false)

        } else {
            
            portraitView.hidden = true
            landscapeView.hidden = false
            
            zipCodeTextFieldLandscape.text = zipCodeTextFieldPortrait.text
            lastNameTextFieldLandscape.text = lastNameTextFieldPortrait.text
            statePickerLandscape.selectRow(statePickerPortrait.selectedRowInComponent(0), inComponent: 0, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateForOrientation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateForOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
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
        zipCodeTextFieldPortrait.text = ""
        zipCodeTextFieldLandscape.text = ""
        lastNameTextFieldPortrait.text = ""
        lastNameTextFieldLandscape.text = ""
        
        // dismiss all keyboards to be safe, though it may not be necessary
        view.endEditing(true)

        // I saw a wrong orientation happen once when coming back from the list view controller, so that's why I'm putting this here to guard against that happening again
        updateForOrientation()
    }
    
    func prettifySearchByStateButton()
    {
        searchByStateButtonPortrait.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        searchByStateButtonPortrait.backgroundColor = UIColor.whiteColor()
        searchByStateButtonPortrait.layer.cornerRadius = 5.0
        searchByStateButtonPortrait.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        searchByStateButtonPortrait.layer.shadowColor = UIColor.blackColor().CGColor
        searchByStateButtonPortrait.layer.shadowOpacity = 0.5
        
        searchByStateButtonLandscape.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        searchByStateButtonLandscape.backgroundColor = UIColor.whiteColor()
        searchByStateButtonLandscape.layer.cornerRadius = 5.0
        searchByStateButtonLandscape.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        searchByStateButtonLandscape.layer.shadowColor = UIColor.blackColor().CGColor
        searchByStateButtonLandscape.layer.shadowOpacity = 0.5
    }
    
    func createNumberPadDoneBar()
    {
        // numberPadBar is for dismissing the number pad which normally doesn't have a "return" or "done" button
        numberPadBar.barStyle = UIBarStyle.Default
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "dismissNumberPad:")
        numberPadBar.items = [flexibleSpace, doneButton]
        numberPadBar.sizeToFit()
        
        zipCodeTextFieldPortrait.inputAccessoryView = numberPadBar
        zipCodeTextFieldLandscape.inputAccessoryView = numberPadBar
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // disable searching by state button while entering text to avoid strange double search results (searching for both text field (zip code or last name) and state at the same time, resulting in an odd two list result screens being pushed on the nav stack
        searchByStateButtonPortrait.enabled = false
        searchByStateButtonLandscape.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // reenable search by state button because it's safe to press it now that the text field entry is done
        searchByStateButtonPortrait.enabled = true
        searchByStateButtonLandscape.enabled = true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        // check for invalid input and present alert to user to correct it instead of feeding the list view controller bad search input
        if let id = identifier {
            if id == SegueId.ZipCodePortrait.rawValue {
                if zipCodeTextFieldPortrait.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) == 0 {
                    // just dismiss with no alert, they may have just changed their minds and don't need an annoying alert
                    return false
                    
                } else if zipCodeTextFieldPortrait.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) != 5 {
                    
                    alertWithTitle("Zip Code Must Be 5 Digits Long", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else if containsNonNumbers(zipCodeTextFieldPortrait.text) {
                    
                    alertWithTitle("Zip Codes Can Only Contain Numbers", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else {
                    return true
                }
            } else if id == SegueId.ZipCodeLandscape.rawValue {
                if zipCodeTextFieldLandscape.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) == 0 {
                    // just dismiss with no alert, they may have just changed their minds and don't need an annoying alert
                    return false
                    
                } else if zipCodeTextFieldLandscape.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) != 5 {
                    
                    alertWithTitle("Zip Code Must Be 5 Digits Long", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else if containsNonNumbers(zipCodeTextFieldLandscape.text) {
                    
                    alertWithTitle("Zip Codes Can Only Contain Numbers", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else {
                    return true
                }
            } else if id==SegueId.LastNamePortrait.rawValue {
                if lastNameTextFieldPortrait.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) == 0 {
                    return false
                } else if containsSpecialCharacters(lastNameTextFieldPortrait.text) {
                    alertWithTitle("Last Name Can't Have Special Characters", message: "", dismissText: "Got It", viewController: self)
                    return false
                } else {
                    return true
                }
            } else if id==SegueId.LastNameLandscape.rawValue {
                if lastNameTextFieldLandscape.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) == 0 {
                    return false
                } else if containsSpecialCharacters(lastNameTextFieldLandscape.text) {
                    alertWithTitle("Last Name Can't Have Special Characters", message: "", dismissText: "Got It", viewController: self)
                    return false
                } else {
                    return true
                }
            } else if id==SegueId.StatePortrait.rawValue || id==SegueId.StateLandscape.rawValue {
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
            
            if segue.identifier == SegueId.ZipCodePortrait.rawValue ||
                segue.identifier == SegueId.ZipCodeLandscape.rawValue {
                destinationViewController.searchType = SearchType.ZipCode
            } else if segue.identifier == SegueId.LastNamePortrait.rawValue ||
                segue.identifier == SegueId.LastNameLandscape.rawValue {
                destinationViewController.searchType = SearchType.LastName
            } else if segue.identifier == SegueId.StatePortrait.rawValue ||
                segue.identifier == SegueId.StateLandscape.rawValue {
                destinationViewController.searchType = SearchType.State
            } else {
                alertWithTitle("Invalid segue.identifier", message: "", dismissText: "Okay", viewController: self)
            }
            
            if segue.identifier == SegueId.ZipCodePortrait.rawValue {
                destinationViewController.zipCode = zipCodeTextFieldPortrait.text
            } else if segue.identifier == SegueId.ZipCodeLandscape.rawValue {
                 destinationViewController.zipCode = zipCodeTextFieldLandscape.text
            } else if segue.identifier == SegueId.LastNamePortrait.rawValue {
                destinationViewController.lastName = lastNameTextFieldPortrait.text
            } else if segue.identifier == SegueId.LastNameLandscape.rawValue {
                destinationViewController.lastName = lastNameTextFieldLandscape.text
            } else if segue.identifier == SegueId.StatePortrait.rawValue {
                let pickerIndex = statePickerPortrait.selectedRowInComponent(0)
                destinationViewController.state = statePickerDataSource.stateList[pickerIndex]
            } else if segue.identifier == SegueId.StateLandscape.rawValue {
                let pickerIndex = statePickerLandscape.selectedRowInComponent(0)
                destinationViewController.state = statePickerDataSource.stateList[pickerIndex]
            } else {
                alertWithTitle("Invalid segue.identifier", message: "", dismissText: "Okay", viewController: self)
            }
        } else {
            alertWithTitle("Dest VC Cast Failed in Search VC", message: "", dismissText: "Okay", viewController: self)
        }
    }        
    
    func containsNonNumbers(testString: String) -> Bool
    {
        let numbers = NSCharacterSet(charactersInString: "1234567890")
        let range = testString.rangeOfCharacterFromSet(numbers.invertedSet)
        
        // range will be nil if no letters is found
        if let test = range {
            return true
        } else {
            return false
        }
    }
    
    func containsSpecialCharacters(testString: String) -> Bool
    {
        let specialChars = NSCharacterSet(charactersInString: " !@#$%^&*()<>?:\"{}|~,./;'[]\\`=_+1234567890")
        let range = testString.rangeOfCharacterFromSet(specialChars)
        
        // range will be nil if anything but letters is found
        if let test = range {
            return true
        } else {
            return false
        }
    }
}
