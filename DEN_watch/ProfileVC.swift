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
    @IBOutlet weak var logout: UIButton!
    
    var user: PFUser! = PFUser.currentUser()
    var name: String!
    var email: String!
    
    let imagePicker = UIImagePickerController()
    
    override func viewWillAppear(animated: Bool) {
        //edit button
        editPicture.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        editPicture.setTitle(String.fontAwesomeIconWithName(.Camera), forState: .Normal)
        
        //log out button
        logout.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        logout.setTitle(String.fontAwesomeIconWithName(.SignOut), forState: .Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = PFUser.currentUser()
        if self.user != nil{
            let pictureObject = self.user["picture"] as! PFObject
            print(pictureObject)
            if user["picture"] as? PFObject != nil {
                let picture = pictureObject["picture"] as! NSData
                let image = UIImage(data: picture)
                self.pictureView.image = image
            }
        }
        
        imagePicker.delegate = self

        setUserNameAndEmails(self.user, name: nameLabel, email: emailLabel)
        Utils.setPictureBorder(pictureView)
    }
    
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
    
    //delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pictureView.contentMode = .ScaleAspectFill
            self.pictureView.image = pickedImage
            
            self.user = PFUser.currentUser()
            if user != nil {
                let pictureObject = user["picture"] as! PFObject //delete
                if user["picture"] as? PFObject != nil {
                    user.removeObjectForKey("picture")
                }
                let file = PFFile(data: UIImageJPEGRepresentation(pickedImage, 0.5)!)
                let picture = PFObject(className:"UserPicture")
                picture["picture"] = file
                self.user["picture"] = picture
                
                self.user.saveInBackground()
                picture.saveInBackground()
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //delegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelling")
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}