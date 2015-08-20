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
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var user: PFUser!
    
    override func viewWillAppear(animated: Bool) {
        if user == nil {
            print("no user passed to view")
        }
        else {
            if let userPicture = user["profilePicture"] as? PFFile {
                userPicture.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        let image = UIImage(data:imageData!)
                        self.pictureView.image = image
                    }
                })
            }
            
            nameLabel.text = user["FullName"] as! String!
            if user["Year"] as! String! != nil {
                nameLabel.text! += " \'" + (user["Year"] as! String!)
            }
            emailLabel.text = user.email as String!
            
        }
        
        //back button
        button.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
        button.setTitle(String.fontAwesomeIconWithName(.AngleLeft), forState: .Normal)
        

        Utils.setPictureBorder(pictureView)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}