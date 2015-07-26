//
//  AlertHelper.swift
//  DEN_watch
//
//  Created by David Bain on 7/14/15.
//  Copyright (c) 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
class AlertHelper{
    internal class func createAlert(message : String) -> UIAlertController{
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
}