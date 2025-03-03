//
//  Workout.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class Workout:ObservableObject{
    var name:String
    var workoutDescription:String
    
    @Transient var duration:Int = 0
    @Transient var formattedDuration:String = ""
    @Relationship var activitySets:[ActivitySet]{didSet{
        calculateWorkoutDuration()
    }}
    
    init(
        name: String = "Workout",
        workoutDescription: String = "",
        activitySets: [ActivitySet] = []
    ) {
        self.name = name
        self.workoutDescription = workoutDescription
        self.activitySets = activitySets
        
        self.calculateWorkoutDuration()
    }
    
    @Transient private func calculateWorkoutDuration() {
            var totalDuration = 0
            for activity in activitySets {
                totalDuration += activity.duration
            }
        //before we complete the total, save the pre-rep duration
        formattedDuration = Workout.formatDuration(forDuration: totalDuration)
        
    }
    
    @Transient static func formatDuration(forDuration:Int) -> String{
            var returnVal: String = ""

            if forDuration > 3600 {
                let hours = (Int(forDuration / 3600))
                returnVal += (String(format: "%02d:", hours))
            }
            var remainingDuration = forDuration % 3600
            if remainingDuration >= 60 {
                let minutes = (Int(remainingDuration / 60))
                returnVal += (String(format: "%02d:", minutes))
            } else {
                returnVal += "00:"
            }
            remainingDuration = remainingDuration % 60
            if remainingDuration > 0 {
                returnVal += String(String(format: "%02d", remainingDuration))
            } else {
                returnVal += "00"
            }
            return returnVal
        }
}
