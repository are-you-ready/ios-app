//
//  AddEventTableViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/15/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit
import CoreData

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


class AddEventTableViewController: UITableViewController, MeetUpTypeCellDelegate, MeetSpotCellDelegate, ReadyTimeCellDelegate, IdCellDelegate, WhatsUpCellDelegate, MeetUpDateCellDelegate {
    @IBOutlet weak var backUIBarButton: UIBarButtonItem!
    @IBOutlet weak var addUIBarButton: UIBarButtonItem!
    var user = ""
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
        
        var eventType: EventType?
        switch meetUpTypeSelectionIndex {
        case 0: eventType = .eatOut
        case 1: eventType = .hangOut
        case 2: eventType = .meetUp
        default:
            eventType = nil
        }
        
        var meetUpLocation: EventMeetupLocation?
        switch meetUpSpotSelectionIndex {
        case 0: meetUpLocation = .car
        case 1: meetUpLocation = .frontDoor
        case 2: meetUpLocation = .kitchen
        case 3: meetUpLocation = .livingRoom
        default:
            meetUpLocation = nil
        }
        
        let description = whatsUpText
        
        var readyMinutes: Int?
        switch readyTimeSelectionIndex {
        case 0: readyMinutes = 5
        case 1: readyMinutes = 10
        case 2: readyMinutes = 30
        default:
            readyMinutes = nil
        }
        
        
        
        

        
        if (eventTitle) == "" {
            let alertController = UIAlertController(title: "Failed to Write Event", message:
                "No Title Entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if (meetUpLocation) == nil {
            let alertController = UIAlertController(title: "Failed to Write Event", message:
                "No Meetup Location Selected", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let calendar = Calendar.current
        let readyTime = calendar.date(byAdding: .second, value: (readyMinutes! * -1 * 60), to: eventDate)
        
        if (readyTime) == nil {
            
            let alertController = UIAlertController(title: "Failed to Write Event", message:
                "Event Time not Valid", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return

        }
        if (eventType) == nil {
            
            let alertController = UIAlertController(title: "Failed to Write Event", message:
                "No Type Entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
                        if (eventLocation) == "" {
            let alertController = UIAlertController(title: "Failed to Write Event", message:
                "No Location Selected", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if (description) == "" {
            let alertController = UIAlertController(title: "Failed to Write Event", message:
                "No Description Entered", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }

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
                    let alertController = UIAlertController(title: "Failed to write event", message:
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
         self.hideKeyboardWhenTappedAround()
        
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) ->String? {
        switch section {
        case 0:
            return "Event Identification"
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
            print("You shouldn't be here")
            return "Event Identification"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellId1", for: indexPath) as! Cell1TableViewCell
            cell.delegate = self
            return cell
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
            print("You shouldn't be here")
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
    
}
