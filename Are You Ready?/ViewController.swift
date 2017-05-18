//
//  ViewController.swift
//  Are You Ready?
//
//  Created by Markus Tran on 5/17/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressButton() {
        AreYouReadyAPI.getProfile(name: "Markus") { (json, error) in
            if let error = error {
                print("There was an error: \(error)")
            } else if let json = json {
                let name = json["name"] as! String
                let age = json["age"] as! Int
                print("name: \(name)")
                print("age: \(age)")
                // made a change
                // made a second change
            }
        }
    }

}

