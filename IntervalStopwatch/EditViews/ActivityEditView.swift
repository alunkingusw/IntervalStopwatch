//
//  ActivityView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivityEditView: View {
    //basic information
    @ObservedObject var activity:Activity
    
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
                    DurationSelector(durationInt:$activity.duration)
                }
                Section(header:Text("Optional Information")){
                    TextField("Description", text:$activity.activityDescription)
                }
                Section(header:Text("Re-use previous activity")){
                    
                    ScrollView{
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityEditView(activity:Activity.sampleData)
}
