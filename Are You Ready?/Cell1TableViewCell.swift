//
//  Cell1TableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class Cell1TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func titleEntered(_ sender: Any) {
    }
    
    @IBOutlet weak var locationEntered: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
