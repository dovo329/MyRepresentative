//
//  ViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//
// Known bug with ios 7.1 simulator when navigating back to this view controller from the RepresentativeListViewController where the layout gets messed up on at least the 4S model.  In ios 8.4 this problem doesn't exist

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet var statePickerDataSource: StatePickerDataSource!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var searchByStateButton: UIButton!
    
    var bgGradLayer = CAGradientLayer()
    
    enum SegueId: String
    {
        case ZipCode = "search.by.zip.code.segue"
        case LastName = "search.by.last.name.segue"
        case State = "search.by.state.segue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        doBackgroundGradientWithColors(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            endColor: UIColor(red: 0.9, green: 1.0, blue: 1.0, alpha: 1.0))
        
        searchByStateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        searchByStateButton.backgroundColor = UIColor.whiteColor()
        searchByStateButton.layer.cornerRadius = 5.0
        searchByStateButton.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        searchByStateButton.layer.shadowColor = UIColor.blackColor().CGColor
        searchByStateButton.layer.shadowOpacity = 0.5
        //searchByStateButton.layer.borderWidth = 1.0
        //searchByStateButton.layer.borderColor = UIColor.blackColor().CGColor
        
        // dismiss keyboard if user taps outside of keyboard area
        let tap = UITapGestureRecognizer(target: self, action: "outsideTap:")
        view.addGestureRecognizer(tap)
    }
    
    func outsideTap(sender: UITapGestureRecognizer!) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        zipCodeTextField.text = ""
        lastNameTextField.text = ""
        view.endEditing(true)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        // check for invalid input and present alert to user to correct it instead of feeding the list view controller bad search input
        if let id = identifier {
            if id == SegueId.ZipCode.rawValue {
                if zipCodeTextField.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) < 5 {
                    zipCodeTextField.text = ""
                    
                    alertWithTitle("Zip Code Must Be At Least 5 Digits", message: "", dismissText: "Got It", viewController: self)
                    
                    return false
                } else if containsLetters(zipCodeTextField.text) {
                    zipCodeTextField.text = ""
                    
                    alertWithTitle("Zip Codes Are Numbers Only", message: "", dismissText: "Got It", viewController: self)
                    
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
                fatalError("Invalid segue id!")
                return false
            }
        } else {
            fatalError("nil segue id!")
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
            fatalError("Invalid segue.identifier")
            }
            
            destinationViewController.zipCode = zipCodeTextField.text
            destinationViewController.lastName = lastNameTextField.text
            let pickerIndex = statePicker.selectedRowInComponent(0)
            destinationViewController.state = statePickerDataSource.stateList[pickerIndex]
        } else {
            fatalError("Wrong destination view controller type, expected RepresentativeListViewController, cast failed")
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
