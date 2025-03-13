//
//  ActivitySetListView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct WorkoutListView: View {
    var workout:Workout
    
    var body: some View {
        VStack{
            HStack{
                Text(workout.name)
                Spacer()
                HStack{
                    Image(systemName:"timer")
                    Text(workout.formattedDuration)
                }.accessibilityLabel("The total workout time")
            }.font(.headline)
            HStack{
                Text("\(workout.activitySets.count) sets")
                
                Spacer()
                
            }
            //Text("\(activitySet.activitySetDescription)")
            
                
                
            
        }
    }
}



#Preview(traits: .sizeThatFitsLayout) {
    WorkoutListView(
        workout:Workout.sampleData)
}
