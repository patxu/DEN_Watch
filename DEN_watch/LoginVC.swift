//
//  LoginVC.swift
//  DEN_watch
//
//  Created by David Bain on 7/25/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginVC: UIViewController{

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginPressed(sender: AnyObject) {
        if (userNameField.text!.isEmpty || passwordField.text!.isEmpty){
            let alert = AlertHelper.createAlert("All fields must be filled in")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        PFUser.logInWithUsernameInBackground(userNameField.text!, password:passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("success")
            } else {
                print("failure")
            }
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}