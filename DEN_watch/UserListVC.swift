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
    var pageIndex: Int!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        var query = PFUser.query()!
        //query.whereKey("inDEN", equalTo: true)
        for user in query.findObjects()!{
            self.userArray.addObject(user)
        }
        userTable.delegate = self
        userTable.dataSource = self
    }
    /*
    func loadParseData(){
        var query : PFQuery = PFUser.query()
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.userArray.addObject(object)
                    }
                }
                self.tableView.reloadData()
            } else {
                println("There was an error")
            }
        }
    }
    */

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        var user = userArray[row] as! PFUser
        var username = user["FullName"] as! String!
        cell.textLabel?.text = username
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        self.performSegueWithIdentifier("viewUser", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}