import SwiftData
import WorkoutKit
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State var searchText = ""
    @State var orderAscending = true
    @State var orderBy = "Name"
    @Query var workouts: [Workout]
    @State private var isPresentingNewWorkoutView = false
    @State var orderAscendingSelection: String = "arrowtriangle.up"
    @State private var path = NavigationPath()

    private var orderAscendingOptions: [String] = ["arrowtriangle.up", "arrowtriangle.down"]
    private var orderByOptions: [String] = ["Name", "Duration", "Sets"]

    var sortedWorkouts: [Workout] {
        workouts.sorted { workout1, workout2 in
            let ascending = orderAscending
            switch orderBy {
            case "Name":
                return ascending ? workout1.name < workout2.name : workout1.name > workout2.name
            case "Duration":
                return ascending ? workout1.duration < workout2.duration : workout1.duration > workout2.duration
            case "Sets":
                return ascending ? workout1.activitySets.count < workout2.activitySets.count : workout1.activitySets.count > workout2.activitySets.count
            default:
                return ascending ? workout1.name < workout2.name : workout1.name > workout2.name
            }
        }
    }

    var body: some View {
        NavigationStack(path:$path) {
            VStack {
                HStack {
                    Picker("Field", selection: $orderBy) {
                        ForEach(self.orderByOptions, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(.segmented).accessibilityLabel("Sort by field")

                    Picker("Order", selection: $orderAscendingSelection) {
                        ForEach(self.orderAscendingOptions, id: \.self) { unit in
                            Image(systemName: unit)
                        }
                    }
                    .onChange(of: orderAscendingSelection) {
                        orderAscending = orderAscendingSelection != "arrowtriangle.down"
                    }
                    .pickerStyle(.segmented).accessibilityLabel("Choose ascending or descending")
                    .frame(width: 150)
                }

                List(sortedWorkouts.filter {
                    searchText == "" || $0.name.lowercased().contains(searchText.lowercased())
                }) { workout in
                    /*Button("Go to view 2") {
                        path.append("workout")
                    }
                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "workout":
                            WorkoutListView(workout: workout)
                        default:
                            WorkoutListView(workout: workout)
                        }
                    }*/
                
                    NavigationLink {
                        WorkoutView(workout: workout)
                    } label: {
                        WorkoutListView(workout: workout)
                    }
                }
                .navigationTitle("Workouts")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: addWorkout, label: {
                            Image(systemName: "plus")
                        }).accessibilityLabel("Add a new workout")
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $isPresentingNewWorkoutView) {
            WorkoutCreateView()
        }
        .onAppear {
            //this can be moved to the navigation link - see here: https://stackoverflow.com/questions/73939238/how-to-perform-action-before-executing-navigationlink
            for workout in workouts {
                workout.plan =  WorkoutPlan(.custom(workout.exportToWorkoutKit()))
            }
        }
        .searchable(text: $searchText, prompt: "Search Workouts")
    }

    func addWorkout() {
        isPresentingNewWorkoutView = true
    }
}

#Preview {
    ContentView()
}
