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
        NavigationView{
            VStack{
                Form{
                    Section(header:Text("Workout")){
                        TextField("Name", text:$workout.name)
                        
                        TextField("Description", text:$workout.workoutDescription)
                        Picker(selection:$workout.type, label:Text("Workout Type")){
                            ForEach(WorkoutTypes.allCases){ menuOption in
                                Text(menuOption.rawValue).tag(menuOption)
                                
                            }
                        }.pickerStyle(.navigationLink)
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
                                        .padding(.trailing, 8).accessibilityLabel("Image indicating drag to move")
                                    ActivitySetListView(activitySet:workoutActivitySet)
                                    /*Button(action: {
                                     print("work needed here")
                                     }) {
                                     Image(systemName:"minus.circle.fill").foregroundStyle(.red).padding(.leading, 10)
                                     }.accessibilityLabel("Delete Activity Set")*/
                                }
                            }.onDelete(perform: deleteActivitySet).onMove(perform:moveActivitySet)
                        }
                        HStack {
                            TextField("New Activity Set", text: $newActivitySetName)
                            Button(action: {
                                withAnimation {
                                    let activitySet = ActivitySet(name: newActivitySetName, sortIndex:workout.activitySets.count)
                                    activitySet.parentWorkout = workout
                                    workout.activitySets.append(activitySet)
                                    newActivitySetName = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill").accessibilityLabel("Add activity set (disabled until a name is entered)")
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
