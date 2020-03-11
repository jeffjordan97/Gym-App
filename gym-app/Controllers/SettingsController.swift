//
//  SettingsController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 11/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingsController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Attributes
    
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Settings Loaded")
        
    }
}
