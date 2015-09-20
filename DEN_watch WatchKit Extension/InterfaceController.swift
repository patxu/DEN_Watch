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
    var session : WCSession!

    @IBOutlet var hourLabel: WKInterfaceLabel!
    @IBOutlet var userLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        let msg = ["message": "foo foo foo"]
        session.sendMessage(msg, replyHandler: { reply in
            print("Got reply: \(reply)")
            }, errorHandler: { error in
                print("error: \(error)")
        })
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let minutes = message["minutes"] as! NSNumber
        let users = message["userCount"]!
        
        let hours = String(Double(round(100*(minutes.doubleValue/60))/100))
        hourLabel.setText("Hours in DEN: \(hours)")
        
        userLabel.setText("Users in DEN:\(users)")
    }
    
}