//
//  ActivitySetListView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//
/*
 * Copyright 2025 Alun King
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
