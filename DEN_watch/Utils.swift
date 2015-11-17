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
        //rounded profile picture
        view.layer.borderWidth = 5
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.whiteColor().CGColor
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
    

}