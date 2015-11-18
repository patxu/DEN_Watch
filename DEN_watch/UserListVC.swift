//
//  UserListVC.swift
//  DEN_watch
//
//  Created by Smartwatch Project on 7/28/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreLocation

class UserListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userTable: UITableView!
    @IBOutlet weak var pictureView: UIImageView!
    
    let textCellIdentifier = "TextCell"
    var userArray:NSMutableArray = []
    var manager: LocationManager?
    var index: Int! = 0
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var user: PFUser! = PFUser.currentUser()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadParseData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        userTable.addSubview(refreshControl)
        userTable.delegate = self
        userTable.dataSource = self
        
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
                        print("Error while loading profile picture: ", error)
                    }
                }
            }
        }
        
        Utils.setPictureBorder(pictureView, width: 2)
        let tap = UITapGestureRecognizer(target: self, action: Selector("viewProfile:"))
        pictureView.userInteractionEnabled = true
        pictureView.addGestureRecognizer(tap)
        
    }
    
    //Parse query
    func loadParseData(){
        //Clears userArray
        //Note: This is inefficient because users already in the list must be redownloaded
        //However, with limited number of people this should be fine, but if things look slow, take a look at this
        userArray = []
        let query = PFUser.query()!
        query.whereKey("inDEN", equalTo:true)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.userArray.addObject(object)
                    }
                }
                self.userTable.reloadData()
            } else {
                print ("Parse data error: ", error)
            }
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        //Automatically reloads table inside this method
        loadParseData()
        //If user is refreshing list, good chance user is inside DEN, so do a one time location check to see if user is in DEN
        //This should help with issue where region can take time to register exit/enter
        //appDelegate.locationManager.startUpdatingLocation()
        refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let row = indexPath.row
        let user = userArray[row] as! PFUser
        let username = user["FullName"] as! String!
        cell.textLabel?.text = username
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("viewUserSegue", sender: cell)
    }
    
    func viewProfile(recognizer: UITapGestureRecognizer){
        performSegueWithIdentifier("viewProfileSegue", sender: self)
    }
    
    //custom segue based on cell tapped
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewUserSegue"{
            if let destination = segue.destinationViewController as? ViewUserVC {
                if let index = userTable.indexPathForSelectedRow?.row {
                    destination.user = userArray[index] as! PFUser
                }
            }
        }
        if segue.identifier == "viewProfileSegue"{
            if let destination = segue.destinationViewController as? ViewUserVC {
                destination.user = self.user
                destination.ownProfile = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
   
}