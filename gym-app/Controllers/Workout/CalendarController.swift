//
//  CalendarController.swift
//  gym-app
//
//  Created by Jeff Jordan on 03/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import FSCalendar


class CalendarController: UIViewController{
    
    
    //MARK: Outlets
    
    
    
    
    
    //MARK: Attributes
    var allWorkoutSessions = [WorkoutSession]()
    fileprivate weak var calendar: FSCalendar!
    
    let displayWorkoutView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 400))
    let dateContentView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 400))
    
    
    
    //sets gradient background of a view (used for fading between calendar view and display workout view
    func setGradientBackground(colourOne: UIColor, colourTwo: UIColor, view: UIView){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colourOne.cgColor, colourTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        view.layer.addSublayer(gradientLayer)
        
    }
    
    
    //creates view at the top of the page above the calendar, adding the label 'Calendar'
    func createTopView(){
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 84))
        topView.backgroundColor = .white
        view.addSubview(topView)
        
        //label on view above calendar
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 52, width: 150, height: 22))
        titleLabel.textAlignment = .center
        titleLabel.text = "CALENDAR"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.2225729227, blue: 0.5179873705, alpha: 1)
        titleLabel.center.x = topView.center.x
        topView.addSubview(titleLabel)
    }
    
    
    //styles for displayWorkoutView
    func setDisplayWorkoutViewStyles(){
        displayWorkoutView.backgroundColor = .white
        displayWorkoutView.layer.borderWidth = 1
        displayWorkoutView.layer.borderColor = UIColor.lightGray.cgColor
        displayWorkoutView.layer.cornerRadius = 20
        displayWorkoutView.translatesAutoresizingMaskIntoConstraints = false
        displayWorkoutView.isScrollEnabled = true
        displayWorkoutView.contentSize = CGSize(width: displayWorkoutView.frame.width, height: displayWorkoutView.frame.height)
    }
    
    
    //constraints for displayWorkoutView
    func setDisplayWorkoutViewConstraints(){
        displayWorkoutView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 40).isActive = true
        displayWorkoutView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        displayWorkoutView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        displayWorkoutView.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //show Workout Info for today's date
        if allWorkoutSessions.count > 0 {
            
            let workoutSessionsForToday = allWorkoutSessions.filter({ Helper.getFormattedDate($0.date!) == Helper.getFormattedDate(Date()) })
            
            
            if workoutSessionsForToday.count > 0 {
                print("Workout Found Today")
                
                var subViewsTotalHeight: CGFloat = 0.0
                
                for workoutSession in workoutSessionsForToday {
                    print("Workout: \(workoutSession.type!)")
                    let viewToAdd = viewForWorkout(workoutSession)
                    let viewToAddHeight = viewToAdd.frame.height
                    let viewToAddWidth = viewToAdd.frame.width
                    
                    //adjusting frame for new y position of the view
                    viewToAdd.frame = CGRect(x: 0, y: subViewsTotalHeight, width: viewToAddWidth, height: viewToAddHeight)
                    
                    displayWorkoutView.addSubview(viewToAdd)
                    subViewsTotalHeight = subViewsTotalHeight + viewToAddHeight
                    
                }
                
                //adjusts size of scrollview to account for the number of workouts
                displayWorkoutView.contentSize = CGSize(width: displayWorkoutView.frame.width, height: subViewsTotalHeight)
                
            } else {
                print("Workout Not Found Today")
                displayWorkoutView.addSubview(noWorkoutView())
                displayWorkoutView.contentSize = CGSize(width: displayWorkoutView.frame.width, height: displayWorkoutView.frame.height)
            }
            
        } else {
            print("Workout Not Found Today")
            displayWorkoutView.addSubview(noWorkoutView())
            displayWorkoutView.contentSize = CGSize(width: displayWorkoutView.frame.width, height: displayWorkoutView.frame.height)
        }
        
    }
    
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Calendar Loaded")
        
        //view above calendar
        createTopView()
        
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.contentView.backgroundColor = .white
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 275).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        self.calendar = calendar
        
        
        let fadeView = UIView(frame: CGRect(x: 0, y: calendar.bounds.maxY + 58, width: view.frame.width, height: 20.0))
        fadeView.backgroundColor = .green
        setGradientBackground(colourOne: UIColor.white, colourTwo: UIColor.opaqueSeparator, view: fadeView)
        view.addSubview(fadeView)
        
        
        setDisplayWorkoutViewStyles()
        view.addSubview(displayWorkoutView)
        setDisplayWorkoutViewConstraints()
        
        
    }
    
}



//MARK: Calendar
extension CalendarController: FSCalendarDataSource, FSCalendarDelegate {
    
    //adds the number of events (dots) to a specific date given the number of workouts performed on that day
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var workoutsOnDate = 0
        let thisDateWorkout = allWorkoutSessions.filter({ Helper.getFormattedDate($0.date!) == Helper.getFormattedDate(date) })
        
        //prevents the number of events exceeding 3 dots
        if thisDateWorkout.count < 4 {
            workoutsOnDate = thisDateWorkout.count
        } else {
            workoutsOnDate = 3
        }
        return workoutsOnDate
    }
    
    //returns a cell for the current calendar cell
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        
        return cell
    }
    
    //changes content below calendar upon selecting a date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        
        let workoutSessionsForDate = allWorkoutSessions.filter( { Helper.getFormattedDate($0.date!)  == Helper.getFormattedDate(date)} )
        
        //removes all subviews of displayWorkoutView
        for view in displayWorkoutView.subviews {
            view.removeFromSuperview()
        }
        
        if workoutSessionsForDate.count > 0 {
            
            print("Workout Found!")
            
            
            var heightForWorkoutView:CGFloat = 0.0
            var subViewsTotalHeight:CGFloat = 0.0
            
            //adds workout for the selected day  to the displayWorkoutView
            for workoutSession in workoutSessionsForDate {
                let viewToAdd = viewForWorkout(workoutSession)
                let viewToAddHeight = viewToAdd.frame.height
                let viewToAddWidth = viewToAdd.frame.width
                
                //adjusting frame for new y position of the view
                viewToAdd.frame = CGRect(x: 0, y: heightForWorkoutView, width: viewToAddWidth, height: viewToAddHeight)
                
                displayWorkoutView.addSubview(viewToAdd)
                heightForWorkoutView = heightForWorkoutView + viewToAddHeight
            }
            
            
            for thisSubView in displayWorkoutView.subviews {
                subViewsTotalHeight = subViewsTotalHeight + thisSubView.frame.height
            }
            displayWorkoutView.contentSize = CGSize(width: displayWorkoutView.frame.width, height: subViewsTotalHeight)
            
            
        } else {
            
            print("Workout Not Found")
            displayWorkoutView.addSubview(noWorkoutView())
            displayWorkoutView.contentSize = CGSize(width: displayWorkoutView.frame.width, height: displayWorkoutView.frame.height)
            
        }
        
    }
    
    
}


//MARK: Display Workouts
extension CalendarController {
    
    //creates a view to display when there are no workouts to display for the date selected
    func noWorkoutView() -> UIView {
        let noWorkoutView = UIView(frame: CGRect(x: 20, y: 0, width: displayWorkoutView.frame.width - 40, height: 390))
        
        let noWorkoutLabel = UILabel(frame: CGRect(x: 0, y: 0, width: noWorkoutView.frame.width, height: 44.0))
        noWorkoutLabel.numberOfLines = 2
        noWorkoutLabel.center.y = noWorkoutView.center.y
        noWorkoutLabel.textAlignment = .center
        noWorkoutLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        noWorkoutLabel.text = "No Workout Today\n😢"
        
        noWorkoutView.addSubview(noWorkoutLabel)
        
        return noWorkoutView
    }
    
    
    //returns the view for the workout on the current date
    func viewForWorkout(_ workoutSession: WorkoutSession) -> UIView {
        let workoutView = UIView(frame: CGRect(x: 0, y: 0, width: displayWorkoutView.frame.width, height: 110))
        
        workoutView.backgroundColor = .white
        
        var workoutImage = UIImage()
        
        if workoutSession.type == "Weights" {
            workoutImage = UIImage(named: "icons8-barbell-100")!
        } else if workoutSession.type == "Cardio" {
            workoutImage = UIImage(named: "icons8-running-100")!
        } else {    //for Circuits
            workoutImage = UIImage(named: "icons8-jump-100")!
        }
        
        //Image of Workout Type
        let workoutImageView = UIImageView(image: workoutImage)
        workoutImageView.frame = CGRect(x: 20, y: 40.0, width: 60.0, height: 60.0)
        workoutView.addSubview(workoutImageView)
        
        
        //Title of Workout (Type)
        let titleLabel = UILabel(frame: CGRect(x: 90, y: 40, width: 120, height: 20))
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        titleLabel.textColor = .black
        titleLabel.text = workoutSession.type
        workoutView.addSubview(titleLabel)
        
        
        //Date of Workout
        let dateLabel = UILabel(frame: CGRect(x: 90, y: 60, width: 120, height: 20))
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        dateLabel.textColor = .lightGray
        dateLabel.text = Helper.getFormattedDate(workoutSession.date!)
        workoutView.addSubview(dateLabel)
        
        
        //Time of Workout
        let timeLabel = UILabel(frame: CGRect(x: 90, y: 80, width: 120, height: 20))
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        timeLabel.textColor = .lightGray
        timeLabel.text = "At: \(getFormattedTime(workoutSession.date!))"
        workoutView.addSubview(timeLabel)
        
        
        //Duration Image
        let durationImage = UIImage(named: "icons8-timer-100")
        let durationImageView = UIImageView(image: durationImage)
        durationImageView.frame = CGRect(x: 220, y: 50, width: 40, height: 40)
        workoutView.addSubview(durationImageView)
        
        
        //Duration Label
        let durationLabel = UILabel(frame: CGRect(x: 270, y: 60, width: 120, height: 20))
        durationLabel.textAlignment = .left
        durationLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        durationLabel.textColor = .black
        let formattedDuration = Helper.secondsToHoursMinutesSeconds(seconds: workoutSession.duration!)
        durationLabel.text = Helper.displayZeroInTime(formattedDuration)
        workoutView.addSubview(durationLabel)
        
        
        var heightOfExerciseViews:CGFloat = 0.0
        let bottomPaddingForWorkout:CGFloat = 10.0
        
        //adds each exercise to the workout view
        for exercise in workoutSession.workoutExercises! {

            //creates a view for the current exercise
            let thisExerciseView = viewForExercise(exercise)

            //adjust y position of exercise view to account for previously inserted exercise views
            thisExerciseView.frame = CGRect(x: 0, y:110 + heightOfExerciseViews, width: thisExerciseView.frame.width, height: thisExerciseView.frame.height)

            //adds height of the exercise view to the total of all exercise view heights
            heightOfExerciseViews = heightOfExerciseViews + thisExerciseView.frame.height


            workoutView.addSubview(thisExerciseView)
        }
            
        //adjusts the workout view frame to account for the height of all exercise views
        workoutView.frame = CGRect(x: 0, y: 0, width: displayWorkoutView.frame.height, height: workoutView.frame.height + heightOfExerciseViews + bottomPaddingForWorkout)
        
        
        //add delete workout button?
        
        
        //Bottom border to separate workouts
        let bottomBorder = UIView(frame: CGRect(x: 0, y: workoutView.frame.height - 2.0, width: workoutView.frame.width, height: 2.0))
        bottomBorder.backgroundColor = .opaqueSeparator
        //workoutView.addSubview(bottomBorder)
        
        return workoutView
    }
    
    
    //reutrns a view that displays the exercise details
    func viewForExercise(_ exercise: SelectedExercises) -> UIView {
        let exerciseView = UIView(frame: CGRect(x: 0, y: 110, width: displayWorkoutView.frame.width, height: 40))
        exerciseView.backgroundColor = .white
            
        var heightOfExerciseSubViews:CGFloat = exerciseView.frame.height
            
        //exercise name
        let exerciseName = exerciseNameLabel(exercise.exerciseName!)
        exerciseView.addSubview(exerciseName)
            
        //exercise type
        let exerciseType = exerciseTypeLabel(exercise.exerciseType!)
        exerciseView.addSubview(exerciseType)
        
        //appends each set to exerciseView
        for set in exercise.exerciseSets! {

            var thisSetView = UIView()

            if exercise.exerciseInfo! == "Weights"{

                thisSetView = weightsSetView(set)

            } else if exercise.exerciseInfo! == "Cardio" || exercise.exerciseInfo! == "Circuits"{

                thisSetView = cardioSetView(set)

            } else {    //Bodyweight

                thisSetView = bodyweightSetView(set)
            }


            //edits y position of set to below the previously inserted set
            thisSetView.frame = CGRect(x: 0, y: heightOfExerciseSubViews, width: thisSetView.frame.width, height: thisSetView.frame.height)

            //adds the current height of the set to the total height for all sets (so each set appears below each other)
            heightOfExerciseSubViews = heightOfExerciseSubViews + thisSetView.frame.height

            exerciseView.addSubview(thisSetView)
        }
        
        //adjusts the height of the exercise view to account for the added set
        exerciseView.frame = CGRect(x: 0, y: 110, width: displayWorkoutView.frame.width, height: heightOfExerciseSubViews + 2.0)
        
        //Bottom border to separate exercises
        let bottomBorder = UIView(frame: CGRect(x: 20, y: exerciseView.frame.height - 2.0, width: exerciseView.frame.width - 40, height: 2.0))
        bottomBorder.backgroundColor = .opaqueSeparator
        //exerciseView.addSubview(bottomBorder)
        
        
        return exerciseView
    }
    
    
    //returns label with name of exercise, for use in viewFor'Type'Exercise func
    func exerciseNameLabel(_ exerciseName: String) -> UILabel {
        let exerciseNameLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 240, height: 20))
        exerciseNameLabel.backgroundColor = .white
        exerciseNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        exerciseNameLabel.textColor = .black
        exerciseNameLabel.text = exerciseName
        
        return exerciseNameLabel
    }
    
    
    func exerciseTypeLabel(_ exerciseType: String) -> UILabel {
        let exerciseTypeLabel = UILabel(frame: CGRect(x: 270, y: 10, width: 100, height: 20))
        exerciseTypeLabel.backgroundColor = .white
        exerciseTypeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        exerciseTypeLabel.textColor = .opaqueSeparator
        exerciseTypeLabel.text = exerciseType
        
        return exerciseTypeLabel
    }
    
    //returns set details of an exercise set, where exercise type = Weights
    func weightsSetView(_ set: SetRepsWeights) -> UIView {
        let setView = UIView(frame: CGRect(x: 0, y: 0, width: displayWorkoutView.frame.width, height: 25))
        setView.backgroundColor = .white
        
        let setRepsWeightLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 20))
        setRepsWeightLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        setRepsWeightLabel.textColor = .black
        setRepsWeightLabel.textAlignment = .left
        setRepsWeightLabel.text = "\(set.set!)              \(set.weight!)kg x \(set.reps!)"
        
        setView.addSubview(setRepsWeightLabel)
        
        return setView
    }
    
    
    //view for Cardio set
    func cardioSetView(_ set: SetRepsWeights) -> UIView {
        let setView = UIView(frame: CGRect(x: 0, y: 0, width: displayWorkoutView.frame.width, height: 25))
        setView.backgroundColor = .white
        
        let setTimeLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 20))
        setTimeLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        setTimeLabel.textColor = .black
        setTimeLabel.textAlignment = .left
        let formattedTime = Helper.secondsToHoursMinutesSeconds(seconds: set.time!)
        setTimeLabel.text = "\(set.set!)              "+Helper.displayZeroInTime(formattedTime)
        
        setView.addSubview(setTimeLabel)
        
        return setView
    }
    
    
    
    //view for Circuits set
    func bodyweightSetView(_ set: SetRepsWeights) -> UIView {
        let setView = UIView(frame: CGRect(x: 0, y: 0, width: displayWorkoutView.frame.width, height: 25))
        setView.backgroundColor = .white
        
        let setRepsLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 200, height: 20))
        setRepsLabel.font = UIFont(name: "HelveticaNeue", size: 16.0)
        setRepsLabel.textColor = .black
        setRepsLabel.textAlignment = .left
        setRepsLabel.text = "\(set.set!)              Reps: \(set.reps!)"
        
        setView.addSubview(setRepsLabel)
        
        return setView
    }
    
    
    //returns today's date in the format: Month Day, Year
    func getFormattedTime(_ thisDate: Date) -> String {
        
        //gets the date String of the date object
        let format = DateFormatter()
        format.dateStyle = .full
        format.dateFormat = "HH:mm"
        
        //gets the date String from the date object
        let dateString = format.string(from: thisDate)
        
        return dateString
    }
    
    
}
