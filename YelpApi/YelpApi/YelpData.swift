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
    
    static let apiLink = "https://api.yelp.com/v3/businesses/search?term=spicy+food&latitude=37.786882&longitude=-122.399972"
    
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
                .map(YelpDataObject.fromJson)
                .filter() { $0 != nil }
                .map() { $0! }
            
            guard !yelpObjects.isEmpty else {
                print("No Results found.")
                exitWithoutImage()
                return
            }
            
//            if let image = oneImageFrom(yelpObjects: yelpObjects) {
//                exitWithImage(image: image)
//            }
//            else {
//                exitWithoutImage()
//            }
        }
        
    }

//    private static func oneImageFrom(yelpObjects: [YelpDataObject]) -> UIImage? {
//        
//        let oneObject = yelpObjects
//        
//        let imageUrl = oneObject.image.url
//        
//        do {
//            let data = try Data(contentsOf: imageUrl)
//            return UIImage(data: data)
//        }
//        catch let ex {
//            print("Failed to load Image from URL: \(imageUrl) : \(ex)")
//            return nil
//        }
//    }
    
}

let YelpTokenRequest = ["grant_type" : "client_credentials",
                        "client_id": "ih_D0tv9FsD5dR1Gx6K17Q",
                        "client_secret" : "8RYrEyosCCVLXospGDXsqPxqPZx95lAJvShqNkHiekfG0EtwOSLCv4NzKXx2aMb7"]

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

fileprivate struct YelpDataObject {
    
    let type: String
    let id: String
    let slug: String
    let url: URL
    let source: URL
    let image: YelpImage
    
    static func fromJson(json: NSDictionary) -> YelpDataObject? {
        
        guard let type = json["type"] as? String,
            let id = json["id"] as? String,
            let slug = json["slug"] as? String,
            let urlString = json["url"] as? String, let url = URL(string: urlString),
            let sourceString = json["source"] as? String, let source = URL(string: sourceString),
            let imagesObject = json["images"] as? NSDictionary,
            let imageObject = imagesObject["fixed_height"] as? NSDictionary
            else {
                return nil
        }
        
        guard let yelpImage = YelpImage.fromJson(json: imageObject)
            else {
                print("Could not parse Yelp Image")
                return nil
        }
        
        return YelpDataObject(type: type, id: id, slug: slug, url: url, source: source, image: yelpImage)
    
        }
    }


