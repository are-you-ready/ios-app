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
        AreYouReadyAPI.getGroup(name: "cis55") { (result) in
            switch (result) {
            case let .success(user):
                print(user.name)
                print(user.users)
            case let .failure(.requestFailure(reason, _)),
                 let .failure(.JSONParseFailure(reason)),
                 let .failure(.JSONErrorResponse(reason, _)):
                print("Request failed because \(reason)")
            }
        }
    }

}
