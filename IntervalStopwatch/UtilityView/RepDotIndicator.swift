//
//  RepDotIndicator.swift
//  IntervalStopwatch
//
//  Created by Alun King on 18/06/2025.
//
import SwiftUI

struct RepDotIndicator: View {
    let currentRep: Int        // 0-based index of current rep
    let totalReps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalReps, id: \.self) { index in
                ZStack {
                    // Black background dot
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.primary)

                    // Green foreground dot for completed + current reps
                    if index <= currentRep {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
}
