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
    internal class func createAlert(message: String) -> UIAlertController{
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        return alert    }
    internal class func createAlert(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
}