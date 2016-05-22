//
//  DMKid.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/17/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import Foundation

class DMKid {
    
    private var _firstName: String!
    private var _lastName: String!
    private var _imageUrl: String!
    private var _cachedImage: UIImage?
    private var _kidKey: String!
    private var _parents: Dictionary<String, String> = [:]
    private var _currentStatus: Status = .Default
    private var _checkStatus: String!
    
    
    enum Status {
        case Default, CheckedIn, CheckedOut
    }
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var kidKey: String {
        return _kidKey
    }
    
    var cachedImage: UIImage {
        return _cachedImage!
    }
    
    var parents: Dictionary<String, String> {
        return _parents
    }
    
    var checkStatus: String {
        return _checkStatus
    }
    
    var currentStatus: Status {
        get {
            return _currentStatus
        }
        
        set(value) {
            _currentStatus = value
        }
    }
    
    
    init(firstName: String, lastName: String, imageUrl: String, kidParents: Dictionary<String, String>) {
        self._firstName = firstName
        self._lastName = lastName
        self._imageUrl = imageUrl
        self._parents = kidParents
    }
    
    init(kidKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._kidKey = kidKey
        
        if let firstName = dictionary["firstName"] as? String {
            self._firstName = firstName
        }
        
        if let lastName = dictionary["lastName"] as? String {
            self._lastName = lastName
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let kidparents = dictionary["parents"] as? Dictionary<String, String> {
            self._parents = kidparents
        }
        
        if let checkStatus = dictionary["status"] as? String {
            self._checkStatus = checkStatus
            if self._checkStatus == "checkedin" {
                self.currentStatus = .CheckedIn
            } else if self._checkStatus == "checkedout" {
                self.currentStatus = .CheckedOut
            } else {
                self.currentStatus = .Default
            }
        }
        
        
    }
}