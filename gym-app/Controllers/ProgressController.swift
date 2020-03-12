//
//  ProgressController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProgressController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Attributes
    
    
    //function to pass info to AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddGoal"){
            let addGoalVC = segue.destination as! AddGoalController
            print("toAddGoal Segue...")
            addGoalVC.isModalInPresentation = true
        }
    }
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Progress Loaded")
        
    }
}
