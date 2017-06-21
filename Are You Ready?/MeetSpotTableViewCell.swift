//
//  MeetSpotTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

protocol MeetSpotCellDelegate {
    func meetSpotButtonTapped(index:Int)
}

class MeetSpotTableViewCell: UITableViewCell {
    @IBOutlet weak var carButton: RadioButton!
    @IBOutlet weak var frontDoorButton: RadioButton!
    @IBOutlet weak var kitchenButton: RadioButton!
    @IBOutlet weak var livingRoomButton: RadioButton!

    var delegate: MeetSpotCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func carPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.meetSpotButtonTapped(index: 0)
            frontDoorButton.isSelected = false
            kitchenButton.isSelected = false
            livingRoomButton.isSelected = false
        }
    }
    
    @IBAction func frontDoorPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.meetSpotButtonTapped(index: 1)
            carButton.isSelected = false
            kitchenButton.isSelected = false
            livingRoomButton.isSelected = false
        }
    }
    
    @IBAction func kitchenPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.meetSpotButtonTapped(index: 2)
            frontDoorButton.isSelected = false
            carButton.isSelected = false
            livingRoomButton.isSelected = false
        }
    }
    
    @IBAction func livingRoomPushed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.meetSpotButtonTapped(index: 3)
            frontDoorButton.isSelected = false
            kitchenButton.isSelected = false
            carButton.isSelected = false
        }
    }
}
