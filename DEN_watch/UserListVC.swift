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
    let textCellIdentifier = "TextCell"
    var userArray:NSMutableArray = []
    var manager: LocationManager?
    let userSegue = "showUserDetails"
    var index: Int! = 0
       
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadParseData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        userTable.addSubview(refreshControl)
        userTable.delegate = self
        userTable.dataSource = self
                
    }
    
    //custom segue based on cell tapped
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == userSegue {
            if let destination = segue.destinationViewController as? ViewUserVC {
                if let index = userTable.indexPathForSelectedRow?.row {
                    destination.user = userArray[index] as! PFUser
                }
            }
        }
    }
    
    //Parse query
    func loadParseData(){
        let query = PFUser.query()!
        //query.whereKey("inDEN", equalTo:true)
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
                // Log details of the failure
                print ("Parse data error: ", error)
            }
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        self.userTable.reloadData()
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
   
}