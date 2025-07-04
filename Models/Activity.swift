//
//  Activity.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import Foundation
import SwiftData
import WorkoutKit


@Model
class Activity:Identifiable, ObservableObject{
    var id=UUID()
    var name:String
    var activityDescription:String
    var type:String
    var sortIndex:Int
    @Transient var parentActivitySet: ActivitySet?
    var duration:Int{didSet{
        self.formattedTime = Workout.formatDuration(for: duration)
        //if we have a parent, inform it that the duration of the activity has changed.
        print("updated duration")
        parentActivitySet?.triggerUpdate()
    }}
    
    var formattedTime:String = ""
    
    init(
        name: String="Work",
        activityDescription: String = "",
        type:String = ActivityType.work.rawValue,
        duration: Int = 60,
        sortIndex:Int = 99,
    ) {
        self.name = name
        self.activityDescription = activityDescription
        self.type = type
        self.duration = duration
        self.sortIndex = sortIndex
        self.formattedTime = Workout.formatDuration(for: duration)
    }
    
    func save(editedActivity:Activity){
        self.name = editedActivity.name
        self.activityDescription = editedActivity.activityDescription
        self.type = editedActivity.type
        self.sortIndex = editedActivity.sortIndex
        self.duration = editedActivity.duration
        self.formattedTime = Workout.formatDuration(for: self.duration)
        parentActivitySet?.triggerUpdate()
    }
    
    @Transient static func clone(of originalActivity:Activity)->Activity{
        let clonedActivity = Activity(
            name:originalActivity.name,
            activityDescription:originalActivity.activityDescription,
            type:originalActivity.type,
            duration:originalActivity.duration,
            sortIndex:originalActivity.sortIndex,
        )
        //formatted time should be called from init()
        return clonedActivity
    }
    
    @Transient func exportToWorkoutKit()->IntervalStep{
        var workoutGoal:WorkoutGoal
        
        if self.duration < 0{
            workoutGoal = .open
        }else{
            workoutGoal = .time(Double(self.duration), .seconds)
        }
        let workoutStep = WorkoutStep(goal:workoutGoal, displayName: self.name)
        if self.type == ActivityType.work.rawValue{
            return IntervalStep(.work,step:workoutStep)
        }else{
            return IntervalStep(.recovery,step:workoutStep)
        }
    }
    
    
}
enum ActivityType:String, CaseIterable, Identifiable{
    case work = "Work"
    case rest = "Rest"
    var id:String {self.rawValue}
}
