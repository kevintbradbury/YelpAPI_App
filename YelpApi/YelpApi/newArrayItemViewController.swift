//
//  newArrayItemViewController.swift
//  YelpApi
//
//  Created by K on 9/23/16.
//  Copyright © 2016 K. All rights reserved.
//

import Foundation
import UIKit

class NewArrayItemViewController: UIViewController {
    
    @IBOutlet weak var newArrayItemField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var categoryTxtField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 15
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard let text = newArrayItemField.text else { return }
        defaultArray.append(text)
        guard let category = categoryTxtField.text else { return }
        categorySearchItem.append(category)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
