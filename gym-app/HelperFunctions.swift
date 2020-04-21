//
//  CommonFunctions.swift
//  gym-app
//
//  Created by Jeff Jordan on 06/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import KDCircularProgress
import MaterialComponents.MaterialButtons

public class Helper {
    
    //MARK: Formatted Time
    //converts hours,mins,seconds to strings, adding 0 first should the value be less than 9, returning a String of format HH:MM:SS
    static func displayZeroInTime(_ hoursMinsSeconds:(Int,Int,Int)) -> String {
        
        var formattedHoursMinsSeconds: String
        var formatHours: String
        var formatMins: String
        var formatSeconds: String
            
        if hoursMinsSeconds.0 < 10 {
            formatHours = "0"+String(hoursMinsSeconds.0)
        } else { formatHours = String(hoursMinsSeconds.0) }
            
        if hoursMinsSeconds.1 < 10 {
            formatMins = "0"+String(hoursMinsSeconds.1)
        } else { formatMins = String(hoursMinsSeconds.1) }
            
        if hoursMinsSeconds.2 < 10 {
            formatSeconds = "0"+String(hoursMinsSeconds.2)
        } else { formatSeconds = String(hoursMinsSeconds.2) }
        
        
        formattedHoursMinsSeconds = formatHours+":"+formatMins+":"+formatSeconds
        
        return formattedHoursMinsSeconds
    }
    
    
    //MARK: Formatted Date
    //returns today's date in the format: Month Day, Year
    static func getFormattedDate(_ thisDate: Date) -> String {
        
        //gets the date String of the date object
        let format = DateFormatter()
        format.dateStyle = .medium
        
        //gets the date String from the date object
        let dateString = format.string(from: thisDate)
        
        return dateString
    }
    
    //MARK: Formatted Seconds
    //returns a tuple containing (hours,mins,seconds)
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    //MARK: Is String an Int?
    //checks whether a string can be converted to an Int
    static func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    
    //MARK: Dates Difference
    //returns a String with the number of days difference of two dates
    static func returnDatesDifference(_ startDate: Date, _ endDate: Date) -> String {
        
        let daysDifference = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        
        if daysDifference > 0 {
            
            return "(\(daysDifference) days)"
            
        } else {
            
            let hoursDifference = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
            
            if hoursDifference < 0 {
                return "(today)"
            } else {
                return "(tomorrow)"
            }
            
        }
        
        
    }
    
    
    //MARK: Gradient View
    //sets gradient background of a view (used for fading between calendar view and display workout view
    static func setGradientBackground(colourOne: UIColor, colourTwo: UIColor, view: UIView){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colourOne.cgColor, colourTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        view.layer.addSublayer(gradientLayer)
        
    }
    
}


//MARK: Progress Goal View
//Added to Helper as same styling will be used on the HomeVC as well as the ProgressVC
extension Helper {
    
    
    //creates the outer view for a goal
    static func createGoalView(_ view:UIView, _ goalProgress: GoalProgress, _ allWorkoutSessions:[WorkoutSession]) -> UIView {
        let goalView = UIView(frame: CGRect(x: 20, y: 20, width: view.frame.width - 40, height: 260))
        
        goalView.backgroundColor = .white
        goalView.layer.borderWidth = 2
        goalView.layer.borderColor = UIColor.opaqueSeparator.cgColor
        goalView.layer.cornerRadius = 20
        goalView.layer.shadowOpacity = 1
        goalView.layer.shadowRadius = 5
        goalView.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        
        
        let setTypeImage = getTypeImage(goalProgress.type!)
        goalView.addSubview(setTypeImage)
        
        let setTitle = getTypeTitle(goalProgress.type!)
        goalView.addSubview(setTitle)
        
        let setStars = getStarRating(goalProgress.rating!)
        goalView.addSubview(setStars)
        
        let setDaysLeft = getDaysLeft(Date(), goalProgress.endDate!)
        goalView.addSubview(setDaysLeft)
        
        let setStartEndDate = getStartEndDates(goalProgress.startDate!, goalProgress.endDate!)
        goalView.addSubview(setStartEndDate)
        
        let setProgressView = getProgressBar(goalProgress, allWorkoutSessions)
        goalView.addSubview(setProgressView)
        
        let setProgressDetailsView = getProgressBarDetails(view, goalProgress, allWorkoutSessions)
        goalView.addSubview(setProgressDetailsView)
        
        return goalView
    }
    
    //returns a UIImage for the correct goal type
    static func getTypeImage(_ type:String) -> UIImageView {
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
    static func getTypeTitle(_ type:String) -> UILabel {
        let typeTitleLabel = UILabel(frame: CGRect(x: 80, y: 10, width: 250, height: 30))
        
        typeTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
        typeTitleLabel.textColor = .black
        typeTitleLabel.text = type
        
        return typeTitleLabel
    }
    
    //returns a UIImageView containing the star rating for the goal
    static func getStarRating(_ starRating:Int) -> UIView {
        let starsView = UIView(frame: CGRect(x: 80, y: 40, width: 250, height: 20))
        let starImage = UIImage(named: "icons8-star-100-filled")
        var xPositionOfStar:CGFloat = 0
        
        for _ in 0...starRating {
            let starImageView = UIImageView(image: starImage)
            starImageView.frame = CGRect(x: xPositionOfStar, y: 0, width: 20, height: 20)
            starsView.addSubview(starImageView)
            xPositionOfStar = xPositionOfStar + starImageView.frame.width + 10.0
        }
        
        return starsView
    }
    
    //returns a UIView of the number of days/hours left to complete their goal
    static func getDaysLeft(_ startDate:Date, _ endDate:Date) -> UIView {
        let returnView = UIView(frame: CGRect(x: 10, y: 70, width: 130, height: 60))
        var daysOrHoursDifference: Int = 0
        var daysOrHoursString: String = "days"
        
        //returnView.backgroundColor = .purple
        
        //works out the number of days between two dates
        daysOrHoursDifference = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        
        if daysOrHoursDifference <= 0 {
            
            //if number of days between is 0, work out the number of hours between the two dates, adjusting the corresponding string
            daysOrHoursDifference = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
            daysOrHoursString = "hours"
            
            if daysOrHoursDifference <= 0 {
                daysOrHoursDifference = 0
            }
            
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
    static func getStartEndDates(_ startDate:Date, _ endDate:Date) -> UIView {
        let returnView = UIView(frame: CGRect(x: 170, y: 78, width: 190, height: 42))
        
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
    static func getProgressBar(_ goalProgress: GoalProgress, _ allWorkoutSessions: [WorkoutSession]) -> KDCircularProgress {
        let progress = KDCircularProgress(frame: CGRect(x: 0, y: 120, width: 140, height: 140))
        progress.layer.cornerRadius = 20
        var progressBarPercentage:Double = 0
        //progress.backgroundColor = .green

        progress.startAngle = -90
        progress.progressThickness = 0.4
        progress.trackThickness = 0.4
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: #colorLiteral(red: 0.03383557126, green: 0.6863066554, blue: 0, alpha: 1))
        progress.trackColor = #colorLiteral(red: 0.7763438225, green: 0.9647529721, blue: 0.5528729558, alpha: 1)
        //progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        //progress.center = CGPoint(x: view.center.x, y: view.center.y + 25)
        
        
        //progress bar
        if goalProgress.type! == "Improve Strength" || goalProgress.type! == "Improve Fitness" {
            progressBarPercentage = Helper.percentageForStrengthFitness(goalProgress: goalProgress, allWorkoutSessions: allWorkoutSessions)
            //print("Progress: \(progressBarPercentage)")
        } else {
            //print("progress bar percentage for comparing start weight, current weight and goal weight")
            progressBarPercentage = Helper.percentageForLoseWeightBuildMuscle(goalProgress)
        }
        
        progress.angle = 360 * progressBarPercentage
        
        progress.animate(fromAngle: 0, toAngle: (360 * progressBarPercentage), duration: 2, completion: nil)
        
        let progressPercentage = Int((progressBarPercentage * 100).round(to: 0))
        
        let progressPercentageCircleView = UIView(frame: CGRect(x: 30, y: 30, width: 80, height: 80))
        progressPercentageCircleView.backgroundColor = #colorLiteral(red: 0.2352691293, green: 0.2392317355, blue: 0.2587879896, alpha: 1)
        //progressPercentageCircleView.layer.borderWidth = 1
        //progressPercentageCircleView.layer.borderColor = UIColor.black.cgColor
        progressPercentageCircleView.layer.cornerRadius = progressPercentageCircleView.frame.width/2
        
        let progressPercentageCircleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        progressPercentageCircleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        progressPercentageCircleLabel.textColor = .white
        progressPercentageCircleLabel.textAlignment = .center
        progressPercentageCircleLabel.text = "\(progressPercentage)%"
        progressPercentageCircleView.addSubview(progressPercentageCircleLabel)
        
        progress.addSubview(progressPercentageCircleView)
        
        
        return progress
    }
    
    //returns goal type related info, positioned to the right of the progressBarCircle
    static func getProgressBarDetails(_ view:UIView, _ goalProgress: GoalProgress, _ allWorkoutSessions:[WorkoutSession]) -> UIView {
        let detailsView = UIView(frame: CGRect(x: 130, y: 140, width: view.frame.width - 170, height: 140))
        
        //detailsView.backgroundColor = .purple
        detailsView.layer.cornerRadius = 20
        
        //type label
        let title = UILabel(frame: CGRect(x: 40, y: 0, width: detailsView.frame.width-40, height: 20.0))
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        let startView = UIView(frame: CGRect(x: 0, y: 20.0, width: detailsView.frame.width, height: 25))
        let lowLabel = UILabel(frame: CGRect(x: 40, y: 0, width: (startView.frame.width/2)-40, height: 25))
        lowLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        startView.addSubview(lowLabel)
        
        
        
        let currentView = UIView(frame: CGRect(x: 0, y: 45.0, width: detailsView.frame.width, height: 25))
        let averageLabel = UILabel(frame: CGRect(x: 40, y: 0, width: (currentView.frame.width/2)-40, height: 25))
        averageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        currentView.addSubview(averageLabel)
        
        
        
        let goalView = UIView(frame: CGRect(x: 0, y: 70.0, width: detailsView.frame.width, height: 25))
        let highLabel = UILabel(frame: CGRect(x: 40, y: 0, width: (goalView.frame.width/2)-40, height: 25))
        highLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        goalView.addSubview(highLabel)

        let imageSeparatorPosition = CGRect(x: startView.center.x-12.5, y: 0, width: 25, height: 25)

        if goalProgress.type! == "Improve Strength" {
            title.text = "Total Weights Moved"
            let lowAverageHigh = Helper.lowAverageHighWeights(goalProgress.startDate!, goalProgress.endDate!, allWorkoutSessions: allWorkoutSessions)
            
            let weightSeparator = UIImage(named: "icons8-weight-100")
            
            lowLabel.text = "Low"
            
            let weightSeparatorOne = UIImageView(image: weightSeparator)
            weightSeparatorOne.frame = imageSeparatorPosition
            startView.addSubview(weightSeparatorOne)
            
            averageLabel.text = "Average"
            
            let weightSeparatorTwo = UIImageView(image: weightSeparator)
            weightSeparatorTwo.frame = imageSeparatorPosition
            currentView.addSubview(weightSeparatorTwo)
            
            highLabel.text = "High"
            
            
            let weightSeparatorThree = UIImageView(image: weightSeparator)
            weightSeparatorThree.frame = imageSeparatorPosition
            goalView.addSubview(weightSeparatorThree)
            
            
            let lowWeightLabel = UILabel(frame: CGRect(x: startView.frame.width/2, y: 0, width: (startView.frame.width/2)-40, height: 25))
            lowWeightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            lowWeightLabel.textAlignment = .right
            lowWeightLabel.text = "\(lowAverageHigh.0)kg"
            startView.addSubview(lowWeightLabel)
            
            let averageWeightLabel = UILabel(frame: CGRect(x: currentView.frame.width/2, y: 0, width: (currentView.frame.width/2)-40, height: 25))
            averageWeightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            averageWeightLabel.textAlignment = .right
            averageWeightLabel.text = "\(lowAverageHigh.1)kg"
            currentView.addSubview(averageWeightLabel)
            
            let highWeightLabel = UILabel(frame: CGRect(x: goalView.frame.width/2, y: 0, width: (goalView.frame.width/2)-40, height: 25))
            highWeightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            highWeightLabel.textAlignment = .right
            highWeightLabel.text = "\(lowAverageHigh.2)kg"
            goalView.addSubview(highWeightLabel)
            
            
        } else if goalProgress.type! == "Improve Fitness" {
            title.text = "Total Time Achieved"
            let lowAverageHigh = Helper.lowAverageHighTimes(goalProgress.startDate!, goalProgress.endDate!, allWorkoutSessions: allWorkoutSessions)
            
            let timeSeparator = UIImage(named: "icons8-stopwatch-100")
            
            lowLabel.text = "Low"
            
            let timeSeparatorOne = UIImageView(image: timeSeparator)
            timeSeparatorOne.frame = CGRect(x: startView.center.x-12.5, y: 0, width: 25, height: 25)
            startView.addSubview(timeSeparatorOne)
            
            averageLabel.text = "Average"
            
            let timeSeparatorTwo = UIImageView(image: timeSeparator)
            timeSeparatorTwo.frame = CGRect(x: currentView.center.x-12.5, y: 0, width: 25, height: 25)
            currentView.addSubview(timeSeparatorTwo)
            
            highLabel.text = "High"
            
            let timeSeparatorThree = UIImageView(image: timeSeparator)
            timeSeparatorThree.frame = CGRect(x: goalView.center.x-12.5, y: 0, width: 25, height: 25)
            goalView.addSubview(timeSeparatorThree)
            
            let lowTimeLabel = UILabel(frame: CGRect(x: startView.frame.width/2, y: 0, width: (startView.frame.width/2)-40, height: 25))
            lowTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            lowTimeLabel.textAlignment = .right
            lowTimeLabel.text = lowAverageHigh.0
            startView.addSubview(lowTimeLabel)
            
            let averageTimeLabel = UILabel(frame: CGRect(x: currentView.frame.width/2, y: 0, width: (currentView.frame.width/2)-40, height: 25))
            averageTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            averageTimeLabel.textAlignment = .right
            averageTimeLabel.text = lowAverageHigh.1
            currentView.addSubview(averageTimeLabel)
            
            let highTimeLabel = UILabel(frame: CGRect(x: goalView.frame.width/2, y: 0, width: (goalView.frame.width/2)-40, height: 25))
            highTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            highTimeLabel.textAlignment = .right
            highTimeLabel.text = "\(lowAverageHigh.2)"
            goalView.addSubview(highTimeLabel)
            
            
            
        } else {
            title.text = "Bodyweight"
            
            lowLabel.text = "Start"
            averageLabel.text = "Current"
            highLabel.text = "Goal"
            
            let lowBodyweightLabel = UILabel(frame: CGRect(x: startView.frame.width/2, y: 0, width: (startView.frame.width/2)-70, height: 25))
            lowBodyweightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            lowBodyweightLabel.textAlignment = .right
            lowBodyweightLabel.text = "\(goalProgress.startWeight!)kg"
            startView.addSubview(lowBodyweightLabel)
            
            let averageBodyweightLabel = UILabel(frame: CGRect(x: currentView.frame.width/2, y: 0, width: (currentView.frame.width/2)-70, height: 25))
            averageBodyweightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            averageBodyweightLabel.textAlignment = .right
            if goalProgress.currentWeight != nil {
                averageBodyweightLabel.text = "\(goalProgress.currentWeight!)kg"
            } else {
                averageBodyweightLabel.text = "N/A"
            }
            currentView.addSubview(averageBodyweightLabel)
            
            let highBodyweightLabel = UILabel(frame: CGRect(x: goalView.frame.width/2, y: 0, width: (goalView.frame.width/2)-70, height: 25))
            highBodyweightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
            highBodyweightLabel.textAlignment = .right
            highBodyweightLabel.text = "\(goalProgress.goalWeight!)kg"
            goalView.addSubview(highBodyweightLabel)
            
            //NEED TO ADD BUTTON FUNCTIONALITY TO OPEN Update Current Weight VC
            //add edit icon in top right which opens up new VC
            //add notes icon alongside title which opens new VC to display notes(can be edited?)
            
            
            
            
//            let buttonView = MDCFloatingButton(frame: CGRect(x: goalView.frame.width - 82, y: 100, width: 72, height: 30))
//            buttonView.backgroundColor = UIColor.link
//            buttonView.setBackgroundColor(UIColor.opaqueSeparator.withAlphaComponent(0.6), for: .selected)
//            buttonView.setBackgroundColor(UIColor.link.withAlphaComponent(0.6), for: .highlighted)
//            buttonView.setTitle("Update", for: .normal)
//            buttonView.inkColor = .clear
//            buttonView.setTitleFont(UIFont(name: "HelveticaNeue", size: 14.0), for: .normal)
//            buttonView.isUppercaseTitle = false
//            buttonView.center.x = goalView.center.x
//            detailsView.addSubview(buttonView)
        }
        
        
        detailsView.addSubview(title)
        detailsView.addSubview(startView)
        detailsView.addSubview(currentView)
        detailsView.addSubview(goalView)
        
        
        return detailsView
    }
    
    
}


//MARK: Progress Algorithms
//calculates the current progress and goal progress of time based exercises and weights based exercises recorded within the given goal date period
extension Helper {
    
    //MARK: Strength/Fitness Progress%
    //returns a percentage (max 100%) relating to the user's progress with weights
    static func percentageForStrengthFitness(goalProgress:GoalProgress, allWorkoutSessions: [WorkoutSession]) -> Double {
        
        //start and end date of the goal
        let startDate = goalProgress.startDate!
        let endDate = goalProgress.endDate!
        
        //returns the workouts within the date range
        let workoutsWithinDateRange = getWorkoutsWithinProgressDateRange(startDate, endDate, allWorkoutSessions: allWorkoutSessions)
        
        //achievedPoints is the number of points achieved from performing weights sets in workouts within the goal date range
        let achievedPoints:Double = Double(totalPoints(workoutsWithinDateRange, goalType: goalProgress.type!))
        
        //returns the goal number of points to achieve, based on the goal startDate, endDate, and average number of sets per session
        let goalPoints:Double = calculateGoalPoints(startDate, endDate, allWorkoutSessions: allWorkoutSessions)
        
//        print("Achieved Points: \(achievedPoints)")
//        print(" > 0 == improved | < 0 == declining")
//        print("Goal Points: \(goalPoints)")
        
        //value between 0.0 and 1.0 returned to represent a percentage from 0% to 100% for the goal
        var totalPercentage = (achievedPoints/goalPoints)
        
        
        if totalPercentage > 100 {
            totalPercentage = 100
        }
        
        
        return totalPercentage
    }
    
    
    //returns the workout Sessions within the progress start date and progress end date
    static func getWorkoutsWithinProgressDateRange(_ startDate: Date, _ endDate: Date, allWorkoutSessions:[WorkoutSession]) -> [WorkoutSession]{
        
        var workoutSessionsAfterDate = [WorkoutSession]()
        
        for workout in allWorkoutSessions {
            
            //need to change to > progressStartDate && workout.date! < progressEndDate
            if workout.date! > startDate && workout.date! < endDate {
                //print("     added")
                workoutSessionsAfterDate.append(workout)
            } else { break }    //exit for loop as allWorkoutSessions is sorted by date, so following dates will have occurred before todaysDate
            
        }
        
        return workoutSessionsAfterDate
    }
    
    
    //returns the achieved number of points from the workouts within the start and end date of the goal
    static func totalPoints(_ workoutSessionsAfterDate: [WorkoutSession], goalType:String) -> Int {
        var weightsSetsVolume = [Int]()
        var bodyweightSetsVolume = [Int]()
        var cardioCircuitsSetsVolume = [Int]()
        var achievedPoints = 0
        
        //calculate the total points earned for a workout
        for workout in workoutSessionsAfterDate {
            
            for exercise in workout.workoutExercises! {
                
                if exercise.exerciseInfo! == "Weights" {
                    
                    for set in exercise.exerciseSets! {
                        let repsWeightPoints = set.reps! * set.weight!
                        weightsSetsVolume.insert(repsWeightPoints, at: 0)
                    }
                }
                if exercise.exerciseInfo! == "Bodyweight" {
                    
                    for set in exercise.exerciseSets! {
                        bodyweightSetsVolume.append(set.reps!)
                    }
                }
                if exercise.exerciseInfo! == "Cardio" || exercise.exerciseInfo! == "Circuits" {
                    
                    for set in exercise.exerciseSets! {
                        let repsTimePoints = set.time!
                        cardioCircuitsSetsVolume.insert(repsTimePoints, at: 0)
                    }
                }
            }
        }
        
        //print("GoalType: \(goalType)")
        if goalType == "Improve Strength" {

            if weightsSetsVolume.count > 0 {
                //Compares each set to previous sets for weights exercises and if set volume value is greater, adds a point
                for i in 0...weightsSetsVolume.count-1 {
                    
                    for j in i...weightsSetsVolume.count-1 {
                        
                        if  weightsSetsVolume[i] > weightsSetsVolume[j] {
                            achievedPoints = achievedPoints + 1
                            print("AchievedPoints: \(achievedPoints)")
                        }
                    }
                    
                }
            }
            
            if bodyweightSetsVolume.count > 0 {
                //Compares each set to previous sets for bodyweight exercises and if set volume value is greater, adds a point
                for i in 0...bodyweightSetsVolume.count-1 {
                    
                    for j in i...bodyweightSetsVolume.count-1 {
                        
                        if  bodyweightSetsVolume[i] > bodyweightSetsVolume[j] {
                            achievedPoints = achievedPoints + 1
                        }
                    }
                    
                }
            }
            
        } else if goalType == "Improve Fitness" {
            
            if cardioCircuitsSetsVolume.count > 0 {
                //Compares each set to previous sets for time-related exercises and if set volume value is greater, adds a point
                for i in 0...cardioCircuitsSetsVolume.count-1 {
                    
                    for j in i...cardioCircuitsSetsVolume.count-1 {
                        
                        if  cardioCircuitsSetsVolume[i] > cardioCircuitsSetsVolume[j] {
                            achievedPoints = achievedPoints + 1
                        }
                    }
                    
                }
            }
        }
        
        return achievedPoints
    }
    
    
    //returns an approximate number of sets to progress within two date ranges
    static func calculateGoalPoints(_ startDate:Date, _ endDate:Date, allWorkoutSessions: [WorkoutSession]) -> Double {
        var goalPoints:Double = 0
        
        //returns number of days difference between goal start date and end date
        let daysDifference = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        
        //calculates the average number of sets per workout, based on all recorded workouts (default being 15)
        let averageSetsPerWorkout = getAverageSetsPerWorkout(allWorkoutSessions: allWorkoutSessions)
        
        if daysDifference > 1 {
            
            goalPoints = Double(daysDifference) * (averageSetsPerWorkout/3)
            
        } else {
            //1 represents 1 workout
            goalPoints = 1 * (averageSetsPerWorkout/3)
            
        }
        return goalPoints
    }
    
    
    //gets the average number of sets per workout for the user
    static func getAverageSetsPerWorkout(allWorkoutSessions: [WorkoutSession]) -> Double {
        var totalWorkouts:Double = 0
        var totalSets:Double = 0
        var average:Double = 0

        for workout in allWorkoutSessions {
            totalWorkouts = totalWorkouts + 1
            for exercise in workout.workoutExercises! {
                for _ in exercise.exerciseSets! {
                    totalSets = totalSets + 1
                }
            }
        }
        
        if allWorkoutSessions.count > 3 {
            //returns the average sets per workout
            average = Double(totalSets/totalWorkouts).round(to: 2)
        }
        
        if average < 15 {
            //sets general average for sets per workout (Lower bound from researching average sets per workout)
            average = 15
        }
        
        return average
    }
    
    
    
    //MARK: LoseWeight/BuildMuscle %
    static func percentageForLoseWeightBuildMuscle(_ goalProgress: GoalProgress) -> Double{
        var percentage:Double = 0
        
        if goalProgress.currentWeight != nil {
            
            //if to lose weight, start weight will be greater than the goal weight
            if goalProgress.startWeight! > goalProgress.goalWeight! {
                percentage = Double(goalProgress.goalWeight!/goalProgress.currentWeight!).round(to: 2)
            } else {
                //if goal weight greater than start weight, goal is to gain weight/build muscle
                percentage = Double(goalProgress.currentWeight!/goalProgress.goalWeight!).round(to: 2)
            }
        }
        return percentage
    }
    
    
    //returns the lowest, average, and best total weights moved for sessions within the given date
    static func lowAverageHighWeights(_ startDate:Date, _ endDate:Date, allWorkoutSessions: [WorkoutSession]) -> (Int, Int, Int) {
        let workoutsWithinDates = Helper.getWorkoutsWithinProgressDateRange(startDate, endDate, allWorkoutSessions: allWorkoutSessions)
        var weightsWorkoutTotals = [Int]()
        
        for workout in workoutsWithinDates {
            var weightsSetsVolume:Int = 0
            for exercise in workout.workoutExercises! {
                
                if exercise.exerciseInfo! == "Weights" {
                    
                    for set in exercise.exerciseSets! {
                        let repsWeightPoints = set.reps! * set.weight!
                        weightsSetsVolume = weightsSetsVolume + repsWeightPoints
                    }
                }
            }
            weightsWorkoutTotals.append(weightsSetsVolume)
        }
        
        var lowestWeightTotal = 100000
        var averageWeightTotal = 0
        var highestWeightTotal = 0
        
        //sets the values of lowest, average, and highest total volume achieved for a workout session containing weights
        for weightsTotal in weightsWorkoutTotals {
            
            if weightsTotal < lowestWeightTotal {
                lowestWeightTotal = weightsTotal
            }
            if weightsTotal > highestWeightTotal {
                highestWeightTotal = weightsTotal
            }
            averageWeightTotal = averageWeightTotal + weightsTotal
        }
        if weightsWorkoutTotals.count < 1 {
            averageWeightTotal = (averageWeightTotal/1)

        }
        if lowestWeightTotal == 100000 {
            lowestWeightTotal = 0
        }
                
        return (lowestWeightTotal, averageWeightTotal, highestWeightTotal)
    }
    
    
    //returns the lowest, average, and best total times for sessions within the given date
    static func lowAverageHighTimes(_ startDate:Date, _ endDate:Date, allWorkoutSessions: [WorkoutSession]) -> (String, String, String) {
        let workoutsWithinDates = Helper.getWorkoutsWithinProgressDateRange(startDate, endDate, allWorkoutSessions: allWorkoutSessions)
        var timeWorkoutTotals = [Int]()
        
        for workout in workoutsWithinDates {
            var timeSetsVolume:Int = 0
            
            for exercise in workout.workoutExercises! {
                
                if exercise.exerciseInfo! == "Cardio" || exercise.exerciseInfo! == "Circuits" {
                    
                    for set in exercise.exerciseSets! {
                        let timePoints = set.time!
                        timeSetsVolume = timeSetsVolume + timePoints
                    }
                }
            }
            timeWorkoutTotals.append(timeSetsVolume)
        }
        
        var lowestTimeTotal = 1000000
        var averageTimeTotal = 0
        var highestTimeTotal = 0
        
        //sets the values of lowest, average, and highest total time achieved for a workout session
        for timeTotal in timeWorkoutTotals {
            
            if timeTotal < lowestTimeTotal {
                lowestTimeTotal = timeTotal
            }
            if timeTotal > highestTimeTotal {
                highestTimeTotal = timeTotal
            }
            averageTimeTotal = averageTimeTotal + timeTotal
        }
        if timeWorkoutTotals.count < 1 {
            averageTimeTotal = (averageTimeTotal/1)
        }
        
        
        if lowestTimeTotal == 1000000 {
            lowestTimeTotal = 0
        }
        
        let lowestTimeFormatted = Helper.secondsToHoursMinutesSeconds(seconds: lowestTimeTotal)
        let lowestTimeString = Helper.displayZeroInTime(lowestTimeFormatted)
        
        let averageTimeFormatted = Helper.secondsToHoursMinutesSeconds(seconds: averageTimeTotal)
        let averageTimeString = Helper.displayZeroInTime(averageTimeFormatted)
        
        let highestTimeFormatted = Helper.secondsToHoursMinutesSeconds(seconds: highestTimeTotal)
        let highestTimeString = Helper.displayZeroInTime(highestTimeFormatted)
        
        
        return (lowestTimeString, averageTimeString, highestTimeString)
    }
    
    
}


extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
