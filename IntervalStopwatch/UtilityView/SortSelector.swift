//
//  SortSelector.swift
//  IntervalStopwatch
//
//  Created by Alun King on 10/03/2025.
//

import SwiftUI



struct SortSelector: View {
    enum SortBy:String {
        case name = "Name"
        case duration = "Duration"
        case sets = "Sets"
    }
    
    
    @Binding var orderAscending:Bool
    @Binding var orderBy: String
    
    @State var orderAscendingSelection:String = "arrow.up"{
        didSet{
            orderAscending = orderAscendingSelection == "arrow.down"
        }
    }
    
    private var orderAscendingOptions: [String] = ["arrow.up", "arrow.down"]
    private var orderByOptions: [String] = ["Name", "Duration", "Sets"]
    
    
    public init(orderAscending: Binding<Bool>, orderBy: Binding<String>) {
        self._orderAscending = orderAscending
        self._orderBy = orderBy
    }
    
    var body: some View {
        HStack {
            Picker("Field", selection:$orderBy) {
                ForEach(self.orderByOptions, id: \.self) { unit in
                    Text(unit)
                }
            }
            .pickerStyle(.segmented)

            Picker("Order", selection: $orderAscendingSelection) {
                ForEach(self.orderAscendingOptions, id: \.self) { unit in
                    
                    Image(systemName: unit)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
    }
}

