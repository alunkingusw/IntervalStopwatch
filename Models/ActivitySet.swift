//
//  ActivitySet.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
import SwiftData
import Foundation

@Model
class ActivitySet:ObservableObject{
    var name:String
    var activitySetDescription:String
    var reps:Int8
    //var hasAutoRest:Bool
    //var autoRestDuration:Int
    @Transient var formattedDuration:String = ""
    @Transient var formattedRepDuration:String = ""
    @Transient var duration:Int = 0{didSet{
        //update the formattedDuration
        formattedDuration = Workout.formatDuration(forDuration:duration)
    }
    }
    @Relationship(deleteRule: .cascade) var activities:[Activity]{didSet{
        calculateTotalDuration()
    }}
    
    init(name: String = "Workout Set",
         activitySetDescription: String = "",
         reps: Int8 = 1,
         //hasAutoRest:Bool = false,
         //autoRestDuration:Int = 0,
         activities: [Activity] = []
    ) {
        self.name = name
        self.activitySetDescription = activitySetDescription
        self.reps = reps
        self.activities = activities
        //self.hasAutoRest = hasAutoRest
        //self.autoRestDuration = autoRestDuration
        calculateTotalDuration()
    }
    
    func save(editedActivitySet:ActivitySet){
        //copy over the edited information
        self.name = editedActivitySet.name
        self.activitySetDescription = editedActivitySet.activitySetDescription
        self.activities = editedActivitySet.activities
        self.calculateTotalDuration()
    }
    
    @Transient private func calculateTotalDuration() {
            var totalDuration = 0
            for activity in activities {
                totalDuration += activity.duration
                /*if hasAutoRest{
                    totalDuration += autoRestDuration
                }*/
            }
        //before we complete the total, save the pre-rep duration
        formattedRepDuration = Workout.formatDuration(forDuration: totalDuration)
        duration = totalDuration * Int(reps)
        }

    @Transient func clone(originalActivitySet:ActivitySet){
        self.name = originalActivitySet.name
        self.activitySetDescription = originalActivitySet.activitySetDescription
        self.reps = originalActivitySet.reps
        for originalActivity in originalActivitySet.activities {
            let clonedActivity = Activity()
            clonedActivity.clone(originalActivity: originalActivity)
            self.activities.append(clonedActivity)
        }
        //self.hasAutoRest = hasAutoRest
        //self.autoRestDuration = autoRestDuration
        calculateTotalDuration()
    }
    
    
    
}


extension ActivitySet{
    static var sampleData:ActivitySet = ActivitySet(
        name:"Example Set",
        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
        reps:2,
        activities:[
            Activity(name:"Push ups", duration:60),
            Activity(name:"Rest", duration:30),
            Activity(name:"Sit ups", duration:60),
            Activity(name:"Rest", duration:30),
        ])
}
