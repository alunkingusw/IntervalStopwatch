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
                } .accessibilityLabel("The total activity set time")
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
        activitySet:ActivitySet.sampleData)
}
