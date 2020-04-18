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
    @IBOutlet weak var settingsView: UIView!
    
    
    
    //MARK: Attributes
    
    
    
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        settingsView.layer.cornerRadius = 20
        settingsView.layer.shadowOpacity = 1
        settingsView.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        settingsView.layer.shadowRadius = 10
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Settings Loaded")
        
    }
}
