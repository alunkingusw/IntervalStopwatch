//
//  ContentView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var workouts:[Workout]
    @State private var isPresentingNewWorkoutView = false
    var body: some View {
        NavigationStack{
            //TODO: add sorting and searching here
            List (workouts){ workout in
                NavigationLink{
                    WorkoutView(workout:workout)
                }
                label:{WorkoutListView(workout:workout)
                }
            }.navigationTitle("Workouts")
                .toolbar {
                    ToolbarItem(placement:.confirmationAction){
                        Button(
                            action: addWorkout,
                            label:{
                                Image(systemName:"plus")
                            }
                        )
                    }
            }
                
        }.padding()
        .sheet(isPresented: $isPresentingNewWorkoutView){
            WorkoutCreateView()
        }
    }
    func addWorkout() {
        isPresentingNewWorkoutView = true
    }
}


#Preview {
    ContentView()
}
