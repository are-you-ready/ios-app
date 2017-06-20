//
//  MainViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/14/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import UserNotificationsUI

class MainViewController: UIViewController {

    var user = ""

    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var showGroupButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    @IBOutlet weak var whoAmILabel: UILabel!

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var fetchResultsController: NSFetchedResultsController<Login>!
        let fetchRequest: NSFetchRequest<Login> = Login.fetchRequest()
        fetchRequest.sortDescriptors = []
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects{
                    user = fetchedObjects[0].id!
                }
            } catch {
                print(error)
            }
        }

        whoAmILabel.text = "You are \(user)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func createEventAction(_ sender: Any) {
    }

    @IBAction func showGroupAction(_ sender: Any) {
    }

    @IBAction func myEventsAction(_ sender: Any) {
    }
}
