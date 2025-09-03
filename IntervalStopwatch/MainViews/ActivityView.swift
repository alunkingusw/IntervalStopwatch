//
//  ActivityView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
/*
 * Copyright 2025 Alun King
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import SwiftUI

struct ActivityView: View {
    //basic information
    @ObservedObject var activity:Activity
    @State private var editingActivity = Activity(name:"")
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
                            editingActivity = Activity.clone(of:activity)
                            isPresentingEditActivityView = true
                            
                        }
                    }
                }
        }.sheet(isPresented: $isPresentingEditActivityView){
            NavigationStack{
                ActivityEditView(activity:$editingActivity)
                    .toolbar{
                        ToolbarItem(placement:.confirmationAction){
                            Button("Save"){
                                isPresentingEditActivityView = false
                                activity.save(editedActivity:editingActivity)
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
