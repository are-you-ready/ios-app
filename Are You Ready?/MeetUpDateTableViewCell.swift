//
//  MeetUpDateTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/16/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

protocol MeetUpDateCellDelegate {
    func meetUpDateEntered(meetUpDate: Date)
}

class MeetUpDateTableViewCell: UITableViewCell {
    @IBOutlet weak var meetUpDatePicker: UIDatePicker!

    var delegate:MeetUpDateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func meetUpDatePicked(_ sender: UIDatePicker) {
        delegate?.meetUpDateEntered(meetUpDate: sender.date)
    }
}
