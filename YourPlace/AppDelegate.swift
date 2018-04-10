//
//  AppDelegate.swift
//  YourPlace
//
//  Created by Lacy Rhoades on 4/9/18.
//  Copyright © 2018 Lacy Rhoades. All rights reserved.
//

import UIKit
import CoreLocation
import PMAMobileFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let locationManager = GalleryLocationManager(locationManager: CLLocationManager())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Constants.backend.host = "https://hackathon.philamuseum.org";
        Constants.backend.apiKey = PMA_API_KEY
        
        do {
            print("Retrieving location assets from backend...")
            try BackendService.shared.retrieveGeolocationData(completion: {
                print("Successfully loaded location assets from backend.")
            })
        } catch let error {
            print("Error loading location assets from backend: \(error)")
        }
        
        self.startLocationSensing()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func startLocationSensing() {
        
        // setting ourselfs up as delegate for location updates
        locationManager.delegate = self
        
        // we need to ask the user for when in use permissions
        locationManager.requestPermissions()
        
        do {
            try locationManager.startLocationRanging(with: Constants.locationSensing.method.apple)
            print("Starting Location Sensing...\n")
        } catch let error {
            print("Error starting Location Sensing: \(error)\n")
        }
        
        // this is a sample test call to match a given location with the geojson file
        // note that we need to set ignoreFloors to true since we cannot define a floor in CLLocation (yeah, really...)
        //        let location = CLLocation(latitude: 39.965186632142064, longitude: -75.1815766902897)
        //        let matchedLocation = LocationStore.sharedInstance.locationForCLLocation(location: location, ignoreFloors: true)
        //        print("Location: \(String(describing: matchedLocation?.name))") // this will return gallery 119
        
    }


}

extension AppDelegate : GalleryLocationManagerDelegate {
    func locationManager(locationManager: GalleryLocationManager, didEnterKnownLocation location: Location) {
        print("Entered Location: \(location.name)")
    }
    
    @nonobjc func locationManager(locationManager: GalleryLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("Updated Heading: x: \(newHeading.x) y: \(newHeading.y) z: \(newHeading.z)")
    }
}
