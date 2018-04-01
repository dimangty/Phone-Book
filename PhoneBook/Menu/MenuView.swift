//
//  MenuView.swift
//  PhoneBook
//
//  Created by dima on 30.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func menuSelectGroup(group: String?)
    func menuSelectPage(pageID: String?)
}

class MenuView: UIView {
    @IBOutlet weak var menuTable: UITableView!
    var groups:[String] = []
    var pages:[String] = ["AboutVC"]
    weak var delegate: MenuDelegate?
    
    public func updateMenu() {
        groups.removeAll()
        groups.append("ALL")
        let arr = StorageManager.shared.getAllGroups()
        for group in arr {
            groups.append(group.groupName)
        }
        
        menuTable.reloadData()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MenuView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 1) {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return groups.count;
        } else {
            return pages.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
          cell.menuTitleLab.text = groups[indexPath.row]
          return cell
        } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell") as! PageCell
           return cell
        }
    }
}

extension MenuView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
          if(indexPath.row == 0) {
              delegate?.menuSelectGroup(group: nil)
           } else {
              let groupName = groups[indexPath.row]
              delegate?.menuSelectGroup(group: groupName)
           }
        } else {
            let pageID = pages[indexPath.row]
            delegate?.menuSelectPage(pageID: pageID)
        }
    }
}
