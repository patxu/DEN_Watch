//
//  LocationManager.swift
//  DEN_watch
//
//  Created by David Bain on 8/1/15.
//  Copyright © 2015 David Bain. All rights reserved.
//

import Foundation
import CoreLocation

typealias LMReverseGeocodeCompletionHandler = ((reverseGecodeInfo:NSDictionary?,placemark:CLPlacemark?, error:String?)->Void)?
typealias LMGeocodeCompletionHandler = ((gecodeInfo:NSDictionary?,placemark:CLPlacemark?, error:String?)->Void)?
typealias LMLocationCompletionHandler = ((latitude:Double, longitude:Double, status:String, verboseMessage:String, error:String?)->())?


class LocationManager: NSObject, CLLocationManagerDelegate{
    
    /* Private variables */
    private var completionHandler:LMLocationCompletionHandler
    
    private var reverseGeocodingCompletionHandler:LMReverseGeocodeCompletionHandler
    private var geocodingCompletionHandler:LMGeocodeCompletionHandler
    
    private var locationStatus = NSLocalizedString("Calibrating", comment: "")// to pass in handler
    private var locationManager: CLLocationManager!
    private var verboseMessage = NSLocalizedString("Calibrating", comment: "")

    private let verboseMessageDictionary = [CLAuthorizationStatus.NotDetermined:NSLocalizedString("You have not yet made a choice with regards to this application.", comment: ""),
        CLAuthorizationStatus.Restricted:NSLocalizedString("This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.", comment: ""),
        CLAuthorizationStatus.Denied:NSLocalizedString("You have explicitly denied authorization for this application, or location services are disabled in Settings.", comment: ""),
        CLAuthorizationStatus.AuthorizedAlways:NSLocalizedString("App is Authorized to always use location services.", comment: ""),CLAuthorizationStatus.AuthorizedWhenInUse:NSLocalizedString("You have granted authorization to use your location only when the app is visible to you.", comment: "")]
    
    var delegate:CLLocationManagerDelegate? = nil
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    var latitudeAsString:String = ""
    var longitudeAsString:String = ""
    
    
    var lastKnownLatitude:Double = 0.0
    var lastKnownLongitude:Double = 0.0
    
    var lastKnownLatitudeAsString:String = ""
    var lastKnownLongitudeAsString:String = ""
    
    
    var keepLastKnownLocation:Bool = true
    var hasLastKnownLocation:Bool = true
    
    var autoUpdate:Bool = false
    
    var showVerboseMessage = false
    
    var isRunning = false
    
    class var sharedInstance : LocationManager {
        struct Static {
            static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    private override init(){
        
        super.init()
        if !autoUpdate {
            autoUpdate = !CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
    }
    private func resetLatLon(){
        
        latitude = 0.0
        longitude = 0.0
        
        latitudeAsString = ""
        longitudeAsString = ""
    }
    private func resetLastKnownLatLon(){
        
        hasLastKnownLocation = false
        
        lastKnownLatitude = 0.0
        lastKnownLongitude = 0.0
        
        lastKnownLatitudeAsString = ""
        lastKnownLongitudeAsString = ""
    }
    
    func startUpdatingLocationWithCompletionHandler(completionHandler:((latitude:Double, longitude:Double, status:String, verboseMessage:String, error:String?)->())? = nil){
        print ("inside startUpdatingLocation")
        
        self.completionHandler = completionHandler
        
        initLocationManager()
    }
    
    func startUpdatingLocation(){
        
        initLocationManager()
    }
    
    func stopUpdatingLocation(){
        
        if autoUpdate {
            locationManager.stopUpdatingLocation()
        } else {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        resetLatLon()
        if !keepLastKnownLocation {
            resetLastKnownLatLon()
        }
    }
    
    private func initLocationManager() {
        print ("inside initlocationmang")
        
        // App might be unreliable if someone changes autoupdate status in between and stops it
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if NSString(string: UIDevice.currentDevice().systemVersion).doubleValue >= 8 {
            
            //locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
            locationManager.requestWhenInUseAuthorization() // add in plist NSLocationWhenInUseUsageDescription
        }
        
        startLocationManger()
    }
    
    
    private func startLocationManger() {
        autoUpdate = true
        print (self.autoUpdate)
        if self.autoUpdate {
            print ("inside statLocationManager")
            
            locationManager.startUpdatingLocation()
        } else {
            print ("inside statLocationManager else")
            
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        isRunning = true
    }
    
    private func stopLocationManger() {
        
        if autoUpdate {
            
            locationManager.stopUpdatingLocation()
        } else {
            
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        isRunning = false
    }
    
    internal func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print ("error in locationManager didFaileWithError")
        stopLocationManger()
        
        resetLatLon()
        
        if !keepLastKnownLocation {
            
            resetLastKnownLatLon()
        }
        
        var verbose = ""
        
        if showVerboseMessage {verbose = verboseMessage}
        completionHandler?(latitude: 0.0, longitude: 0.0, status: locationStatus, verboseMessage:verbose,error: error.localizedDescription)
        
        if (delegate != nil) && (delegate?.respondsToSelector(Selector("locationManagerReceivedError:")))! {
            //delegate?.locationManagerReceivedError!(error.localizedDescription)
            
        }
    }
    
    internal func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]!) {
        
        let arrayOfLocation = locations as NSArray
        let location = arrayOfLocation.lastObject as! CLLocation
        let coordLatLon = location.coordinate
        
        latitude  = coordLatLon.latitude
        longitude = coordLatLon.longitude
        
        latitudeAsString  = coordLatLon.latitude.description
        longitudeAsString = coordLatLon.longitude.description
        
        var verbose = ""
        
        if showVerboseMessage {verbose = verboseMessage}
        
        if completionHandler != nil {
            
            completionHandler?(latitude: latitude, longitude: longitude, status: locationStatus, verboseMessage:verbose, error: nil)
        }
        
        lastKnownLatitude = coordLatLon.latitude
        lastKnownLongitude = coordLatLon.longitude
        
        lastKnownLatitudeAsString = coordLatLon.latitude.description
        lastKnownLongitudeAsString = coordLatLon.longitude.description
        
        hasLastKnownLocation = true
        
        if delegate != nil {
            if (delegate?.respondsToSelector(Selector("locationFoundGetAsString:longitude:")))! {
                //delegate?.locationFoundGetAsString!(latitudeAsString,longitude:longitudeAsString)
                
            }
            if (delegate?.respondsToSelector(Selector("locationFound:longitude:")))! {
               
                //delegate?.locationFound(latitude,longitude:longitude)
            }
        }
    }
    
    internal func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var hasAuthorised = false
            var verboseKey = status
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = NSLocalizedString("Restricted Access", comment: "")
            case CLAuthorizationStatus.Denied:
                locationStatus = NSLocalizedString("Denied access", comment: "")
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = NSLocalizedString("Not determined", comment: "")
            default:
                locationStatus = NSLocalizedString("Allowed access", comment: "")
                hasAuthorised = true
            }
            
            verboseMessage = verboseMessageDictionary[verboseKey]!
            
            if hasAuthorised {
                startLocationManger()
            } else {
                
                resetLatLon()
                if !(locationStatus == NSLocalizedString("Denied access", comment: "")) {
                    
                    var verbose = ""
                    if showVerboseMessage {
                        
                        verbose = verboseMessage
                        
                        if (delegate != nil) && (delegate?.respondsToSelector(Selector("locationManagerVerboseMessage:")))! {
                            
                            //delegate?.locationManagerVerboseMessage!(verbose)
                        }
                    }
                    
                    if completionHandler != nil {
                        completionHandler?(latitude: latitude, longitude: longitude, status: locationStatus, verboseMessage:verbose,error: nil)
                    }
                }
                if (delegate != nil) && (delegate?.respondsToSelector(Selector("locationManagerStatus:")))! {
                    //delegate?.locationManagerStatus!(locationStatus)
                }
            }
    }

    
    
    
    
}