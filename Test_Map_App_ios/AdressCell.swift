//
//  AdressCell.swift
//  Test_Map_App_ios
//
//  Created by PeCheRukiN on 26.08.17.
//  Copyright © 2017 PeCheRukiN. All rights reserved.
//

import UIKit

class AdressCell: UITableViewCell {

    @IBOutlet weak var adressNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        adressNameLabel.text = ""
    }
}
