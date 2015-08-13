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

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!    
    
    var user: PFUser!
    
    var name: String!
    var email: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getUser()

        
        setPictureView()
    }
    
    func getUser() {
        let query = PFUser.query()!
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        self.user = object
                        print(self.user["FullName"])

                        self.name = self.user["FullName"] as! String!
                        self.email = self.user.email as String!
                        self.setProfileFields()
//                        self.descriptionLabel.text = "NO DESCRIPTION" //todo
                        
                    }
                }
            } else {
                // Log details of the failure
                print ("Parse data error: ", error)
                self.user = nil
            }
        }
    }
    
    func setProfileFields(){
        self.nameLabel.text = name
    }
    
    func setPictureView(){
        pictureView.layer.cornerRadius = pictureView.bounds.height / 2
        pictureView.layer.borderWidth = 3
        pictureView.layer.borderColor = UIColor.redColor().CGColor
        pictureView.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}