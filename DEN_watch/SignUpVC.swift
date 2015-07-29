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
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func createAccount(sender: AnyObject) {
       
        if (passwordField.text!.isEmpty || emailField.text!.isEmpty || nameField.text!.isEmpty){
            let alert = AlertHelper.createAlert("All fields must be filled in")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let user = PFUser()
        user.password = passwordField.text
        user.username =  nameField.text! + emailField.text! //don't care about usernames
        user.email = emailField.text
        // other fields can be set just like with PFObject
        user["FullName"] = nameField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let _ = error {
                //let errorString = error.userInfo?["error"] as? NSString
                print("error")
                // Show the errorString somewhere and let the user try again.
            } else {
                self.performSegueWithIdentifier("signUpComplete", sender: self)
            
            }
        }
    }
    
    override func viewDidLoad() {

        //unwind segue
        let  swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showFirstViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
    }
    
    //unwind segue
    func showFirstViewController() {
        self.performSegueWithIdentifier("idFirstSegueUnwind", sender: self)
    }
    
}
