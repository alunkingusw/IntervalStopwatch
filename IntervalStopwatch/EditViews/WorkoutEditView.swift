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
    @State private var isShowingDeleteAlert = false
    @State var newActivitySetName = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            Form{
                Section(header:Text("Workout")){
                    TextField("Name", text:$workout.name)
                    
                    TextField("Description", text:$workout.workoutDescription)
                    HStack{
                        Image(systemName:"timer")
                        Text(" \(workout.formattedDuration)")
                    }
                    
                }
                Section(header:Text("Sets - swipe to remove or copy")){
                    /*
                     * Loop through and display the
                     * Activity Sets which can be
                     * clicked and edited
                     */
                    List (workout.activitySets){ workoutActivitySet in
                        
                        ActivitySetListView(activitySet:workoutActivitySet)
                        
                        
                    }
                    HStack {
                        TextField("New Activity Set", text: $newActivitySetName)
                        Button(action: {
                            withAnimation {
                                let activitySet = ActivitySet(name: newActivitySetName, sortIndex:workout.activitySets.count)
                                workout.activitySets.append(activitySet)
                                newActivitySetName = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newActivitySetName.isEmpty)
                    }
                    
                }
                
                
                
                
            }
            Spacer()
            Button("Delete Workout", role:.destructive){
                //Navigate to workout screen here
                isShowingDeleteAlert = true
            }
        }.confirmationDialog(
            Text("This will remove your entire workout!"),
            isPresented: $isShowingDeleteAlert,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                
            }
        }
    }
}

#Preview {
    WorkoutEditView(workout:Workout.sampleData)
}
