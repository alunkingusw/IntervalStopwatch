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
    //create a blank workout
    @State private var editingWorkout = Workout(name:"")
    @State private var isPresentingEditWorkoutView = false
    
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
                            NavigationLink{
                                ActivitySetView(activitySet:workoutActivitySet)
                            } label:{
                                ActivitySetListView(activitySet:workoutActivitySet)
                            }
                            
                        }
                        
                    }
                    Section{
                        if(workout.activitySets.count == 0){
                            Text("Click edit to add workout sets").font(.subheadline)
                        }else{
                            Button("Start Workout", systemImage: "timer"){
                                //Navigate to workout screen here
                            }
                            .font(.headline)
                        }
                    }
                    
                    
                }
                .navigationTitle(workout.name)
                .toolbar{
                    ToolbarItem(placement:.confirmationAction){
                        Button("Edit"){
                            //we don't want to pass the whole object here
                            editingWorkout.clone(originalWorkout:workout)
                            isPresentingEditWorkoutView = true
                            
                        }
                    }
                }
                
            
            
            
        }.sheet(isPresented: $isPresentingEditWorkoutView){
            NavigationStack{
                WorkoutEditView(workout:$editingWorkout)
                    .toolbar{
                        ToolbarItem(placement:.confirmationAction){
                            Button("Save"){
                                isPresentingEditWorkoutView = false
                                workout.save(editedWorkout:editingWorkout)
                                
                            }
                        }
                        ToolbarItem(placement:.cancellationAction){
                            Button("Cancel"){
                                isPresentingEditWorkoutView = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    WorkoutView(workout:Workout.sampleData)
}
