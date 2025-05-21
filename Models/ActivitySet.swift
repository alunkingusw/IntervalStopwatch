//
//  ActivitySet.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
import SwiftData
import Foundation
import WorkoutKit

@Model
class ActivitySet:Identifiable, ObservableObject{
    var name:String
    var activitySetDescription:String
    var reps:Int8{didSet{
        calculateTotalDuration()
    }}
    var sortIndex:Int
    
    //var hasAutoRest:Bool
    //var autoRestDuration:Int
    var formattedDuration:String = ""
    var formattedRepDuration:String = ""
    var duration:Int = 0
    @Transient var sortedActivities: [Activity] {
        activities.sorted(by: { $0.sortIndex < $1.sortIndex })
    }
    
    @Relationship(deleteRule: .cascade) var activities:[Activity]{didSet{
        calculateTotalDuration()
    }}
    @Transient var updateCallback:()->Void = {}
    
    init(name: String = "Workout Set",
         activitySetDescription: String = "",
         reps: Int8 = 1,
         sortIndex:Int = 99,
         //hasAutoRest:Bool= false,
         //autoRestDuration:Int = 0,
         activities: [Activity] = [],
         updateCallback:@escaping ()->Void = {}
    ) {
        self.name = name
        self.activitySetDescription = activitySetDescription
        self.reps = reps
        self.activities = activities
        self.sortIndex = sortIndex
        self.updateCallback = updateCallback
        //self.hasAutoRest = hasAutoRest
        //self.autoRestDuration = autoRestDuration
        calculateTotalDuration()
    }
    
    func save(editedActivitySet:ActivitySet){
        self.name = editedActivitySet.name
        self.activitySetDescription = editedActivitySet.activitySetDescription
        self.reps = editedActivitySet.reps
        self.sortIndex = editedActivitySet.sortIndex
        self.activities = editedActivitySet.activities
        self.updateCallback = editedActivitySet.updateCallback
        self.calculateTotalDuration()
    }
    
    func calculateTotalDuration() {
            var totalDuration = 0
            for activity in activities {
                totalDuration += activity.duration
                /*if hasAutoRest{
                    totalDuration += autoRestDuration
                }*/
            }
        //before we complete the total, save the pre-rep duration
        formattedRepDuration = Workout.formatDuration(for: totalDuration)
        self.duration = totalDuration * Int(reps)
        formattedDuration = Workout.formatDuration(for: self.duration)
        }

    @Transient static func clone(of originalActivitySet:ActivitySet)->ActivitySet{
        //get the activities first to pass to the constructor
        var clonedActivities:[Activity] = []
        for originalActivity in originalActivitySet.activities {
            clonedActivities.append(Activity.clone(of: originalActivity))
        }
        
        let clonedActivitySet = ActivitySet(
            name:originalActivitySet.name,
            activitySetDescription:originalActivitySet.activitySetDescription,
            reps:originalActivitySet.reps,
            sortIndex:originalActivitySet.sortIndex,
            activities:clonedActivities,
            updateCallback:originalActivitySet.updateCallback
        )
        print (clonedActivitySet.name)
        //calculateTotalDuration() should be called on init()
        
        //self.hasAutoRest = hasAutoRest
        //self.autoRestDuration = autoRestDuration
        return clonedActivitySet
    }
    
    @Transient func exportToWorkoutKit() -> IntervalBlock{
        var steps:[IntervalStep] = []
        for activity in self.sortedActivities {
            steps.append(activity.exportToWorkoutKit())
        }
        return IntervalBlock(steps: steps, iterations:Int(self.reps))
    }
    
    
}

