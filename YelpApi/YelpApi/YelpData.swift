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
    var price: String
    var phone: String
    var id: String
    var review_count: Int
    var name: String
    var address: NSDictionary
    var coordinates: CLLocationCoordinate2D

    static func fromjson(dictionary: NSDictionary) -> YelpDataItem? {
        guard let imageUrl = dictionary["image_url"] as? String,
            let rating = dictionary["rating"] as? Double,
            let price = dictionary["price"] as? String,
            let phone = dictionary["phone"] as? String,
            let id = dictionary["id"] as? String,
            let review_count = dictionary["review_count"] as? Int,
            let name = dictionary["name"] as? String,
            let address = dictionary["location"] as? NSDictionary,
            let coordinates = dictionary["coordinates"] as? NSDictionary else {
                print("Guard failed on fromJson()")
                return nil
        }
        guard let url = URL(string: imageUrl) else { return nil }

        guard let coordinatesDictionary = dictionary["coordinates"] as? NSDictionary else { return nil }
            guard let latitude = coordinatesDictionary["latitude"] as? CLLocationDegrees else { return nil }
            guard let longitude = coordinatesDictionary["longitude"] as? CLLocationDegrees else { return nil }
            let coordinatesObject = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
        
//        guard let addressDictionary = dictionary["location"] as? NSDictionary else { return nil }
//            guard let streetAddress = addressDictionary["address1"] as? String else { return nil }
//            guard let cityAddress = addressDictionary["city"] as? String else { return nil}
//            guard let stateAddress = addressDictionary["state"] as? String else { return nil }
//        let addressObject = [streetAddress, cityAddress, stateAddress]
//        print("address Object is : \(addressObject) ")

        
        return YelpDataItem(url: url, rating: rating, price: price, phone: phone, id: id, review_count: review_count, name: name, address: address, coordinates: coordinatesObject)
    }
}






