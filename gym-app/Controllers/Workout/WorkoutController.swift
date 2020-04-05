//
//  WorkoutController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class WorkoutController: UIViewController, isAbleToReceiveData {
    
    //MARK: Outlets
    @IBOutlet weak var workoutsTable: UITableView!
    @IBOutlet weak var noWorkoutsView: UIView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    //MARK: Attributes
    var allWorkoutSessions = [WorkoutSession]()
    
    
    //function to pass info to AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddWorkout"){
            let addWorkoutVC = segue.destination as! AddWorkoutController
            print("toAddWorkout Segue...")
            addWorkoutVC.isModalInPresentation = true
            addWorkoutVC.delegate = self
        }
        
        if (segue.identifier == "toCalendar"){
            let calenderVC = segue.destination as! CalendarController
            print("toCalendar Segue...")
            calenderVC.isModalInPresentation = true
            calenderVC.allWorkoutSessions = self.allWorkoutSessions
        }
        
        if (segue.identifier == "toSettings"){
            let settingsVC = segue.destination as! SettingsController
            print("toSettings segue...")
            settingsVC.isModalInPresentation = true
            clearCoreData()
        }
    }
    
    
    
    
    
    
    //implements protocol to get data from AddWorkout
    func pass(thisWorkout: WorkoutSession) {
        self.allWorkoutSessions.append(thisWorkout)
        self.allWorkoutSessions = self.allWorkoutSessions.sorted(by: { $0.date! < $1.date! }).reversed()
        self.noWorkoutsView.isHidden = true
        self.workoutsTable.isHidden = false
        self.workoutsTable.reloadData()
    }
    
    
    func retrieveCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            for result in fetchedResults as! [NSManagedObject] {

                let workoutSession = result.value(forKey: "workoutSession") as! WorkoutSession
                
                self.allWorkoutSessions.append(workoutSession)
            }
            if self.allWorkoutSessions.count > 0 {
                
                self.allWorkoutSessions = self.allWorkoutSessions.sorted(by: { $0.date! < $1.date! }).reversed()
                
            }
            
            checkCoreDataIsEmpty()
            
        } catch {
            print("Failed to Retrieve Core Data")
        }
    }
    
    
    func checkCoreDataIsEmpty(){
        if allWorkoutSessions.count == 0 {
            workoutsTable.isHidden = true
            addStylesToNoWorkoutView()
            
        } else {
            noWorkoutsView.isHidden = true
            workoutsTable.isHidden = false
        }
    }
    
    
    func clearCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    managedContext.delete(result)
                }
                do {
                    try managedContext.save()
                    print("Removed ALL core data")
                    self.allWorkoutSessions.removeAll()
                    self.workoutsTable.reloadData()
                    workoutsTable.isHidden = true
                    addStylesToNoWorkoutView()
                    noWorkoutsView.isHidden = false
                } catch {
                    print("Error saving context from delete: ", error)
                }
            }
        } catch {
            print("Error fetching results: ",error)
        }
        
    }
    
    
    func addStylesToNoWorkoutView() {
        noWorkoutsView.layer.borderWidth = 1
        noWorkoutsView.layer.borderColor = UIColor.lightGray.cgColor
        noWorkoutsView.layer.cornerRadius = 20
        let label = noWorkoutsView.subviews.first as? UILabel
        label?.text = "No Workout History 😢"
    }
    
    
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
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Workout Loaded")
        
        
        workoutsTable.delegate = self
        workoutsTable.register(UITableViewCell.self, forCellReuseIdentifier: "WorkoutTableInfoCell")
        
        
        //LOAD CORE DATA
        retrieveCoreData()
        
        
        //changes settingsButton image when button is clicked/highlighted
        settingsButton.setImage(UIImage(named: "icons8-settings-dark"), for: .highlighted)
        
        //changes calendarButton image when button is clicked/highlighted
        calendarButton.setImage(UIImage(named: "icons8-calendar-100 filled"), for: .highlighted)
        
        
    }
}


//extension for tableview of workouts
extension WorkoutController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allWorkoutSessions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allWorkoutSessions[section].workoutExercises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        workoutsTable.rowHeight = 80
        
        let thisWorkout = allWorkoutSessions[section]
        
        let headerCell = Bundle.main.loadNibNamed("WorkoutTableHeaderCell", owner: self, options: nil)?.first as! WorkoutTableHeaderCell
        
        
        headerCell.setImage(type: thisWorkout.type!)
        headerCell.typeLabel.text = thisWorkout.type!
        headerCell.dateLabel.text = getFormattedDate(thisWorkout.date!)
        headerCell.durationLabel.text = "\(thisWorkout.duration!) mins"
        
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        workoutsTable.rowHeight = 40
        
        let thisWorkout = allWorkoutSessions[indexPath.section]
        
        let cell = Bundle.main.loadNibNamed("WorkoutTableInfoCell", owner: self, options: nil)?.first as! WorkoutTableInfoCell
        let exerciseName = thisWorkout.workoutExercises?[indexPath.row].exerciseName
        let exerciseInfo = thisWorkout.workoutExercises?[indexPath.row].exerciseInfo
        let exerciseSets = thisWorkout.workoutExercises?[indexPath.row].exerciseSets
        let numberOfSets = thisWorkout.workoutExercises?[indexPath.row].exerciseSets?.count

        
        cell.exerciseNameLabel.text = exerciseName
        cell.exerciseSetsLabel.text = "\(numberOfSets!)"
        
        if exerciseInfo == "Weights" || exerciseInfo == "Bodyweight" {
            cell.exerciseRepsOrTimeLabel.text = returnRepsRange(exerciseSets!)
            
        } else if exerciseInfo == "Cardio" || exerciseInfo == "Circuits" {
            cell.exerciseRepsOrTimeLabel.text = returnBestTime(exerciseSets!)
            
        }
        
        return cell
    }
    
    //returns the minimum and maximum reps from the exercise
    func returnRepsRange(_ sets: [SetRepsWeights]) -> String {
        
        var minReps = 10000
        var maxReps = 0
        for i in 0...sets.count-1 {
            
            if(sets[i].reps! < minReps) { minReps = sets[i].reps!}
            if(sets[i].reps! > maxReps) { maxReps = sets[i].reps!}
            
        }
        
        if minReps == maxReps {
            return "\(minReps)"
        } else {
            return "\(minReps) - \(maxReps)"
        }
        
    }
    
    
    func returnBestTime(_ sets: [SetRepsWeights]) -> String {
        var bestTime =  10000.0
        
        for i in 0...sets.count-1 {
            if (sets[i].time! < bestTime) { bestTime = sets[i].time! }
        }
        
        return "\(bestTime) mins"
    }
    
    //functionality when row is clicked - MODAL?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    
}
