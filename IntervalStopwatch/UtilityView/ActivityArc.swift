//
//  RepArc.swift
//  IntervalStopwatch
//
//  Created by Alun King on 17/06/2025. - obtained from Scrumdinger tutorial, Apple tutorials.
//

import SwiftUI

struct ActivityArc: Shape {
    let activityIndex: Int
    let totalActivities: Int
    let gapDegrees: Double = 10.0

    private var degreesPerActivity: Double {
        360.0 / Double(totalActivities)
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)

        for i in 0..<activityIndex {
            let startDeg = degreesPerActivity * Double(i) + gapDegrees / 2
            let endDeg = degreesPerActivity * Double(i + 1) - gapDegrees / 2

            path.addArc(center: center,
                        radius: radius,
                        startAngle: Angle(degrees: startDeg),
                        endAngle: Angle(degrees: endDeg),
                        clockwise: false)
        }

        // Optionally, draw the current activity arc
        if activityIndex < totalActivities {
            let startDeg = degreesPerActivity * Double(activityIndex) + gapDegrees / 2
            let endDeg = degreesPerActivity * Double(activityIndex + 1) - gapDegrees / 2

            path.addArc(center: center,
                        radius: radius,
                        startAngle: Angle(degrees: startDeg),
                        endAngle: Angle(degrees: endDeg),
                        clockwise: false)
        }

        return path
    }
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
                
                // Background ring (static, low opacity)
                Circle()
                    .stroke(.green.opacity(0.3), lineWidth: width)
                
                // Foreground ring showing actual progress
                Circle()
                    .trim(from: 0, to: CGFloat(activitiesCompleted) / CGFloat(currentSet.activities.count))
                    .stroke(.green, style: StrokeStyle(lineWidth: width, lineCap: .round))
                    .rotationEffect(Angle(degrees: 90)) // Start progress from the top use -90
                    .shadow(radius: 6) // Adds depth
                    .animation(.easeOut(duration: 0.8), value: activitiesCompleted) // how long the amination will take in seconds. This could be a variable that is passed and can be the duration of the workout.
            }
        }
    }
}

#Preview {
    // Preview with constant sample data
    ActivityRing(activitiesCompleted: .constant(100), currentSet: ActivitySet.sampleData, timeRemaining:.constant(20), width:40)
}

