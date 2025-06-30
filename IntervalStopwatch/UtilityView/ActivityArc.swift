//
//  RepArc.swift
//  IntervalStopwatch
//
//  Created by Alun King on 17/06/2025. - obtained from Scrumdinger tutorial, Apple tutorials.
//

import SwiftUI

struct ActivitySegmentArcView: View {
    var activitySet: ActivitySet
    var currentActivityIndex: Int
    var thickness: CGFloat
    let gapDegrees: Double = 2.0
    private let degreesPerSecond: Double
    init(activitySet: ActivitySet, currentActivityIndex: Int, thickness: CGFloat) {
            self.activitySet = activitySet
            self.currentActivityIndex = currentActivityIndex
            self.thickness = thickness

            let total = activitySet.totalAdjustedDuration(manualDuration: 5)
            self.degreesPerSecond = total > 0 ? 360.0 / Double(total) : 0
        }
    var body: some View {
        ZStack {
            ForEach(0..<activitySet.sortedActivities.count, id: \.self) { index in
                let activity = activitySet.sortedActivities[index]
                SegmentArcShape(
                    startAngle: .degrees(segmentStart(index)),
                    endAngle: .degrees(segmentEnd(index)),
                    thickness: thickness
                )
                .stroke(style: StrokeStyle(lineWidth: thickness))
                .foregroundColor(activity.type == ActivityType.rest.rawValue ? .red: .blue).opacity(index <= currentActivityIndex ? 1 : 0.3)
            }
        }
    }
    
    private func segmentStart(_ index: Int) -> Double {
        return (degreesPerSecond * Double(activitySet.elapsedTime(upTo: index) + Int(gapDegrees)/2))
    }
    
    private func segmentEnd(_ index: Int) -> Double {
        return (degreesPerSecond * Double(activitySet.elapsedTime(upTo: index+1) + Int(gapDegrees)/2))
    }
}
struct SegmentArcShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var thickness: CGFloat

    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.width, rect.height)
        let radius = diameter / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path
    }
}


struct ActivityProgressArc: Shape {
    var progress: CGFloat // 0.0 to 1.0
    let insetBy:CGFloat
    let thickness: CGFloat
    

    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.width, rect.height) - (insetBy * 2)
        let radius = diameter / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()
        path.addArc(center: center,
                    radius: radius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(0 + (360 * Double(progress))),
                    clockwise: false)
        return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
    }
}
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct ActivityArcView: View {
    var activitySet: ActivitySet
    @Binding var currentActivityIndex: Int
    @Binding var timeRemaining: Int
    

    let segmentThickness: CGFloat = 16
    let timerThickness: CGFloat = 10

    var currentActivityDuration: Int {
        let activity = activitySet.sortedActivities[currentActivityIndex]
        return max(activity.duration, 1) // prevent divide-by-zero
    }

    var progress: CGFloat {
        1.0 - CGFloat(timeRemaining) / CGFloat(currentActivityDuration)
    }

    var body: some View {
        
        ZStack {
            // Outer segmented ring
            ActivitySegmentArcView(
                activitySet: activitySet,
                currentActivityIndex: currentActivityIndex,
                thickness: segmentThickness
            )
            .foregroundStyle(.clear) // background fill

            // Inner timer arc
            ActivityProgressArc(progress: progress, insetBy:segmentThickness, thickness: timerThickness)
                .foregroundColor(.green)
        }
    }
}



#Preview {
    // Preview with constant sample data
    ActivityArcView(activitySet: ActivitySet.sampleData, currentActivityIndex: .constant(1), timeRemaining:.constant(20))
}



// A reusable ring component to visually represent progress towards completion of the rep
struct ActivityRing: View {
    // counting the activities completed (eg. rep)
    @Binding var activitiesCompleted: Int
    // the total reps to complete
    var currentSet: ActivitySet
    @Binding var timeRemaining:Int
    // Width of the ring stroke
    let width: CGFloat
    
    var body: some View {
        ZStack {
            ZStack {
                let currentActivity = currentSet.sortedActivities[activitiesCompleted]
                let percentage = CGFloat(currentActivity.duration-timeRemaining) / (CGFloat(currentActivity.duration))
                let start = (CGFloat(activitiesCompleted-1) / CGFloat(currentSet.activities.count))
                // Background ring (static, low opacity)
                Circle()
                    .stroke(.green.opacity(0.3), lineWidth: width)
                //draw a segment for the activity in the set
                ForEach(Array(zip(currentSet.sortedActivities.indices, currentSet.sortedActivities)), id: \.0) { index, activity in
                    
                    if index <= activitiesCompleted{
                        
                        Circle()
                            .trim(from: CGFloat(index)/CGFloat(currentSet.activities.count),
                                  to: CGFloat(index+1)/CGFloat(currentSet.activities.count))
                            .stroke(
                                Color.gray,
                                style: StrokeStyle(lineWidth: width, lineCap: .round)
                            )
                        
                    }
                }.overlay{
                    /* Inner ring showing actual progress, changing every second*/
                    
                    Circle()
                        .trim(from: 0, to: percentage)
                        .stroke(.green, style: StrokeStyle(lineWidth: width-10, lineCap: .round))
                        .rotationEffect(Angle(degrees: 0)) // Start progress from the top use -90
                    // Adds depth
                        .animation(.easeOut(duration: 0.8), value: activitiesCompleted) // how long the amination will take in seconds. This could be a variable that is passed and can be the duration of the workout.
                }
            }
        }.rotationEffect(Angle(degrees:-90))
    }
}


extension ActivitySet {
    // Returns the total duration of all activities before the specified index.
    // Manual activities (duration == -1) count as a default duration.
    // - Parameters:
    //   - index: The index up to which durations should be summed (not inclusive).
    //   - manualDuration: The assumed duration to allocate for manual activities (default: 5 seconds).
    // - Returns: The elapsed time in seconds.
    func elapsedTime(upTo index: Int, manualDuration: Int = 5) -> Int {
        guard index > 0 else { return 0 }

        return sortedActivities.prefix(index).reduce(0) { total, activity in
            total + (activity.duration == -1 ? manualDuration : activity.duration)
        }
    }
    
    func totalAdjustedDuration(manualDuration: Int = 5) -> Int {
            sortedActivities.reduce(0) { total, activity in
                total + (activity.duration == -1 ? manualDuration : activity.duration)
            }
        }
}
