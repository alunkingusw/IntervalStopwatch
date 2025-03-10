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
    var reps:Int8{didSet{
        calculateTotalDuration()
    }}
    var sortIndex:Int
    
    //var hasAutoRest:Bool
    //var autoRestDuration:Int
    var formattedDuration:String = ""
    var formattedRepDuration:String = ""
    var duration:Int = 0
    
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
    
    func triggerUpdate(){
        
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

    @Transient func clone(of originalActivitySet:ActivitySet){
        self.name = originalActivitySet.name
        self.activitySetDescription = originalActivitySet.activitySetDescription
        self.reps = originalActivitySet.reps
        self.sortIndex = originalActivitySet.sortIndex
        self.updateCallback = originalActivitySet.updateCallback
        self.activities = []
        for originalActivity in originalActivitySet.activities {
            let clonedActivity = Activity(updateCallback:self.updateCallback)
            clonedActivity.clone(of: originalActivity)
            self.activities.append(clonedActivity)
        }
        self.updateCallback = originalActivitySet.updateCallback
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
            Activity(name:"Push ups", duration:60, updateCallback: {}),
            Activity(name:"Rest", duration:30, updateCallback: {}),
            Activity(name:"Sit ups", duration:60, updateCallback: {}),
            Activity(name:"Rest", duration:30, updateCallback: {}),
        ], updateCallback:{})
}
