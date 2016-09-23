//
//  MapViewTableViewCell.swift
//  YelpApi
//
//  Created by K on 9/20/16.
//  Copyright © 2016 K. All rights reserved.
//

import Foundation
import UIKit

class MapViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bizPhoto: UIImageView!
    @IBOutlet weak var bizNameLabel: UILabel!
    @IBOutlet weak var bizAddressLabel: UILabel!
    @IBOutlet weak var bizPhoneLabel: UILabel!
    @IBOutlet weak var bizRatingNumberLabel: UILabel!
    @IBOutlet weak var yelpLogo: UIImageView!
    @IBOutlet weak var tableCellContentView: UIView!
    @IBOutlet weak var yelpLogoButton: UIButton!
    @IBOutlet weak var bizIDLabel: UILabel!
    
    @IBAction func yelpLogoButtonPressed(_ sender: AnyObject) {
        let yelpBiz = "https://www.yelp.com/biz/"
        
        let id: String! = bizIDLabel.text

        let bizIDurl = yelpBiz + id!
        
        print(bizIDurl)
        
        if let url = NSURL(string: bizIDurl) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    

  


}
