//
//  MainViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/14/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    var user = ""
    
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var showGroupButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    @IBOutlet weak var whoAmILabel: UILabel!

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
        // Dispose of any resources that can be recreated.
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
        /*
        AreYouReadyAPI.getGroup(name: "cis55") { (result) in
            switch (result) {
            case let .success(group):
                print(group.name)
                print(group.users)
                self.performSegue(withIdentifier: "MainToGroupView", sender: nil)
                //DispatchQueue.main.async {
                //    //MyTextLabel.text = user.name
                //    print("hello")
                //}
            // let cis55: AYRGroup = user.groups["cis55"]
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because \(reason)")
            }
        }
        */
    }
    
    @IBAction func myEventsAction(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
