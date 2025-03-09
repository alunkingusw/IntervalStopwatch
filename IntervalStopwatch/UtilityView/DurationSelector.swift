//
//  DurationSelector.swift
//  IntervalStopwatch
//
//  Created by Alun King on 08/03/2025.
//

import SwiftUI

struct DurationSelector: View {
    @Binding var durationInt:Int
    @State private var durationString:String
    private var units:[String] = ["seconds","minutes"]
    @State private var selection:String
    init(durationInt: Binding<Int>) {
        self._durationInt = durationInt
        if durationInt.wrappedValue % 60 == 0{
            selection = "minutes"
            //display the string as minutes
            self.durationString = String((durationInt.wrappedValue / 60))
        }else{
            selection = "seconds"
            self.durationString = String(durationInt.wrappedValue)
        }
    }
    
    var body: some View {
            HStack {
                TextField("Duration", text: $durationString)
                    .keyboardType(.numberPad)
                    .onChange(of: durationString) {
                        updateDurationInt()
                    }
                Spacer()
                Picker("Units", selection: $selection) {
                    ForEach(self.units, id: \.self) { unit in
                        Text("\(unit)")
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selection) {
                    updateDurationInt()
                }
            }
        }

        private func updateDurationInt() {
            if let value = Int(durationString) {
                if selection == "minutes" {
                    durationInt = value * 60
                } else {
                    durationInt = value
                }
            } else {
                durationInt = 0
            }
        }
}

#Preview {
    DurationSelector(durationInt:.constant(600))
}
