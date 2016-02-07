//
//  ViewController.swift
//  myFirstMap
//
//  Created by Alberto De Avila Hernandez on 5/2/16.
//  Copyright © 2016 Alberto De Avila Hernandez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var hybridMapButton: UIButton!
    @IBOutlet weak var satelliteMapButton: UIButton!
    @IBOutlet weak var planeMapButton: UIButton!
    
    var firstPoint: CLLocation! = nil
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        * initialize locationManager and the map
        */
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50.0
        map.userTrackingMode = MKUserTrackingMode.Follow
        locationManager.requestWhenInUseAuthorization()
    }
    
    /*
     * Method to intialize or stop the read of the locations 
     */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
        }else{
            locationManager.stopUpdatingLocation()
            map.showsUserLocation = true
        }
    }
    
    /*
    * Method to put a pin when a lecture of the position is done
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentPoint: CLLocationCoordinate2D = locationManager.location!.coordinate
        let pin = MKPointAnnotation()
        pin.title = "LAT: \(currentPoint.latitude) LONG: \(currentPoint.longitude)"
        pin.coordinate = currentPoint

        if(firstPoint == nil){
            firstPoint = locationManager.location!
            pin.subtitle = "INICIO"
        }else{
            pin.subtitle = "Distancia recorrida total: \(locationManager.location?.distanceFromLocation(firstPoint)) m"
        }
        map.addAnnotation(pin)
    }
    
    /*
     * Method to show a message if something goes wrong
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alert = UIAlertController(title: "Error", message: "Ha ocurrido un error", preferredStyle: .Alert)
        
         alert.addAction(UIAlertAction(title: "Ok", style: .Default) {alert in
            //..
         })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
     * Action to change the map to a plane type
     */
    @IBAction func changePlaneMap() {
        planeMapButton.enabled = false
        hybridMapButton.enabled = true
        satelliteMapButton.enabled = true
        map.mapType = .Standard
    }
    
    /*
     * Action to change the map to a hybrid type
     */
    @IBAction func changeHybridMap() {
        hybridMapButton.enabled = false
        satelliteMapButton.enabled = true
        planeMapButton.enabled = true
        map.mapType = .Hybrid
    }
    
    
    /*
     * Action to change the map to a satellite type
     */
    @IBAction func changeSatelliteMap() {
        satelliteMapButton.enabled = false
        planeMapButton.enabled = true
        hybridMapButton.enabled = true
        map.mapType = .Satellite
    }
}

