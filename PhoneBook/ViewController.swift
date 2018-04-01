//
//  ViewController.swift
//  PhoneBook
//
//  Created by dima on 30.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var menuLeadingConst: NSLayoutConstraint!
    @IBOutlet var menuWidhtConst: NSLayoutConstraint!
    @IBOutlet var menuView: MenuView!
    @IBOutlet var contactsTable: UITableView!
    
    var menuShowing : Bool = false
    var menuWidht : CGFloat = 170.0
    var shadowOffset : CGFloat = 5
    var contacts: [ContactItem] = []
    var lastGroup: String?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.
       initMenu()
       initSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = StorageManager.shared.getContacts(groupName: lastGroup, search: "")
        contactsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initMenu() {
        menuLeadingConst.constant = (menuWidht + shadowOffset) * -1
        menuWidhtConst.constant = menuWidht
        menuView.layer.shadowOffset = CGSize(width: shadowOffset, height: 0)
        menuView.layer.shadowOpacity = 0.7
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.delegate = self
    }
    
    private func initSearchBar() {
        searchController = UISearchController.init(searchResultsController: nil)
        searchController?.searchBar.placeholder = "Введите имя"
        searchController?.searchResultsUpdater = nil
        searchController?.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController?.searchBar.delegate = self
        
        contactsTable.tableHeaderView = searchController?.searchBar
    }

    // MARK: - Actions
    @IBAction func clickMenu(_ sender: Any) {
        if(menuShowing) {
            hideMenu()
        } else {
            showMenu()
        }
    }
    
    @IBAction func clickAdd(_ sender: Any) {
      let detailVC = self.storyboard?.instantiateViewController(withIdentifier:"DetailVC")
      self.navigationController?.pushViewController(detailVC!, animated: false)
    }
    
    @IBAction func clickEdit(_ sender: Any) {
        contactsTable.isEditing = !contactsTable.isEditing
    }
    
    
    // MARK: - Private
    private func showMenu() {
        menuView.updateMenu()
        menuLeadingConst.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        menuShowing = true
    }
    
    private func hideMenu() {
        menuLeadingConst.constant = (menuWidht + shadowOffset) * -1
         menuShowing = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailsSeque") {
            let vc = segue.destination as! DetailsViewController
            let indexPath = contactsTable.indexPath(for: sender as! UITableViewCell)
            vc.contactItem = contacts[indexPath!.row]
        }
    }
}


// MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        let contact = contacts[indexPath.row]
        cell.contactTitle.text = contact.fullName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("Commit row " + String(indexPath.row))
        
        StorageManager.shared.removeContact(contactItem: contacts[indexPath.row], groupName: lastGroup)
        contacts.remove(at: indexPath.row)
        contactsTable.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension ViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("search="+searchBar.text!)
        contacts = StorageManager.shared.getContacts(groupName: lastGroup, search: searchBar.text!)
        contactsTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        contacts = StorageManager.shared.getContacts(groupName: lastGroup, search: "")
        contactsTable.reloadData()
    }
}

// MARK: - MenuDelegate
extension ViewController : MenuDelegate {

    func menuSelectGroup(group: String?) {
        lastGroup = group
        contacts = StorageManager.shared.getContacts(groupName: lastGroup, search: "")
        hideMenu()
        contactsTable.reloadData()
    }
    
    func menuSelectPage(pageID: String?) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: pageID!)
        self.navigationController?.pushViewController(vc!, animated: false)
        hideMenu()
    }
}

