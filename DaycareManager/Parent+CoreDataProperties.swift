//
//  Parent+CoreDataProperties.swift
//  DaycareManager
//
//  Created by carlos calderon on 5/13/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Parent {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phone: String?
    @NSManaged var formattedPhone: String?
    @NSManaged var gender: String?
    @NSManaged var institutionId: String?
    @NSManaged var id: String?
    @NSManaged var kids: NSSet?

}
