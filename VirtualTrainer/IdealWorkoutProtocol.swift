//
//  WorkoutProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//
import Amplify

protocol IdealWorkoutProtocol {
  var name: String {get}
  var jointAngles: Array<Float> {get}
  var accelerations: Array<Float> {get}
  func analyzeIdealWorkout(url: String) -> Bool
  func calculateJointAngles() -> Void
  func calculateAccelerations() -> Void
  func saveIdealWorkout()
}

class IdealWorkout: IdealWorkoutProtocol{
  var name: String = ""
  var jointAngles: Array<Float> = [0]
  var accelerations: Array<Float> = [0]
  
  init(name: String, url: String) {
    self.name = name
    analyzeIdealWorkout(url: url)
  }
  
  func analyzeIdealWorkout(url: String) -> Bool {
    print("Analyze video at url: " + url)
    return true
  }
  
  func calculateJointAngles() {
    print("Calculating joint angles")
  }
  
  func calculateAccelerations() {
    print("Calculating accelerations")
  }
  
  func saveIdealWorkout() {
    let idealWorkoutItem = IdealWorkoutModel(
        workoutType: "Lorem ipsum dolor sit amet",
        jointAngles: [],
        accelerations: [])
    Amplify.DataStore.save(idealWorkoutItem) { result in
        switch(result) {
        case .success(let savedItem):
            print("Saved ideal workout: \(savedItem.id)")
        case .failure(let error):
            print("Could not save ideal workout to DataStore: \(error)")
        }
    }
  }
}
