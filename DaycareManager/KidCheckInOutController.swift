//
//  KidCheckInOutController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/18/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit

class KidCheckInOutController: UIViewController {
    
    var kid: DMKid!
    
    @IBOutlet weak var kidNameLabel: UILabel!
    @IBOutlet weak var kidImageView: UIImageView!
    override func viewDidLoad() {
        
        let url = NSURL(string: kid.imageUrl)
        self.kidNameLabel.text = "\(kid.firstName) \(kid.lastName)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            dispatch_async(dispatch_get_main_queue(), {
                self.kidImageView.image = UIImage(data: data!)
            });
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
}
