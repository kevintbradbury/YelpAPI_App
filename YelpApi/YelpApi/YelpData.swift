//
//  YelpData.swift
//  YelpApi
//
//  Created by K on 9/20/16.
//  Copyright © 2016 K. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct YelpDataItem {
    
    var url: URL
    var rating: Double
    var phone: String
    var id: String
    var price: String
    var review_count: Int
    var name: String
    var address: NSDictionary
    var coordinates: CLLocationCoordinate2D
    
    static func fromjson(dictionary: NSDictionary) -> YelpDataItem? {
        guard let imageUrl = dictionary["image_url"] as? String,
            let rating = dictionary["rating"] as? Double,
            let phone = dictionary["phone"] as? String,
            let id = dictionary["id"] as? String,
            let price = dictionary["price"] as? String,
            let review_count = dictionary["review_count"] as? Int,
            let name = dictionary["name"] as? String,
            let address = dictionary["location"] as? NSDictionary,
            let coordinates = dictionary["coordinates"] as? NSDictionary else {
                print("Guard failed on fromJson()")
                return nil
        }
        guard let url = URL(string: imageUrl) else { return nil }
        guard let latitude = coordinates["latitude"] as? CLLocationDegrees else { return nil }
        guard let longitude = coordinates["longitude"] as? CLLocationDegrees else { return nil }
        print("\(latitude) :lat & \(longitude) :long")
        let coordinatesObject = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) , longitude: CLLocationDegrees(longitude))
        
        return YelpDataItem(url: url, rating: rating, phone: phone, id: id, price: price, review_count: review_count, name: name, address: address, coordinates: coordinatesObject)
    }
}






