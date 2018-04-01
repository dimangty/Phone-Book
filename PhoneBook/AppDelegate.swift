//
//  AppDelegate.swift
//  PhoneBook
//
//  Created by dima on 30.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if(UserDefaults.standard.object(forKey: "initStore") == nil) {
            print("init store")
            initStore()
        }
        return true
    }
    
    func initStore() {
        let filePath = Bundle.main.path(forResource: "ContactsFile", ofType: "txt")
        if filePath != nil {
            do {
                let fileContent = try String(contentsOfFile: filePath!)
                let data = fileContent.data(using: .utf8)
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [Any]
                
                for group in json! {
                    let groupName = (group as! [String:Any])["GroupName"] as! String
                    let contacts = (group as! [String:Any])["Contacts"] as? [Any]
                    
                    for contact in contacts! {
                      let contactItem = ContactItem.init()
                      contactItem.address = (contact as! [String:Any])["address"] as! String
                      contactItem.fullName = (contact as! [String:Any])["name"] as! String
                      contactItem.phone = (contact as! [String:Any])["phone"] as! String
                      StorageManager.shared.addContact(contactItem: contactItem, toGroupName: groupName)
                    }
                }
                
                
            } catch {
                print("Read Error")
            }
        }
        
        UserDefaults.standard.set(true, forKey: "initStore")
        UserDefaults.standard.synchronize()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

