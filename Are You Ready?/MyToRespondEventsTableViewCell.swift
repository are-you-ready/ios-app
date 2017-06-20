//
//  MyEventsTableViewCell.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/18/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyToRespondEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellEventName: UILabel!
    @IBOutlet weak var cellEventTime: UILabel!
    @IBOutlet weak var cellEventLocation: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
