//
//  ReadyTimeTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/16/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

protocol ReadyTimeCellDelegate {
    func readyTimeButtonTapped(index:Int)
}

class ReadyTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var fiveMinuteButton: RadioButton!
    @IBOutlet weak var tenMinutesButton: RadioButton!
    @IBOutlet weak var thirtyMinutesButton: RadioButton!

    var delegate: ReadyTimeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func fiveMinutesPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.readyTimeButtonTapped(index: 0)
            tenMinutesButton.isSelected = false
            thirtyMinutesButton.isSelected = false
        }
    }
    
    @IBAction func tenMinutesPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.readyTimeButtonTapped(index: 1)
            fiveMinuteButton.isSelected = false
            thirtyMinutesButton.isSelected = false
        }
    }
    
    @IBAction func thirtyMinutesPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.readyTimeButtonTapped(index: 2)
            tenMinutesButton.isSelected = false
            fiveMinuteButton.isSelected = false
        }
    }
}
