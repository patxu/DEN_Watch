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

class UserListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userTable: UITableView!
    let textCellIdentifier = "TextCell"
    var userArray:NSMutableArray = []
    var manager: LocationManager?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadParseData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        userTable.addSubview(refreshControl)
        userTable.delegate = self
        userTable.dataSource = self
        
        manager = LocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                print(location)
            } else if let err = error {
                print(err.localizedDescription)
            }
            self.manager = nil
        }
        
    }
    
    
    func loadParseData(){
        let query = PFUser.query()!
        //query.whereKey("username", equalTo:"foo")
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
                print ("error")
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
        
        let row = indexPath.row
        print(userArray[row])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}