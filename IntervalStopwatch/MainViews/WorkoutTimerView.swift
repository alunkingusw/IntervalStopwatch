//
//  WorkoutTimerView.swift
//  IntervalStopwatch
//
//  Created by Alun King on 11/05/2025.
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
                
                Circle()
                    .strokeBorder(lineWidth: 24)
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
                    .overlay  {
                        ActivityArc(activityIndex: viewModel.currentActivityIndex, totalActivities: viewModel.currentSet?.activities.count ?? 0)
                                .rotation(Angle(degrees: -90))//ensures circle starts at the top
                                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round)).foregroundStyle(.green)
                    }
                    .padding(.horizontal)
                RepDotIndicator(currentRep: viewModel.currentRep-1, totalReps: Int(viewModel.currentSet?.reps ?? 0))


                Text("Set \(viewModel.currentSetIndex + 1) of \(viewModel.workout.activitySets.count)")
                

                HStack {
                    if viewModel.isRunning {
                        Button("Pause") { viewModel.pause() }
                            .buttonStyle(.borderedProminent)
                    } else {
                        Button(viewModel.isFinished ? "Restart" : "Start") {
                            if viewModel.isFinished {
                                viewModel.reset()
                            } else {
                                viewModel.start()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .padding()
        .onDisappear {
            //MARK: change by Huw
            // stops the timer as it will continue to run in the background
            viewModel.pause()
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
