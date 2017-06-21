import UIKit

class MyGetReadyEventsTableViewCell: UITableViewCell {

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
