//
//  SampleData.swift
//  IntervalStopwatch
//
//  Created by Alun King on 10/03/2025.
//

//sample data for the previews
extension Workout{
    static let sampleData: Workout = Workout(name:"Example workout", workoutDescription: "Example description of a workout", activitySets: [
        ActivitySet(
            name:"Example Set",
            activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
            reps:2,
            activities:[
                Activity(name:"Push ups", duration:60),
                Activity(name:"Rest", duration:30),
                Activity(name:"Sit ups", duration:60),
                Activity(name:"Rest", duration:30),
            ]),
        ActivitySet(
            name:"Another Set",
            activitySetDescription:"More description",
            reps:3,
            activities:[
                Activity(name:"Push ups", duration:120),
                Activity(name:"Rest", duration:60),
                Activity(name:"Sit ups", duration:120),
                Activity(name:"Rest", duration:60),
            ])
    ])
    static let multipleSampleData: [Workout] = [
        Workout(name:"Example workout",
                workoutDescription: "Example description of a workout",
                activitySets: [
                    ActivitySet(
                        name:"Example Set",
                        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
                        reps:2,
                        activities:[
                            Activity(name:"Push ups", duration:60),
                            Activity(name:"Rest", duration:30),
                            Activity(name:"Sit ups", duration:60),
                            Activity(name:"Rest", duration:30),
                        ]),
                    ActivitySet(
                        name:"Another Set",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", duration:120),
                            Activity(name:"Rest", duration:60),
                            Activity(name:"Sit ups", duration:120),
                            Activity(name:"Rest", duration:60),
                        ])
                ]),
        Workout(name:"Another workout",
                workoutDescription: "HIIT Class",
                activitySets: [
                    ActivitySet(
                        name:"Warm up",
                        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
                        reps:2,
                        activities:[
                            Activity(name:"Push ups", duration:60),
                            Activity(name:"Rest", duration:30),
                            Activity(name:"Sit ups", duration:60),
                            Activity(name:"Rest", duration:30),
                        ]),
                    ActivitySet(
                        name:"Workout Set",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", duration:120),
                            Activity(name:"Rest", duration:180),
                            Activity(name:"Sit ups", duration:120),
                            Activity(name:"Rest", duration:180),
                        ]),
                    ActivitySet(
                        name:"Cool Down",
                        activitySetDescription:"More description",
                        reps:3,
                        activities:[
                            Activity(name:"Push ups", duration:120),
                            Activity(name:"Rest", duration:60),
                            Activity(name:"Sit ups", duration:60),
                            Activity(name:"Rest", duration:60),
                        ])
                ])
        ]
}

extension ActivitySet{
    static var sampleData:ActivitySet = ActivitySet(
        name:"Example Set",
        activitySetDescription:"Warm up for everyone doing the workout and this is what happens when the string is really long",
        reps:2,
        activities:[
            Activity(name:"Push ups", duration:60),
            Activity(name:"Rest", duration:30),
            Activity(name:"Sit ups", duration:60),
            Activity(name:"Rest", duration:30),
        ])
}


extension Activity{
    static let sampleData:Activity = Activity(name:"Push ups", duration:60)
}
