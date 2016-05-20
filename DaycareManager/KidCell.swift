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
    
    func renderCell(kid: DMKid, checkActions:[[String:AnyObject]]) {
        
        let url = NSURL(string: kid.imageUrl)
        self.captionLabel.text = "\(kid.firstName) \(kid.lastName)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                self.imageView.image = UIImage(data: data!)
            });
        }
        
        if checkActions.count > 0 {
            
            for checkAction in checkActions {
                
                for (key, value) in checkAction {
                    
                    if key == "kid" {
                        if value as! String == kid.kidKey {
                            print("\(kid.kidKey) -- nino en check in state")
                        }
                    }
                }
            }
            
        }
    }
    
}
