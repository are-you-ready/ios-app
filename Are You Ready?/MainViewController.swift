//
//  MainViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/14/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


class MainViewController: UIViewController {

    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var showGroupButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    
    
    //#sage: present notification in background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){}
    
    
    //#sage: check permission for localized notifications
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
