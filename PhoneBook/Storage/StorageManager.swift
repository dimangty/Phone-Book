//
//  StorageManager.swift
//  PhoneBook
//
//  Created by dima on 31.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

import Foundation
import CoreData

class StorageManager: NSObject {
    static let shared = StorageManager()
    
    // MARK: - Init Context
    
    //Инициализация Core Data
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelPath = Bundle.main.path(forResource: "Model", ofType: "momd")
        let modelUrl = NSURL.fileURL(withPath: modelPath!)
        let model = NSManagedObjectModel.init(contentsOf: modelUrl)
        return model!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let applicationsDocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let storePath = applicationsDocumentsDirectory! + "/DB.sqlite"
        let storeUrl = NSURL.fileURL(withPath: storePath)
        let persistentStoreCoordinator  = NSPersistentStoreCoordinator.init(managedObjectModel: self.managedObjectModel)

        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return persistentStoreCoordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }()
    
    
    // MARK: - Contacts
    /*
     Методы работы с контактами
     */
    func addContact(contactItem: ContactItem) {
        let context = managedObjectContext
        let contact : Contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
       
        contact.fullName = contactItem.fullName
        contact.address = contactItem.address
        contact.phone = contactItem.phone
        if contact.contactID == nil {
            contact.contactID = contactItem.contactID
        } else {
            contact.contactID = NSUUID().uuidString
        }
        
        saveContext()
    }
    
    func addContact(contactItem:ContactItem, toGroupName:String) {
        var group:Group? = getGroup(groupName: toGroupName)
        if group == nil {
            addGroup(groupName: toGroupName)
            group = getGroup(groupName: toGroupName)
        }
        
        var contact:Contact? = getContact(contactID: contactItem.contactID)
        if contact == nil {
            contactItem.contactID = NSUUID().uuidString
            addContact(contactItem: contactItem)
            contact = getContact(contactID: contactItem.contactID)
        }
        
       contact?.addToGroups(group!)
       
        
        saveContext()
    }
    
    func getContacts(groupName: String?, search: String!) -> [ContactItem] {
        var result:[ContactItem] = []
        
        if groupName == nil { //Все контакты
            let context = managedObjectContext
            let request = NSFetchRequest<NSFetchRequestResult>.init()
            
            let description = NSEntityDescription.entity(forEntityName: "Contact", in: context)
            request.entity = description
            
            if !search.isEmpty {//Фильтр по имени
                let predicate = NSPredicate(format: "(fullName contains[c] %@)", search!)
                request.predicate = predicate
            }
            
            let arr = try! context.fetch(request) as! [Contact]
            for item : Contact in arr {
                let contactItem = ContactItem.init()
                contactItem.contactID = item.contactID!
                contactItem.address = item.address!
                contactItem.fullName = item.fullName!
                contactItem.phone = item.phone!
                result.append(contactItem)
            }
        } else {//Контакты для группы
            let group = getGroup(groupName: groupName!)
            if(group == nil) {
                return result
            }
            
            
            var arr: [Contact] = group!.contacts!.allObjects as! [Contact]
            
            if !search.isEmpty {//Фильтр по имени
              let predicate = NSPredicate(format: "(fullName contains[c] %@)", search!)
              arr = arr.filter {predicate.evaluate(with: $0) };
            }
            
            for contact in arr {
                let contactItem = ContactItem.init()
                contactItem.contactID = contact.contactID!
                contactItem.address = contact.address!
                contactItem.fullName = contact.fullName!
                contactItem.phone = contact.phone!
                result.append(contactItem)
            }
        }
        
        result.sort(by: { (object1, object2) -> Bool in
            return object1.fullName.lowercased() < object2.fullName.lowercased()
        })
        
        return result
    }
    
    func removeContact(contactItem:ContactItem!, groupName:String?) {
        let contact: Contact? = getContact(contactID: contactItem.contactID)
        if(contact != nil) {
            if(groupName == nil) {//Удаление из базы
                let context = managedObjectContext
                context.delete(contact!)
            } else {//Удаление из группы
                let group = getGroup(groupName: groupName!)
                contact?.removeFromGroups(group!)
            }
        }
        
        saveContext()
    }
    
    func updateContact(contactItem:ContactItem!) {
        let contact: Contact? = getContact(contactID: contactItem.contactID)
        if(contact != nil) {
            contact!.fullName = contactItem.fullName
            contact!.address = contactItem.address
            contact!.phone = contactItem.phone
        }
        
        saveContext()
    }
    
    
    // MARK: - Group
    /*
     Методы работы с группами
     */
    func addGroup(groupName: String) {
        let context = managedObjectContext
        
        let group : Group = NSEntityDescription.insertNewObject(forEntityName: "Group", into: context) as! Group
        group.groupID = NSUUID().uuidString
        group.groupName = groupName
        saveContext()
    }
    
    func getAllGroups() -> [GroupItem] {
        var result:[GroupItem] = []
        
        let context = managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>.init()
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Group", in: context)
        request.entity = entityDescription
        request.sortDescriptors = [NSSortDescriptor(key: "groupName", ascending: true)]
        
        let arr = try! context.fetch(request) as! [Group]
        for item : Group in arr {
            let groupItem = GroupItem.init()
            groupItem.groupID = item.groupID!
            groupItem.groupName = item.groupName!
            result.append(groupItem)
        }
        
        return result
    }
    
    func getGroupsForContact(contactID:String!) -> [GroupItem] {
        var result:[GroupItem] = []
        let contact = getContact(contactID:contactID)
        
        if contact == nil {
            return result
        }
        
        let arr = contact!.groups!.allObjects as! [Group]
        for group in arr {
            let groupItem = GroupItem.init()
            groupItem.groupID = group.groupID!
            groupItem.groupName = group.groupName!
            result.append(groupItem)
        }
        
        return result
    }
    
    func updateGroups(contactID:String!, groups:[String]) {
        let contact: Contact? = getContact(contactID: contactID)
        if(contact != nil) {
           let arr = getGroups(names: groups) as [Group]!
           for item in arr! {
             item.addToContacts(contact!)
           }
            
           contact?.groups = NSSet.init(array: arr!)
        }
        
        saveContext()
    }
    
    // MARK: - Private
    private func getGroup(groupName: String) -> Group? {
        let context = managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>.init()
        
        let description = NSEntityDescription.entity(forEntityName: "Group", in: context)
        request.entity = description
        
        let predicate = NSPredicate(format: "groupName == %@", groupName)
        request.predicate = predicate
        
        let arr = try! context.fetch(request) as! [Group]
        
        if(arr.count == 0) {
            return nil
        } else {
            return arr[0]
        }
    }
    
    private func getGroups(names: [String]) -> [Group]! {
        let context = managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>.init()
        
        let description = NSEntityDescription.entity(forEntityName: "Group", in: context)
        request.entity = description
        
        let predicate = NSPredicate(format: "groupName IN %@", names)
        request.predicate = predicate
        
        let arr = try! context.fetch(request) as! [Group]
        
        return arr
    }
    
    private func getContact(contactID : String) -> Contact? {
        let context = managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>.init()
        
        let description = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        request.entity = description
        
        let predicate = NSPredicate(format: "contactID == %@", contactID)
        request.predicate = predicate
        
        let arr = try! context.fetch(request) as! [Contact]
        
        if(arr.count == 0) {
            return nil
        } else {
            return arr[0]
        }
    }
    
    
    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
