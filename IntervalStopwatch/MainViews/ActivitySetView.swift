//
//  ActivitySetView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivitySetView: View {
    @ObservedObject var activitySet:ActivitySet
    @State private var isPresentingEditActivitySetView = false
    @State private var editingActivitySet = ActivitySet(name:"")
    
    var body: some View {
        NavigationStack{
            List{
                Section(header:Text("Activity Set ")){
                    TextField("Name", text:$activitySet.name)
                    
                    TextField("Description", text:$activitySet.activitySetDescription)
                    Picker("Reps", selection:$activitySet.reps){
                        ForEach(1..<31){
                            if $0 > 1{
                                Text("\($0) reps")
                            }else{
                                Text("1 rep")
                            }
                        }
                    }
                    
                }
                Section(header:Text("Activities")){
                    /*
                     * Loop through and display the
                     * activities which can be
                     * clicked and edited
                     */
                    ForEach (activitySet.activities, id:\.self){  activity in
                        NavigationLink{
                            ActivityView(activity:activity)
                        } label:{
                            ActivityListView(activity:activity)
                        }
                        
                    }
                    if(activitySet.activities.count == 0){
                        Text("Click edit to add activities").font(.subheadline)
                    }
                }
                
            }.navigationTitle(activitySet.name)
                .toolbar{
                    ToolbarItem(placement:.confirmationAction){
                        Button("Edit"){
                            //we don't want to pass the whole object here
                            editingActivitySet.clone(originalActivitySet:activitySet)
                            isPresentingEditActivitySetView = true
                            
                        }
                    }
                }
        }.sheet(isPresented: $isPresentingEditActivitySetView){
            ActivitySetEditView(activitySet:activitySet)
        }
    }
}

#Preview {
    ActivitySetView(activitySet:ActivitySet.sampleData)
}
