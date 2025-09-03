//
//  RepDotIndicator.swift
//  IntervalStopwatch
//
//  Created by Alun King on 18/06/2025.
//
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
