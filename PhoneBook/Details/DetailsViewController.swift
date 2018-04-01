//
//  DetailsViewController.swift
//  PhoneBook
//
//  Created by dima on 31.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var addressTF: UITextField!
    var contactItem: ContactItem?
    
    var allGroups:[String] = []
    var selectedGroups:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (contactItem != nil) {
            nameTF.text = contactItem?.fullName
            phoneTF.text = contactItem?.phone
            addressTF.text = contactItem?.address
        } else {
            nameTF.text = "New Contact"
        }
        
        loadGroups()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadGroups()  {
        var arr:[GroupItem] = StorageManager.shared.getAllGroups()
        for item in arr {
            allGroups.append(item.groupName)
        }
        
        if(contactItem != nil) {
            arr = StorageManager.shared.getGroupsForContact(contactID: contactItem!.contactID)
            for item in arr {
                selectedGroups.append(item.groupName)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(_ sender: Any) {
        if(contactItem == nil) {//Create new contact
            contactItem = ContactItem.init()
            contactItem?.contactID = NSUUID().uuidString
            contactItem!.fullName = nameTF!.text!
            contactItem!.address = addressTF!.text!
            contactItem!.phone = phoneTF!.text!
            StorageManager.shared.addContact(contactItem: contactItem!)
        } else {//update current contact
            contactItem!.fullName = nameTF!.text!
            contactItem!.address = addressTF!.text!
            contactItem!.phone = phoneTF!.text!
            StorageManager.shared.updateContact(contactItem: contactItem!)
        }
     
        StorageManager.shared.updateGroups(contactID: contactItem?.contactID, groups: selectedGroups)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - UITableViewDataSource
extension DetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell")
        let groupName = allGroups[indexPath.row]
        
        cell!.textLabel?.text = groupName

        if  selectedGroups.index(of: groupName) == nil {
            cell!.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension DetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        
        let groupName = allGroups[indexPath.row]
        if let index = selectedGroups.index(of: groupName) {
            selectedGroups.remove(at: index)
            cell!.accessoryType = UITableViewCellAccessoryType.none
        } else {
            selectedGroups.append(groupName)
            cell!.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
}
