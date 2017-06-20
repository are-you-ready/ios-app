//
//  MyEventsDetailViewController.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/19/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyEventsDetailViewController: UIViewController {

    var myEvent: AYREvent? = nil
    var mediumFormatter = DateFormatter()
    var shortFormatter = DateFormatter()
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var meetupSpot: UILabel!
    @IBOutlet weak var whatsUp: UITextView!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var whosComing: UITextView!

    @IBAction func pressComing(_ sender: Any) {
        AreYouReadyAPI.updateStatus(group: "cis55", event: myEvent!.name, user: "Scott", status: .coming) { result in
            switch (result) {
            case let .success(group):
                print(group.name)
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because: \(reason)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mediumFormatter.dateStyle = .medium
        mediumFormatter.timeStyle = .medium
        shortFormatter.dateStyle = .none
        shortFormatter.timeStyle = .short

        // Do any additional setup after loading the view.
        eventName.text = myEvent?.name
        location.text = myEvent?.location
        time.text = mediumFormatter.string(from: myEvent!.readyTime)
        meetupSpot.text = myEvent?.meetupLocation?.rawValue
        whatsUp.text = myEvent?.description
        notificationTime.text = shortFormatter.string(from: myEvent!.notificationTime)
        
        var whosComingText = ""
        for attendee in Array(myEvent!.attendees.values) {
            switch attendee.status {
            case .pending:
                whosComingText += "\(attendee.user.name): Pending\n"
            case .coming:
                whosComingText += "\(attendee.user.name): Is coming!\n"
            default:
                whosComingText += "\(attendee.user.name): Is NOT coming :(\n"
            }
        }
        
        whosComing.text = whosComingText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
