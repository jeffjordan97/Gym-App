//
//  NotesViewController.swift
//  gym-app
//
//  Created by Jeff Jordan on 16/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    
    
    //MARK: Outlets
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    
    //MARK: Attributes
    var textViewText: String?
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        outerView.layer.cornerRadius = 40
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Notes Loaded")
        
        textView.text = textViewText
        
        
    }
}
