//
//  WorkoutView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
// MARK: Huw: 23 June 2025
//       added a fade in/out to the "Start Workout" using opacity.
                                                //   Line 123
                                                //   Line 20
                                                //   Line 65

import SwiftUI
import WorkoutKit

struct WorkoutView: View {
    //basic information
    @ObservedObject var workout: Workout
    @State var dismissBool:Bool = false
    @State var isWorkoutPreviewVisible = false
    
    // makes the "Start Workout" text fade in and out.
    @State private var isFaded = false

    //create a blank workout
    @State private var editingWorkout = Workout(name: "")
    @State private var isPresentingEditWorkoutView = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
            List {
                Section(header:Text("Overview")){
                    Label(workout.workoutDescription, systemImage:"info.circle")
                    Label(workout.type, systemImage:"questionmark.circle")
                    Label(" \(workout.formattedDuration)", systemImage:"timer")
                }
                
                Section(header:Text("Sets")){
                    /*
                     * Loop through and display the
                     * Activity Sets which can be
                     * clicked and edited
                     */
                    
                    ForEach (workout.activitySets.sorted(by:{$0.sortIndex < $1.sortIndex})){ workoutActivitySet in
                        NavigationLink{
                            ActivitySetView(activitySet:workoutActivitySet)
                        } label:{
                            ActivitySetListView(activitySet:workoutActivitySet)
                        }
                        
                    }
                    
                }
                Section{ // display if no Sets are availble.
                    if(workout.activitySets.count == 0){
                        Text("Click edit to add workout sets").font(.subheadline)
                    }else{
                        VStack {
                            NavigationLink{
                                WorkoutTimerView(viewModel: WorkoutTimer(workout:workout))
                            }label:{
                                Text("Start Workout")
                                    .opacity(isFaded ? 0.2 : 1.0)
                            }
                            .font(.headline)
                        }
                        Button("Preview in WorkoutKit", systemImage: "stopwatch"){
                            //Navigate to workout screen here
                            workout.plan =  WorkoutPlan(.custom(workout.exportToWorkoutKit()))
                            
                            isWorkoutPreviewVisible = true
                        }
                        .font(.headline)
                        NavigationLink{
                            WorkoutQRView(workout: workout)
                        }label:
                        {Text("Share with others")
                        }.font(.headline)
                    }
                }
                
                
            }
            .navigationTitle(workout.name)
            .toolbar{
                ToolbarItem(placement:.confirmationAction){
                    Button("Edit"){
                        //we don't want to pass the whole object here
                        editingWorkout.clone(of:workout)
                        isPresentingEditWorkoutView = true
                        
                    }
                }
            }
            
            
        }
            
        }
        .workoutPreview(workout.plan, isPresented: $isWorkoutPreviewVisible).sheet(isPresented: $isPresentingEditWorkoutView){
            NavigationStack{
                WorkoutEditView(workout:editingWorkout, originalWorkout:workout, deletedWorkout:$dismissBool)
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
        }.onChange(of: dismissBool) { oldValue, newValue in
            if newValue {
                dismissBool = false
                dismiss()
            }
        }.onAppear{
            //set up the callbacks so we are notified of any edits
            workout.bindChildren()
            
            // 3 seconds then fade in and out animation.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isFaded = true
                }
            }
        }

    }
}

#Preview {
    WorkoutView(workout:Workout.sampleData)
}
