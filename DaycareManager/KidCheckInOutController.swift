//
//  KidCheckInOutController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/18/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit
import Firebase

class KidCheckInOutController: UIViewController, UITextFieldDelegate {
    
    var kid: DMKid!
    var kidImage: UIImage?
    var otherFirstName: String!
    var otherLastName: String!
    
    
    var currentParentDadId: String? = nil
    var currentParentMomId: String? = nil
    var selectedParentId: String? = nil
    
    @IBOutlet weak var kidNameLabel: UILabel!
    @IBOutlet weak var kidImageView: UIImageView!
    @IBOutlet weak var momNameLabel: UILabel!
    @IBOutlet weak var dadNameLabel: UILabel!
    
    @IBOutlet weak var momCheckButton: UIButton!
    @IBOutlet weak var dadCheckButton: UIButton!
    @IBOutlet weak var otherCheckButton: UIButton!
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    
    @IBOutlet weak var otherFullName: UILabel!
    override func viewDidLoad() {
        
        let url = NSURL(string: kid.imageUrl)
        self.kidNameLabel.text = "\(kid.firstName) \(kid.lastName)"
        
        if let cachedKitImage = kidImage {
            self.kidImageView.image = cachedKitImage

        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                dispatch_async(dispatch_get_main_queue(), {
                    self.kidImageView.image = UIImage(data: data!)
                });
            }
        }
        
        getParentInformation(kid)
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getParentInformation(kid:DMKid) {
        
        for (key, value) in kid.parents {
            
            if value == "dad" {
                DataService.ds.REF_PARENTS.childByAppendingPath(key).observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot)
                    
                    let parent = snapshot.value as? Dictionary<String, AnyObject>
                    if let firstName = parent!["firstName"],let lastName = parent!["lastName"] {
                        
                        self.dadNameLabel.text = "\(firstName) \(lastName)"
                        self.currentParentDadId = key
                    }
                    
                })
                
            } else if value == "mom" {
                DataService.ds.REF_PARENTS.childByAppendingPath(key).observeEventType(.Value, withBlock: { snapshot in
                    print(snapshot)
                    
                    let parent = snapshot.value as? Dictionary<String, AnyObject>
                    if let firstName = parent!["firstName"],let lastName = parent!["lastName"] {
                        
                        self.momNameLabel.text = "\(firstName) \(lastName)"
                        self.currentParentMomId = key
                    }
                    
                })
            }
                        
        }
    }
    
    @IBAction func checkInButtomPressed(sender: UIButton) {
        
        let firebaseCheckAction = DataService.ds.REF_CHECK_ACTION.childByAutoId()
        let todayDate = getTodayDate()
        let checkAction = [
            "day": todayDate.day,
            "month": todayDate.month,
            "year": todayDate.year,
            "hour": todayDate.hour,
            "minute": todayDate.minute,
            "fulldate": "\(todayDate.month)-\(todayDate.day)-\(todayDate.year)",
            "action": "checkin",
            "kid": self.kid.kidKey,
            "parent": self.selectedParentId!
        ]
        
        firebaseCheckAction.setValue(checkAction)
        checkInButton.enabled = false
        
        let firebaseKid = DataService.ds.REF_KIDS.childByAppendingPath(self.kid.kidKey)
        let kid = [
            "status": "checkedin"
        ]
        firebaseKid.updateChildValues(kid)
    }
    
    @IBAction func checkOutButtonPressed(sender: UIButton) {
        
        let firebaseCheckAction = DataService.ds.REF_CHECK_ACTION.childByAutoId()
        let todayDate = getTodayDate()
        let checkAction = [
            "day": todayDate.day,
            "month": todayDate.month,
            "year": todayDate.year,
            "hour": todayDate.hour,
            "fulldate": "\(todayDate.month)-\(todayDate.day)-\(todayDate.year)",
            "minute": todayDate.minute,
            "action": "checkout",
            "kid": self.kid.kidKey,
            "parent": self.selectedParentId!
        ]
        
        firebaseCheckAction.setValue(checkAction)
        checkOutButton.enabled = false
        
        let firebaseKid = DataService.ds.REF_KIDS.childByAppendingPath(self.kid.kidKey)
        let kid = [
            "status": "checkedout"
        ]
        firebaseKid.updateChildValues(kid)
    }
    
    
    @IBAction func momButtonPressed(sender: UIButton) {
        self.selectedParentId = self.currentParentMomId
        setupCheckButtonsStatus()
        setMomSelectedState()
    }
    
    @IBAction func dadButtonPressed(sender: AnyObject) {
        self.selectedParentId = self.currentParentDadId
        setupCheckButtonsStatus()
        setDadSelectedState()
    }
    
    
    @IBAction func addedOtherRelative(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(OtherCheckRelativeViewController) {
            let otherCheckRelativeVC = segue.sourceViewController as! OtherCheckRelativeViewController
            
            if let otherRelativeFirstName = otherCheckRelativeVC.otherRelativeFirstName.text, let otherRelativeLastName = otherCheckRelativeVC.otherRelativeLastName.text {
                let todayDate = getTodayDate()
                self.otherFullName.text = "\(otherRelativeFirstName) \(otherRelativeLastName)"
                self.otherFullName.hidden = false
                setupCheckButtonsStatus()
                setOtherSelectedState()
                self.selectedParentId = "\(otherRelativeFirstName)-\(otherRelativeLastName)-\(todayDate.month)-\(todayDate.day)-\(todayDate.year)"
            }
        }
    }
    
    func getTodayDate() -> (day: Int, month: Int, hour: Int, minute: Int, year: Int){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let hr = components.hour
        let min = components.minute
        
        return (day, month, hr, min, year)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "other" {
            
            let otherRelativeVC = segue.destinationViewController as! OtherCheckRelativeViewController
            otherRelativeVC.kidImage = self.kidImageView.image
            
        }
        
    }
    
    
    func setupCheckButtonsStatus () {
        if kid.currentStatus == .Default {
            setupDefaulState()
        } else if kid.currentStatus == .CheckedIn {
            setupCheckedInState()
        } else if kid.currentStatus == . CheckedOut {
            setupCheckedOutState()
        }

    }
    
    func setupDefaulState () {
        checkOutButton.enabled = false
        checkInButton.enabled = true
        
    }
    
    func setupCheckedInState () {
        checkInButton.enabled = false
        checkOutButton.enabled = true
        
    }
    
    func setupCheckedOutState () {
        checkInButton.enabled = true
        checkOutButton.enabled = false
    }
    
    func setDadSelectedState () {
        
        momCheckButton.setBackgroundImage(UIImage(named: "female-placeholder.png"), forState: UIControlState.Normal)
        
        dadCheckButton.setBackgroundImage(UIImage(named: "male-placeholderchecked"), forState: UIControlState.Normal)
        
        otherCheckButton.setBackgroundImage(UIImage(named: "othercheck"), forState: UIControlState.Normal)
        
    }
    
    func setMomSelectedState () {
        
        momCheckButton.setBackgroundImage(UIImage(named: "female-placeholderchecked"), forState: UIControlState.Normal)
        
        dadCheckButton.setBackgroundImage(UIImage(named: "male-placeholder"), forState: UIControlState.Normal)
        
        otherCheckButton.setBackgroundImage(UIImage(named: "othercheck"), forState: UIControlState.Normal)
        

    }
    
    func setOtherSelectedState () {
        momCheckButton.setBackgroundImage(UIImage(named: "female-placeholder"), forState: UIControlState.Normal)
        
        dadCheckButton.setBackgroundImage(UIImage(named: "male-placeholder"), forState: UIControlState.Normal)
        
        otherCheckButton.setBackgroundImage(UIImage(named: "othercheckchecked"), forState: UIControlState.Normal)
    }
    
    
    func confirmAction () {
        var refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
   
}
