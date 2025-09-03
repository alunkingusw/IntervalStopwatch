//
//  WorkoutTimerView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 11/05/2025.
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
// This view shows the timer at the top for the workout.

import SwiftUI

struct WorkoutTimerView: View {
    @StateObject var viewModel: WorkoutTimer
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isFinished {
                Text("Workout Complete!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            } else {
                Text(viewModel.currentActivity?.activityDescription ?? "")
                    .font(.subheadline)
                
                Text(viewModel.currentActivity?.type ?? "")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                
                
                // the ring.
                ActivityArcView( activitySet: viewModel.currentSet ?? ActivitySet(), currentActivityIndex: $viewModel.currentActivityIndex, timeRemaining:$viewModel.timeRemaining)
                    .overlay {
                        VStack {
                            Text(viewModel.currentActivity?.name ?? "No Activity")
                                .font(.title)
                            Text(timeString(from: viewModel.timeRemaining))
                                .font(.system(size: 60, weight: .bold, design: .monospaced))
                            if(viewModel.currentActivity?.duration == -1){
                                Button("Next") { viewModel.nextActivity() }
                                    .buttonStyle(.borderedProminent)
                            }
                        }
                        .accessibilityElement(children: .combine)
                    }
                    .padding()
                RepDotIndicator(currentRep: viewModel.currentRep - 1, totalReps: Int(viewModel.currentSet?.reps ?? 0))
                
                
                Text("Set \(viewModel.currentSetIndex + 1) of \(viewModel.workout.activitySets.count)")
                    .font(.title2)
                
                // changes the start/pause button
                if viewModel.isRunning {
                    Button() { viewModel.pause() }
                    label: {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.blue)
                            .frame(width: 100, height: 60)
                            .overlay(
                                Text("Pause")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.white))
                    }
                } else {
                    Button() {
                        if viewModel.isFinished {
                            viewModel.reset()
                        } else {
                            viewModel.start()
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.green)
                            .frame(width: 100, height: 60)
                            .overlay(
                                Text(viewModel.isFinished ? "Finish" : "Start")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(.white))
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // stop the screen from sleeping durng workout.
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            //MARK: change by Huw
            // stops the timer as it will continue to run in the background
            viewModel.pause()
            // enables the screen sleep mode again.
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
#Preview {
    WorkoutTimerView(viewModel: WorkoutTimer(workout:Workout.sampleData))
}
