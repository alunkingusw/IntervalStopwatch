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
    var body: some View {
        NavigationStack {
            List (workouts){ workout in
                
            }.navigationTitle("Workouts").toolbar {
                Button(
                    action: addWorkout,
                    label:{
                        Image(systemName:"plus")
                    }
                )
            }
        }
        .padding()
    }
    func addWorkout() {
        let newWorkout = Workout()
        modelContext.insert(newWorkout)
    }
}


#Preview {
    ContentView()
}
