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
                Text(String(activity.type.first ?? Character(""))).frame(width:35, height:35) // Optional padding inside the rectangle
                    .background(
                        RoundedRectangle(cornerRadius: 8) // Adjust cornerRadius as needed
                            .fill(backgroundColor(for:activity.type)) // Change to your desired background color
                    )
                    .foregroundColor(foregroundColor(for:activity.type)) // Change to your desired letter color
                    .bold()// Optional: Adjust the font size
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
    func backgroundColor(for activityType: String) -> Color {
            switch activityType {
            case ActivityType.rest.rawValue:
                return Color.yellow
            case ActivityType.work.rawValue:
                return Color.red
            default:
                return Color.gray // Default color
            }
        }

        func foregroundColor(for activityType: String) -> Color {
            switch activityType {
            case ActivityType.rest.rawValue:
                return Color.black
            case ActivityType.work.rawValue:
                return Color.white
            default:
                return Color.gray // Default color
            }
        }
}



#Preview(traits: .sizeThatFitsLayout) {
    ActivityListView(
        activity:
            Activity.sampleData
            )
}
