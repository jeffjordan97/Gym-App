//
//  ViewController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 02/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    

    @IBOutlet weak var durationLabel: UITextView!
    @IBOutlet weak var typeLabel: UITextView!
    @IBOutlet weak var historyLabel: UITextView!
    
    @IBOutlet weak var durationInput: UITextField!
    @IBOutlet weak var typeInput: DropDown!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    func getDate() -> String {
        //gets current date and time
        let currentDateTime = Date()
        
        //gets the date String of the date object
        let format = DateFormatter()
        format.dateStyle = .medium
        
        //gets the date String from the date object
        let dateString = format.string(from: currentDateTime)
        
        return dateString
    }
    
    
    func addCoreData(date: String, duration:Int, type:String ){
        //refer to container set up in the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        //create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //crete an entity and new user records
        let workoutEntity = NSEntityDescription.entity(forEntityName: "WorkoutList", in: managedContext)!
        
        //adding some data to newly created record for each keys
        let user = NSManagedObject(entity: workoutEntity, insertInto: managedContext)
        user.setValue(date, forKey: "date")
        user.setValue(String(duration), forKey: "duration")
        user.setValue(type, forKey: "type")
        
        
        //now all values have been set, next step is to save inside Core Data
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveCoreData(){
        //https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        durationLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        typeLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        historyLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        
        // The list of array to display. Can be changed dynamically
        typeInput.optionArray = ["Weights", "Cardio", "Circuits"]
        

        
        // The the Closure returns Selected Index and String
        typeInput.didSelect{(selectedText , index ,id) in
        self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index) \n id: \(id)"
        }
    }
}



