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

struct DurationSelector: View {
    private enum TimingOptions:String, CaseIterable, Identifiable {
        case manual = "Manual"
        case timed = "Timed"
        var id:String {self.rawValue}
    }
    
    @Binding public var seconds: Int
    
    private let minutesArray = [Int](0...59)
    private let secondsArray = [Int](0...59)
    private let secondsInMinute:Int = 60
    
    @State private var timingType:TimingOptions = TimingOptions.manual
    @State private var minuteSelection = 1
    @State private var secondSelection = 0
    
    var body: some View {
        
        VStack{
            Picker(selection:$timingType, label:Text("Timing")){
                ForEach(TimingOptions.allCases){ menuOption in
                    Text(menuOption.rawValue).tag(menuOption)
                    
                }}.pickerStyle(.menu).onChange(of:timingType){
                    if timingType==TimingOptions.manual{
                        seconds = -1
                    }else{
                        //set seconds to a default value
                        seconds = totalInSeconds
                    }
                }
            if(!(timingType==TimingOptions.manual)){
                HStack(spacing: 0) {
                    
                    Picker(selection: self.$minuteSelection, label: Text("")) {
                        ForEach(0 ..< self.minutesArray.count,id:\.self) { index in
                            Text("\(self.minutesArray[index]) m").tag(index)
                        }
                    }.pickerStyle(.wheel)
                        .onChange(of: self.minuteSelection) {
                            seconds = totalInSeconds
                        }
                    
                    
                    Picker(selection: self.self.$secondSelection, label: Text("")) {
                        ForEach(0 ..< self.secondsArray.count,id:\.self) { index in
                            Text("\(self.secondsArray[index]) s").tag(index)
                        }
                    }.pickerStyle(.wheel)
                        .onChange(of: self.secondSelection) {                    seconds = totalInSeconds
                        }
                    
                }
                
                
            }
        }
        .onAppear(perform: {
            updatePickers()
        })
    }
    
    func updatePickers() {
        if(seconds != -1){
            timingType = .timed
            minuteSelection = Int(seconds/60)
            secondSelection = seconds%60
        }
        
    }
    
    var totalInSeconds: Int {
        return minuteSelection *     self.secondsInMinute + secondSelection
    }
}
#Preview {
    DurationSelector(seconds:.constant(600))
}
