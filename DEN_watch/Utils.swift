//
//  Utils.swift
//  DEN_watch
//
//  Created by Smartwatch Project on 8/15/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import UIKit
import Parse

let borderColor = "#03A9F4"

class Utils{
    
    class func setPictureBorder(view: UIImageView){
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(rgba: borderColor).CGColor
        view.layer.masksToBounds = true
    }
    

}