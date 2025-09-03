//
//  SampleData.swift
//  IntervalStopwatch
//
//  Created by Alun King on 10/03/2025.
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
import WorkoutKit

//sample data for the previews
extension Workout{
    static let sampleData: Workout = Workout(name:"Example workout", workoutDescription: "Example description of a workout", type:"Wheelchair", activitySets: [
        ActivitySet(
            name:"Example Set",
            activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
            reps:2,
            activities:[
                Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:10),
                Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:30),
                Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:60),
                Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:30),
            ]),
        ActivitySet(
            name:"Another Set",
            activitySetDescription:"More description",
            reps:3,
            activities:[
                Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:120),
                Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:60),
                Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:120),
                Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:60),
            ])
    ])
    static let multipleSampleData: [Workout] = [
        Workout(name:"Example workout",
                workoutDescription: "Example description of a workout",
                type:"Running",
                activitySets: [
                    ActivitySet(
                        name:"Example Set",
                        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
                        reps:2,
                        activities:[
                            Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:60),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:30),
                            Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:60),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:30),
                        ]),
                    ActivitySet(
                        name:"Another Set",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:120),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:60),
                            Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:120),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:60),
                        ])
                ]),
        Workout(name:"Another workout",
                workoutDescription: "HIIT Class",
                type:"HIIT",
                activitySets: [
                    ActivitySet(
                        name:"Warm up",
                        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
                        reps:2,
                        activities:[
                            Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:10),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:30),
                            Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:60),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:30),
                        ]),
                    ActivitySet(
                        name:"Workout Set",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:120),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:180),
                            Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:120),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:180),
                        ]),
                    ActivitySet(
                        name:"Cool Down",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:120),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:60),
                            Activity(name:"Sit ups", type:ActivityType.rest.rawValue, duration:60),
                            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:60),
                        ])
                ])
        ]
    
    
        static func createSimpleWorkout() -> CustomWorkout {
            // Warmup step.
            let warmupStep = WorkoutStep()
            
            // Block 1.
            let block1 = workoutBlockOne()
            
            // Block 2.
            let block2 = workoutBlockTwo()

            // Cooldown step.
            let cooldownStep = WorkoutStep(goal: .time(5, .minutes))
            
            return CustomWorkout(activity: .other,
                                 location: .outdoor,
                                 displayName: "Example Workout",
                                 warmup: warmupStep,
                                 blocks: [block1, block2],
                                 cooldown: cooldownStep)
        }
        
        static func workoutBlockOne() -> IntervalBlock {
            // Work step 1.
            var workStep1 = IntervalStep(.work)
            workStep1.step.goal = .time(2, .minutes)

            // Recovery step.
            var recoveryStep1 = IntervalStep(.recovery)
            recoveryStep1.step.goal = .time(2, .minutes)
            
            return IntervalBlock(steps: [workStep1, recoveryStep1],
                                 iterations: 4)
        }
        
        static func workoutBlockTwo() -> IntervalBlock {
            // Work step 2.
            var workStep2 = IntervalStep(.work)
            workStep2.step.goal = .time(2, .minutes)

            // Recovery step.
            var recoveryStep2 = IntervalStep(.recovery)
            recoveryStep2.step.goal = .time(30, .seconds)
            
            // Block with two iterations.
            return IntervalBlock(steps: [workStep2, recoveryStep2],
                                 iterations: 2)
        }
}

extension ActivitySet{
    static var sampleData:ActivitySet = ActivitySet(
        name:"Example Set",
        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
        reps:2,
        activities:[
            Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:40),
            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:50),
            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:-1),
            Activity(name:"Sit ups", type:ActivityType.work.rawValue, duration:60),
            Activity(name:"Rest", type:ActivityType.rest.rawValue, duration:70),
        ])
}


extension Activity{
    static let sampleData:Activity = Activity(name:"Push ups", type:ActivityType.work.rawValue, duration:60)
}
