//
//  Activity.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import Foundation
import SwiftData

@Model
class Activity:Identifiable, ObservableObject{
    var name:String
    var activityDescription:String
    var sortIndex:Int
    var duration:Int{didSet{
        self.formattedTime = Workout.formatDuration(for: duration)
        //if we have a parent, inform it that the duration of the activity has changed.
        parentActivitySet?.triggerUpdate()
    }}
    @Transient var updateCallback:()->Void = {}
    
    var formattedTime:String = ""
    
    init(
        name: String="Work",
        activityDescription: String = "",
        duration: Int = 60,
        sortIndex:Int = 99,
        updateCallback:@escaping ()->Void = {}
    ) {
        self.name = name
        self.activityDescription = activityDescription
        self.duration = duration
        self.sortIndex = sortIndex
        self.updateCallback = updateCallback
        self.formattedTime = Workout.formatDuration(for: duration)
    }
    
    func save(editedActivity:Activity){
        self.name = editedActivity.name
        self.activityDescription = editedActivity.activityDescription
        self.sortIndex = editedActivity.sortIndex
        self.duration = editedActivity.duration
        self.updateCallback = editedActivity.updateCallback
        self.formattedTime = Workout.formatDuration(for: self.duration)
    }
    
    @Transient static func clone(of originalActivity:Activity)->Activity{
        let clonedActivity = Activity(
            name:originalActivity.name,
            activityDescription:originalActivity.activityDescription,
            duration:originalActivity.duration,
            sortIndex:originalActivity.sortIndex,
            updateCallback:originalActivity.updateCallback
        )
        //formatted time should be called from init()
        return clonedActivity
    }
}
