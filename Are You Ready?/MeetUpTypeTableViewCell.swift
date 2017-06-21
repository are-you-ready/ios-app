//
//  MeetUpTypeTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

protocol MeetUpTypeCellDelegate {
    func meetUpButtonTapped(index:Int)
}

class MeetUpTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var eatOutButton: RadioButton!
    @IBOutlet weak var hangOutButton: RadioButton!
    @IBOutlet weak var meetUpButton: RadioButton!
    
    var delegate: MeetUpTypeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        // eatOutSelected = eatOutButton.getValue(forKey: "isSelected")
    }

    @IBAction func eatOutPushed(_ sender: RadioButton) {
        sender.isSelected = negate(sender.isSelected)
        if sender.isSelected {
            delegate?.meetUpButtonTapped(index: 0)
            hangOutButton.isSelected = false
            meetUpButton.isSelected = false
        }
    }
    
    @IBAction func hangOutPushed(_ sender: RadioButton) {
        sender.isSelected = negate(sender.isSelected)
        if sender.isSelected {
            delegate?.meetUpButtonTapped(index: 1)
            eatOutButton.isSelected = false
            meetUpButton.isSelected = false
        }
    }
    
    @IBAction func meetUpPushed(_ sender: RadioButton) {
        sender.isSelected = negate(sender.isSelected)
        if sender.isSelected {
            delegate?.meetUpButtonTapped(index: 2)
            hangOutButton.isSelected = false
            eatOutButton.isSelected = false
        }
    }
    
    
    func negate(_ boolToNegate: Bool) -> Bool {
        if boolToNegate {
            return false
        }
        else {
            return true
        }
    }
    
}
