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

struct ActivityEditView: View {
    //basic information
    @Binding var activity:Activity
    @State private var type:String = ActivityType.work.rawValue
    /*
     * Form specific information.
     * When the user saves, we convert the
     * duration to seconds and save it.
     */
    @State var duration:String = ""
    
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header:Text("Activity Information")){
                    TextField("Name", text:$activity.name)
                    Picker(selection: $activity.type, label:Text("Activity Type")) {
                        ForEach(ActivityType.allCases){ type in
                            Text(type.rawValue).tag(type)
                        }
                    }.pickerStyle(.segmented)
                    
                    DurationSelector(seconds:$activity.duration)
                    
                }
                Section(header:Text("Optional Information")){
                    TextField("Description", text:$activity.activityDescription)
                }
                /*
                Section(header:Text("Re-use previous activity")){
                    
                    ScrollView{
                        
                    }
                }*/
            }
        }
    }
}

#Preview {
    ActivityEditView(activity:.constant(Activity.sampleData))
}
