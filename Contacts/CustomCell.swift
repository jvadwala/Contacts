//
//  CustomCell.swift
//  Contacts
//
//  Created by Jay Vadwala on 2015-12-19.
//  Copyright © 2015 Jay Vadwala. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
   
    @IBOutlet var ContactName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


