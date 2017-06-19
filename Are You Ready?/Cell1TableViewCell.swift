//
//  Cell1TableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

protocol IdCellDelegate {
    func titleEntered2(title: String)
    func locationEntered2(location: String)
}

class Cell1TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    var delegate: IdCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func titleEntered(_ sender: Any) {
        delegate?.titleEntered2(title: titleField.text!)
    }
    
    @IBAction func locationEntered(_ sender: Any) {
        delegate?.locationEntered2(location: locationField.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
