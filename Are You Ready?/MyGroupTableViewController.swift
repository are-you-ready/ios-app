//
//  GroupTableViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/14/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyGroupTableViewController: UITableViewController {

    var groupMembers = [AYRUser]()

    func handleRefresh() {
        AreYouReadyAPI.getGroup("cis55") { result in
            switch (result) {
            case let .success(group):
                print("#getGroup success: \(group.name)")
                self.groupMembers = Array(group.users.values)
                self.tableView.reloadData()
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                self.groupMembers = []
                print("#getGroup failure: \(reason)")
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupTableViewCell
        cell.groupMemberNameLabel?.text = groupMembers[indexPath.row].name
        return cell
    }

}
