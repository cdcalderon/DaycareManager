//
//  AddKidViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/16/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit

class AddKidViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , CLUploaderDelegate, UITextFieldDelegate{

    //kid
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var monthTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    //dad
    @IBOutlet weak var dadFirstNameTextField: UITextField!
    
    @IBOutlet weak var dadLastNameTextField: UITextField!
    
    //mom
    @IBOutlet weak var momFirstNameTextField: UITextField!
    
    @IBOutlet weak var momLastNameTextField: UITextField!
    
    @IBOutlet weak var kidDOBDatePicker: UIDatePicker!
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        

    }
    
    @IBAction func saveKidButtonPressed(sender: UIButton) {
        self.saveKidToFirebase()
        
    }
    
    @IBAction func addKidImageButtonPressed(sender: UIButton) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                //postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
           // postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
     //  presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func selectKidImageFromLibraryButtonPressed(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func saveKidToFirebase() {
       // let cloudinary_url = "cloudinary://686262751217777:5qSCCtXQ45SHWF-dUeNi7JkpwZY@carlos-calderon"
        let cloudinary: CLCloudinary = CLCloudinary()
        
        cloudinary.config().setValue("carlos-calderon", forKey: "cloud_name")
        cloudinary.config().setValue("686262751217777", forKey: "api_key")
        cloudinary.config().setValue("5qSCCtXQ45SHWF-dUeNi7JkpwZY", forKey: "api_secret")
        
        let uploader: CLUploader = CLUploader(cloudinary, delegate: self)
        
        let currentUser = DataService.ds.REF_USER_CURRENT
        
        uploader.upload(UIImageJPEGRepresentation(selectedImage.image!, 0.8), options: ["format":"jpg"], withCompletion: { sucessResult, error, code, context in
            print("DONE IMAGE")
            var kidDOB = self.getDOB()
            let kid:[String:AnyObject]
            let firebaseKid = DataService.ds.REF_KIDS.childByAutoId()
            if let firstName = self.firstNameTextField.text where !self.firstNameTextField.text!.isEmpty,
               let lastName = self.lastNameTextField.text where !self.lastNameTextField.text!.isEmpty,
               let imageUrl = sucessResult["url"] where sucessResult["url"] != nil
            {
                 kid = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "imageUrl": imageUrl,
                    "userappid": currentUser.key,
                    "month": kidDOB.month,
                    "day": kidDOB.day,
                    "year": kidDOB.year
                ]
                firebaseKid.setValue(kid)
                self.firstNameTextField.text = ""
                self.lastNameTextField.text = ""
            }
            
            
            
            if let dadFirstName = self.dadFirstNameTextField.text where !self.dadFirstNameTextField.text!.isEmpty,
               let dadLastName =  self.dadLastNameTextField.text where  !self.dadLastNameTextField.text!.isEmpty{
                let parentDad: Dictionary<String, AnyObject> = [
                    "firstName": dadFirstName,
                    "lastName": dadLastName,
                    "relationship": "father",
                    "userappid": currentUser.key
                ]
                //save parent
                let firebaseParentDad = DataService.ds.REF_PARENTS.childByAutoId()
                firebaseParentDad.setValue(parentDad)
                self.dadFirstNameTextField.text = ""
                self.dadLastNameTextField.text = ""
                
                //save kid to parent's kids
                let firebaseParentDadKids = DataService.ds.REF_PARENTS.childByAppendingPath(firebaseParentDad.key).childByAppendingPath("kids")
                let parentDadKid = [firebaseKid.key: true];
                firebaseParentDadKids.setValue(parentDadKid)
                
                //add parent to kid's parent object
                let firebaseKidParentsDad = DataService.ds.REF_KIDS.childByAppendingPath(firebaseKid.key).childByAppendingPath("parents")
                let dadOfKid = [firebaseParentDad.key: "dad"]
                firebaseKidParentsDad.updateChildValues(dadOfKid)
                
                
            }
            
            if let momFirstName = self.momFirstNameTextField.text where !self.momFirstNameTextField.text!.isEmpty,
               let momLastName =  self.momLastNameTextField.text where !self.momLastNameTextField.text!.isEmpty{
                let parentMom: Dictionary<String, AnyObject> = [
                    "firstName": momFirstName,
                    "lastName": momLastName,
                    "relationship": "mother",
                    "userappid": currentUser.key

                ]
                
                let firebaseParentMom = DataService.ds.REF_PARENTS.childByAutoId()
                firebaseParentMom.setValue(parentMom)
                self.momFirstNameTextField.text = ""
                self.momLastNameTextField.text = ""
                
                //save kid to parent's kids
                let firebaseParentMomKids = DataService.ds.REF_PARENTS.childByAppendingPath(firebaseParentMom.key).childByAppendingPath("kids")
                let parentMomKid = [firebaseKid.key: true];
                firebaseParentMomKids.setValue(parentMomKid)
                
                //add parent to kid's parent object
                let firebaseKidParentsMom = DataService.ds.REF_KIDS.childByAppendingPath(firebaseKid.key).childByAppendingPath("parents")
                let momOfKid = [firebaseParentMom.key: "mom"]
                firebaseKidParentsMom.updateChildValues(momOfKid)
                
            }
            self.navigationController?.popViewControllerAnimated(true)
            }) { (p1, p2, p3,p4) in
                
        }
        
        
    }
    @IBAction func kidDOBDatePickerValueChanged(sender: UIDatePicker) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        selectedImage.image = image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    func getDOB() -> (day: Int, month: Int, year: Int){
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: self.kidDOBDatePicker.date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return (day, month, year)
    }

    
}
