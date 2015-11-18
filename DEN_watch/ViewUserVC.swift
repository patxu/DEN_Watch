//
//  ViewUserVC.swift
//  DEN_watch
//
//  Created by Smartwatch Project on 7/26/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ViewUserVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var user: PFUser!
    var ownProfile = false
    let imagePicker = UIImagePickerController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if self.user != nil {
            //load picture
            if let pictureObject = self.user["picture"] as? PFObject {
                pictureObject.fetchIfNeeded()
                pictureObject["picture"]!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if let data = data where error == nil{
                        self.pictureView.image = UIImage(data: data)
                    }
                })
            }
            setUserNameAndEmails(self.user, name: nameLabel, email: emailLabel)
            //set about me
            if(self.user["aboutMe"] != nil){
                aboutMeLabel.text = self.user["aboutMe"] as! String!
            }
            else{
                aboutMeLabel.text = "Hi there!"
            }
        } else {
            print("Error: no user supplied to view controller!")
        }
        
        //back button
        backButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        backButton.setTitle(String.fontAwesomeIconWithName(.AngleLeft), forState: .Normal)
        
        //email button
        emailButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        if ownProfile {
            emailButton.setTitle(String.fontAwesomeIconWithName(.Camera), forState: .Normal)
            aboutMeButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
            aboutMeButton.setTitle(String.fontAwesomeIconWithName(.Pencil), forState: .Normal)
            logoutButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
            logoutButton.setTitle(String.fontAwesomeIconWithName(.SignOut), forState: .Normal)
        } else {
            emailButton.setTitle(String.fontAwesomeIconWithName(.Send), forState: .Normal)
            aboutMeButton.hidden = true
            logoutButton.hidden = true
        }
        
        imagePicker.delegate = self
        Utils.setPictureBorder(pictureView, width: 5)
    }
    
    func setTimeFields(minutes: Double){
        self.hourLabel.text = String(Double(round(100*(minutes/60))/100))
    }
    
    func updateTimeFields(user: PFUser){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let function: (Double)->() = setTimeFields
        appDelegate.calculateWeekTime(user,function)
    }
    
    //choose profile pciture OR send mail
    @IBAction func sendMail(sender: AnyObject) {
        if ownProfile {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                self.imagePicker.allowsEditing = false //TODO allow for user edits; will have to change "UIImagePickerControllerOriginalImage" below
                self.imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        } else {
            if self.user != nil {
                let url = NSURL(string: "mailto:" + emailLabel.text!)
                UIApplication.sharedApplication().openURL(url!)
            } else {
                let alert = AlertHelper.createAlert("No user supplied.")
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editAboutMe(sender: AnyObject) {
        let editPopup = UIAlertController(title: "Edit About Me", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        editPopup.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.text = self.aboutMeLabel.text
        })
        editPopup.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        editPopup.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action: UIAlertAction!) in
            let input = editPopup.textFields![0].text
            self.aboutMeLabel.text = input
            
            self.user = PFUser.currentUser()
            self.user["aboutMe"] = input
            self.user.saveInBackground()
        }))
        presentViewController(editPopup, animated: true, completion: nil)
    }
    
    //logout confirmation and action
    @IBAction func logout(sender: AnyObject) {
        let logoutConfirmation = UIAlertController(title: "Logout", message: "Are you really ready to leave?", preferredStyle: UIAlertControllerStyle.Alert)

        logoutConfirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        logoutConfirmation.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            PFUser.logOut()
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.userInDEN(false)
            
        }))
        
        self.presentViewController(logoutConfirmation, animated: true, completion: nil)
    }
    
    //takes in user and sets the text of two UILabels based on the user info
    func setUserNameAndEmails(user: PFUser, name: UILabel, email: UILabel) {
        name.text = user["FullName"] as! String!
        if user["Year"] as! String! != nil {
            name.text! += " \'" + (user["Year"] as! String!)
        }
        email.text = user.email as String!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}