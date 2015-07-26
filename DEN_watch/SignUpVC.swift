//
//  SignUpVC.swift
//  DEN_watch
//
//  Created by David Bain on 7/25/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignUpVC: UIViewController{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func createAccount(sender: AnyObject) {
       
        if (userNameField.text!.isEmpty || passwordField.text!.isEmpty || emailField.text!.isEmpty || nameField.text!.isEmpty){
            let alert = AlertHelper.createAlert("All fields must be filled in")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let user = PFUser()
        user.username = userNameField.text
        user.password = passwordField.text
        user.email = emailField.text
        // other fields can be set just like with PFObject
        user["FullName"] = nameField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                //let errorString = error.userInfo?["error"] as? NSString
                print("error")
                // Show the errorString somewhere and let the user try again.
            } else {
                self.performSegueWithIdentifier("signUpComplete", sender: self)
            
            }
        }
    }
}
