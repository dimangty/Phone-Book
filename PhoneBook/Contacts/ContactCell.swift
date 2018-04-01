//
//  ContactCell.swift
//  PhoneBook
//
//  Created by dima on 31.03.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet var contactTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
