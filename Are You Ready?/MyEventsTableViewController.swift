//
//  MyEventsTableViewController.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/18/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController {

    var myToRespondEvents = [AYREvent]()
    var myToGetReadyEvents = [AYREvent]()

    var formatter = DateFormatter()

    func handleRefresh() {
        AreYouReadyAPI.getGroup("cis55") { result in
            switch (result) {
            case let .success(group):
                let myEvents = Array(group.events.values)
                self.myToRespondEvents = []
                self.myToGetReadyEvents = []
                
                for event in myEvents {
                    var hasNotResponded = false
                    for attendee in Array(event.attendees.values) {
                        if attendee.status == .pending {
                            hasNotResponded = true
                        }
                    }
                    if hasNotResponded == true {
                        self.myToRespondEvents += [event]
                    } else {
                        self.myToGetReadyEvents += [event]
                    }
                }
                
                self.tableView.reloadData()
                
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because: \(reason)")
                self.myToRespondEvents = []
                self.myToGetReadyEvents = []
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        handleRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return myToRespondEvents.count
        case 1:
            return myToGetReadyEvents.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:

            let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath) as! MyEventsTableViewCell
            let event = myToRespondEvents[indexPath.row]
        
            cell.cellEventName.text = event.name
            cell.cellEventTime.text = formatter.string(from: event.readyTime)
            cell.cellEventLocation.text = event.location
        
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyGetReadyEventCell", for: indexPath) as! MyGetReadyEventsTableViewCell
            let event = myToGetReadyEvents[indexPath.row]
            
            cell.cellEventName.text = event.name
            cell.cellEventTime.text = formatter.string(from: event.readyTime)
            cell.cellEventLocation.text = event.location
            
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath) as! MyEventsTableViewCell
            let event = myToRespondEvents[indexPath.row]
            
            cell.cellEventName.text = event.name
            cell.cellEventTime.text = formatter.string(from: event.readyTime)
            cell.cellEventLocation.text = event.location
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Are you coming?"
        case 1:
            return "Are you ready?"
        default:
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyEventsDetailSegue" {
            let viewController = segue.destination as! MyEventsDetailViewController
            let cell = sender as! MyEventsTableViewCell
            viewController.myEvent = myToRespondEvents[self.tableView.indexPath(for: cell)!.row]
        } else if segue.identifier == "MyToGetReadyEventsDetailSegue" {
            let viewController = segue.destination as! MyGetReadyEventsDetailView
            let cell = sender as! MyGetReadyEventsTableViewCell
            viewController.myEvent = myToGetReadyEvents[self.tableView.indexPath(for: cell)!.row]
        }
    }
}
