//
//  WorkoutView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct WorkoutEditView: View {
    //basic information
    @ObservedObject var workout:Workout
    @State var name:String = ""
    @State var description:String = ""
    
    var body: some View {
        Form{
            Section(header:Text("Workout")){
                TextField("Name", text:$name)
            
                TextField("Description", text:$description)
                HStack{
                    Image(systemName:"timer")
                    Text(" \(workout.formattedDuration)")
                }
                
            }
            Section(header:Text("Sets")){
                /*
                 * Loop through and display the
                 * Activity Sets which can be
                 * clicked and edited
                 */
                List (workout.activitySets){ workoutActivitySet in
                    ActivitySetListView(activitySet:workoutActivitySet)
                    
                }
            }
            
        }
    }
}

#Preview {
    WorkoutEditView(workout:Workout(name:"Example workout", workoutDescription: "Example description of a workout", activitySets: [
        ActivitySet(
            name:"Example Set",
            activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
            reps:2,
            activities:[
                Activity(name:"Push ups", duration:60),
                Activity(name:"Rest", duration:30),
                Activity(name:"Sit ups", duration:60),
                Activity(name:"Rest", duration:30),
            ]),
        ActivitySet(
            name:"Another Set",
            activitySetDescription:"More description",
            reps:3,
            activities:[
                Activity(name:"Push ups", duration:120),
                Activity(name:"Rest", duration:60),
                Activity(name:"Sit ups", duration:120),
                Activity(name:"Rest", duration:60),
            ])
    ]))
}
