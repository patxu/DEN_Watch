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
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
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
        
        aboutMeButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        aboutMeButton.setTitle(String.fontAwesomeIconWithName(.Edit), forState: .Normal)
        
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
                        print("Error here")
                        print(error)
                    }
                }
            }
            updateTimeFields(self.user)
        }
        
        
        
        aboutMeTextView.text = self.user["aboutMe"] as! String
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
    
    func setTimeFields(minutes: Double){
        self.hourLabel.text = String(Double(round(100*(minutes/60))/100))
    }
    @IBAction func EditAboutMe(sender: AnyObject) {
        
    }
    
    
    @IBAction func switchChanged(sender: UISwitch) {
       if sender.on{
        aboutMeTextView.editable = false
        aboutMeTextView.backgroundColor = UIColor.clearColor()
       
        let aboutText = aboutMeTextView.text
        self.user = PFUser.currentUser()
        self.user["aboutMe"] = aboutText
        self.user.saveInBackground()
        
        
       }
       else{
        aboutMeTextView.editable = true
        aboutMeTextView.backgroundColor = UIColor.whiteColor()
        
        }
    }
    func updateTimeFields(user: PFUser){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var function: (Double)->() = setTimeFields
        appDelegate.calculateWeekTime(user,function)
    }
    
    
    
    }