//
//  RoutinesController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 16/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RoutinesController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Attributes
    
    
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Routines Loaded")
        
    }
}
