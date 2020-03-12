//
//  AddGoalController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 12/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddGoalController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Attributes
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("AddGoal Loaded")
        
    }
}
