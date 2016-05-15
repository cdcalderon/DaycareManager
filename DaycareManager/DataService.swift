//
//  DataService.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/15/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "https://daycaremg.firebaseio.com")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
}