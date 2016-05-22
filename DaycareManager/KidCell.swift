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
    
    func renderCell(kid: DMKid, kidCachedImages: NSMutableDictionary) {
        
        let url = NSURL(string: kid.imageUrl)
        self.captionLabel.text = "\(kid.firstName) \(kid.lastName)"
        
        if let cachedImage = kidCachedImages.objectForKey(kid.imageUrl) {
            self.imageView.image = nil
            self.checkStatusIcon.image = nil
            self.imageView.image = cachedImage as? UIImage
            
            if kid.currentStatus == .CheckedIn {
                self.checkStatusIcon.image = UIImage(named: "checkedin")
                print("\(kid.kidKey) -- nino en check in state")
            } else if kid.currentStatus == .CheckedOut {
                self.checkStatusIcon.image = UIImage(named: "checkedoutround")
                
                print("\(kid.kidKey) -- nino en check out state")
            }
        } else {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if let imageUrl = url {
                    
                    if let data = NSData(contentsOfURL: imageUrl) {
                        kidCachedImages[kid.imageUrl] = UIImage(data: data)

                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.imageView.image = nil
                            self.checkStatusIcon.image = nil
                            
                            self.imageView.image = UIImage(data: data)
                            
                            if kid.currentStatus == .CheckedIn {
                                self.checkStatusIcon.image = UIImage(named: "checkedin")
                                print("\(kid.kidKey) -- nino en check in state")
                            } else if kid.currentStatus == .CheckedOut {
                                self.checkStatusIcon.image = UIImage(named: "checkedoutround")
                                
                                print("\(kid.kidKey) -- nino en check out state")
                            }
                            
                        });
                    }
                    
                }
            }
        }
        
        
        
//        if checkActions.count > 0 {
//            
//            for checkAction in checkActions {
//                if let kidKey = checkAction["kid"], let checkAction = checkAction["action"] {
//                    
//                    if kidKey as! String == kid.kidKey && checkAction as! String == "checkin" {
//                        
//                        if kid.currentStatus == .Default {
//                            kid.currentStatus = .CheckedIn
//                            self.checkStatusIcon.image = UIImage(named: "checkedin")
//                            print("\(kid.kidKey) -- nino en check in state")
//
//                        }
//                        
//                    } else if kidKey as! String == kid.kidKey && checkAction as! String ==  "checkout" {
//                        
//                        kid.currentStatus = .CheckedOut
//                        self.checkStatusIcon.image = UIImage(named: "checkedoutround")
//
//                        print("\(kid.kidKey) -- nino en check out state")
//                    }
//                }
//            }
//            
//        }
    }
    
}
