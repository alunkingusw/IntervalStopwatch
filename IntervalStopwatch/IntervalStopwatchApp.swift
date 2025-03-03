//
//  IntervalStopwatchApp.swift
//  IntervalStopwatch
//
//  Created by Alun King on 24/02/2025.
//

import SwiftData
import SwiftUI

@main
struct IntervalStopwatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for:[Activity.self,ActivitySet.self, Workout.self])
    }
}
