//
//  WhatsUpTableViewCell.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/16/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

protocol WhatsUpCellDelegate {
    func whatsUpTextEntered(whatsUpText:String)
}

class WhatsUpTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var whatsUpTextView: UITextView!
    
    var delegate: WhatsUpCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        whatsUpTextView!.delegate = self as UITextViewDelegate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textViewDidChange(_ textView: UITextView) { //#Markus: Handle the text changes here
        delegate?.whatsUpTextEntered(whatsUpText: textView.text)
    }

}
