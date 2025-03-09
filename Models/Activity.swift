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
        formattedTime = Workout.formatDuration(forDuration: duration)
    }}
    
    var formattedTime:String = ""
    
    init(
        name: String="Work",
        activityDescription: String = "",
        duration: Int = 60,
        sortIndex:Int = 99
    ) {
        self.name = name
        self.activityDescription = activityDescription
        self.duration = duration
        self.sortIndex = sortIndex
        self.formattedTime = Workout.formatDuration(for: duration)
    }
    
    func save(editedActivity:Activity){
        self.name = editedActivity.name
        self.activityDescription = editedActivity.activityDescription
        self.sortIndex = editedActivity.sortIndex
        self.duration = editedActivity.duration
        self.formattedTime = Workout.formatDuration(for: duration)
    }
    
    @Transient func clone(of originalActivity:Activity){
        self.name = originalActivity.name
        self.activityDescription = originalActivity.activityDescription
        self.duration = originalActivity.duration
        self.sortIndex = originalActivity.sortIndex
    }
}

extension Activity{
    static let sampleData:Activity = Activity(name:"Push ups", duration:60)
}
