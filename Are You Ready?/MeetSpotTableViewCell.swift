//
//  MeetSpotTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MeetSpotTableViewCell: UITableViewCell {
    @IBOutlet weak var carButton: RadioButton!
    @IBOutlet weak var frontDoorButton: RadioButton!
    @IBOutlet weak var kitchenButton: RadioButton!
    @IBOutlet weak var livingRoomButton: RadioButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func carPushed(_ sender: RadioButton) {
        frontDoorButton.isSelected = false
        kitchenButton.isSelected = false
        livingRoomButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
    @IBAction func frontDoorPushed(_ sender: RadioButton) {
        carButton.isSelected = false
        kitchenButton.isSelected = false
        livingRoomButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
    @IBAction func kitchenPushed(_ sender: RadioButton) {
        carButton.isSelected = false
        frontDoorButton.isSelected = false
        livingRoomButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
    @IBAction func livingRoomPushed(_ sender: RadioButton) {
        carButton.isSelected = false
        frontDoorButton.isSelected = false
        kitchenButton.isSelected = false
        sender.isSelected = !sender.isSelected
    }
}
