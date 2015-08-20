//
//  InterfaceController.swift
//  DEN_watch WatchKit Extension
//
//  Created by David Bain on 7/19/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import WatchKit
import Foundation
import CoreData

class InterfaceController: WKInterfaceController {
    @IBOutlet var label: WKInterfaceLabel!
    

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        getUserData()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //No parse data should be sent to watch extension, only string data in dictionary or something
    @IBAction func getUserData(){
        let groupID = "group.edu.dartmouth.den.DEN-watch"
        
        /*
        if let defaults = NSUserDefaults(suiteName: groupID) {
            defaults.setValue("foo", forKey: "userString")
        }
        */
       
        let defaults = NSUserDefaults(suiteName: groupID)
        print(defaults?.dictionaryRepresentation().keys.array)
        /*
        if let data0 = defaults!.dictionaryForKey("userData") {
            label.setText("set")
            print(data0)
        } else {
            label.setText("not set")
            print("not set")
        }*/
        if let data = defaults!.stringForKey("userString"){
            label.setText("set")
            print(data)
        } else {
            label.setText("not set")
            print("not set")
        }
    }
}