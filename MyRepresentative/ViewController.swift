//
//  ViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet weak var statePicker: UIPickerView!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    var bgGradLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        doBackgroundGradientWithColors(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            endColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
    }
    
    override func viewDidAppear(animated: Bool) {
        zipCodeTextField.text = ""
        lastNameTextField.text = ""
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
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //println("prepareForSegue")
        if let destinationViewController = segue.destinationViewController as? RepresentativeListViewController
        {
            if zipCodeTextField.text != ""
            {
                destinationViewController.searchBy = 0
            }
            
            if lastNameTextField.text != ""
            {
                destinationViewController.searchBy = 1
            }
            
            destinationViewController.zipCode = zipCodeTextField.text
            destinationViewController.lastName = lastNameTextField.text
            
        }
        else
        {
            fatalError("Wrong destination view controller type, expected RepresentativeListViewController, cast failed")
        }
    }
    
    let stateList = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
    
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

