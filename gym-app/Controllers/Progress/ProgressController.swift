//
//  ProgressController.swift
//  gym-app
//
//  Created by Jordan, Jeffrey on 05/03/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProgressController: UIViewController, passBackToProgress {
    
    
    
    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noGoalsView: UIView!
    
    
    //MARK: Attributes
    var allGoalProgress = [GoalProgress]()
    var allWorkoutSessions = [WorkoutSession]()
    
    //function to pass info to AddWorkoutController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAddGoal"){
            let addGoalVC = segue.destination as! AddGoalController
            print("toAddGoal Segue...")
            addGoalVC.isModalInPresentation = true
            addGoalVC.delegate = self
        }
        if (segue.identifier == "toSettings"){
            let settingsVC = segue.destination as! SettingsController
            print("toSettings Segue...")
            settingsVC.isModalInPresentation = true
            
            //testing to clear core data
            clearCoreData()
        }
    }
    
    
    //handle data passed from delegate here...
    func dataToPass(_ goalProgress: GoalProgress) {
        print("...Goal Passed to ProgressVC")
        
        //delegate passed backward...
        //need to update the value of primaryGoal to false for every goalProgress in [goalProgress] before the new goalProgress is appended
        if goalProgress.primaryGoal! {
            for thisGoalProgess in allGoalProgress {
                thisGoalProgess.primaryGoal = false
            }
        }
        
        //inserts as the first element, as ordered in terms of start date from recent to later
        allGoalProgress.insert(goalProgress, at: 0)
        
        
        //create view to add to scrollView based on the type of goal added
        if goalProgress.type == "Build Muscle" || goalProgress.type == "Lose Weight" {
            print("Create View: with weights")
        } else {
            print("Create View: without weights")
        }
        
        
        //adjust y position of all subviews in scrollView to move them down
        
        
        //adjusts the 'scroll' size of the scrollView according to the height of the new view
        //scrollView.contentSize = CGSize(width: scrollView.frame.width, height: <#T##CGFloat#>)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //fades opacity of the view controller's view
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.view.alpha = 1
        })
        
        //last view in the superview is this current view
        let lastView = self.view.superview?.subviews.last
        
        //change opacity of other views behind this current view so fade in animation is seen
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
        
        print("Progress Loaded")
        
        //to fade view when clicked, in the viewDidAppear
        self.view.alpha = 0
        
        noGoalsView.layer.borderWidth = 2
        noGoalsView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        noGoalsView.layer.cornerRadius = 20
        
        retrieveCoreData()
        checkCoreDataIsEmpty()
        
        //creates views for each goal added, adds them to scrollView, then adjusts scrollView contentSize to enable scrolling if content is greater than scrollView height
        if !allGoalProgress.isEmpty {
            var totalGoalViewHeight:CGFloat = 0.0
            var endedGoals = [UIView]()
            var finishedFlag = false
            
            for goal in allGoalProgress {
                
                //if the goal endDate is greater than the current date, add, else add to endedGoals array
                if goal.endDate! > Date() {
                    let goalView = createGoalView(goal)
                    totalGoalViewHeight = totalGoalViewHeight + goalView.frame.height
                    
                    //adjust y position of goalView to appear below the previosly added goalView
                    
                    
                    scrollView.addSubview(goalView)
                    
                } else {
                    //accessed once to add in a view that cuts off the in progress goals from the finished goals
                    if !finishedFlag {
                        let finishedDividerView = finishedGoalsDivider()
                        scrollView.addSubview(finishedDividerView)
                        finishedFlag = true
                        totalGoalViewHeight = totalGoalViewHeight + finishedDividerView.frame.height
                    }
                    
                    let endedGoalView = createGoalView(goal)
                    totalGoalViewHeight = totalGoalViewHeight + endedGoalView.frame.height
                    
                    //adjust y position of endedGoalView to appear below previously added goal view
                    
                    
                    endedGoals.append(endedGoalView)
                }
                
                
            }
            
            
            
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalGoalViewHeight)
        }
        
        
    }
}


//MARK: Goal Views
extension ProgressController {
    
    //creates finished divider to separate in progress goals from finished goals
    func finishedGoalsDivider() -> UIView {
        let finishedDividerView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 30))
        
        finishedDividerView.backgroundColor = .opaqueSeparator
        
        let finishedDividerLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 20))
        finishedDividerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        finishedDividerLabel.textColor = .white
        
        finishedDividerView.addSubview(finishedDividerLabel)
        
        return finishedDividerView
    }
    
    //creates the outer view for a goal
    func createGoalView(_ goalProgress: GoalProgress) -> UIView {
        let goalView = UIView(frame: CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: 260))
        
        goalView.backgroundColor = .white
        goalView.layer.borderWidth = 2
        goalView.layer.borderColor = UIColor.black.cgColor
        goalView.layer.cornerRadius = 20
        
        
        let setTypeImage = getTypeImage(goalProgress.type!)
        goalView.addSubview(setTypeImage)
        
        let setTitle = getTypeTitle(goalProgress.type!)
        goalView.addSubview(setTitle)
        
        let setDaysLeft = getDaysLeft(goalProgress.startDate!, goalProgress.endDate!)
        goalView.addSubview(setDaysLeft)
        
        let setStartEndDate = getStartEndDates(goalProgress.startDate!, goalProgress.endDate!)
        goalView.addSubview(setStartEndDate)
        
        let setProgressView = getProgressBar(goalProgress)
        goalView.addSubview(setProgressView)
        
        return goalView
    }
    
    //returns a UIImage for the correct goal type
    func getTypeImage(_ type:String) -> UIImageView {
        var typeImage = UIImage(named: "icons8-running-100")
        
        if type == "Lose Weight" {
            typeImage = UIImage(named: "icons8-lose-weight-100")
        } else if type == "Build Muscle" {
            typeImage = UIImage(named: "icons8-muscle-100")
        } else if type == "Improve Strength" {
            typeImage = UIImage(named: "icons8-strength-100")
        }
        
        let returnImageView = UIImageView(image: typeImage)
        returnImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        
        return returnImageView
    }
    
    //returns a UILabel with the goal type
    func getTypeTitle(_ type:String) -> UILabel {
        let typeTitleLabel = UILabel(frame: CGRect(x: 80, y: 25, width: 250, height: 30))
        
        typeTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        typeTitleLabel.textColor = .black
        typeTitleLabel.text = type
        //typeTitleLabel.backgroundColor = .orange
        
        
        return typeTitleLabel
    }
    
    //returns a UIView of the number of days/hours left to complete their goal
    func getDaysLeft(_ startDate:Date, _ endDate:Date) -> UIView {
        let returnView = UIView(frame: CGRect(x: 10, y: 60, width: 130, height: 60))
        var daysOrHoursDifference: Int = 0
        var daysOrHoursString: String = "days"
        
        //returnView.backgroundColor = .purple
        
        //works out the number of days between two dates
        daysOrHoursDifference = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        
        if daysOrHoursDifference <= 0 {
            
            //if number of days between is 0, work out the number of hours between the two dates, adjusting the corresponding string
            daysOrHoursDifference = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
            daysOrHoursString = "hours"
            
        } else if daysOrHoursDifference == 1 {
            daysOrHoursString = "day"
        }
        
        
        let daysLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        daysLabel.text = "\(daysOrHoursDifference)"
        daysLabel.font = UIFont(name: "HelveticaNeue", size: 30.0)
        daysLabel.textAlignment = .right
        
        returnView.addSubview(daysLabel)
        
        
        let daysTextLabel = UILabel(frame: CGRect(x: 70, y: 0, width: 60, height: 60))
        daysTextLabel.text = """
        \(daysOrHoursString)
        left
        """
        daysTextLabel.numberOfLines = 2
        daysTextLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        daysTextLabel.textAlignment = .left
        
        returnView.addSubview(daysTextLabel)
        
        
        return returnView
    }
    
    //returns a view with the start and end dates of the goalProgress
    func getStartEndDates(_ startDate:Date, _ endDate:Date) -> UIView {
        let returnView = UIView(frame: CGRect(x: 150, y: 68, width: 190, height: 42))
        
        //returnView.backgroundColor = .orange
        
        let startDateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 20))
        startDateLabel.text = "Start: " + Helper.getFormattedDate(startDate)
        startDateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        returnView.addSubview(startDateLabel)
        
        
        let endDateLabel = UILabel(frame: CGRect(x: 0, y: 24, width: 180, height: 20))
        endDateLabel.text = "End:  " + Helper.getFormattedDate(endDate)
        endDateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        returnView.addSubview(endDateLabel)
        
        return returnView
    }
    
    //returns a progress bar view for the current goal
    func getProgressBar(_ goalProgress: GoalProgress) -> UIView{
        let progressView = UIView(frame: CGRect(x: 0, y: 110, width: scrollView.frame.width - 40, height: 100))
        
        progressView.backgroundColor = .green
        
        //progress bar
        let progressBarPercentage = Helper.getProgressForWeights(goalProgress: goalProgress, allWorkoutSessions: allWorkoutSessions)
        print("Progress: \(progressBarPercentage)")
        
        //type label
        
        //start label
        
        //current label
        
        //goal label
        
        //button to update weight if goalType is 'lose weight' or 'build muscle'
        
        return progressView
    }
    
    
}



//MARK: Core Data
extension ProgressController {
    
    //retrieves previously recorded workouts and goals from core data and adds to allWorkoutSessions and allGoalProgress respectively
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
        
        let secondFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutList")
        secondFetchRequest.returnsObjectsAsFaults = false
        do {
            let fetchedResultsTwo = try managedContext.fetch(secondFetchRequest)
            
            allWorkoutSessions.removeAll()
            
            for result in fetchedResultsTwo as! [NSManagedObject] {
                
                let workoutSession = result.value(forKey: "workoutSession") as! WorkoutSession
                
                self.allWorkoutSessions.append(workoutSession)
            }
            if self.allWorkoutSessions.count > 1 {
                self.allWorkoutSessions = self.allWorkoutSessions.sorted(by: { $0.date! < $1.date! }).reversed()
            }
        } catch {
            print("Failed to Retrieve Core Data - 2")
        }
    }
    
    
    func checkCoreDataIsEmpty(){
        if allGoalProgress.count == 0 {
            scrollView.isHidden = true
            noGoalsView.isHidden = false
            
        } else {
            scrollView.isHidden = false
            noGoalsView.isHidden = true
        }
    }
    
    
    func clearCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressList")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    managedContext.delete(result)
                }
                do {
                    try managedContext.save()
                    print("Removed ALL core data")
                    self.allGoalProgress.removeAll()
                    
                    //removes all added goal views from scrollView
                    for thisView in scrollView.subviews {
                        thisView.removeFromSuperview()
                    }
                    
                    //resets the scrollView 'scroll' size
                    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
                    
                    //hides the scrollView, shows the noGoalsView message
                    scrollView.isHidden = true
                    noGoalsView.isHidden = false
                    
                } catch {
                    print("Error saving context from delete: ", error)
                }
            }
        } catch {
            print("Error fetching results: ",error)
        }
        
    }
    
}
