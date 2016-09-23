//
//  TreasureHuntViewController.swift
//  YelpApi
//
//  Created by K on 9/16/16.
//  Copyright © 2016 K. All rights reserved.
//

import Foundation
import UIKit

class TeasureHuntViewController: UITableViewController {
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let defaultArray = ["Find the weirdest drink on the menu.", "Try the spiciest thing on the menu", "Share dessert with a stranger", "Thumb wrestle a server"]
    
    var scavengerHuntArray: [String]?
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    
}
