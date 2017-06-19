//
//  Cell2TableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class Cell2TableViewCell: UITableViewCell {
    @IBOutlet weak var radioButton1: RadioButton!
    @IBOutlet weak var radioButton2: RadioButton!
 
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func button1Selected(_ sender: RadioButton) {
        radioButton2.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func button2Selected(_ sender: RadioButton) {
        radioButton1.isSelected = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
