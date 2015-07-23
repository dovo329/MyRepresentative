//
//  ViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var searchByStateButton: UIButton!
    
    var bgGradLayer = CAGradientLayer()
    
    let stateList = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
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
        //let tap = UITapGestureRecognizer(target: self, action: "outsideTap:")
        //view.addGestureRecognizer(tap)
    }
    
    /*func outsideTap(sender: UITapGestureRecognizer!)
    {
    view.endEditing(true)
    }*/
    
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
                    let alertController = UIAlertController(title: "Zip Code Must Be At Least 5 Digits", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissOption = UIAlertAction(title: "Got It", style: UIAlertActionStyle.Default)
                        { _ -> Void in }
                    alertController.addAction(dismissOption)
                    presentViewController(alertController, animated: true, completion: nil)
                    return false
                } else if containsLetters(zipCodeTextField.text) {
                    let alertController = UIAlertController(title: "Zip Codes Are Numbers Only", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    let dismissOption = UIAlertAction(title: "Got It", style: UIAlertActionStyle.Default)
                        { _ -> Void in }
                    alertController.addAction(dismissOption)
                    presentViewController(alertController, animated: true, completion: nil)
                    zipCodeTextField.text = ""
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
        //println("prepareForSegue")
        if let destinationViewController = segue.destinationViewController as? RepresentativeListViewController {
            if segue.identifier == SegueId.ZipCode.rawValue {
            destinationViewController.searchBy = 0
        } else if segue.identifier == SegueId.LastName.rawValue {
            destinationViewController.searchBy = 1
        } else if segue.identifier == SegueId.State.rawValue {
            destinationViewController.searchBy = 2
        } else {
            fatalError("Invalid segue.identifier")
            }
            
            destinationViewController.zipCode = zipCodeTextField.text
            destinationViewController.lastName = lastNameTextField.text
            let pickerIndex = statePicker.selectedRowInComponent(0)
            destinationViewController.state = stateList[pickerIndex]
            
        } else {
            fatalError("Wrong destination view controller type, expected RepresentativeListViewController, cast failed")
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return stateList[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateList.count
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

