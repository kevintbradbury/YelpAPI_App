//
//  YelpData.swift
//  YelpApi
//
//  Created by K on 9/20/16.
//  Copyright © 2016 K. All rights reserved.
//

import Foundation
import UIKit

typealias Callback = (UIImage?) -> ()

class Yelp {
    
    static let apiLink = "https://api.yelp.com/oauth2/token"
    
    private var apiToken: String?
    
    static var keyword: String = "spicy food"
    
    static let searchWords = apiLink
    
//    private let apiKey: 

    private static let async: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private static let main = OperationQueue.main
    
    static func searchForInfo(withTerm term: String, onDone callback: @escaping Callback) {
        
        guard let url = createUrlFor(searchTerm: term)
            else {
                callback(nil)
                return
        }
        
        async.maxConcurrentOperationCount = 1
        
        loadSearchResults(for: url, withCallback: callback)
        print(loadSearchResults(for: url, withCallback: callback))
    }
    
    private static func createUrlFor(searchTerm term: String?) -> URL? {
        
     //   guard let escapedTerm = term else { return nil }
        
        let link = "https://api.yelp.com/v3/businesses/search?term=spicy+food&latitude=37.786882&longitude=-122.399972"
        
        return URL(string: link)
    }

    private static func loadSearchResults(for url: URL, withCallback callback: @escaping Callback) {
        
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

fileprivate struct YelpImage {
    
    let url: URL
    let width: Int
    let height: Int
    let size: Int
    
    static func fromJson(json: NSDictionary) -> YelpImage? {
        
        guard let urlString = json["url"] as? String, let url = URL(string: urlString),
                let widthString = json["width"] as? String, let width = Int(widthString),
                let heightString = json["height"] as? String, let height = Int(heightString),
                let sizeString = json["size"] as? String, let size = Int(sizeString)
            else {
                return nil
        }
        
        return YelpImage(url: url, width: width, height: height, size: size)
        
        }
    }

struct YelpDataItem {
    
    let rating: String
    let price: String
    let phone: String
    let id: String
    let review_count: String
    let name: String
    let url: URL
    let image_url: URL
    
    static func fromjson(dictionary: NSDictionary) -> YelpDataItem? {
        guard let rating = dictionary["rating"] as? String,
            let price = dictionary["price"] as? String,
            let phone = dictionary["phone"] as? String,
            let id = dictionary["id"] as? String,
            let review_count = dictionary["review_count"] as? String,
            let name = dictionary["name"] as? String,
            let url = dictionary["url"] as? URL,
            let image_url = dictionary["image_url"] as? URL
            else {
                return nil
        }
        return YelpDataItem(rating: rating, price: price, phone: phone, id: id, review_count: review_count, name: name, url: url, image_url: image_url)
    }
}


//
//struct yelpBusinessAddress {
//    let location: Dictionary = [
//        city: String,
//        country: String,
//        address2: String,
//        address3: String,
//        state: String,
//        address1: String,
//        zip_code: Int
//    ]
//
//}
//
//struct businessCoordinates {
//    let coordinates: Dictionary = [
//        latitude: Double,
//        longitude: Double
//    ]
//
//}
