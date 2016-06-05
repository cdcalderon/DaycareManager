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
    private var _years:Int?
    private var _months: Int?
    private var _days: Int?
    
    private var _dobDay: Int?
    private var _dobMonth: Int?
    private var _dobYear: Int?
    
    
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
    
    var years: Int {
        return _years!
    }
    
    var months: Int {
        return _months!
    }
    
    var days: Int {
        return _days!
    }
    
    var dobDay: Int {
        return _dobDay!
    }
    
    var dobMonth: Int {
        return _dobMonth!
    }
    
    var dobYear: Int {
        return _dobYear!
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
        
        if let dobDay = dictionary["day"] as? Int {
            self._dobDay = dobDay
        }
        
        if let dobMonth = dictionary["month"] as? Int {
            self._dobMonth = dobMonth
        }
        
        if let dobYear = dictionary["year"] as? Int {
            self._dobYear = dobYear
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