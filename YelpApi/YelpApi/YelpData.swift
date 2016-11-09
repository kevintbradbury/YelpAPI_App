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

typealias Callback = (UIImage?) -> ()

class Yelp {

    static let apiLink = "https://api.yelp.com/oauth2/token"

    private var apiToken: String?

    static var keyword: String = ""

    static let searchWords = apiLink

    var imageArray: [UIImage] = []

    private static let async: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private static let main = OperationQueue.main

    static func searchForImages(withTerm term: String, onDone callback: @escaping Callback) {

        guard let url = createUrlFor(searchTerm: term)
            else {
                callback(nil)
                return
        }

        async.maxConcurrentOperationCount = 1

        loadImages(for: url, withCallback: callback)
        print(loadImages(for: url, withCallback: callback))
    }

    private static func createUrlFor(searchTerm term: String?) -> URL? {

        guard let link = term else { return nil }

        return URL(string: link)
    }

    private static func loadImages(for url: URL, withCallback callback: @escaping Callback) {

        func exitWithImage(image: UIImage) {

            self.main.addOperation() { callback(image) }
        }

        func exitWithoutImage() {

            self.main.addOperation() { callback(nil) }
        }

        self.async.addOperation() {

            guard let data = try? Data(contentsOf: url),
                let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? NSDictionary
                else {
                    exitWithoutImage()
                    return
            }

            guard let dataArray = json["data"] as? NSArray  //dataArray.notEmpty
                else {
                    exitWithoutImage()
                    return
            }

            let yelpObjects = dataArray
                .filter() { $0 is NSDictionary }
                .map() { $0 as! NSDictionary }
                .map(YelpDataItem.fromjson)
                .filter() { $0 != nil }
                .map() { $0! }

            guard !yelpObjects.isEmpty else {
                print("No Results found.")
                exitWithoutImage()
                return
            }

        }

    }


}

let YelpTokenAccess = ["access_token" : "XT-cgvuAYuopiCBZfTktylJweQmBcaHksb2mEwMpSG7ZBfWdWmcmWtOwEiyCAJBjTL7_hMFoT4Np976vktSLBVcSZy7nVoDOA4cH1Fl7fEnGADkjhEWInXEMhdXhV3Yx",
    "token_type": "Bearer",
    "expires_in": 15551999] as [String : Any]

fileprivate struct YelpTokenReceived {
    let access_token: String
    let token_type: String
    let expires_in: Int

    static func fromJson(json: NSDictionary) -> YelpTokenReceived? {

        guard let access_token = json["access_token"] as? String,
                let token_type = json["token_type"] as? String,
                let expires_in = json["expires_in"] as? Int
            else {
             return nil
        }

        return YelpTokenReceived(access_token: access_token, token_type: token_type, expires_in: expires_in)
    }
}


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
////            guard let streetAddress = addressDictionary["address1"] as? String else { return nil }
////            guard let cityAddress = addressDictionary["city"] as? String else { return nil}
////            guard let stateAddress = addressDictionary["state"] as? String else { return nil }
////        let addressObject = ["street": streetAddress, "city": cityAddress, "state": stateAddress]
////                print("address Object is : \(addressObject) ")

        return YelpDataItem(url: url, rating: rating, price: price, phone: phone, id: id, review_count: review_count, name: name, address: address as NSDictionary, coordinates: coordinatesObject)
    }
}






