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
import KDCircularProgress
import MaterialComponents.MDCFloatingButton

class ProgressController: UIViewController, passBackToProgress, EditedGoalToProgress {

    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noGoalsView: UIView!
    
    
    //MARK: Attributes
    var allGoalProgress = [GoalProgress]()
    var allWorkoutSessions = [WorkoutSession]()
    
    var notesForGoal: String?
    var goalsToUpdateWeight = [GoalProgress]()
    var totalEditButtons:Int = 0
    
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
        }
    }
    
    
    //returns a button to represent a note icon
    func getNotes(_ thisView:UIView, _ notes: String) -> UIButton {
        let notesButton = UIButton(frame: CGRect(x: thisView.frame.width - 50, y: 20, width: 30, height: 30))
        let notesImage = UIImage(named: "icons8-note-100")
        let notesSelectedImage = UIImage(named: "icons8-note-100-filled")
        
        notesButton.setImage(notesImage, for: .normal)
        notesButton.setImage(notesSelectedImage, for: .selected)
        notesButton.setImage(notesSelectedImage, for: .highlighted)
        
        notesForGoal = notes
        
        notesButton.addTarget(self, action: #selector(notesButtonAction), for: .touchUpInside)
        
        return notesButton
    }
    
    
    //function called when notesButton Clicked
    @objc func notesButtonAction(){
        print("Notes Button tapped")
        let notesVC = UIStoryboard(name: "NotesPopover", bundle: nil).instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        
        //delegate to pass to NotesVC
        if notesForGoal?.isEmpty ?? true {
            notesVC.textViewText = "No Notes"
        } else {
            notesVC.textViewText = notesForGoal
        }
        
        self.present(notesVC, animated: true, completion: nil)
    }
    
    
    //returns a button to edit the current weight of the user
    func getEditButton(_ thisView:UIView, _ goal:GoalProgress) -> UIButton {
        let editButton = UIButton(frame: CGRect(x: thisView.frame.width - 40, y: 185, width: 20, height: 20))
        let editImage = UIImage(named: "icons8-edit-100")
        let editSelectedImage = UIImage(named: "icons8-edit-100-filled")
        
        editButton.tag = totalEditButtons
        totalEditButtons = totalEditButtons + 1
        
        goalsToUpdateWeight.append(goal)
        
        editButton.setImage(editImage, for: .normal)
        editButton.setImage(editSelectedImage, for: .selected)
        editButton.setImage(editSelectedImage, for: .highlighted)
        
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        
        return editButton
    }
    
    
    @objc func editButtonAction(sender:UIButton){
        print("Edit Button tapped")
        let EditVC = UIStoryboard(name: "EditWeight", bundle: nil).instantiateViewController(withIdentifier: "EditWeightViewController") as! EditWeightViewController
        
        if !goalsToUpdateWeight.isEmpty {
            
            EditVC.goalPassed = goalsToUpdateWeight[sender.tag]
            EditVC.delegate = self
            
            self.present(EditVC, animated: true, completion: nil)
        }
        
        
    }
    
    
    func updatedGoalPassed(_ goal: GoalProgress) {
        allGoalProgress.first(where: { $0.startDate == goal.startDate })?.currentWeight = goal.currentWeight
        //figure out why this isnt updating the goal currentWeight?
        
        
        //update core data here...
        
        
        updateGoals()
        
    }
    
    
    //creates views for each goal added, adds them to scrollView, then adjusts scrollView contentSize to enable scrolling if content is greater than scrollView height
    func updateGoals(){
        
        if !allGoalProgress.isEmpty {
            //clear all subviews in scrollView ready for updated views to be added
            for subview in scrollView.subviews {
                subview.removeFromSuperview()
            }
            var totalGoalViewHeight:CGFloat = 20.0
            var endedGoals = [GoalProgress]()
            
            print("Date: \(Date())")
            for goal in allGoalProgress {
                
                //Sets the number of days left, including the end day (therefore using the start of the following day as the end date)
                let cal = NSCalendar.current
                let nextEndDay = cal.date(byAdding: Calendar.Component.day, value: 1, to: goal.endDate!)
                let endDay = cal.startOfDay(for: nextEndDay!)
                
                //if the goal endDate + 1 (to include the endDate) is greater than the current date, add, else add to endedGoals array
                if endDay > Date() {
                    print("Goal: \(goal.type!) endDate: \(goal.endDate!)")
                    let goalView = Helper.createGoalView(view, goal, allWorkoutSessions)
                    
                    let setNotes = getNotes(goalView, goal.notes!)
                    goalView.addSubview(setNotes)
                    
                    if goal.type == "Lose Weight" || goal.type == "Build Muscle" {
                        let setEditButton = getEditButton(goalView, goal)
                        goalView.addSubview(setEditButton)
                    }
                    
                    //adjust y position of goalView to appear below the previosly added goalView
                    goalView.frame = CGRect(x: goalView.frame.minX, y: totalGoalViewHeight, width: goalView.frame.width, height: goalView.frame.height)
                    
                    //adjusts to add height of the previously added progress
                    totalGoalViewHeight = totalGoalViewHeight + goalView.frame.height + 30.0
                    
                    scrollView.addSubview(goalView)
                    
                } else {
                    //adds to ended goals to add below all goals in progress
                    endedGoals.append(goal)
                }
            }
            
            let finishedDividerView = finishedGoalsDivider()
            finishedDividerView.frame = CGRect(x: finishedDividerView.frame.minX, y: totalGoalViewHeight, width: finishedDividerView.frame.width, height: finishedDividerView.frame.height)
            scrollView.addSubview(finishedDividerView)
            totalGoalViewHeight = totalGoalViewHeight + finishedDividerView.frame.height + 30.0
            
            for goal in endedGoals {
                let endedGoalView = Helper.createGoalView(view, goal, allWorkoutSessions)
                
                let setNotes = getNotes(endedGoalView, goal.notes!)
                endedGoalView.addSubview(setNotes)
                
                if goal.type == "Lose Weight" || goal.type == "Build Muscle" {
                    let setEditButton = getEditButton(endedGoalView, goal)
                    endedGoalView.addSubview(setEditButton)
                }
                
                //adjust y position of endedGoalView to appear below previously added goal view
                endedGoalView.frame = CGRect(x: endedGoalView.frame.minX, y: totalGoalViewHeight, width: endedGoalView.frame.width, height: endedGoalView.frame.height)
                
                totalGoalViewHeight = totalGoalViewHeight + endedGoalView.frame.height + 30.0
                
                scrollView.addSubview(endedGoalView)
            }
            
            
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalGoalViewHeight)
            
            if scrollView.contentSize.height > scrollView.frame.height {
                let fadeView = UIView(frame: CGRect(x: 0, y:scrollView.frame.minY + scrollView.frame.height - 10.0, width: scrollView.frame.width, height: 10.0))
                Helper.setGradientBackground(colourOne: UIColor.clear, colourTwo: UIColor.white, view: fadeView)
                view.addSubview(fadeView)
            }
            
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
        
        //inserts as the first element
        allGoalProgress.insert(goalProgress, at: 0)
        
        //sorts according to time remaining, with least amount of time first
        allGoalProgress.sort(by: { $0.startDate!.distance(to: $0.endDate!) < $1.startDate!.distance(to: $1.endDate!) })
        
        //unhides scrollview
        checkCoreDataIsEmpty()
        
        updateGoals()
        
    }
    
    
    //MARK: ViewDidAppear
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
        
        retrieveCoreData()
        checkCoreDataIsEmpty()
        
        updateGoals()
        
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
        noGoalsView.layer.shadowOpacity = 1
        noGoalsView.layer.shadowRadius = 10
        noGoalsView.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        
    }
    
    
    //creates finished divider to separate in progress goals from finished goals
    func finishedGoalsDivider() -> UIView {
        let finishedDividerView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 30))
        
        finishedDividerView.backgroundColor = .opaqueSeparator
        
        let finishedDividerLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 20))
        finishedDividerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        finishedDividerLabel.textColor = .white
        finishedDividerLabel.text = "Previous"
        
        finishedDividerView.addSubview(finishedDividerLabel)
        
        return finishedDividerView
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
                //sorts according to time remaining, with lowest time remaining at the top
                self.allGoalProgress = self.allGoalProgress.sorted(by: { $0.startDate!.distance(to: $0.endDate!) < $1.startDate!.distance(to: $1.endDate!) })
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
    
    
}
