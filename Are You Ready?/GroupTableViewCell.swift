//
//  GroupTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/20/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    @IBOutlet weak var groupMemberName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
