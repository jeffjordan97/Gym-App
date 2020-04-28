//
//  HomeController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import SOTabBar
import CoreData
import DropDown


class HomeController: UIViewController, isAbleToReceiveData {
    
    
    //MARK: Outlets
    @IBOutlet weak var primaryGoalView: UIView!
    
    @IBOutlet weak var workoutSummaryView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var workoutSummaryTable: UITableView!
    @IBOutlet weak var fadeBelowTable: UIView!
    
    
    //MARK: Attributes
    var allGoalProgress = [GoalProgress]()
    
    var allWorkoutSessions = [WorkoutSession]()
    var workoutSessionsThisWeek = [WorkoutSession]()
    var totalTimeThisWeek:Int = 0
    let workoutsHeadingNumberLabel = UILabel(frame: CGRect(x: 100, y: 50, width: 35, height: 40))
    let timeHeadingNumberLabel = UILabel(frame: CGRect(x: 100, y: 45, width: 100, height: 40))
    let noWorkoutsThisWeek = UIView(frame: CGRect(x: 10, y: 130, width: 394, height: 130))
    var totalWorkoutsThisWeek:Int = 0
    
    
    //delegate function to receive added workouts from AddWorkoutVC
    func pass(thisWorkout: WorkoutSession) {
        self.workoutSessionsThisWeek.append(thisWorkout)
        self.workoutSessionsThisWeek = self.workoutSessionsThisWeek.sorted(by: { $0.date! < $1.date! }).reversed()
        totalWorkoutsThisWeek = totalWorkoutsThisWeek + 1
        workoutsHeadingNumberLabel.text = "\(totalWorkoutsThisWeek)"
        totalTimeThisWeek = totalTimeThisWeek + thisWorkout.duration!
        timeHeadingNumberLabel.text = Helper.displayZeroInTime(Helper.secondsToHoursMinutesSeconds(seconds: totalTimeThisWeek))
        workoutSummaryTable.reloadData()
    }
    
    
    //function to pass info to AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddWorkout"){
            let addWorkoutVC = segue.destination as! AddWorkoutController
            print("toAddWorkout Segue...")
            addWorkoutVC.isModalInPresentation = true
            addWorkoutVC.delegate = self
        }
        if (segue.identifier == "toSettings"){
            let settingsVC = segue.destination as! SettingsController
            print("toSettings segue...")
            settingsVC.isModalInPresentation = true
        }
    }
    
    
    //MARK: Retrieve Core Data
    func retrieveCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressList")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            
            allGoalProgress.removeAll()
            
            for result in fetchedResults as! [NSManagedObject] {

                let goalProgress = result.value(forKey: "goalProgress") as! GoalProgress
                
                self.allGoalProgress.append(goalProgress)
            }
            if self.allGoalProgress.count > 1 {
                self.allGoalProgress = self.allGoalProgress.sorted(by: { $0.startDate! < $1.startDate! }).reversed()
            }
        } catch {
            print("Failed to Retrieve Core Data - 1")
        }
        
        
        let fetchRequestTwo = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        fetchRequestTwo.returnsObjectsAsFaults = false
        do {
            let fetchedResults = try managedContext.fetch(fetchRequestTwo)
            
            //resets values
            allWorkoutSessions.removeAll()
            totalTimeThisWeek = 0
            totalWorkoutsThisWeek = 0
            workoutSessionsThisWeek.removeAll()
            
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
    func workoutsThisWeek() {
        
        if self.allWorkoutSessions.count > 0 {
            
            let cal = NSCalendar.current
            var date = cal.startOfDay(for: Date())
            var lastSevenDates = [String]()
            lastSevenDates.append(Helper.getFormattedDate(Date()))
            for _ in 0...5 {
                date = cal.date(byAdding: Calendar.Component.day,value: -1, to: date)!
                lastSevenDates.append(Helper.getFormattedDate(date))
            }
            
            //loops through each workout and checks date, if the date is in the array of dates for the last 7 days
            for workout in allWorkoutSessions {
                
                let workoutDate = Helper.getFormattedDate(workout.date!)
                
                if lastSevenDates.contains(workoutDate){
                    workoutSessionsThisWeek.append(workout)
                    totalWorkoutsThisWeek = totalWorkoutsThisWeek + 1
                    totalTimeThisWeek = totalTimeThisWeek + workout.duration!
                    
                } else { break }
                
            }
            
        }
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
        
        workoutsHeadingNumberLabel.text = "\(totalWorkoutsThisWeek)"
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
    
    
    func noWorkoutsThisWeekView() {
        
        noWorkoutsThisWeek.backgroundColor = .white
        noWorkoutsThisWeek.layer.borderWidth = 2
        noWorkoutsThisWeek.layer.borderColor = UIColor.opaqueSeparator.cgColor
        noWorkoutsThisWeek.layer.cornerRadius = 10
        noWorkoutsThisWeek.layer.shadowRadius = 10
        noWorkoutsThisWeek.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        noWorkoutsThisWeek.layer.shadowOpacity = 1
        
        let noWorkoutsLabel = UILabel(frame: CGRect(x: 0, y: 45, width: 414, height: 30))
        noWorkoutsLabel.textAlignment = .center
        noWorkoutsLabel.text = "No Workouts This Week 😢"
        noWorkoutsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
       
        noWorkoutsThisWeek.addSubview(noWorkoutsLabel)
        
    }
    
    
    func noProgressToDisplay() -> UIView {
        
        let noProgressView = UIView(frame: CGRect(x: 20, y: 20, width: primaryGoalView.frame.width - 40, height: 200))

        noProgressView.backgroundColor = .white
        noProgressView.layer.cornerRadius = 10
        noProgressView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        noProgressView.layer.borderWidth = 2
        noProgressView.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        noProgressView.layer.shadowRadius = 10
        noProgressView.layer.shadowOpacity = 1
        
        let noProgressLabel = UILabel(frame: CGRect(x: 0, y: 85, width: noProgressView.frame.width, height: 30))
        noProgressLabel.text = "No Goals Active 😢"
        noProgressLabel.textAlignment = .center
        noProgressLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        
        noProgressView.addSubview(noProgressLabel)
        
        return noProgressView
    }
    
    
    //MARK: viewDidAppear
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
        
        
        //MARK: Progress Goal View
        //removes all previous views from primaryGoalView (to prevent layering)
        for subView in primaryGoalView.subviews {
            subView.removeFromSuperview()
        }
        
        if !allGoalProgress.isEmpty {
            var displayGoal: GoalProgress?
            for goal in allGoalProgress {
                
                if goal.endDate! > Date() {
                    
                    //assigns displayGoal to the goal if it is the primary goal, else compares the rating and uses the highest rating goal
                    if goal.primaryGoal! {
                        displayGoal = goal
                        break
                    } else if displayGoal == nil || goal.rating! > displayGoal?.rating ?? -1 {
                        displayGoal = goal
                    }
                    
                } else { break }
            }
            
            if displayGoal != nil {
                let displayGoalView = Helper.createGoalView(view, displayGoal!, allWorkoutSessions)
                
                //adjusts frame to higher y position, at the top of primaryGoalView
                displayGoalView.frame = CGRect(x: displayGoalView.frame.minX, y: 0, width: displayGoalView.frame.width, height: displayGoalView.frame.height)
                
                primaryGoalView.addSubview(displayGoalView)
                
            } else {
                primaryGoalView.addSubview(noProgressToDisplay())
            }
            
        } else {
            primaryGoalView.addSubview(noProgressToDisplay())
        }
        
        
        
        //MARK: Workout Summary View
        //removes all previous views from Workout Summary View (to prevent layering)
        
        workoutSummaryView.addSubview(workoutsHeadingView())
        
        workoutSummaryView.addSubview(timeHeadingView())
        
        noWorkoutsThisWeekView()
        workoutSummaryView.addSubview(noWorkoutsThisWeek)
        
    }
    
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        print("Home")
        
        
        retrieveCoreData()
        workoutsThisWeek()
        
        if workoutSessionsThisWeek.isEmpty {
            noWorkoutsThisWeek.isHidden = false
            workoutSummaryTable.isHidden = true
            fadeBelowTable.isHidden = true
        } else {
            noWorkoutsThisWeek.isHidden = true
            workoutSummaryTable.isHidden = false
            workoutSummaryTable.reloadData()
            if workoutSessionsThisWeek.count > 3 {
                fadeBelowTable.isHidden = false
            }
        }
        
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Home Loaded")
        
        self.view.alpha = 0
        
        workoutSummaryTable.dataSource = self
        workoutSummaryTable.delegate = self
        
        
        if totalWorkoutsThisWeek == 0 {
            workoutSummaryTable.isHidden = true
        } else {
            workoutSummaryTable.isHidden = false
        }
        
        //changes settingsButton image when button is clicked/highlighted
        settingsButton.setImage(UIImage(named: "icons8-settings-dark"), for: .highlighted)
        
        Helper.setGradientBackground(colourOne: UIColor.clear, colourTwo: UIColor.white, view: fadeBelowTable)
    }
    
}

//MARK: Table View
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalWorkoutsThisWeek
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
