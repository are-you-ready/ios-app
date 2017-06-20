import UIKit

class MyEventsTableViewController: UITableViewController {

    var myToRespondEvents = [AYREvent]()
    var myToGetReadyEvents = [AYREvent]()

    var formatter = DateFormatter()

    func handleRefresh() {
        AreYouReadyAPI.getGroup("cis55") { result in
            self.myToRespondEvents = []
            self.myToGetReadyEvents = []

            switch (result) {
            case let .success(group):
                print("#getGroup success: \(group.name)")

                for event in group.events {
                    var hasNotResponded = false
                    for attendee in event.value.attendees {
                        if attendee.value.status == .pending {
                            hasNotResponded = true
                        }
                    }
                    if hasNotResponded == true {
                        self.myToRespondEvents += [event.value]
                    } else {
                        self.myToGetReadyEvents += [event.value]
                    }
                }

            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("#getGroup failure: \(reason)")
            }

            self.tableView.reloadData()
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
            print("You shouldn't be here")
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath) as! MyToRespondEventsTableViewCell
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
            print("You shouldn't be here")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath)
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
            print("You shouldn't be here")
            return nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "MyEventsDetailSegue":
            let viewController = segue.destination as! MyToRespondEventsDetailViewController
            let cell = sender as! MyToRespondEventsTableViewCell
            viewController.myEvent = myToRespondEvents[self.tableView.indexPath(for: cell)!.row]

        case "MyToGetReadyEventsDetailSegue":
            let viewController = segue.destination as! MyGetReadyEventsDetailViewController
            let cell = sender as! MyGetReadyEventsTableViewCell
            viewController.myEvent = myToGetReadyEvents[self.tableView.indexPath(for: cell)!.row]

        default:
            print("You shouldn't be here")
        }
    }
}
