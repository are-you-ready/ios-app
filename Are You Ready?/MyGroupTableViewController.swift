import UIKit

class MyGroupTableViewController: UITableViewController {

    var groupMembers = [AYRUser]()

    func handleRefresh() {
        AreYouReadyAPI.getGroup("cis55") { result in
            self.groupMembers = []

            switch (result) {
            case let .success(group):
                print("#getGroup success: \(group.name)")
                self.groupMembers = Array(group.users.values)
                self.tableView.reloadData()

            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("#getGroup failure: \(reason)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Failed to get group", message:
                        reason, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
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
