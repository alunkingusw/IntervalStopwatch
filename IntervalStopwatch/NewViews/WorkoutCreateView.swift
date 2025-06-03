//
//  WorkoutView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
// Workout Type picker is on line 33
//

import SwiftData
import SwiftUI

struct WorkoutCreateView: View {
    //basic information
    @StateObject var workout: Workout = Workout(name: "", workoutDescription: "")
    // swiftdata context
    @Environment(\.modelContext) var modelContext
    // used in cancel button
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        NavigationStack{
            Form{
                // Section with name and description.
                Section(header: Text("Workout")) {
                    
                    TextField("Name", text: $workout.name)
                    TextField("Description", text: $workout.workoutDescription)
                    
                    // Workout type picker
                    Picker(selection: $workout.type, label:Text("Workout Type")){
                        ForEach(WorkoutTypes.allCases){ menuOption in
                            Text(menuOption.rawValue).tag(menuOption)
                            
                        }
                    }.pickerStyle(.navigationLink)
                }
                
                Section(header:Text("Save the workout to create sets")){
                    
                }
                
            }// cancel button
            .toolbar{
                ToolbarItem(placement:.cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                }// save button
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
