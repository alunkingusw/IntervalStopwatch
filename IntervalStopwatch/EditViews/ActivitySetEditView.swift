//
//  ActivitySetView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivitySetEditView: View {
    @Binding var activitySet:ActivitySet
    @State private var isShowingDeleteAlert = false
    //@Environment(\.dismiss) var dismiss
    
    @State var newActivityName = ""
    @State var newActivityDuration = 60
    var body: some View {
        NavigationStack{
            Form{
                Section(header:Text("Activity Set")){
                    TextField("Name", text:$activitySet.name)
                    
                    TextField("Description", text:$activitySet.activitySetDescription)
                    Stepper("\(activitySet.reps) reps", value:$activitySet.reps, in: 1...100)
                    
                    
                }
                Section(header:Text("Activities")){
                    /*
                     * Loop through and display the
                     * activities which can be
                     * clicked and edited
                     */
                    List {
                        ForEach($activitySet.activities, id:\.self, editActions:.all){
                            $activity in
                            HStack{
                                Image(systemName: "line.3.horizontal") // Sort handle
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8).accessibilityLabel("Image indicating drag to move")
                                ActivityListView(activity: activity)
                                /*Button(action: {
                                    print("work needed here")
                                }) {
                                    Image(systemName:"minus.circle.fill").foregroundStyle(.red).padding(.leading, 10)
                                }.accessibilityLabel("Delete Activity Set")*/
                            }
                        }.onDelete(perform: deleteActivity).onMove(perform:moveActivity)
                    }
                    VStack{
                        HStack {
                            TextField("New Activity", text: $newActivityName)
                            
                            Button(action: {
                                withAnimation {
                                    let activity = Activity(
                                        name:newActivityName,
                                        duration:newActivityDuration,
                                        sortIndex:activitySet.activities.count,
                                        updateCallback:activitySet.updateCallback
                                    )
                                    activitySet.activities.append(activity)
                                    newActivityName = ""
                                    newActivityDuration = 60
                                }
                            }) {
                                Image(systemName: "plus.circle.fill").accessibilityLabel("Add activity (disabled until a name is entered)")
                            }
                            .disabled(newActivityName.isEmpty)
                        }
                        DurationSelector(durationInt:$newActivityDuration).opacity(newActivityName.isEmpty ? 0 : 1)
                    }
                }
                
            }
        }
    }
    func deleteActivity(at offsets: IndexSet) {
        activitySet.activities.remove(atOffsets: offsets)
    }
    func moveActivity(from source: IndexSet, to destination: Int) {
        activitySet.activities.move(fromOffsets: source, toOffset: destination)
                recalculateSortIndexes()
            }
            
            func recalculateSortIndexes() {
                for (index, activitySet) in activitySet.activities.enumerated() {
                    activitySet.sortIndex = index
                }
            }
}

#Preview {
    ActivitySetEditView(activitySet:.constant(ActivitySet.sampleData))
}
