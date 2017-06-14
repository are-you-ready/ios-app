//
//  LoginViewController.swift
//  Are You Ready?
//
//  Created by Scott Willey on 6/14/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var LoginField: UITextField!
    @IBOutlet weak var EnterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPushed(_ sender: Any) {
        //if there is something in the edit field, use it
        if (LoginField.text?.characters.count)! > 0 {
            //write to core data
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let newLoginObject = Login(context: appDelegate.persistentContainer.viewContext)
                
                newLoginObject.id = LoginField.text!
                appDelegate.saveContext()
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
