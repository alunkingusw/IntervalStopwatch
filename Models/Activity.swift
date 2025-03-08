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
    var duration:Int { didSet{
        formattedTime = Workout.formatDuration(forDuration: duration)
    }}
    @Transient var formattedTime:String = ""
    
    init(
        name: String="Work",
        activityDescription: String = "",
        duration: Int = 60
    ) {
        self.name = name
        self.activityDescription = activityDescription
        self.duration = duration
        formattedTime = Workout.formatDuration(forDuration: duration)
    }
    
    func save(editedActivity:Activity){
        //copy over the edited information
        self.name = editedActivity.name
        self.activityDescription = editedActivity.activityDescription
        self.duration = editedActivity.duration
        
    }
    
    @Transient func clone(originalActivity:Activity){
        self.name = originalActivity.name
        self.activityDescription = originalActivity.activityDescription
        self.duration = originalActivity.duration
    }
}

extension Activity{
    static let sampleData:Activity = Activity(name:"Push ups", duration:60)
}
