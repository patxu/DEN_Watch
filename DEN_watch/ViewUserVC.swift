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

class ViewUserVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    var user: PFUser!
    
    override func viewWillAppear(animated: Bool) {
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
        }
        else {
            print("no user supplied to view controller!")
        }
        
        //back button
        backButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        backButton.setTitle(String.fontAwesomeIconWithName(.AngleLeft), forState: .Normal)
        
        //email button
        emailButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        emailButton.setTitle(String.fontAwesomeIconWithName(.Send), forState: .Normal)
        
        Utils.setPictureBorder(pictureView)
        
        //set about me
        if(self.user["aboutMe"] != nil){
            aboutMeTextView.text = self.user["aboutMe"] as! String
        }
        else{
            aboutMeTextView.text = "About Me"
        }
        
    }
    
    func setTimeFields(minutes: Double){
        self.hourLabel.text = String(Double(round(100*(minutes/60))/100))
    }
    
    func updateTimeFields(user: PFUser){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var function: (Double)->() = setTimeFields
        appDelegate.calculateWeekTime(user,function)
    }
    
    //send mail
    @IBAction func sendMail(sender: AnyObject) {
        let url = NSURL(string: "mailto:" + emailLabel.text!)
        UIApplication.sharedApplication().openURL(url!)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
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