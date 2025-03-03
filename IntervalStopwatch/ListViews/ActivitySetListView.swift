//
//  ActivitySetListView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivitySetListView: View {
    var activitySet:ActivitySet
    
    var body: some View {
        VStack{
            HStack{
                Text(activitySet.name)
                Spacer()
                HStack{
                    Image(systemName:"timer")
                    Text(activitySet.formattedDuration)
                } 
            }.font(.headline)
            HStack{
                Text("\(activitySet.activities.count) activities")
                
                Spacer()
                Text("\(activitySet.reps) x \(activitySet.formattedRepDuration)")
            }
            //Text("\(activitySet.activitySetDescription)")
            
                
                
            
        }
    }
}



#Preview(traits: .sizeThatFitsLayout) {
    ActivitySetListView(
        activitySet:ActivitySet(
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
