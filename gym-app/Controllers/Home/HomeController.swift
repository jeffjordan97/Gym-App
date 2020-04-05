//
//  HomeController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import DropDown


class HomeController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var settingsButton: UIButton!
    
    
    //MARK: Attributes
    
    
    
    
    
    //function to pass info to AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddWorkout"){
            let addWorkoutVC = segue.destination as! AddWorkoutController
            print("toAddWorkout Segue...")
            addWorkoutVC.isModalInPresentation = true
        }
    }
    
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Home Loaded")
        
        
        //changes settingsButton image when button is clicked/highlighted
        settingsButton.setImage(UIImage(named: "icons8-settings-dark"), for: .highlighted)
        
        
    }
}
