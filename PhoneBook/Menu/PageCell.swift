//
//  PageCell.swift
//  PhoneBook
//
//  Created by dima on 01.04.18.
//  Copyright © 2018 dima. All rights reserved.
//

import UIKit

class PageCell: UITableViewCell {
    @IBOutlet var pageIcon: UIImageView!
    @IBOutlet var pageTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
