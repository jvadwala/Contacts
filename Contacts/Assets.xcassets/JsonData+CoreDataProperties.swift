//
//  JsonData+CoreDataProperties.swift
//  Contacts
//
//  Created by Jay Vadwala on 2015-12-19.
//  Copyright © 2015 Jay Vadwala. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension JsonData {

    @NSManaged var birthdate: String?
    @NSManaged var city: String?
    @NSManaged var company: String?
    @NSManaged var country: String?
    @NSManaged var favorite: NSNumber?
    @NSManaged var hImage: NSData?
    @NSManaged var home: String?
    @NSManaged var mobile: String?
    @NSManaged var name: String?
    @NSManaged var sImage: NSData?
    @NSManaged var state: String?
    @NSManaged var street: String?
    @NSManaged var work: String?
    @NSManaged var zip: String?

}
