//
//  GoalProgressModel.swift
//  gym-app
//
//  Created by Jeff Jordan on 07/04/2020.
//  Copyright © 2020 Jordan, Jeffrey. All rights reserved.
//

import Foundation

//object structure used to store a goal
public class GoalProgress: NSObject, NSCoding {
    
    var type: String?
    var startDate: Date?
    var endDate: Date?
    var notes: String?
    var startWeight: Int?
    var currentWeight: Int?
    var goalWeight: Int?
    var primaryGoal: Bool?
    var rating: Int?
    var isComplete: Bool?
    
    enum Key:String {
        case type = "type"
        case startDate = "startDate"
        case endDate = "endDate"
        case notes = "notes"
        case startWeight = "startWeight"
        case currentWeight = "currentWeight"
        case goalWeight = "goalWeight"
        case primaryGoal = "primaryGoal"
        case rating = "rating"
        case isComplete = "isComplete"
    }
    
    init(type:String, startDate:Date?, endDate:Date?, notes:String, startWeight:Int?, currentWeight:Int?, goalWeight:Int?, primaryGoal: Bool, rating: Int, isComplete:Bool){
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.startWeight = startWeight
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        self.primaryGoal = primaryGoal
        self.rating = rating
        self.isComplete = isComplete
    }
    
    //to encode into core data
    public func encode(with coder: NSCoder) {
        coder.encode(type, forKey: Key.type.rawValue)
        coder.encode(startDate, forKey: Key.startDate.rawValue)
        coder.encode(endDate, forKey: Key.endDate.rawValue)
        coder.encode(notes, forKey: Key.notes.rawValue)
        coder.encode(startWeight, forKey: Key.startWeight.rawValue)
        coder.encode(currentWeight, forKey: Key.currentWeight.rawValue)
        coder.encode(goalWeight, forKey: Key.goalWeight.rawValue)
        coder.encode(primaryGoal, forKey: Key.primaryGoal.rawValue)
        coder.encode(rating, forKey: Key.rating.rawValue)
        coder.encode(isComplete, forKey: Key.isComplete.rawValue)
    }
    
    //for decoding from core data
    required public convenience init?(coder: NSCoder) {
        let gotType = coder.decodeObject(forKey: Key.type.rawValue) as! String?
        let gotStartDate = coder.decodeObject(forKey: Key.startDate.rawValue) as! Date?
        let gotEndDate = coder.decodeObject(forKey: Key.endDate.rawValue) as! Date?
        let gotNotes = coder.decodeObject(forKey: Key.notes.rawValue) as! String?
        let gotStartWeight = coder.decodeObject(forKey: Key.startWeight.rawValue) as! Int?
        let gotCurrentWeight = coder.decodeObject(forKey: Key.currentWeight.rawValue) as! Int?
        let gotGoalWeight = coder.decodeObject(forKey: Key.goalWeight.rawValue) as! Int?
        let gotPrimaryGoal = coder.decodeObject(forKey: Key.primaryGoal.rawValue) as! Bool?
        let gotRating = coder.decodeObject(forKey: Key.rating.rawValue) as! Int?
        let gotIsComplete = coder.decodeObject(forKey: Key.isComplete.rawValue) as! Bool?
        
        self.init(type: gotType!, startDate: gotStartDate!, endDate: gotEndDate!, notes: gotNotes!, startWeight: gotStartWeight ,currentWeight: gotCurrentWeight, goalWeight: gotGoalWeight, primaryGoal: gotPrimaryGoal!, rating: gotRating!, isComplete:gotIsComplete!)
    }
    
}
