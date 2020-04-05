//
//  WorkoutSessionModel.swift
//  gym-app
//
//  Created by Jeff Jordan on 03/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation


//possibly add timeOfDay to WorkoutSession


//Object Structure used to store a Workout
public class WorkoutSession: NSObject, NSCoding{
    
    var duration: Int?
    var type: String?
    var date: Date?
    var workoutExercises: [SelectedExercises]?
    
    enum Key:String {
        case duration = "duration"
        case type = "type"
        case date = "date"
        case workoutExercises = "workoutExercises"
    }
    
    init(duration:Int, type:String, date:Date, workoutExercises:[SelectedExercises]){
        self.duration = duration
        self.type = type
        self.date = date
        self.workoutExercises = workoutExercises
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(duration, forKey: Key.duration.rawValue)
        coder.encode(type, forKey: Key.type.rawValue)
        coder.encode(date, forKey: Key.date.rawValue)
        coder.encode(workoutExercises, forKey: Key.workoutExercises.rawValue)
    }
    
    required public convenience init?(coder: NSCoder) {
        let gotDuration = coder.decodeObject(forKey: Key.duration.rawValue) as! Int?
        let gotType = coder.decodeObject(forKey: Key.type.rawValue) as! String?
        let gotDate = coder.decodeObject(forKey: Key.date.rawValue) as! Date?
        let gotWorkoutExercises = coder.decodeObject(forKey: Key.workoutExercises.rawValue) as! [SelectedExercises]?
        
        self.init(duration: gotDuration!, type: gotType!, date: gotDate!, workoutExercises: gotWorkoutExercises!)
    }
    
}


//Object Structure for List of Selected Exercises
public class SelectedExercises: NSObject, NSCoding {
    
    var exerciseName: String?
    var exerciseType: String?
    var exerciseInfo: String?
    var exerciseSets: [SetRepsWeights]?
    
    enum Key:String {
        case name = "exerciseName"
        case type = "exerciseType"
        case info = "exerciseInfo"
        case sets = "exerciseSets"
    }
    
    init(exerciseName:String, exerciseType:String, exerciseInfo: String, exerciseSets:[SetRepsWeights]) {
        self.exerciseName = exerciseName
        self.exerciseType = exerciseType
        self.exerciseInfo = exerciseInfo
        self.exerciseSets = exerciseSets
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(exerciseName, forKey: Key.name.rawValue)
        coder.encode(exerciseType, forKey: Key.type.rawValue)
        coder.encode(exerciseInfo, forKey: Key.info.rawValue)
        coder.encode(exerciseSets, forKey: Key.sets.rawValue)
    }
    
    required public convenience init?(coder: NSCoder) {
        let gotExerciseName = coder.decodeObject(forKey: Key.name.rawValue) as! String?
        let gotExerciseType = coder.decodeObject(forKey: Key.type.rawValue) as! String?
        let gotExerciseInfo = coder.decodeObject(forKey: Key.info.rawValue) as! String?
        let gotExerciseSets = coder.decodeObject(forKey: Key.sets.rawValue) as! [SetRepsWeights]?
        
        self.init(exerciseName: gotExerciseName!, exerciseType: gotExerciseType!, exerciseInfo: gotExerciseInfo!, exerciseSets: gotExerciseSets!)
    }
    
}


//Object Structure for List of Sets for an Exercise
public class SetRepsWeights: NSObject, NSCoding {
    
    var set: Int?
    var reps: Int?
    var weight: Int?
    var time: Double?
    var indexPath: IndexPath?
    
    enum Key:String{
        case set = "setNumber"
        case reps = "repsNumber"
        case weight = "weightNumber"
        case time = "timeNumber"
        case indexPath = "indexPathOfSet"
    }
    
    init(set:Int?, reps:Int?, weight:Int?, time: Double?, indexpath:IndexPath?){
        self.set = set
        self.reps = reps
        self.weight = weight
        self.time = time
        self.indexPath = indexpath
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(set, forKey: Key.set.rawValue)
        coder.encode(reps, forKey: Key.reps.rawValue)
        coder.encode(weight, forKey: Key.weight.rawValue)
        coder.encode(time, forKey: Key.time.rawValue)
        coder.encode(indexPath, forKey: Key.indexPath.rawValue)
    }
    
    required public convenience init?(coder: NSCoder) {
        let gotSet = coder.decodeObject(forKey: Key.set.rawValue) as! Int?
        let gotReps = coder.decodeObject(forKey: Key.reps.rawValue) as! Int?
        let gotWeight = coder.decodeObject(forKey: Key.weight.rawValue) as! Int?
        let gotTime = coder.decodeObject(forKey: Key.time.rawValue) as! Double?
        let gotIndexPath = coder.decodeObject(forKey: Key.indexPath.rawValue) as! IndexPath?
        
        self.init(set: gotSet, reps: gotReps, weight: gotWeight, time: gotTime, indexpath: gotIndexPath)
    }
    
}
