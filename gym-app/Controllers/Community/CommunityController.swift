//
//  CommunityController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CommunityController: UIViewController {
    
    //MARK: Outlets
    
    //MARK: Attributes
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.view.alpha = 1
        })
        
        let lastView = self.view.superview?.subviews.last
        
        for thisView in self.view.superview!.subviews {
            
            if thisView != lastView {
                thisView.alpha = 0
            }
        }
        
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Community Loaded")
        
        self.view.alpha = 0
        
    }
}
