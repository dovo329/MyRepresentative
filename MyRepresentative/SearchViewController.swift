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
        //println("should return")
        textField.resignFirstResponder()
        
        let destinationViewController = RepresentativeListViewController()
                
        /*if let serverResponse = NSString(data: data, encoding: NSAS\
            CIIStringEncoding)
        {
            println("server Response = \(serverResponse)")
        }*/

        // check for invalid input and present alert to user to correct it instead of feeding the list view controller bad search input
        if zipCodeTextField.text != ""
        {
            if zipCodeTextField.text.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) < 5
            {
               println("invalid zip code")
                
                let alertController = UIAlertController(title: "Zip Code Must Be At Least 5 Digits", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissOption = UIAlertAction(title: "Got It", style: UIAlertActionStyle.Default)
                { _ -> Void in
                    
                }
                alertController.addAction(dismissOption)
                presentViewController(alertController, animated: true, completion: nil)
            }
            else
            {
                destinationViewController.searchBy = 0
                destinationViewController.zipCode = zipCodeTextField.text
                navigationController?.pushViewController(destinationViewController, animated: true)
            }
        }
        else if lastNameTextField.text != ""
        {
            destinationViewController.searchBy = 1
            destinationViewController.lastName = lastNameTextField.text
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
        else // no valid textfields so just dismiss the keyboard and don't present the list view controller
        {
            
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //println("prepareForSegue")
        if let destinationViewController = segue.destinationViewController as? RepresentativeListViewController
        {

            if (sender != nil)
            {
                /*if sender!.isKindOfClass(UITextField)
                    {
                    if zipCodeTextField.text != ""
                    {
                        destinationViewController.searchBy = 0
                    }
                    
                    if lastNameTextField.text != ""
                    {
                        destinationViewController.searchBy = 1
                }
                }
                else*/
                // now
                if sender!.isKindOfClass(UIButton)
                {
                    destinationViewController.searchBy = 2
                }
            }
            else
            {
                fatalError("sender is nil in segue in search view controller")
            }
            
            destinationViewController.zipCode = zipCodeTextField.text
            destinationViewController.lastName = lastNameTextField.text
            let pickerIndex = statePicker.selectedRowInComponent(0)
            destinationViewController.state = stateList[pickerIndex]
            
        }
        else
        {
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
}

