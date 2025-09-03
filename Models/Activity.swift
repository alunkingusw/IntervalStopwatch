//
//  Activity.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
/*
 * Copyright 2025 Alun King
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import Foundation
import SwiftData
import WorkoutKit


/// This is the basic activity class, where the actual activity within a workout is defined.
/// For example, we may want the user to do push ups, or sit ups, or rest and recover.
/// We define these actions here and either assign a specific time, or set it to manual
/// For manual, the user has the option of advancing to the next activity when they are ready.
@Model
class Activity:Identifiable, ObservableObject, Codable{
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
    
    
    /// The coding keys are used to encode to JSON which we need for the QR code sharing.
    enum CodingKeys:String, CodingKey{
        case name
        case activityDescription
        case type
        case sortIndex
        case duration
    }
    
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
    
    
    /// This is the manually defined decoder for JSON. The class does not automatically conform to codable
    /// because it is observable, so we define the decode (and encode, below) ourselves.
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.activityDescription = try container.decode(String.self, forKey: .activityDescription)
        self.type = try container.decode(String.self, forKey: .type)
        self.sortIndex = try container.decode(Int.self, forKey: .sortIndex)
        self.duration = try container.decode(Int.self, forKey: .duration)
                
        // Derived value
        self.formattedTime = Workout.formatDuration(for: duration)
                
        // Transient stays nil
        self.parentActivitySet = nil
    }
    
    /// See above comment on decode.. this func is used to manually encode to JSON.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(activityDescription, forKey: .activityDescription)
        try container.encode(type, forKey: .type)
        try container.encode(sortIndex, forKey: .sortIndex)
        try container.encode(duration, forKey: .duration)
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
