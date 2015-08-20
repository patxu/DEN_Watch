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
    
    var user: PFUser!
    var name: String!
    var email: String!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewWillAppear(animated: Bool) {
        //edit button
        editPicture.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        editPicture.setTitle(String.fontAwesomeIconWithName(.Pencil), forState: .Normal)
        
        //log out button
        logout.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        logout.setTitle(String.fontAwesomeIconWithName(.SignOut), forState: .Normal)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUserDetails()
        imagePicker.delegate = self
        
        Utils.setPictureBorder(pictureView)
    }
    
    //logout dialog
    @IBAction func logout(sender: AnyObject) {
        var logoutConfirmation = UIAlertController(title: "Logout", message: "Are you really ready to leave?", preferredStyle: UIAlertControllerStyle.Alert)

        logoutConfirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        logoutConfirmation.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        }))
        
        presentViewController(logoutConfirmation, animated: true, completion: nil)
    }
    
    //choose a picture from the gallery
    @IBAction func editPicture(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            self.imagePicker.allowsEditing = false //TODO allow for user edits; will have to cheng "UIImagePickerControllerOriginalImage" below
            self.imagePicker.sourceType = .SavedPhotosAlbum
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo image: UIImage, info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pictureView.contentMode = .ScaleAspectFit
            self.pictureView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //delegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setUserDetails() {
        let query = PFUser.query()!
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        self.user = object
//                        print(self.user["FullName"])

                        self.name = self.user["FullName"] as! String!
                        if self.user["Year"] as! String! != "" {
//                            print("year is", self.user["Year"])
                            self.name! += (self.user["Year"] as! String!)
                        }
                        self.email = self.user.email as String!
                        self.setProfileFields()
                        
                    }
                }
                else {
                    print("no locally stored user")
                }
            } else {
                // Log details of the failure
                print("Parse data error: ", error)
                self.user = nil
            }
        }
    }
    
    func setProfileFields(){
        self.nameLabel.text = name
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}