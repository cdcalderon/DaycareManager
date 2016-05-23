//
//  KidCollectionViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/17/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit
import Firebase

class KidCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var kidCollectionView: UICollectionView!
    
    var kidsArray = [DMKid]()
    var kidsImages = NSMutableDictionary()
    //var checkActions = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        DataService.ds.REF_CHECK_ACTION.queryOrderedByChild("fulldate").queryEqualToValue("\(todayDate.month)-\(todayDate.day)-\(todayDate.year)")
//            .observeEventType(.Value, withBlock: { snapshot in
//                print(snapshot)
//                self.checkActions = []
//                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                    
//                    for snap in snapshots {
//                        print("SNAP:  \(snap)")
//                        
//                        if let checkAction = snap.value as? Dictionary<String, AnyObject> {
//                            self.checkActions.append(checkAction)
//                        }
//                    }
//                }
//                
//                self.kidCollectionView.reloadData()
//            })
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let currentAppUser = DataService.ds.REF_USER_CURRENT
        
        DataService.ds.REF_KIDS.queryOrderedByChild("userappid").queryEqualToValue(currentAppUser.key).observeEventType(.Value, withBlock: { snapshot in
            print(snapshot)
            
            self.kidsArray = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP:  \(snap)")
                    
                    if let kidDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let kid = DMKid(kidKey: key, dictionary: kidDict)
                        self.kidsArray.append(kid)
                    }
                }
            }
            
            self.kidCollectionView.reloadData()
        })
        
    }
    
    // MARK: - UICollectionViewDataSOurce
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return kidsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: KidCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! KidCell
        
        let kid = kidsArray[indexPath.row]
        print("OBJECT : \(kid.firstName) - \(kid.lastName) ")
        
        
        cell.renderCell(kid, kidCachedImages: kidsImages)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("checkinkid", sender: self)
        
        //performSegueWithIdentifier("checkinkid", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "checkinkid" {
            let indexPaths = self.kidCollectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            
            let kidCheckInOutVC = segue.destinationViewController as! KidCheckInOutController
            kidCheckInOutVC.kid = kidsArray[indexPath.row]
            
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
}