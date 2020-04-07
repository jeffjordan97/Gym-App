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
            
        if hoursMinsSeconds.0 < 9 {
            formatHours = "0"+String(hoursMinsSeconds.0)
        } else { formatHours = String(hoursMinsSeconds.0) }
            
        if hoursMinsSeconds.1 < 9 {
            formatMins = "0"+String(hoursMinsSeconds.1)
        } else { formatMins = String(hoursMinsSeconds.1) }
            
        if hoursMinsSeconds.2 < 9 {
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
    
    
}
    
