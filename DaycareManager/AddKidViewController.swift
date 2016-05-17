//
//  AddKidViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/16/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit

class AddKidViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , CLUploaderDelegate{

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var monthTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    @IBAction func saveKidButtonPressed(sender: UIButton) {
        self.saveKidToFirebase(nil)
    }
    
    @IBAction func addKidImageButtonPressed(sender: UIButton) {
       presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func saveKidToFirebase(imgUrl: String?) {
        var kid: Dictionary<String, AnyObject> = [
            "firstName": firstNameTextField.text!,
            "lastName": lastNameTextField.text!
        ]
        
       // let cloudinary_url = "cloudinary://686262751217777:5qSCCtXQ45SHWF-dUeNi7JkpwZY@carlos-calderon"
        let cloudinary: CLCloudinary = CLCloudinary()
        
        cloudinary.config().setValue("carlos-calderon", forKey: "cloud_name")
        cloudinary.config().setValue("686262751217777", forKey: "api_key")
        cloudinary.config().setValue("5qSCCtXQ45SHWF-dUeNi7JkpwZY", forKey: "api_secret")
        
        let  uploader: CLUploader = CLUploader(cloudinary, delegate: self)
        
        uploader.upload(UIImageJPEGRepresentation(selectedImage.image!, 0.8), options: ["format":"jpg"], withCompletion: { sucessResult, error, code, context in
            print("DONE IMAGE")
            }) { (p1, p2, p3,p4) in
                
        }
        
        
        if imgUrl != nil {
            kid["imageUrl"] = imgUrl!
        }
        
        let firebaseKid = DataService.ds.REF_KIDS.childByAutoId()
        firebaseKid.setValue(kid)
        
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        selectedImage.image = image
    }
}
