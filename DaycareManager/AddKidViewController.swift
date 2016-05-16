//
//  AddKidViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/16/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit

class AddKidViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var monthTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    
    @IBAction func saveKidButtonPressed(sender: UIButton) {
        self.saveKidToFirebase(nil)
    }
    
    func saveKidToFirebase(imgUrl: String?) {
        var kid: Dictionary<String, AnyObject> = [
            "firstName": firstNameTextField.text!,
            "lastName": lastNameTextField.text!
        ]
        
        if imgUrl != nil {
            kid["imageUrl"] = imgUrl!
        }
        
        let firebaseKid = DataService.ds.REF_KIDS.childByAutoId()
        firebaseKid.setValue(kid)
        
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
}
