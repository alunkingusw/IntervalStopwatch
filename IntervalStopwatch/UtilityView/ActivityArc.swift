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
    let gapDegrees: Double = 1
    let manualTime: Int //length of manual activity to make up correct proportion
    private let degreesPerSecond: Double
    init(activitySet: ActivitySet, currentActivityIndex: Int, thickness: CGFloat) {
        self.activitySet = activitySet
        self.currentActivityIndex = currentActivityIndex
        self.thickness = thickness
        //work out the total time without manual activities
        let totalWithoutManual = activitySet.totalAdjustedDuration(manualDuration: 0)
        let manualCount =
        activitySet.totalManualActivities()
        if(manualCount > 0){
            let timedProportion:Double = 1 - (Double(activitySet.totalManualActivities())/Double(activitySet.activities.count))
            let virtualTotal = Int(Double(totalWithoutManual)/timedProportion)
            self.degreesPerSecond = virtualTotal > 0 ? 360.0 / Double(virtualTotal) : 0
            self.manualTime =  (virtualTotal-totalWithoutManual) / activitySet.totalManualActivities()
        }else{
            self.degreesPerSecond = totalWithoutManual > 0 ? 360.0 / Double(totalWithoutManual) : 0
            self.manualTime = 0
        }
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
                .foregroundColor(activity.type == ActivityType.rest.rawValue ? .orange: .cyan).opacity(index <= currentActivityIndex ? 1 : 0.3)
            }
        }
    }
    
    private func segmentStart(_ index: Int) -> Double {
        return (degreesPerSecond * (Double(activitySet.elapsedTime(upTo: index, manualDuration: manualTime)) + gapDegrees/2))
    }
    
    private func segmentEnd(_ index: Int) -> Double {
        return (degreesPerSecond * (Double(activitySet.elapsedTime(upTo: index+1, manualDuration: manualTime)) - gapDegrees/2))
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
    

    let segmentThickness: CGFloat = 20
    let timerThickness: CGFloat = 20

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
            ActivityProgressArc(progress: progress, insetBy:segmentThickness+5, thickness: timerThickness)
                .foregroundColor(.green)
        }.rotationEffect(Angle(degrees: -90))
    }
}



#Preview {
    // Preview with constant sample data
    ActivityArcView(activitySet: ActivitySet.sampleData, currentActivityIndex: .constant(1), timeRemaining:.constant(20))
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
    
    //returns the total time of the activities, accounting for the manual duration being 5 seconds.
    func totalAdjustedDuration(manualDuration: Int = 5) -> Int {
            sortedActivities.reduce(0) { total, activity in
                total + (activity.duration == -1 ? manualDuration : activity.duration)
            }
        }
    
    //calculate the percentage of manual activities to help draw the correct sized ring
    func totalManualActivities() -> Int {
            let manualCount = activities.filter { $0.duration == -1 }.count
            return manualCount
        }
}
