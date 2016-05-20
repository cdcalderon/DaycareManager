//
//  AddKidViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/16/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit

class AddKidViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , CLUploaderDelegate{

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
       presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func saveKidToFirebase() {
        
        
       // let cloudinary_url = "cloudinary://686262751217777:5qSCCtXQ45SHWF-dUeNi7JkpwZY@carlos-calderon"
        let cloudinary: CLCloudinary = CLCloudinary()
        
        cloudinary.config().setValue("carlos-calderon", forKey: "cloud_name")
        cloudinary.config().setValue("686262751217777", forKey: "api_key")
        cloudinary.config().setValue("5qSCCtXQ45SHWF-dUeNi7JkpwZY", forKey: "api_secret")
        
        let  uploader: CLUploader = CLUploader(cloudinary, delegate: self)
        
        uploader.upload(UIImageJPEGRepresentation(selectedImage.image!, 0.8), options: ["format":"jpg"], withCompletion: { sucessResult, error, code, context in
            print("DONE IMAGE")
            let kid:[String:AnyObject]
            let firebaseKid = DataService.ds.REF_KIDS.childByAutoId()
            if let firstName = self.firstNameTextField.text where !self.firstNameTextField.text!.isEmpty,
               let lastName = self.lastNameTextField.text where !self.lastNameTextField.text!.isEmpty,
               let imageUrl = sucessResult["url"] where sucessResult["url"] != nil
            {
                 kid = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "imageUrl": imageUrl
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
                    "relationship": "father"
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
                    "relationship": "mother"
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
            
            }) { (p1, p2, p3,p4) in
                
        }
        
        
//        if imgUrl != nil {
//            kid["imageUrl"] = imgUrl!
//        }
        
       
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        selectedImage.image = image
    }
}
