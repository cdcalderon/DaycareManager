//
//  OtherCheckRelativeViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/21/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit

class OtherCheckRelativeViewController: UIViewController, UITextFieldDelegate {

    var kidImage: UIImage?
    
    @IBOutlet weak var kidImageView: UIImageView!
    @IBOutlet weak var otherRelativeFirstName: UITextField!
    @IBOutlet weak var otherRelativeLastName: UITextField!
    
    override func viewDidLoad() {
        
        if let passedKidImage = self.kidImage {
            kidImageView.image = passedKidImage
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
   
}
