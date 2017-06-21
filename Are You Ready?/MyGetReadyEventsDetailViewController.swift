//
//  MyGetReadyEventsDetailView.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/19/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyGetReadyEventsDetailViewController: UIViewController {

    var myEvent: AYREvent? = nil
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var whosReady: UITextView!

    @IBAction func pressReady(_ sender: Any) {
        AreYouReadyAPI.updateStatus(group: "cis55", event: myEvent!.name, user: "Markus", status: .ready) { result in
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

        eventName.text = myEvent?.name
        
        var whosReadyText = ""
        for attendee in Array(myEvent!.attendees.values) {
            switch attendee.status {
            case .ready:
                whosReadyText += "\(attendee.user.name): IS READY!\n"
            default:
                whosReadyText += "\(attendee.user.name): Not ready... yet\n"
            }
        }
        whosReady.text = whosReadyText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
