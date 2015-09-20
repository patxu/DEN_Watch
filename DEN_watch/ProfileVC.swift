//
//  ProfileVC.swift
//  DEN_watch
//
//  Created by Smartwatch Project on 7/26/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!    
    @IBOutlet weak var editPicture: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    
    var user: PFUser! = PFUser.currentUser()
    var name: String!
    var email: String!
    
    let imagePicker = UIImagePickerController()
    
    override func viewWillAppear(animated: Bool) {
        //edit button
        editPicture.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        editPicture.setTitle(String.fontAwesomeIconWithName(.Camera), forState: .Normal)
        
        //log out button
        logoutButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        logoutButton.setTitle(String.fontAwesomeIconWithName(.SignOut), forState: .Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = PFUser.currentUser()
        if self.user != nil{
            //load picture
            if let pictureObject = self.user["picture"] as? PFObject {
                pictureObject.fetchInBackgroundWithBlock{
                    (post: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        pictureObject["picture"]!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                            if let data = data where error == nil{
                                self.pictureView.image = UIImage(data: data)
                            }
                        })
                    }
                    else {
                        print(error)
                    }
                }
            }
            calculateWeekTime(self.user)
        }
        
        imagePicker.delegate = self

        setUserNameAndEmails(self.user, name: nameLabel, email: emailLabel)
        Utils.setPictureBorder(pictureView)
    }
    
    //takes in user and sets the text of two UILabels based on the user info
    func setUserNameAndEmails(user: PFUser, name: UILabel, email: UILabel) {
        name.text = user["FullName"] as! String!
        if user["Year"] as! String! != nil {
            name.text! += " \'" + (user["Year"] as! String!)
        }
        email.text = user.email as String!
    }
    
    //logout confirmation and action
    @IBAction func logout(sender: AnyObject) {
        let logoutConfirmation = UIAlertController(title: "Logout", message: "Are you really ready to leave?", preferredStyle: UIAlertControllerStyle.Alert)

        logoutConfirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        logoutConfirmation.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            PFUser.logOut()
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        }))
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.userInDEN(false)
        
        self.presentViewController(logoutConfirmation, animated: true, completion: nil)
    }
    
    //choose a picture from the gallery
    @IBAction func editPicture(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            self.imagePicker.allowsEditing = false //TODO allow for user edits; will have to change "UIImagePickerControllerOriginalImage" below
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //image picker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pictureView.contentMode = .ScaleAspectFill
            self.pictureView.image = pickedImage
            
            self.user = PFUser.currentUser()
            if user != nil {
                if user["picture"] as? PFObject != nil {
                    user["picture"]?.deleteEventually()
                    user.removeObjectForKey("picture")
                }
                let file = PFFile(data: UIImageJPEGRepresentation(pickedImage, 0.5)!) //does this go OOM with large images?
                let picture = PFObject(className:"UserPicture")
                picture["picture"] = file
                picture.saveInBackground()

                self.user["picture"] = picture
                self.user.saveInBackground()
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //image picker delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelling")
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateWeekTime(user: PFUser){
        var query = PFQuery(className:"DenSession")
        let calendar = NSCalendar.currentCalendar()
        //week in seconds
        let timeToSubtract = 7*24*60*60 as NSTimeInterval
        let weekAgo = NSDate().dateByAddingTimeInterval(-timeToSubtract)
        query.whereKey("user", equalTo:user)
        query.whereKey("inTime", greaterThan:weekAgo)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    var minutes = 0.0
                    for denSession in objects {
                        let inDate = denSession["inTime"] as! NSDate
                        if let outDate = denSession["outTime"] as? NSDate{
                            minutes += (outDate.timeIntervalSinceDate(inDate)/60)
                        }
                    }
                    if (self.user["currentSession"] != nil){
                        let currentSession = self.user["currentSession"] as! PFObject
                        let startTime = currentSession["inTime"] as! NSDate
                        minutes += (NSDate().timeIntervalSinceDate(startTime)/60)
                    }
                    
                    self.hourLabel.text = String(Double(round(100*(minutes/60))/100))
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
            
        }
    }
}