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
    @State var editingDuration:String = ""
    //also need to have the duration
    
    /*
     * Form specific information.
     * When the user saves, we convert the
     * duration to seconds and save it.
     */
    
    var units:[String] = ["seconds","minutes"]
    @State var selection:String = "seconds"
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header:Text("Activity Information")){
                    TextField("Name", text:$activity.name)
                    HStack{
                        //TODO: Note that we are not saving the duration properly here, this needs sorting.
                        TextField("Duration", text:$editingDuration).keyboardType(.numberPad)
                        Spacer()
                        Picker("Units", selection:$selection){
                            ForEach(self.units, id: \.self){ unit in
                                Text("\(unit)")
                            }
                        }.pickerStyle(.segmented)
                    }
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
    ActivityView(activity:Activity.sampleData)
}
