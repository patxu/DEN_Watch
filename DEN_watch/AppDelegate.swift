//
//  AppDelegate.swift
//  DEN_watch
//
//  Created by David Bain on 7/19/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import UIKit
import Bolts
import Parse
import FBSDKCoreKit
import CoreLocation
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, WCSessionDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let denLong = -72.28721234947443
    let denLat = 43.70045791491961
    var user: PFUser!
    var denRegion: CLCircularRegion!
    var session : WCSession!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //test
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        var keys: NSDictionary?
        
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let _ = keys {
            let applicationId = keys?["parseApplicationId"] as? String
            let clientKey = keys?["parseClientKey"] as? String
            
            // Initialize Parse.
            Parse.setApplicationId(applicationId!, clientKey: clientKey!)
        }
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != .AuthorizedAlways)  {
            locationManager.requestAlwaysAuthorization()
            
        }
        //locationManager.startUpdatingLocation()
        
        //Location set-up
        
        let denCenter = CLLocationCoordinate2D(latitude: denLat, longitude: denLong)
        denRegion = CLCircularRegion(center: denCenter, radius: 100, identifier: "DenCenter")
        // 2
        denRegion.notifyOnEntry = true
        denRegion.notifyOnExit = true
        
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            print ("Geofencing is not supported on this device!")
        }
        
        
        locationManager.startMonitoringForRegion(denRegion)
        
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        //If user is signed in, skip straight to pageVC
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // get your storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // instantiate your desired ViewController
            let rootController = storyboard.instantiateViewControllerWithIdentifier("UserListVC")
            
            // Because self.window is an optional you should check it's value first and assign your rootViewController
            if self.window != nil {
                self.window!.rootViewController = rootController
            }
        }
        
        
        
        
        //Facebook set up
        //        let isFacebookAuthorized = sharedApplication.canOpenURL(NSURL(fileURLWithPath: "fbauth://authorize"));
        return true//FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    //    func application(application: UIApplication,
    //        openURL url: NSURL,
    //        sourceApplication: String?,
    //        annotation: AnyObject?) -> Bool {
    //
    //
    //            print ("url is " + url.path!)
    //            return FBSDKApplicationDelegate.sharedInstance().application(
    //                application,
    //                openURL: url,
    //                sourceApplication: sourceApplication,
    //                annotation: annotation)
    //    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let groupID = "group.edu.dartmouth.den.DEN-watch"
        let sharedDefaults = NSUserDefaults(suiteName: groupID)
        let isOk = sharedDefaults!.synchronize()
        print (isOk)
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //            FBSDKApplicationDelegate.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func handleRegionEvent(region: CLRegion) {
        /*
        // Show an alert if application is active
        if UIApplication.sharedApplication().applicationState == .Active {
        if let message = notefromRegionIdentifier(region.identifier) {
        if let viewController = window?.rootViewController {
        showSimpleAlertWithTitle(nil, message: message, viewController: viewController)
        }
        }
        } else {
        // Otherwise present a local notification
        var notification = UILocalNotification()
        notification.alertBody = notefromRegionIdentifier(region.identifier)
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        }
        */
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            print ("in region")
            userInDEN(true)
            handleRegionEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            print ("out of region")
            userInDEN(false)
            handleRegionEvent(region)
        }
    }
    
    func userInDEN(inDEN: Bool) {
        self.user = PFUser.currentUser()
        if user != nil{
            self.user["inDEN"] = inDEN
            if (inDEN == true){
                let session = PFObject(className:"DenSession")
                session["inTime"] = NSDate()
                let formatter = NSDateFormatter()
                formatter.timeZone = NSTimeZone.localTimeZone()
                session["user"] = self.user
                if (self.user["currentSession"] == nil){
                    self.user["currentSession"] = session
                    print ("set in time")
                }
            }
            else{
                if (self.user["currentSession"] != nil){
                    let currentSession = self.user["currentSession"] as! PFObject
                    print ("setting out time")
                    currentSession["outTime"] = NSDate()
                    let formatter = NSDateFormatter()
                    formatter.timeZone = NSTimeZone.localTimeZone()
                    print ("set out time")
                    self.user.removeObjectForKey("currentSession")
                    currentSession.saveInBackground()
                }
            }
            self.user.saveInBackground()
            print ("changed user status")
        }
        else{
            print("no locally stored user")
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if denRegion.containsCoordinate(locations[0].coordinate){
            userInDEN(true)
        }
        else{
            userInDEN(false)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("Location Manager failed with the following error: \(error)")
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        self.user = PFUser.currentUser()
        if user != nil{
            calculateWeekTime(user,sendInfoToWatch)
            print("message sent")
        }
        
        
    }
    
    func sendInfoToWatch(minutes: Double){
        let query = PFUser.query()!
        query.whereKeyExists("currentSession")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) users.")
                let msg = ["minutes": NSNumber(double: minutes), "userCount":objects!.count]
                print("sending \(msg)")
                self.session.sendMessage(msg, replyHandler: { reply in
                    print("Got reply: \(reply)")
                    }, errorHandler: { error in
                        print("error: \(error)")
                })
            }
        }
        
    }
    
    func calculateWeekTime(user: PFUser, _ useTime:(Double)->()) {
        let query = PFQuery(className:"DenSession")
        var minutes = 0.0
        //week in seconds
        let timeToSubtract = 7*24*60*60 as NSTimeInterval
        let weekAgo = NSDate().dateByAddingTimeInterval(-timeToSubtract)
        query.whereKey("user", equalTo:user)
        query.whereKey("inTime", greaterThan:weekAgo)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for denSession in objects {
                        let inDate = denSession["inTime"] as! NSDate
                        print(inDate)
                        if let outDate = denSession["outTime"] as? NSDate{
                            minutes += (outDate.timeIntervalSinceDate(inDate)/60)
                        }
                    }
                    if (user["currentSession"] != nil){
                        let currentSession = user["currentSession"] as! PFObject
                        let startTime = currentSession["inTime"] as! NSDate
                        minutes += (NSDate().timeIntervalSinceDate(startTime)/60)
                    }
                    useTime(minutes)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
            
        }
        
    }
    
    
}
