//
//  WorkoutView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct WorkoutView: View {
    //basic information
    @ObservedObject var workout:Workout
    
    @State var description:String = ""
    
    var body: some View {
        NavigationStack{
            List{
                Section(header:Text("Overview")){
                    
                    
                    Label(workout.workoutDescription, systemImage:"info.circle")
                    
                    Label(" \(workout.formattedDuration)", systemImage:"timer")
                    
                }
                
                Section(header:Text("Sets")){
                    /*
                     * Loop through and display the
                     * Activity Sets which can be
                     * clicked and edited
                     */
                    ForEach (workout.activitySets){ workoutActivitySet in
                        ActivitySetListView(activitySet:workoutActivitySet)
                        
                    }
                }
                Section{
                    Button("Start Workout", systemImage: "timer"){
                        //Navigate to workout screen here
                    }
                    .font(.headline)
                    
                    
                    
                }
            }.navigationTitle(workout.name)
        }
    }
}

#Preview {
    WorkoutView(workout:Workout(name:"Example workout", workoutDescription: "Example description of a workout that spans more than one line of text", activitySets: [
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
