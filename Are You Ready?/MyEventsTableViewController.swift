//
//  MyEventsTableViewController.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/18/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController {

    var myEvents = [AYREvent]()
    
    func handleRefresh() {
        AreYouReadyAPI.getGroup("cis55") { result in
            switch (result) {
            case let .success(group):
                self.myEvents = Array(group.events.values)
                self.tableView.reloadData()
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because: \(reason)")
                self.myEvents = []
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        handleRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath) as! MyEventsTableViewCell
        let event = myEvents[indexPath.row]
        
        cell.cellEventName.text = event.name
        cell.cellEventTime.text = event.readyTime.description
        cell.cellEventLocation.text = event.location

        return cell
    }
}
