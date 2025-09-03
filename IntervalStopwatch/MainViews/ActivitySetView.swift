//
//  ActivitySetView.swift
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

struct ActivitySetView: View {
    @ObservedObject var activitySet:ActivitySet
    @State private var isPresentingEditActivitySetView = false
    @State private var editingActivitySet = ActivitySet(name:"")
    
    var body: some View {
        NavigationStack{
            List{
                Section(header:Text("Details")){                    
                    Label(activitySet.activitySetDescription,systemImage:"info.circle")
                    
                    
                    Label("\(activitySet.formattedRepDuration) x \(activitySet.reps) = \(activitySet.formattedDuration)", systemImage:"timer")
                    
                }
                Section(header:Text("Activities")){
                    /*
                     * Loop through and display the
                     * activities.
                     */
                    ForEach (activitySet.activities.sorted(by:{$0.sortIndex < $1.sortIndex})){  activity in
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
                            //Clone so we don't mess with Swift data's observing
                            editingActivitySet = ActivitySet.clone(of:activitySet)
                            isPresentingEditActivitySetView = true
                            
                        }
                    }
                }
        }.sheet(isPresented: $isPresentingEditActivitySetView){
            NavigationStack{
            ActivitySetEditView(activitySet:$editingActivitySet).toolbar{
                    ToolbarItem(placement:.confirmationAction){
                            Button("Save"){
                                isPresentingEditActivitySetView = false
                                activitySet.save(editedActivitySet:editingActivitySet)
                            }
                        }
                        ToolbarItem(placement:.cancellationAction){
                            Button("Cancel"){
                                isPresentingEditActivitySetView = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ActivitySetView(activitySet:ActivitySet.sampleData)
}
