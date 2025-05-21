//
//  WorkoutTimer.swift
//  IntervalStopwatch
//
//  Created by Alun King on 05/04/2025.
// This class takes a workout instance and provides
// the necessary fields for it to be displayed and played
// through as a workout on screen.

import Foundation
import Combine
import SwiftUI

class WorkoutTimer: ObservableObject {
    @Published var currentSetIndex = 0
    @Published var currentRep = 1
    @Published var currentActivityIndex = 0
    @Published var timeRemaining = 0
    @Published var isRunning = false
    @Published var isFinished = false

    let workout: Workout
    private var timer: Timer?
    
    var currentSet: ActivitySet? {
        guard currentSetIndex < workout.activitySets.count else { return nil }
        return workout.sortedActivitySets[currentSetIndex]
    }

    var currentActivity: Activity? {
        guard let set = currentSet, currentActivityIndex < set.activities.count else { return nil }
        return set.sortedActivities[currentActivityIndex]
    }

    init(workout: Workout) {
        self.workout = workout
        prepareNextActivity()
    }

    func start() {
        guard !isFinished else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.tick()
        }
    }

    func pause() {
        timer?.invalidate()
        isRunning = false
    }

    func reset() {
        timer?.invalidate()
        isRunning = false
        isFinished = false
        currentSetIndex = 0
        currentRep = 1
        currentActivityIndex = 0
        prepareNextActivity()
    }

    func tick() {
        guard timeRemaining > 0 else {
            nextActivity()
            return
        }
        timeRemaining -= 1
    }

    private func prepareNextActivity() {
        if let activity = currentActivity {
            timeRemaining = activity.duration
        } else {
            finishWorkout()
        }
    }

    private func nextActivity() {
        guard let set = currentSet else {
            finishWorkout()
            return
        }

        if currentActivityIndex + 1 < set.activities.count {
            currentActivityIndex += 1
        } else if currentRep < set.reps {
            currentActivityIndex = 0
            currentRep += 1
        } else {
            currentSetIndex += 1
            currentRep = 1
            currentActivityIndex = 0
        }

        if currentSetIndex >= workout.activitySets.count {
            finishWorkout()
        } else {
            prepareNextActivity()
        }
    }

    private func finishWorkout() {
        timer?.invalidate()
        isRunning = false
        isFinished = true
    }
}
