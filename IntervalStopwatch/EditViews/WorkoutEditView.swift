//
//  WorkoutView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct WorkoutEditView: View {
    //basic information
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var workout:Workout
    @State private var isShowingDeleteAlert = false
    @State var newActivitySetName = ""
    let originalWorkout:Workout
    @Environment(\.dismiss) var dismiss
    @Binding var deletedWorkout:Bool
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
                Section(header:Text("Sets - swipe to delete")){
                    /*
                     * Loop through and display the
                     * Activity Sets which can be
                     * dragged for delete and ordered
                     */
                    List {
                        ForEach(workout.activitySets.sorted(by: {$0.sortIndex < $1.sortIndex})){ workoutActivitySet in
                            HStack{
                                Image(systemName: "line.3.horizontal") // Sort handle
                                                                    .foregroundColor(.gray)
                                                                    .padding(.trailing, 8)
                                ActivitySetListView(activitySet:workoutActivitySet)
                                
                            }
                        }.onDelete(perform: deleteActivitySet).onMove(perform:moveActivitySet)
                    }
                    HStack {
                        TextField("New Activity Set", text: $newActivitySetName)
                        Button(action: {
                            withAnimation {
                                let activitySet = ActivitySet(name: newActivitySetName, sortIndex:workout.activitySets.count, updateCallback:workout.updateCallback)
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
                modelContext.delete(originalWorkout)
                deletedWorkout = true
                dismiss()
            }
        }
    }
    
    func deleteActivitySet(at offsets: IndexSet) {
        workout.activitySets.remove(atOffsets: offsets)
    }
    func moveActivitySet(from source: IndexSet, to destination: Int) {
        workout.activitySets.move(fromOffsets: source, toOffset: destination)
                recalculateSortIndexes()
            }
            
            func recalculateSortIndexes() {
                for (index, activitySet) in workout.activitySets.enumerated() {
                    activitySet.sortIndex = index
                }
            }
}

#Preview {
    WorkoutEditView(workout:Workout.sampleData, originalWorkout:Workout.sampleData, deletedWorkout:.constant(false))
}
