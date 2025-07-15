# Workout Timer View Documentation

---

## Variables

```swift
@StateObject var viewModel: WorkoutTimer
```

The view initialised a view model object to run the timer and monitor workout progress. See futher details in WorkoutTimer (under construction).

---

## Timer Ready/ Workout Complete

```swift

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
            // ... the activity ring and start button 
            }
```

A SwiftUI if-else statement decides whether a minimalist "Wokout Complete" screen, or The interval timer is displayed.

---

## Activity Ring

```swift
// The ring adds the first part of the ring to accommodate the fact that it does not complete on
                // the last activity.
                // We could bind a bool to the ring so when the start button is pressed, the +x is added to
                // the ring.
                ActivityRing(activitiesCompleted: $viewModel.currentActivityIndex, totalActivities: viewModel.currentSet?.activities.count ?? 0, width: 40)
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
```

The activity ring documentation is located in file ActivityRing (under construction). The ring requres:

- __activitiesCompleted:__ Ticks up as activities are completed (Sets 4/-).
- __totalActivities:__ The total amount of activites to be completed (Sets -/4).
- __width:__ The thickness of the ring.

__Note:__ Currently the ring does not complete before resetting to the next activity.

The ring is a visual representation of the user's workout progress.

---

## Rep Indicator Dot

```swift

RepDotIndicator(currentRep: viewModel.currentRep - 1, totalReps: Int(viewModel.currentSet?.reps ?? 0))

```

The Dot Indicator documentation can be found here (under construction). The widget uses the same concept as the ring but is visualised by a row of dots instead of a progress ring.

It requires:

- the current rep - minus one,
- and total reps.

### Accompanying Text

```swift
Text("Set \(viewModel.currentSetIndex + 1) of \(viewModel.workout.activitySets.count)")
    .font(.title2)
```

The text below the dots help to reinforce the rep count. it visualises the current rep / total reps.

---

## Start/Pause Buttons

```swift
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
```

The conditional determines whether the start button or the pause button should be displayed.

The Start button holds a second conditional that determines if it is a "Start" or a "Finish" button.

---

## onAppear/onDisappear

```swift
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
    
```

The onAppear modifier has a idle screen timer boolean set to disabled. This stops the device from drifting into sleep mode or locking the screen while the user exercises.

The onDisappear modifier pauses the timer until the view is popped off the navigation stack, and also enables the idle screeen timer.

---

## TimeString Func

```swift
func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
```

this function accepts the time and converts it to a  string so that it can be displayed in a Text() widget.

[Return to Top](#workout-timer-view-documentation)