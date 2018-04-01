//
//  Contact+CoreDataProperties.swift
//  PhoneBook
//
//  Created by dima on 31.03.18.
//  Copyright © 2018 dima. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var address: String?
    @NSManaged public var contactID: String?
    @NSManaged public var fullName: String?
    @NSManaged public var phone: String?
    @NSManaged public var groups: NSSet?

}

// MARK: Generated accessors for groups
extension Contact {

    @objc(addGroupsObject:)
    @NSManaged public func addToGroups(_ value: Group)

    @objc(removeGroupsObject:)
    @NSManaged public func removeFromGroups(_ value: Group)

    @objc(addGroups:)
    @NSManaged public func addToGroups(_ values: NSSet)

    @objc(removeGroups:)
    @NSManaged public func removeFromGroups(_ values: NSSet)

}
