//
//  AddWorkoutController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import DropDown

class AddWorkoutController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var woTypeView: UIView!
    
    @IBOutlet weak var woTypeLabel: UILabel!
    
    
    
    //MARK: Attributes
    
    
    //To show dropdown for user to select workout type
    @IBAction func woTypeButton(_ sender: Any) {
        
        woTypeLabel.isHidden = true
        
        let typeDropDown = DropDown()
        
        // The list of items to display. Can be changed dynamically
        typeDropDown.dataSource = ["Weights", "Cardio", "Circuits"]
        
        // The view to which the drop down will appear on
        typeDropDown.anchorView = woTypeView // UIView or UIBarButtonItem
        
        // Action triggered on selection
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.woTypeLabel.isHidden = false
            self.woTypeLabel.text = item
            self.woTypeLabel.textColor = .black
            self.woTypeLabel.font = self.woTypeLabel.font.withSize(22.0)
        }
        
        typeDropDown.show()
    }
    
    
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("AddWorkout Loaded")
        
    }
}
