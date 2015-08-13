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

class LoginVC: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //button action
    @IBAction func loginPressed(sender: AnyObject) { login() }
    
    //login wtih email and password
    func login(){
        if (emailField.text!.isEmpty || passwordField.text!.isEmpty){
            let alert = AlertHelper.createAlert("Missing login information.")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        PFUser.logInWithUsernameInBackground(emailField.text!, password:passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("pinning in background")
                user!.pinInBackground()
                self.performSegueWithIdentifier("loginComplete", sender: self)
            } else {
                var alert: UIViewController
                switch error!.code {
                case 101: //no such account
                    alert = AlertHelper.createAlert("The account information does not match our records.")
                default:
                    alert = AlertHelper.createAlert(error!.localizedDescription)
                }
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    //text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() //dismiss textfield
        if (textField == emailField){
            passwordField.becomeFirstResponder()
        }
        else if (textField == passwordField){
            login()
        }
        return true;
        
    }
    
    //return segue
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }
    
    //return segue
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "idFirstSegueUnwind" {
                let unwindSegue = FirstCustomSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()

        
        // User is already logged in, go to next view controller.
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("already logged in")
            self.performSegueWithIdentifier("alreadyLoggedIn", sender: self)
        }
        
            
        else {
            for view in self.view.subviews {
                if view.isKindOfClass(FBSDKLoginButton) {
                    let loginView : FBSDKLoginButton = view as! FBSDKLoginButton
                    loginView.readPermissions = ["public_profile", "email"]
                    loginView.delegate = self
                }
            }
        }
        
        //custom segues
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showSecondViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
    }
    
    // Custom Segue Methods
    func showSecondViewController() {
        self.performSegueWithIdentifier("idFirstSegue", sender: self)
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            print (error)
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile")
            {
                self.returnUserData()
            }
            //go to next VC
            self.performSegueWithIdentifier("loginComplete", sender: self)
        }
    }
    
    //Google delegate methods
    
    
    //call this method anytime after a user has logged in by calling self.returnUserData().
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}