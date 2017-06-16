//
//  ShowGroupTableViewController.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class ShowGroupTableViewController: UITableViewController {
    
    var groupMemberNames = ["Fetching data..."]
    
    func handleRefresh() {
        AreYouReadyAPI.getGroup("cis55") { result in
            switch (result) {
            case let .success(group):
                self.groupMemberNames = Array(group.users.keys)
                print(self.groupMemberNames)
                self.tableView.reloadData()
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                self.groupMemberNames = ["Request failed because: \(reason)"]
            }
        }
        
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        handleRefresh()
//        self.refreshControl?.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupMemberNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowGroupCell", for: indexPath) as! ShowGroupTableViewCell

        cell.cellUserName?.text = self.groupMemberNames[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
