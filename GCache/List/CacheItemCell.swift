//
//  CacheItemCell.swift
//  GCache
//
//  Created by Chris Woodard on 9/16/17.
//  Copyright © 2017 UsefulSoft. All rights reserved.
//

import UIKit

class CacheItemCell: UITableViewCell {

    @IBOutlet weak var itemNameField: UILabel!
    @IBOutlet weak var itemAddressField: UILabel!
    @IBOutlet weak var itemDistanceField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setFromDict(dict:[String:Any]) {
        self.itemNameField.text = dict["Name"] as? String
        self.itemAddressField.text = dict["Address"] as? String
        self.itemDistanceField.text = ""
    }
}
