//
//  AddEventTableViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit
import CoreData

class AddEventTableViewController: UITableViewController, MeetUpTypeCellDelegate, MeetSpotCellDelegate, ReadyTimeCellDelegate, IdCellDelegate, WhatsUpCellDelegate, MeetUpDateCellDelegate {
    @IBOutlet weak var backUIBarButton: UIBarButtonItem!
    @IBOutlet weak var addUIBarButton: UIBarButtonItem!
    var user:String = ""
    var meetUpTypeSelectionIndex = 0
    var meetUpSpotSelectionIndex = 0
    var readyTimeSelectionIndex = 0
    var titleText = ""
    var locationText = ""
    var whatsUpText = ""
    var meetUpDate = Date()
    
    func titleEntered2(title: String) {
        titleText = title
    }

    func locationEntered2(location: String) {
        locationText = location
    }
    
    func meetUpDateEntered(meetUpDate: Date) {
        self.meetUpDate = meetUpDate
    }
    
    func meetUpButtonTapped(index:Int) {
        meetUpTypeSelectionIndex = index
    }
    
    func meetSpotButtonTapped(index:Int) {
        meetUpSpotSelectionIndex = index
    }
    
    func readyTimeButtonTapped(index:Int) {
        readyTimeSelectionIndex = index
    }
    
    func whatsUpTextEntered(whatsUpText:String) {
        self.whatsUpText = whatsUpText
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func addButtonPushed(_ sender: Any) {
        let eventTitle = titleText
        let eventLocation = locationText
        let eventDate: Date = meetUpDate
        var eventType = EventType.eatOut
        if meetUpTypeSelectionIndex == 1 {
            eventType = EventType.hangOut
        }
        else {
            if meetUpTypeSelectionIndex == 2 {
                eventType = EventType.meetUp
            }
        }

        
        var meetUpLocation = EventMeetupLocation.car
        if meetUpSpotSelectionIndex == 1 {
            meetUpLocation = .frontDoor
        }
        else if meetUpSpotSelectionIndex == 2 {
            meetUpLocation = .kitchen
        }
        else if meetUpSpotSelectionIndex == 3 {
            meetUpLocation = .livingRoom
        }
        
        let description = whatsUpText
        
        var readyMinutes = 5
        if readyTimeSelectionIndex == 1 {
            readyMinutes = 10
        }
        else {
            if readyTimeSelectionIndex == 2 {
                readyMinutes = 30
            }
        }
        
        let calendar = Calendar.current
        let readyTime = calendar.date(byAdding: .second, value: (readyMinutes * -1 * 60), to: eventDate)
        
        /*
        let event = AYREvent(
            name: "Awesome Event",
            type: .eatOut,
            description: "Let's go do stuff",
            location: "Somewhere far, far away",
            meetupLocation: .car,
            createdBy: AYRUser(name: "Markus"),
            createdAt: Date(), // This value will be replaced by the server anyway
            notificationTime: Date(timeIntervalSinceNow: 300),
            readyTime: Date(timeIntervalSinceNow: 600),
            attendees: [:]     // This value will also be auto-populated by the server
        )
        */

        let event = AYREvent(
            name: eventTitle,
            type: eventType,
            description: description,
            location: eventLocation,
            meetupLocation: meetUpLocation,
            createdBy: AYRUser(name: user),
            createdAt: Date(), // This value will be replaced by the server anyway
            notificationTime: readyTime!,
            readyTime: eventDate,
            attendees: [:]     // This value will also be auto-populated by the server
        )
        
        AreYouReadyAPI.createEvent(event, inGroup: "cis55") { result in
            switch (result) {
            case let .success(group):
                print(group.name)
                DispatchQueue.main.async {
                    // direct back to main page after adding event
                    self.dismiss(animated: true, completion: nil)
                }
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because: \(reason)")
                DispatchQueue.main.async {
                    //failed to write, issue alert
                    let alertController = UIAlertController(title: "Failed to Write Event", message:
                        reason, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->String? {
        switch section {
        case 1:
            return "Choose Event Time"
        case 2:
            return "Choose Meetup Type"
        case 3:
            return "Choose Meetup Spot"
        case 4:
            return "Choose Ready Time"
        case 5:
            return "Tell 'em What's Up"
        default:
            return "Event Identification"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId2", for: indexPath) as! MeetUpDateTableViewCell
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId3", for: indexPath) as! MeetUpTypeTableViewCell
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId4", for: indexPath) as! MeetSpotTableViewCell
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId5", for: indexPath) as! ReadyTimeTableViewCell
            cell.delegate = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId6", for: indexPath) as! WhatsUpTableViewCell
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId1", for: indexPath) as! Cell1TableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var returnValue = 0.0
        
        switch indexPath.section {
            case 1: returnValue = 120.0
            case 2: returnValue = 120.0
            case 3: returnValue = 150.0
            case 4: returnValue = 120.0
            case 5: returnValue = 150.0
            default: returnValue = 80.0
        }
        return CGFloat(returnValue)
    }

    /*
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["section 1", "section 2"]
    }
     */
    
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
