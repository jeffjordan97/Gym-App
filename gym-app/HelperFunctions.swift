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
    
}
    
extension Helper {
    
    //returns a percentage (max 100%) relating to the user's progress with weights
    static func getProgressForWeights(goalProgress:GoalProgress, allWorkoutSessions: [WorkoutSession]) -> Double {
        
        //start and end date of the goal
        let startDate = goalProgress.startDate!
        let endDate = goalProgress.endDate!
        
        //returns the workouts within the date range
        let workoutsWithinDateRange = getWorkoutsWithinProgressDateRange(startDate, endDate, allWorkoutSessions: allWorkoutSessions)
        
        //achievedPoints is the number of points achieved from performing weights sets in workouts within the goal date range
        let achievedPoints:Double = Double(totalPointsForWeights(workoutsWithinDateRange))
        
        //returns the goal number of points to achieve, based on the goal startDate, endDate, and average number of sets per session
        let goalPoints:Double = calculateGoalPoints(startDate, endDate, allWorkoutSessions: allWorkoutSessions)
        
        print("Achieved Points: \(achievedPoints)")
        print(" > 0 == improved | < 0 == declining")
        print("Goal Points: \(goalPoints)")
        
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
    
    
    //returns the max possible points and the achieved number of points
    static func totalPointsForWeights(_ workoutSessionsAfterDate: [WorkoutSession]) -> Int {
        var weightsSetsVolume = [Int]()
        var bodyweightSetsVolume = [Int]()
        var achievedPoints = 0
        
        //calculate the total points earned for a workout
        for workout in workoutSessionsAfterDate {
            
            for exercise in workout.workoutExercises! {
                
                if exercise.exerciseInfo! == "Weights" {
                    
                    for set in exercise.exerciseSets! {
                        let repsWeightPoints = set.reps! * set.weight!
                        weightsSetsVolume.append(repsWeightPoints)
                    }
                }
                if exercise.exerciseInfo! == "Bodyweight" {
                    
                    for set in exercise.exerciseSets! {
                        bodyweightSetsVolume.append(set.reps!)
                    }
                }
            }
        }
        print("WeightsSetsVolume: \(weightsSetsVolume)")
        
        if weightsSetsVolume.count > 0 {
            //Compares each set to previous sets for weights exercises and if set volume value is greater, adds a point
            for i in 0...weightsSetsVolume.count-1 {
                
                for j in i...weightsSetsVolume.count-1 {
                    
                    if  weightsSetsVolume[i] > weightsSetsVolume[j] {
                        //print("j",pointsForWorkout[j])
                        achievedPoints = achievedPoints + 1
                    }
                }
                
            }
        }
        
        if bodyweightSetsVolume.count > 0 {
            //Compares each set to previous sets for bodyweight exercises and if set volume value is greater, adds a point
            for i in 0...bodyweightSetsVolume.count-1 {
                //print("i: ",pointsForWorkout[i])
                
                for j in i+1...bodyweightSetsVolume.count-1 {
                    
                    if  bodyweightSetsVolume[i] > bodyweightSetsVolume[j] {
                        //print("j",pointsForWorkout[j])
                        achievedPoints = achievedPoints + 1
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
    
    
}


extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
