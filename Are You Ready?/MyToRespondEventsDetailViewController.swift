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
                print(group.name)
                let notificationTime = group.events[self.myEvent!.name]?.notificationTime
                let diff = notificationTime!.timeIntervalSince(Date())
                print(diff)
                
                
                self.setNotification(time: diff)
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because: \(reason)")
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
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediumFormatter.dateStyle = .medium
        mediumFormatter.timeStyle = .medium
        shortFormatter.dateStyle = .none
        shortFormatter.timeStyle = .short

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //see if we can read the core data
        var fetchResultsController: NSFetchedResultsController<Login>!
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        //let sortDescriptor = NSSortDescriptor(key: "iItem", ascending: true)
        fetchRequest.sortDescriptors = []
        //let defaultReturn: [LoginId] = []
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            //fetchResultsController.delegate = self as! NSFetchedResultsControllerDelegate
            do{
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects{
                    user = fetchedObjects[0].id!
                }
            } catch {
                print(error)
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
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
