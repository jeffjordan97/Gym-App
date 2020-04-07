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


class HomeController: UIViewController, isAbleToReceiveData {
    
    //MARK: Outlets
    @IBOutlet weak var workoutSummaryView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var workoutSummaryTable: UITableView!
    
    
    //MARK: Attributes
    var allWorkoutSessions = [WorkoutSession]()
    var workoutSessionsThisWeek = [WorkoutSession]()
    var totalTimeThisWeek:Int = 0
    let workoutsHeadingNumberLabel = UILabel(frame: CGRect(x: 100, y: 50, width: 35, height: 40))
    let timeHeadingNumberLabel = UILabel(frame: CGRect(x: 100, y: 45, width: 100, height: 40))
    
    
    //delegate function to receive added workouts from AddWorkoutVC
    func pass(thisWorkout: WorkoutSession) {
        self.allWorkoutSessions.append(thisWorkout)
        self.allWorkoutSessions = self.allWorkoutSessions.sorted(by: { $0.date! < $1.date! }).reversed()
        //workoutSummaryTable.reloadData()
    }
    
    
    //function to pass info to AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddWorkout"){
            let addWorkoutVC = segue.destination as! AddWorkoutController
            print("toAddWorkout Segue...")
            addWorkoutVC.isModalInPresentation = true
        }
    }
    
    
    //MARK: Retrieve Core Data
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
            print("Core Data is Empty")
            
        } else {
            print("Core Data Loaded")
        }
    }
    
    //MARK: Workouts This Week
    //gets a list of the previous 7 days and checks how many of the dates are in allWorkoutSessions
    func workoutsThisWeek() -> Int {
        var totalWorkoutsThisWeek:Int = 0
        
        if self.allWorkoutSessions.count > 0 {
            
            let cal = NSCalendar.current
            var date = cal.startOfDay(for: Date())
            
            var arrDates = [String]()
            
            for _ in 1...7 {
                date = cal.date(byAdding: Calendar.Component.day,value: -1, to: date)!
                arrDates.append(Helper.getFormattedDate(date))
            }
            
            //loops through each workout and checks date, if the date is in the array of dates for the last 7 days
            for workout in allWorkoutSessions {
                
                let workoutDate = Helper.getFormattedDate(workout.date!)
                
                if arrDates.contains(workoutDate){
                    workoutSessionsThisWeek.append(workout)
                    totalWorkoutsThisWeek = totalWorkoutsThisWeek + 1
                    totalTimeThisWeek = totalTimeThisWeek + workout.duration!
                } else { break }
                
            }
            print("TotalWorkoutsThisWeek = \(totalWorkoutsThisWeek)")
            
            
        }
        
        return totalWorkoutsThisWeek
    }
    
    
    func workoutsHeadingView() -> UIView {
        let width = (workoutSummaryView.frame.width/2) + 3.0
        let workoutsHeadingView = UIView(frame: CGRect(x: -2, y: 0, width: width, height: 120))
        
        workoutsHeadingView.layer.borderWidth = 2
        workoutsHeadingView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let weightImage = UIImage(named: "icons8-barbell-100")
        let weightImageView = UIImageView(image: weightImage)
        weightImageView.frame = CGRect(x: 20, y: 0, width: 60, height: 60)
        weightImageView.center.y = workoutsHeadingView.center.y
        workoutsHeadingView.addSubview(weightImageView)
        
        
        let workoutsHeadingLabel = UILabel(frame: CGRect(x: 100, y: 20, width: 100, height: 20))
        workoutsHeadingLabel.textAlignment = .left
        workoutsHeadingLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        workoutsHeadingLabel.text = "Workouts"
        workoutsHeadingView.addSubview(workoutsHeadingLabel)
        
        
        workoutsHeadingNumberLabel.text = "\(workoutsThisWeek())"
        workoutsHeadingNumberLabel.font = UIFont(name: "HelveticaNeue", size: 30.0)
        workoutsHeadingView.addSubview(workoutsHeadingNumberLabel)
        
        
        let workoutsHeadingTextLabel = UILabel(frame: CGRect(x: 135, y: 50, width: 75, height: 40))
        workoutsHeadingTextLabel.textAlignment = .left
        workoutsHeadingTextLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        workoutsHeadingTextLabel.numberOfLines = 2
        workoutsHeadingTextLabel.text = """
        in the last
        7 days
        """
        workoutsHeadingView.addSubview(workoutsHeadingTextLabel)
        
        
        return workoutsHeadingView
    }
    
    func timeHeadingView() -> UIView {
        let timeHeadingView = UIView(frame: CGRect(x: (workoutSummaryView.frame.width/2) - 2, y: 0, width: workoutSummaryView.frame.width/2 + 4.0, height: 120))
        
        timeHeadingView.layer.borderWidth = 2
        timeHeadingView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let timeImage = UIImage(named: "icons8-timer-100")
        let timeImageView = UIImageView(image: timeImage)
        timeImageView.frame = CGRect(x: 20, y: 0, width: 60, height: 60)
        timeImageView.center.y = timeHeadingView.center.y
        timeHeadingView.addSubview(timeImageView)
        
        
        let timeHeadingLabel = UILabel(frame: CGRect(x: 100, y: 20, width: 100, height: 20))
        timeHeadingLabel.textAlignment = .left
        timeHeadingLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        timeHeadingLabel.text = "Total Time"
        timeHeadingView.addSubview(timeHeadingLabel)
        
        
        let formattedDuration = Helper.secondsToHoursMinutesSeconds(seconds: totalTimeThisWeek)
        timeHeadingNumberLabel.text = Helper.displayZeroInTime(formattedDuration)
        timeHeadingNumberLabel.font = UIFont(name: "HelveticaNeue", size: 24.0)
        timeHeadingView.addSubview(timeHeadingNumberLabel)
        
        
        
        return timeHeadingView
    }
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        workoutSummaryView.addSubview(workoutsHeadingView())
        
        workoutSummaryView.addSubview(timeHeadingView())
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Home Loaded")
        
        retrieveCoreData()
        
        workoutSummaryTable.dataSource = self
        workoutSummaryTable.delegate = self
        
        //changes settingsButton image when button is clicked/highlighted
        settingsButton.setImage(UIImage(named: "icons8-settings-dark"), for: .highlighted)
        
        
    }
}

//MARK: Table View
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         
        
        return workoutsThisWeek()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
        
        let thisWorkout = workoutSessionsThisWeek[indexPath.row]
        
        let thisWorkoutFormattedDate = Helper.getFormattedDate(thisWorkout.date!)
        let thisWorkoutFormattedDuration = Helper.secondsToHoursMinutesSeconds(seconds: thisWorkout.duration!)
        
        cell.setLabels(thisWorkoutFormattedDate, thisWorkout.type!, Helper.displayZeroInTime(thisWorkoutFormattedDuration))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = .white
    }
    
    
}
