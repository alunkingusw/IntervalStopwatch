//
//  ActivitySetView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivitySetView: View {
    @ObservedObject var activitySet:ActivitySet
    @State var name:String=""
    @State var description:String=""
    @State var reps:Int = 1
    @State var newActivityName = ""
    
    var body: some View {
        NavigationStack{
            Form{
                Section(header:Text("Activity Set ")){
                    TextField("Name", text:$name)
                    
                    TextField("Description", text:$description)
                    Picker("Reps", selection:$reps){
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
                    List ($activitySet.activities, id:\.self, editActions:.all){  $activity in
                        ActivityListView(activity: activity)
                    }
                    HStack {
                        TextField("New Activity", text: $newActivityName)
                        Button(action: {
                            withAnimation {
                                let activity = Activity(name: newActivityName, duration:60)
                                activitySet.activities.append(activity)
                                newActivityName = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newActivityName.isEmpty)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ActivitySetView(activitySet:ActivitySet(
        name:"Example Set",
        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
        reps:2,
        activities:[
            Activity(name:"Push ups", duration:60),
            Activity(name:"Rest", duration:30),
            Activity(name:"Sit ups", duration:60),
            Activity(name:"Rest", duration:30),
        ]))
}
