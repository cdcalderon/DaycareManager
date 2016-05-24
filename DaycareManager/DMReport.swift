//
//  DMReport.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/23/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import Foundation


class DMReport {
    
    private var _kidFirstName: String!
    private var _kidLastName: String!
    
    private var _kidKey: String!
    private var _checkInDay: Int!
    private var _checkInMonth: Int!
    private var _checkInYear: Int!
    
    private var _checkOutDay: Int!
    private var _checkOutMonth: Int!
    private var _checkOutYear: Int!
    
    private var _parentFirstName: String!
    private var _parentLastName: String!
    
    
    var kidFirstName: String {
        return _kidFirstName
    }
    
    var kidLastName: String {
        return _kidLastName
    }
    
    var kidKey: String {
        return _kidKey
    }
    
    var checkInDay: Int {
        return _checkInDay
    }
    
    var checkInMonth: Int {
        return _checkInMonth!
    }
    
    var checkInYear: Int {
        return _checkInYear
    }
    
    var checkOutDay: Int {
        return _checkInDay
    }
    
    var checkOutMonth: Int {
        return _checkOutMonth!
    }
    
    var checkOutYear: Int {
        return _checkOutYear
    }
    
    var parentFirstName: String {
        return _parentFirstName
    }
    
    var parentLastName: String {
        return _parentLastName
    }
    
    
    init(kidFirstName: String, kidLastName: String, kidKey: String, checkInDay: Int, checkInMonth: Int, checkInYear: Int, checkOutDay: Int, checkOutMonth: Int, checkOutYear: Int,parentFirstName: String, parentLastName: String) {
        
        self._kidFirstName = kidFirstName
        self._kidLastName = kidLastName
        self._kidKey = kidKey
        self._checkInDay = checkInDay
        self._checkInMonth = checkInMonth
        self._checkInYear = checkInYear
        self._checkOutDay = checkInDay
        self._checkOutMonth = checkInMonth
        self._checkOutYear = checkInYear
        self._parentFirstName = parentFirstName
        self._parentLastName = parentLastName
        
    }
}