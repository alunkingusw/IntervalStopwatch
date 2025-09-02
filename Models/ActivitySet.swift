//
//  ActivitySet.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
import SwiftData
import Foundation
import WorkoutKit
import SwiftUI

/// This ActivitySet is used to contain a collection of Activities. In this set, we can create a series of
/// Activities that run in a sequence, and repeat those activities if required by setting a rep number.
@Model
class ActivitySet:Identifiable, ObservableObject, Codable{
    var id=UUID()
    var name:String
    var activitySetDescription:String
    var reps:Int8
    var sortIndex:Int
    @Transient var parentWorkout:Workout?
    
    //var hasAutoRest:Bool
    //var autoRestDuration:Int
    var formattedDuration:String = ""
    var formattedRepDuration:String = ""
    var duration:Int = 0
    @Transient var sortedActivities: [Activity] {
        activities.sorted(by: { $0.sortIndex < $1.sortIndex })
    }
    
    func triggerUpdate() {
        calculateTotalDuration()
        parentWorkout?.calculateWorkoutDuration()
    }
    
    @Relationship(deleteRule: .cascade) var activities:[Activity]
    
    /// The coding keys are used for the Codable protocol to encode to JSON for QR code sharing
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case activitySetDescription
            case reps
            case sortIndex
            case activities
        }
    
    init(name: String = "Workout Set",
         activitySetDescription: String = "",
         reps: Int8 = 1,
         sortIndex:Int = 99,
         //hasAutoRest:Bool= false,
         //autoRestDuration:Int = 0,
         activities: [Activity] = [],
    ) {
        self.name = name
        self.activitySetDescription = activitySetDescription
        self.reps = reps
        self.activities = activities
        self.sortIndex = sortIndex
        //self.hasAutoRest = hasAutoRest
        //self.autoRestDuration = autoRestDuration
        calculateTotalDuration()
    }
    
    /// We manually define the decoder (and encoder, below) because an observable class does not
    /// conform with Codable
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        self.name = try container.decode(String.self, forKey: .name)
        self.activitySetDescription = try container.decode(String.self, forKey: .activitySetDescription)
        self.reps = try container.decode(Int8.self, forKey: .reps)
        self.sortIndex = try container.decode(Int.self, forKey: .sortIndex)
        self.activities = try container.decode([Activity].self, forKey: .activities)
                
        // Recompute derived values
        self.calculateTotalDuration()
        
        // Transient stays nil
        self.parentWorkout = nil
    }
    
    ///see comment for decoder above. This function manually encodes to JSON
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(activitySetDescription, forKey: .activitySetDescription)
        try container.encode(reps, forKey: .reps)
        try container.encode(sortIndex, forKey: .sortIndex)
        try container.encode(activities, forKey: .activities)
    }
    
    func save(editedActivitySet:ActivitySet){
        self.name = editedActivitySet.name
        self.activitySetDescription = editedActivitySet.activitySetDescription
        self.reps = editedActivitySet.reps
        self.sortIndex = editedActivitySet.sortIndex
        self.activities = editedActivitySet.activities
        self.calculateTotalDuration()
        triggerUpdate()
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
        )
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

