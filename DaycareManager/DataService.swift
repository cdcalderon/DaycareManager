//
//  DataService.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/15/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://daycaremg.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE    =  Firebase(url: "\(URL_BASE)")
    private var _REF_USERS   =  Firebase(url: "\(URL_BASE)/users")
    private var _REF_KIDS    =  Firebase(url: "\(URL_BASE)/kids")
    private var _REF_PARENTS =  Firebase(url: "\(URL_BASE)/parents")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    var REF_KIDS: Firebase {
        return _REF_KIDS
    }
    
    var REF_PARENTS: Firebase {
        return _REF_PARENTS
    }
    
    var REF_USER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        
        return user!
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}