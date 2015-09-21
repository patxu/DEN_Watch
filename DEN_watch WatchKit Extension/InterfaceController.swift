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
    var quotes = ["\"A person who never made a mistake never tried anything new.\"\n-Albert Einstein","\"Do. Or do not. There is no try.\"\n-Yoda","\"The way to get started is to quit talking and begin doing.\"\n-Walt Disney","\"Fail often so you can succeed sooner.\"\n-Tom Kelley","\"Success is how high you bounce after you hit bottom.\"\n–General George Patton","\"Risk more than others think is safe. Dream more than others think is practical.\"\n-Howard Schultz"]
    
    @IBOutlet var hourLabel: WKInterfaceLabel!
    @IBOutlet var userLabel: WKInterfaceLabel!
    
    @IBOutlet var quoteLabel: WKInterfaceLabel!
    
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
        quoteLabel.setText(quotes[Int(arc4random_uniform(UInt32(quotes.count)))])
        let msg = ["message": "value"]
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
        
        let hours = String(Int(round(100*(minutes.doubleValue/60))/100))
        hourLabel.setText("  Hours in DEN: \(hours)")
        
        userLabel.setText("  Users in DEN: \(users)")
    }
    
}