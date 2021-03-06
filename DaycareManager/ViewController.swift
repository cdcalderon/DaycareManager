//
//  ViewController.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/13/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //let predicateForParents = NSPredicate(format: "parent == true")
        
        let parents = Parent.MR_findAll()
    }

    @IBAction func SaveParent(sender: UIButton) {
        let parent = Parent.MR_createEntity()
        parent?.firstName = "carlos"
        parent?.lastName = "calderon"
        
        let context = NSManagedObjectContext.MR_defaultContext()
        
        context.MR_saveToPersistentStoreAndWait()
    }

}

