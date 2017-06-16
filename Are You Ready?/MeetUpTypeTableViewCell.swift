//
//  MeetUpTypeTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MeetUpTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var eatOutButton: RadioButton!
    @IBOutlet weak var hangOutButton: RadioButton!
    @IBOutlet weak var meetUpButton: RadioButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func eatOutPushed(_ sender: RadioButton) {
        hangOutButton.isSelected = false
        meetUpButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func hangOutPushed(_ sender: RadioButton) {
        eatOutButton.isSelected = false
        meetUpButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func meetUpPushed(_ sender: RadioButton) {
        hangOutButton.isSelected = false
        eatOutButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
}
