//
//  ActivityView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivityCreateView: View {
    //basic information
    @State var name:String=""
    @State var description:String=""
    //also need to have the duration
    
    /*
     * Form specific information.
     * When the user saves, we convert the
     * duration to seconds and save it.
     */
    @State var duration:String=""
    var units:[String] = ["seconds","minutes"]
    @State var selection:String = "seconds"
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header:Text("Activity Information")){
                    TextField("Name", text:$name)
                    HStack{
                        TextField("Duration", text:$duration).keyboardType(.numberPad)
                        Spacer()
                        Picker("Units", selection:$selection){
                            ForEach(self.units, id: \.self){ unit in
                                Text("\(unit)")
                            }
                        }.pickerStyle(.segmented)
                    }
                }
                Section(header:Text("Optional Information")){
                    TextField("Description", text:$description)
                }
            }
        }
    }
}

#Preview {
    ActivityCreateView()
}
