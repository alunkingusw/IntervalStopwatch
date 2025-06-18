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
