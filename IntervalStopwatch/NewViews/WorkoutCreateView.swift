//
//  WorkoutView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftData
import SwiftUI

struct WorkoutCreateView: View {
    //basic information
    @StateObject var workout:Workout = Workout(name:"", workoutDescription: "")
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header:Text("Workout")){
                    
                    
                    TextField("Name", text:$workout.name)
                    TextField("Description", text:$workout.workoutDescription)
                    
                }
                
                Section(header:Text("Save the workout to create sets")){
                    
                }
                
            }.toolbar{
                ToolbarItem(placement:.cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement:.confirmationAction){
                    Button("Save"){
                        modelContext.insert(workout)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WorkoutCreateView()
}
