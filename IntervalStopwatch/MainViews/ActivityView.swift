//
//  ActivityView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivityView: View {
    //basic information
    @ObservedObject var activity:Activity
    @State private var editingActivity = Activity(name:"", updateCallback: {})
    //also need to have the duration
    @State var isPresentingEditActivityView:Bool = false
    
    
    var body: some View {
        NavigationStack{
            List{
                
                Label("\(activity.formattedTime)", systemImage: "timer")
                    
                
                
                Label("\(activity.activityDescription)", systemImage: "info.circle")
                
                
            }.navigationTitle(activity.name)
                .toolbar{
                    ToolbarItem(placement:.confirmationAction){
                        Button("Edit"){
                            //we don't want to pass the whole object here
                            editingActivity.clone(of:activity)
                            isPresentingEditActivityView = true
                            
                        }
                    }
                }
        }.sheet(isPresented: $isPresentingEditActivityView){
            NavigationStack{
                ActivityEditView(activity:editingActivity)
                    .toolbar{
                        ToolbarItem(placement:.confirmationAction){
                            Button("Save"){
                                isPresentingEditActivityView = false
                                activity.save(editedActivity:editingActivity)
                                activity.updateCallback()
                            }
                        }
                        ToolbarItem(placement:.cancellationAction){
                            Button("Cancel"){
                                isPresentingEditActivityView = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ActivityView(activity:Activity.sampleData)
}
