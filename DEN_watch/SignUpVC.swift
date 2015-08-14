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
    @IBOutlet weak var yearField: UITextField!
    
    let ParseYear = "Year"
    let ParseFullName = "FullName"
    let inDEN = "inDEN"
    
    @IBAction func createAccount(sender: AnyObject) {
       
        //ensure required field are filled
        if (nameField.text!.isEmpty || emailField.text!.isEmpty || passwordField.text!.isEmpty){
            let alert = AlertHelper.createAlert("Please fill in each required field.")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let user = PFUser()
        print(yearField.text)
        if (yearField.text!.isEmpty){ // no class year MAKE OBVIOUS THAT THIS IS NOT REQUIRED
            user[ParseYear] = 0
        } else { // check for valid year
            let year = Double(yearField.text!)
            if year == nil || (year <= 0 && year >= 100) {
                let alert = AlertHelper.createAlert("Please make sure the class year follows the example (e.g. \"17\")")
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        user.username =  nameField.text! + emailField.text! //FIX USERNAMES
        user.password = passwordField.text
        user.email = emailField.text
        user[ParseFullName] = nameField.text
        user[ParseYear] = yearField.text
        user[inDEN] = false //set smartly? TODO
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if (error != nil) { // handle errors
                var alert: UIViewController
                switch error!.code {
                case 125: //invalid email address
                    alert = AlertHelper.createAlert("Please enter a valid email address.")
                case 203: //duplicate email
                    alert = AlertHelper.createAlert("That email is already registered to an account.")
                default:
                    alert = AlertHelper.createAlert(error!.localizedDescription)
                }
                self.presentViewController(alert, animated: true, completion: nil)
                return
            } else { // continue to next VC
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
