//
//  MapPageViewController.swift
//  YelpApi
//
//  Created by K on 9/16/16.
//  Copyright © 2016 K. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class MapPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        
        
    }
    
}
