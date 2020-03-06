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
    

    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Home Loaded")
        
        
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        //dropDown.anchorView = typeDrop // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
        }

        // Will set a custom width instead of the anchor view width
        //dropDownLeft.width = 200
        
        //dropDown.show()
        
        
        
        
        
    }
}
