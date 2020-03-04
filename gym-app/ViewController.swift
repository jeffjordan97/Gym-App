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
    
    //MARK: Outlets
    @IBOutlet weak var durationLabel: UITextView!
    @IBOutlet weak var typeLabel: UITextView!
    @IBOutlet weak var historyLabel: UITextView!
    
    @IBOutlet weak var durationInput: UITextField!
    @IBOutlet weak var typeInput: DropDown!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    //MARK: Attributes
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    
    var duration: Int = 0
    var activityType: String = ""
    var dateToday = Date()
    
    
    
    //MARK: Formatted Date
    //returns today's date in the format: Month Day, Year
    func getFormattedDate(_ thisDate: Date) -> String {
        
        //gets the date String of the date object
        let format = DateFormatter()
        format.dateStyle = .medium
        
        //gets the date String from the date object
        let dateString = format.string(from: thisDate)
        
        return dateString
    }
    
    
    //MARK: Retrieve Core Data
    func retrieveCoreData(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(request)
            if results!.count > 0 {
                //iterate through array to get value for specific key
                for result in results as! [NSManagedObject] {
                    
                    if let date = result.value(forKey: "date") as? Date {
                        print("CoreData: Date = "+getFormattedDate(date))
                    }
                    
                    if let duration = result.value(forKey: "duration") as? Int {
                        print("CoreData: Duration = ",duration)
                    }
                    
                    if let type = result.value(forKey: "type") as? String {
                        print("CoreData: Type = "+type)
                    }
                }
            }
        } catch {
            print("Error retrieving core data: ",error)
        }
        
    }
    
    
    //MARK: Update Core Data
    func updateCoreData(date: Date, duration:Int, type:String ){
       
        if duration != 0 && type != "" {
            let entity = NSEntityDescription.entity(forEntityName: "WorkoutList", in: context!)
            let newWorkout = NSManagedObject(entity: entity!, insertInto: context)
            newWorkout.setValue(date, forKey: "date")
            newWorkout.setValue(duration, forKey: "duration")
            newWorkout.setValue(type, forKey: "type")
            
            //objects added to context are saved to persistent store
            do {
                try context!.save()
                print("Saved to persistent store")
            } catch {
                print("Failed to save to persistent store",error)
            }
        }
        
    }
    
    
    //MARK: Add Button
    @IBAction func addButton(_ sender: Any) {
        
        if durationInput.text != "" {
            duration = Int(durationInput.text!)!
        } else {
            duration = 0
        }
        
        if activityType == "" {
            activityType = "No Type Entered"
        }
        
        let formatDate = getFormattedDate(dateToday)
        valueLabel.text = "Date: "+formatDate+"\n Duration: "+String(duration)+"\n Type: "+activityType
        
        updateCoreData(date: dateToday, duration: duration, type: activityType)
        
    }
    
    
    
    
    
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        durationLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        typeLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        historyLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        
        // The list of array to display. Can be changed dynamically
        typeInput.optionArray = ["Weights", "Cardio", "Circuits"]
        

        
        //Load Core Data
        context = appDelegate.persistentContainer.viewContext
        retrieveCoreData()
        
        
        //MARK: DropDown Types
        // The list of array to display. Can be changed dynamically
        typeInput.optionArray = ["Weights", "Cardio", "Circuits"]
        
        // The the Closure returns Selected Index and String
        typeInput.didSelect{(selectedText , index ,id) in
        self.activityType = selectedText
        }
         
    }
}



