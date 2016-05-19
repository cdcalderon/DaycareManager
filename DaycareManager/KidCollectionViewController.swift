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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_KIDS.observeEventType(.Value, withBlock: { snapshot in
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
        
        cell.renderCell(kid)
        
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
}