//
//  Activity.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import Foundation
import SwiftData

@Model
class Activity:ObservableObject{
    var name:String
    var activityDescription:String
    var sortIndex:Int
    var duration:Int{didSet{
        self.formattedTime = Workout.formatDuration(for: duration)
        //if we have a parent, inform it that the duration of the activity has changed.
        parentActivitySet?.triggerUpdate()
    }}
    var parentActivitySet:ActivitySet?
    var formattedTime:String = ""
    
    init(
        name: String="Work",
        activityDescription: String = "",
        duration: Int = 60,
        sortIndex:Int = 99,
        parent:ActivitySet? = nil
    ) {
        self.name = name
        self.activityDescription = activityDescription
        self.duration = duration
        self.sortIndex = sortIndex
        self.parentActivitySet = parent
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
    
    @Transient func clone(of originalActivity:Activity){
        self.name = originalActivity.name
        self.activityDescription = originalActivity.activityDescription
        self.duration = originalActivity.duration
        self.sortIndex = originalActivity.sortIndex
        self.updateCallback = originalActivity.updateCallback
        self.formattedTime = Workout.formatDuration(for: self.duration)
    }
}

extension Activity{
    static let sampleData:Activity = Activity(name:"Push ups", duration:60, updateCallback: {})
}
