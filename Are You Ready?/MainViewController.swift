//
//  MainViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/14/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var showGroupButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
