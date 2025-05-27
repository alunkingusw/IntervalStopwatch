# Model

## Table of Contents

---

- [Model](#model)
  - [Table of Contents](#table-of-contents)
  - [SwiftData Models](#swiftdata-models)
    - [Activity Model](#activity-model)
      - [variables](#variables)
    - [Activity init](#activity-init)
    - [Save Function](#save-function)
    - [Clone Function](#clone-function)
    - [Export To WorkoutKit](#export-to-workoutkit)
    - [Enum](#enum)

## SwiftData Models

---

### Activity Model

#### variables

```swift
 var name:String
    var activityDescription:String
    var type:String
    var sortIndex:Int
    var duration:Int{didSet{
        self.formattedTime = Workout.formatDuration(for: duration)
        //if we have a parent, inform it that the duration of the activity has changed.
        parentActivitySet?.triggerUpdate()
    }}
    @Transient var updateCallback:()->Void = {}
    
    var formattedTime:String = ""

```

### Activity init

```swift
init(
        name: String="Work",
        activityDescription: String = "",
        type:String = ActivityType.work.rawValue,
        duration: Int = 60,
        sortIndex:Int = 99,
        updateCallback:@escaping ()->Void = {}
    ) {
        self.name = name
        self.activityDescription = activityDescription
        self.type = type
        self.duration = duration
        self.sortIndex = sortIndex
        self.updateCallback = updateCallback
        self.formattedTime = Workout.formatDuration(for: duration)
    }

```

### Save Function

```swift
    func save(editedActivity:Activity){
        self.name = editedActivity.name
        self.activityDescription = editedActivity.activityDescription
        self.type = editedActivity.type
        self.sortIndex = editedActivity.sortIndex
        self.duration = editedActivity.duration
        self.updateCallback = editedActivity.updateCallback
        self.formattedTime = Workout.formatDuration(for: self.duration)
    }
```

### Clone Function

```swift
 @Transient static func clone(of originalActivity:Activity)->Activity{
        let clonedActivity = Activity(
            name:originalActivity.name,
            activityDescription:originalActivity.activityDescription,
            type:originalActivity.type,
            duration:originalActivity.duration,
            sortIndex:originalActivity.sortIndex,
            updateCallback:originalActivity.updateCallback
        )
        //formatted time should be called from init()
        return clonedActivity
    }
```

### Export To WorkoutKit

```swift
  @Transient func exportToWorkoutKit()->IntervalStep{
        var workoutGoal:WorkoutGoal
        
        if self.duration < 0{
            workoutGoal = .open
        }else{
            workoutGoal = .time(Double(self.duration), .seconds)
        }
        let workoutStep = WorkoutStep(goal:workoutGoal, displayName: self.name)
        if self.type == ActivityType.work.rawValue{
            return IntervalStep(.work,step:workoutStep)
        }else{
            return IntervalStep(.recovery,step:workoutStep)
        }
    }
```

### Enum

```swift
enum ActivityType:String, CaseIterable, Identifiable{
    case work = "Work"
    case rest = "Rest"
    var id:String {self.rawValue}
}
```
