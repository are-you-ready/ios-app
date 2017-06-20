//
//  MyGetReadyEventsTableViewCell.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/19/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyGetReadyEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellEventName: UILabel!
    @IBOutlet weak var cellEventTime: UILabel!
    @IBOutlet weak var cellEventLocation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
