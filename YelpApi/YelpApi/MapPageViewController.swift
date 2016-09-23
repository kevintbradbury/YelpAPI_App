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
import Foundation

class MapPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var yelpBizTable: UITableView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var saveImage: UIImageView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yelpBizTable.delegate = self
        yelpBizTable.dataSource = self
        
        mapView.delegate = self
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        apiCall()
        
        
    }
    
    
    
    var emptyString: String = ""

    private let mainOperation = OperationQueue.main
 
    var yelpBusiness = [YelpDataItem]()
    
    var yelpImages: [UIImage] = []
    
    var yelpLocations: [location] = []
//  API Call
    
    func apiCall() {
        
        emptyString = "https://api.yelp.com/v3/businesses/search?term=spicy&latitude=37.786882&longitude=-122.399972"
        
        let url = URL(string: emptyString)!
        
        var request = URLRequest.init(url: url)
        
        request.setValue("Bearer XT-cgvuAYuopiCBZfTktylJweQmBcaHksb2mEwMpSG7ZBfWdWmcmWtOwEiyCAJBjTL7_hMFoT4Np976vktSLBVcSZy7nVoDOA4cH1Fl7fEnGADkjhEWInXEMhdXhV3Yx", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) {(data, response, error) -> Void in
            
            guard let moreData = data else { return }
            
            guard let someObject = (try? JSONSerialization.jsonObject(with: moreData, options: [])) as? NSDictionary else { return }
            
            guard let array = (someObject["businesses"]) as? NSArray else { return }
            
            for i in array {
                
                guard let dictionary = i as? NSDictionary else { continue }
                
                print(dictionary)
                
                guard let yelpDictionary = YelpDataItem.fromjson(dictionary: dictionary) else {
                    print("error in guard")
                    return }
                
//                let locationInfo: [location] = yelpDictionary.location
                
                guard let newData = try? Data(contentsOf: yelpDictionary.url) else {return}
                
                self.yelpBusiness.append(yelpDictionary)
                
                self.yelpImages.append(UIImage(data: newData)!)
                
//                self.yelpLocations.append(bizLocations)
            }
            
            
            self.mainOperation.addOperation {
                self.yelpBizTable.reloadData()
            }
            
        }

        dataTask.resume()
        
    }
    
//  Location Manager
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
//        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!), span: span)
        
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    

    
//  TableView layout
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors" + error.localizedDescription)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yelpBusiness.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("yelp business count - \(yelpBusiness.count)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MapViewTableViewCell else { return UITableViewCell() }
        
        let yelpData = yelpBusiness[indexPath.row]
        print("yelpData: \(yelpData)")
        cell.bizNameLabel.text = yelpData.name
        cell.bizPhoneLabel.text = yelpData.phone

        let ratingAsAstring = "\(yelpData.rating)"
        cell.bizRatingNumberLabel.text = ratingAsAstring
        
        cell.bizPhoto.image = yelpImages[indexPath.row]
        
        cell.bizIDLabel.text = yelpData.id
        
        

        
        
//        cell.bizAddressLabel.text = yelpData.location
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let yelpData = yelpBusiness[indexPath.row]
        
        let location = yelpData.coordinates
        
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
    
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        saveImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }


}




