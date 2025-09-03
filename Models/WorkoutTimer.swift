//
//  WorkoutTimer.swift
//  IntervalStopwatch
//
//  Created by Alun King on 05/04/2025.
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
// This class takes a workout instance and provides
// the necessary fields for it to be displayed and played
// through as a workout on screen.

import AVFoundation
import Foundation


class WorkoutTimer: ObservableObject {
    @Published var currentSetIndex = 0
    @Published var currentRep = 1
    @Published var currentActivityIndex = 0
    @Published var timeRemaining = 0
    @Published var isRunning = false
    @Published var isFinished = false
    @Published var manualActivity:Bool = false
    // audio
    let synthesizer = AVSpeechSynthesizer()
    

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
        //also check for manual activities here
        guard timeRemaining > 0 || currentActivity?.duration == -1 else {
            nextActivity()
            return
        }
        // it's 31 so that it clicks to 30 half way through the sentence.
        if timeRemaining == 31 {
            //MARK: change
            speak("Thirty Seconds left!")
        }
        if currentActivity?.duration == -1{
            timeRemaining += 1
        }else{
            timeRemaining -= 1
        }
    }
    
    /**
        This function is called when the activity has loaded, this just sets up the related time and any other UI bits if needed
     */
    private func prepareNextActivity() {
        if let activity = currentActivity {
            //check if this is a manual activity
            if activity.duration == -1{
                timeRemaining = 0
            }else{
                timeRemaining = activity.duration
            }
        } else {
            finishWorkout()
        }
    }

    func nextActivity() {
        guard let set = currentSet else {
            //MARK: change
            speak("Finished!")
            finishWorkout()
            return
        }

        if currentActivityIndex + 1 < set.activities.count {
            //MARK: change
            speak("Next Activity!")
            currentActivityIndex += 1
        } else if currentRep < set.reps {
            //MARK: change
            speak("next rep!")
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
    //MARK: change by Huw
    // adds a countdown voice timer
    private func speak(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
   
       
}


