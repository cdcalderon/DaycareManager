//
//  KidCell.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/17/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit
import Firebase

class KidCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var checkStatusIcon: UIImageView!
    
    func renderCell(kid: DMKid, checkActions:[[String:AnyObject]], inout kidCachedImage:[String: UIImage]) {
        
        let url = NSURL(string: kid.imageUrl)
        self.captionLabel.text = "\(kid.firstName) \(kid.lastName)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let imageUrl = url {
                
                let data = NSData(contentsOfURL: imageUrl) //make sure your image in this url does exist, otherwise unwrap in a if let
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.imageView.image = UIImage(data: data!)
                    kidCachedImage[kid.imageUrl] = self.imageView.image
                });
            }
        }
        
        if checkActions.count > 0 {
            
            for checkAction in checkActions {
                if let kidKey = checkAction["kid"], let checkAction = checkAction["action"] {
                    
                    if kidKey as! String == kid.kidKey && checkAction as! String == "checkin" {
                        
                        if kid.currentStatus == .Default {
                            kid.currentStatus = .CheckedIn
                            self.checkStatusIcon.image = UIImage(named: "checkedin")
                            print("\(kid.kidKey) -- nino en check in state")

                        }
                        
                    } else if kidKey as! String == kid.kidKey && checkAction as! String ==  "checkout" {
                        
                        kid.currentStatus = .CheckedOut
                        self.checkStatusIcon.image = UIImage(named: "checkedoutround")

                        print("\(kid.kidKey) -- nino en check out state")
                    }
                }
//                for (key, value) in checkAction {
//                    
//                    if key == "kid" {
//                        if value as! String == kid.kidKey &&  {
//                            kid.currentStatus = .CheckedIn
//                            print("\(kid.kidKey) -- nino en check in state")
//                        }
//                    }
//                }
            }
            
        }
    }
    
}
