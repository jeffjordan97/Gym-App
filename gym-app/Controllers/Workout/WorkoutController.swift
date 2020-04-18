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
import MaterialComponents.MaterialButtons


class WorkoutController: UIViewController, isAbleToReceiveData {
    
    //MARK: Outlets
    @IBOutlet weak var workoutsTable: UITableView!
    @IBOutlet weak var noWorkoutsView: UIView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    //MARK: Attributes
    var allWorkoutSessions = [WorkoutSession]()
    
    
    //implements protocol to get data from AddWorkout
    func pass(thisWorkout: WorkoutSession) {
        self.allWorkoutSessions.append(thisWorkout)
        self.allWorkoutSessions = self.allWorkoutSessions.sorted(by: { $0.date! < $1.date! }).reversed()
        self.noWorkoutsView.isHidden = true
        self.workoutsTable.isHidden = false
        self.workoutsTable.reloadData()
    }
    
    
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
            //clearCoreData()
        }
    }
    
    
    //retrieves previously recorded workouts from core data and adds to addWorkoutSessions
    func retrieveCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            allWorkoutSessions.removeAll()
            
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
        noWorkoutsView.layer.shadowOpacity = 1
        noWorkoutsView.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        noWorkoutsView.layer.shadowRadius = 10
        let label = noWorkoutsView.subviews.first as? UILabel
        label?.text = "No Workout History 😢"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("Workout")
        
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.view.alpha = 1
        })
        
        let lastView = self.view.superview?.subviews.last
        
        for thisView in self.view.superview!.subviews {
            
            if thisView != lastView {
                thisView.alpha = 0
            }
        }
        
        retrieveCoreData()
        workoutsTable.reloadData()
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Workout Loaded")
        
        self.view.alpha = 0
        
        workoutsTable.delegate = self
        workoutsTable.register(UITableViewCell.self, forCellReuseIdentifier: "WorkoutTableInfoCell")
        
        
        //LOAD CORE DATA
        //retrieveCoreData()
        
        
        //changes settingsButton image when button is clicked/highlighted
        settingsButton.setImage(UIImage(named: "icons8-settings-dark"), for: .highlighted)
        
        //changes calendarButton image when button is clicked/highlighted
        let calendarButtonImage = UIImage(named: "icons8-calendar-100")
        calendarButton.setImage(calendarButtonImage, for: .normal)
        let calendarButtonClickedImage = UIImage(named: "icons8-calendar-100 filled")
        calendarButton.setImage(calendarButtonClickedImage, for: .highlighted)
        
        
    }
}


//MARK: Table View
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
        headerCell.dateLabel.text = Helper.getFormattedDate(thisWorkout.date!)
        let formattedDuration = Helper.secondsToHoursMinutesSeconds(seconds: thisWorkout.duration!)
        headerCell.durationLabel.text = Helper.displayZeroInTime(formattedDuration)
        
        
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

        //adds exercise name and set info to the cell row
        cell.exerciseNameLabel.text = exerciseName
        cell.exerciseSummaryLabel.text = "\(numberOfSets!) x "
        
        if exerciseInfo == "Weights" || exerciseInfo == "Bodyweight" {
            cell.exerciseSummaryLabel.text?.append(contentsOf: returnRepsRange(exerciseSets!))
            
        } else if exerciseInfo == "Cardio" || exerciseInfo == "Circuits" {
            let formattedTime = returnBestTime(exerciseSets!)
            cell.exerciseSummaryLabel.text?.append(contentsOf: Helper.displayZeroInTime(formattedTime))
            
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
            return "\(minReps)kg"
        } else {
            return "\(minReps)kg - \(maxReps)kg"
        }
        
    }
    
    //returns the best time from all sets, in the format Hour:Min:Seconds
    func returnBestTime(_ sets: [SetRepsWeights]) -> (Int, Int, Int) {
        var bestTime =  100000
        
        for i in 0...sets.count-1 {
            if (sets[i].time! < bestTime) { bestTime = sets[i].time! }
        }
        
        if bestTime != 100000 {
            let splitTime = secondsToHoursMinutesSeconds(seconds: bestTime)
            return splitTime
        
        } else { return (0,0,0 ) }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //functionality when row is clicked - MODAL?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    
}
