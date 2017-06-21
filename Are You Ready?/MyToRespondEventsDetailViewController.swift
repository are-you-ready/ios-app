import UIKit
import CoreData
import UserNotifications

class MyToRespondEventsDetailViewController: UIViewController {

    var myEvent: AYREvent? = nil
    var mediumFormatter = DateFormatter()
    var shortFormatter = DateFormatter()
    var user = ""

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var meetupSpot: UILabel!
    @IBOutlet weak var whatsUp: UITextView!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var whosComing: UITextView!

    @IBAction func pressComing(_ sender: Any) {
        AreYouReadyAPI.updateStatus(group: "cis55", event: myEvent!.name, user: user, status: .coming) { result in
            switch (result) {
            case let .success(group):
                print("#updateStatus success: \(group.name)")
                let notificationTime = group.events[self.myEvent!.name]!.notificationTime
                let diff = notificationTime.timeIntervalSince(Date())
                self.setNotification(time: diff)

            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("#updateStatus failure: \(reason)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Failed to get group", message:
                        reason, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    func setNotification(time: Double) {
        if time <= 0 {
            return
        }

        let content = UNMutableNotificationContent()

        content.title = myEvent!.name
        content.body = myEvent!.location + " at " + shortFormatter.string(from: myEvent!.readyTime)


        content.sound = UNNotificationSound.default()

        // time interval = time of date minus time of notification in seconds
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time, repeats: false)
        let request = UNNotificationRequest.init(identifier: "test_name", content: content, trigger: trigger)

        // add notification to stack
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mediumFormatter.dateStyle = .medium
        mediumFormatter.timeStyle = .medium
        shortFormatter.dateStyle = .none
        shortFormatter.timeStyle = .short

        var fetchResultsController: NSFetchedResultsController<Login>!
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects{
                    user = fetchedObjects[0].id!
                }
            } catch {
                print(error.localizedDescription)
            }
        }

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
    }

}
