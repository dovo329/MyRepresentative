//
//  ViewController.swift
//  MyRepresentativeSwift
//
//  Created by Douglas Voss on 7/20/15.
//  Copyright (c) 2015 dougsapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.yellowColor()
        //navigationController?.navigationBar.tintColor = UIColor.orangeColor()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //println("should return")
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //println("prepareForSegue")
        if let destinationViewController = segue.destinationViewController as? DetailViewController
        {
            destinationViewController.zipCode = zipCodeTextField.text
        }
        else
        {
            fatalError("Wrong destination view controller type, expected DetailViewController, cast failed")
        }
    }
}

