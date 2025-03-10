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
    
    var duration:Int = 0
    var formattedDuration:String = "00:00"
    @Relationship(deleteRule: .cascade) var activitySets:[ActivitySet]{didSet{
        calculateWorkoutDuration()
    }}
    //create a blank callback for use when the workout children update
    @Transient var updateCallback = {}
    
    init(
        name: String = "Workout",
        workoutDescription: String = "",
        activitySets: [ActivitySet] = []
    ) {
        self.name = name
        self.workoutDescription = workoutDescription
        self.activitySets = activitySets
        self.updateCallback = {self.calculateWorkoutDuration()}
        self.calculateWorkoutDuration()
    }
    
    
    
    func save(editedWorkout:Workout){
        //copy over the edited information
        self.name = editedWorkout.name
        self.workoutDescription = editedWorkout.workoutDescription
        self.activitySets = editedWorkout.activitySets
        self.calculateWorkoutDuration()
    }
    
    @Transient func clone(of originalWorkout:Workout){
        self.name = originalWorkout.name
        self.workoutDescription = originalWorkout.workoutDescription
        //loop through and clone the activity sets which avoids SwiftData observing
        self.activitySets = []
        for originalActivitySet in originalWorkout.activitySets {
            let clonedActivitySet = ActivitySet(updateCallback:{})
            clonedActivitySet.clone(of: originalActivitySet)
            self.activitySets.append(clonedActivitySet)
        }
        
        //self.activitySets = originalWorkout.activitySets
        self.calculateWorkoutDuration()
    }
    
    func calculateWorkoutDuration() {
            var totalDuration = 0
            for activitySet in activitySets {
                activitySet.calculateTotalDuration()
                totalDuration += activitySet.duration
            }
        //before we complete the total, save the pre-rep duration
        formattedDuration = Workout.formatDuration(for: totalDuration) 
    }
    
    @Transient static func formatDuration(for duration:Int) -> String{
            var returnVal: String = ""
            
            if duration > 3600 {
                let hours = (Int(duration / 3600))
                returnVal += (String(format: "%02d:", hours))
            }
            var remainingDuration = duration % 3600
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



//sample data for the previews
extension Workout{
    static let sampleData: Workout = Workout(name:"Example workout", workoutDescription: "Example description of a workout", activitySets: [
        ActivitySet(
            name:"Example Set",
            activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
            reps:2,
            activities:[
                Activity(name:"Push ups", duration:60, updateCallback: {}),
                Activity(name:"Rest", duration:30, updateCallback: {}),
                Activity(name:"Sit ups", duration:60, updateCallback: {}),
                Activity(name:"Rest", duration:30, updateCallback: {}),
            ], updateCallback:{}),
        ActivitySet(
            name:"Another Set",
            activitySetDescription:"More description",
            reps:3,
            activities:[
                Activity(name:"Push ups", duration:120, updateCallback: {}),
                Activity(name:"Rest", duration:60, updateCallback: {}),
                Activity(name:"Sit ups", duration:120, updateCallback: {}),
                Activity(name:"Rest", duration:60, updateCallback: {}),
            ], updateCallback:{})
    ])
    static let multipleSampleData: [Workout] = [
        Workout(name:"Example workout",
                workoutDescription: "Example description of a workout",
                activitySets: [
                    ActivitySet(
                        name:"Example Set",
                        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
                        reps:2,
                        activities:[
                            Activity(name:"Push ups", duration:60, updateCallback: {}),
                            Activity(name:"Rest", duration:30, updateCallback: {}),
                            Activity(name:"Sit ups", duration:60, updateCallback: {}),
                            Activity(name:"Rest", duration:30, updateCallback: {}),
                        ], updateCallback:{}),
                    ActivitySet(
                        name:"Another Set",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", duration:120, updateCallback: {}),
                            Activity(name:"Rest", duration:60, updateCallback: {}),
                            Activity(name:"Sit ups", duration:120, updateCallback: {}),
                            Activity(name:"Rest", duration:60, updateCallback: {}),
                        ], updateCallback:{})
                ]),
        Workout(name:"Another workout",
                workoutDescription: "HIIT Class",
                activitySets: [
                    ActivitySet(
                        name:"Warm up",
                        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
                        reps:2,
                        activities:[
                            Activity(name:"Push ups", duration:60, updateCallback: {}),
                            Activity(name:"Rest", duration:30, updateCallback: {}),
                            Activity(name:"Sit ups", duration:60, updateCallback: {}),
                            Activity(name:"Rest", duration:30, updateCallback: {}),
                        ], updateCallback:{}),
                    ActivitySet(
                        name:"Workout Set",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", duration:120, updateCallback: {}),
                            Activity(name:"Rest", duration:180, updateCallback: {}),
                            Activity(name:"Sit ups", duration:120, updateCallback: {}),
                            Activity(name:"Rest", duration:180, updateCallback: {}),
                        ], updateCallback:{}),
                    ActivitySet(
                        name:"Cool Down",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", duration:120, updateCallback: {}),
                            Activity(name:"Rest", duration:60, updateCallback: {}),
                            Activity(name:"Sit ups", duration:60, updateCallback: {}),
                            Activity(name:"Rest", duration:60, updateCallback: {}),
                        ], updateCallback:{})
                ])
        ]
}
