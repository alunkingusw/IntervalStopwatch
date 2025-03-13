//
//  ActivitySetListView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftUI

struct ActivityListView: View {
    var activity:Activity
    
    var body: some View {
        VStack{
            HStack{
                Text(activity.name)
                Spacer()
                HStack{
                    Image(systemName:"timer")
                    Text(activity.formattedTime)
                }.accessibilityLabel("The activity time")
            }
            
            //Text("\(activitySet.activitySetDescription)")
            
                
                
            
        }
    }
}



#Preview(traits: .sizeThatFitsLayout) {
    ActivityListView(
        activity:
            Activity.sampleData
            )
}
