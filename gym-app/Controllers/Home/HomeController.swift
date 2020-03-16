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
    
    
    
    
    //MARK: Attributes
    
    
    @IBAction func settingsButton(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.05, animations: {
//               sender.alpha = 0.0
//           }, completion:{(finished) in
//            sender.setImage(UIImage(named: "icons8-settings-dark"), for: .normal)
//            UIView.animate(withDuration: 0.05,animations:{
//               sender.alpha = 1.0
//               },completion:nil)
//        })
    }
    
    
    
    
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
        
        
       

        
        
        
        

        // Will set a custom width instead of the anchor view width
        //dropDownLeft.width = 200
        
        //
        
        
        
        
        
    }
}
