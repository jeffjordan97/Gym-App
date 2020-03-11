//
//  ViewController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 02/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import UIKit
import CoreData
import SOTabBar

class ViewController: SOTabBarController {
    
    //MARK: Outlets
    @IBOutlet weak var durationLabel: UITextView!
    @IBOutlet weak var typeLabel: UITextView!
    @IBOutlet weak var historyLabel: UITextView!
    
    @IBOutlet weak var durationInput: UITextField!
    
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
            } else {
                print("Core Data Empty")
            }
        } catch {
            print("Error retrieving core data: ",error)
        }
        
    }
    
    
    //MARK: Update Core Data
    func updateCoreData(date: Date, duration:Int, type:String){
       
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
    
    
    //MARK: Remove Core Data
    func removeCoreData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        //let entity = NSEntityDescription.entity(forEntityName: "WorkoutList", in: context!)
        
        do {
            let results = try context?.fetch(fetchRequest)
            if results!.count > 0 {
                for result in results as! [NSManagedObject] {
                    context?.delete(result)
                }
                do {
                    try context?.save()
                } catch {
                    print("Error updating context from delete:",error)
                }
            }
        } catch {
            print("Error fetching results: ",error)
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
    
    
    //MARK: Delete Button
    //deletes all data from core data
    @IBAction func deleteButton(_ sender: Any) {
        removeCoreData()
        print("...Core Data Emptied...")
    }
    
    
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarAnimationDurationTime = 0.3
        SOTabBarSetting.tabBarTintColor = #colorLiteral(red: 0.5530590781, green: 0.8335904475, blue: 0.9914795678, alpha: 1)
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        durationLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
//        typeLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
//        historyLabel.textContainerInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0);
        

        
        //Load Core Data
//        context = appDelegate.persistentContainer.viewContext
//        retrieveCoreData()
        
        
        
        
        
        //MARK: viewDidLoad: Tab bar
        let firstVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "Home")
        let secondVC = UIStoryboard(name: "Workouts", bundle: nil).instantiateViewController(withIdentifier: "Workouts")
        let thirdVC = UIStoryboard(name: "Progress", bundle: nil).instantiateViewController(withIdentifier: "Progress")
        let fourthVC = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "Community")
           
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "icons8-home"), selectedImage: UIImage(named: "icons8-home"))
        secondVC.tabBarItem = UITabBarItem(title: "Workout", image: UIImage(named: "icons8-workouts"), selectedImage: UIImage(named: "icons8-workouts"))
        thirdVC.tabBarItem = UITabBarItem(title: "Progress", image: UIImage(named: "icons8-progress"), selectedImage: UIImage(named: "icons8-progress"))
        fourthVC.tabBarItem = UITabBarItem(title: "Community", image: UIImage(named: "icons8-community"), selectedImage: UIImage(named: "icons8-community"))
        
        
        
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        
    }
}



