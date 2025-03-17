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
            seconds=60
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
