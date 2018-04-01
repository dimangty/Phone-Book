//
//  Group+CoreDataProperties.swift
//  PhoneBook
//
//  Created by dima on 31.03.18.
//  Copyright © 2018 dima. All rights reserved.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var groupID: String?
    @NSManaged public var groupName: String?
    @NSManaged public var contacts: NSSet?

}

// MARK: Generated accessors for contacts
extension Group {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}
