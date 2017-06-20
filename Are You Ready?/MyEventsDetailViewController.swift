//
//  MyEventsDetailViewController.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/19/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class MyEventsDetailViewController: UIViewController {

    var myEvent: AYREvent? = nil
    
    @IBOutlet weak var eventName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventName.text = myEvent?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

}
