//
//  InterfaceController.swift
//  DEN_watch WatchKit Extension
//
//  Created by David Bain on 7/19/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
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
        let session = WCSession.defaultSession()
        print("Session is reachable: \(session.reachable)") // this is false
        let msg = ["message": "derp derp derp"]
        session.sendMessage(msg, replyHandler: { reply in
            print("Got reply: \(reply)")
        }, errorHandler: { error in
            print("error: \(error)")
        })
    }
    
}