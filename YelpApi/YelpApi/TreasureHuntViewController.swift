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
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var scavengerHuntArray: [String]?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TreasureHuntTableCell else { return UITableViewCell() }
        
        
        cell.arrayTextField.text = defaultArray[indexPath.row]
        cell.arrayTextField.textColor = UIColor.yellow
        cell.button.layer.cornerRadius = 15
        cell.categoryTxtFld.text = categorySearchItem[indexPath.row]
        
        let index = defaultArray[indexPath.row]
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

var defaultArray = ["Find the weirdest drink on the menu.", "Try the spiciest thing on the menu", "Share dessert with a stranger", "Thumb wrestle a server"]

var categorySearchItem = ["weird", "spicy", "dessert", "thumb wrestle"]
