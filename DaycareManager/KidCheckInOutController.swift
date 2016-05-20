//
//  KidCheckInOutController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/18/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit
import Firebase

class KidCheckInOutController: UIViewController {
    
    var kid: DMKid!
    var currentParentDadId: String? = nil
    var currentParentMomId: String? = nil
    var selectedParentId: String? = nil
    
    @IBOutlet weak var kidNameLabel: UILabel!
    @IBOutlet weak var kidImageView: UIImageView!
    @IBOutlet weak var momNameLabel: UILabel!
    @IBOutlet weak var dadNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        let url = NSURL(string: kid.imageUrl)
        self.kidNameLabel.text = "\(kid.firstName) \(kid.lastName)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                self.kidImageView.image = UIImage(data: data!)
            });
        }
        
        getParentInformation(kid)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
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
    }
    
    
    @IBAction func momButtonPressed(sender: UIButton) {
        self.selectedParentId = self.currentParentMomId
    }
    
    @IBAction func dadButtonPressed(sender: AnyObject) {
        self.selectedParentId = self.currentParentDadId
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
    
    
    
}
