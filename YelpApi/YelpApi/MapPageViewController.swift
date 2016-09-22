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
    
  //  var yelpBusinessImages: [UIImage] = []
    
    private let mainOperation = OperationQueue.main
    
    
 
    var yelpBusiness = [YelpDataItem]()
    
    func apiCall() {
        
        emptyString = "https://api.yelp.com/v3/businesses/search?term=pizza&latitude=37.786882&longitude=-122.399972"
        
        let url = URL(string: emptyString)!
        
        var request = URLRequest.init(url: url)
        
        request.setValue("Bearer XT-cgvuAYuopiCBZfTktylJweQmBcaHksb2mEwMpSG7ZBfWdWmcmWtOwEiyCAJBjTL7_hMFoT4Np976vktSLBVcSZy7nVoDOA4cH1Fl7fEnGADkjhEWInXEMhdXhV3Yx", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) {(data, response, error) -> Void in
            
            guard let moreData = data else { return }
            
            guard let someObject = (try? JSONSerialization.jsonObject(with: moreData, options: [])) as? NSDictionary else { return }
            
            guard let array = (someObject["businesses"]) as? NSArray else { return }
            //print(array)
            
            //            print("****\n\(someObject)\n****")
        //    print("array COUNT: \(array.count)")
            
            for i in array {
                
                guard let dictionary = i as? NSDictionary else { continue }
                
                guard let yelpDictionary = YelpDataItem.fromjson(dictionary: dictionary) else {
                    print("error in guard")
                    return }

                self.yelpBusiness.append(yelpDictionary)
                
            }
            
            
            self.mainOperation.addOperation {
                self.yelpBizTable.reloadData()
            }
            
        }

        dataTask.resume()
        
    }
    
    
    
    
//        func onComplete(data: Data?, response: URLResponse?, error: Error?) {
//            guard let data = data else { return }
//            let string = String(data:data, encoding: String.Encoding.utf8)
//            print("string from apicall: \(string)")
//        }
//        // dataTask calls the constant LET that was declared above in the API call
//        let task = session.dataTask(with: url, completionHandler: onComplete)
//        
//        print(url)
//        
//        task.resume()
//        
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors" + error.localizedDescription)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        
        return cell
    }
    

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        ImageDisplay.image = info [UIImagePickerControllerOriginalImage] as? UIImage;
//    }


}




