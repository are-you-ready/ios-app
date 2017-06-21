import UIKit
import CoreData

class MyGetReadyEventsDetailViewController: UIViewController {

    var timer: Timer? = nil
    var myEvent: AYREvent? = nil
    var secondsLeft: TimeInterval = 1
    var user = ""

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var whosReady: UITextView!
    @IBOutlet weak var timer_label: UILabel!

    @IBAction func pressReady(_ sender: Any) {
        AreYouReadyAPI.updateStatus(group: "cis55", event: myEvent!.name, user: user, status: .ready) { result in
            switch (result) {
            case let .success(group):
                print("#updateStatus success: \(group.name)")

            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("#updateStatus failure: \(reason)")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Failed to update status", message:
                        reason, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        eventName.text = myEvent!.name

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

        let readyTime = myEvent!.readyTime
        secondsLeft = readyTime.timeIntervalSince(Date())
        if (secondsLeft >= 0) {
            runTimer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    func updateTimer() {
        secondsLeft -= 1
        if secondsLeft > 0 {
            timer_label.text = timeString(time: secondsLeft)
        } else {
            timer_label.text = "00:00:00"
            timer!.invalidate()
        }
    }

    func runTimer() {
        updateTimer() // Run the function immediately as well
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(MyGetReadyEventsDetailViewController.updateTimer)), userInfo: nil, repeats: true)
    }
}
