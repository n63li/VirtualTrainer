//
//  WorkoutSessionProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//  Copyright © 2021 Google Inc. All rights reserved.
//
import Amplify

class WorkoutSession {
  var poseNetData: Array<Float> = []
  var imuData: Array<Float> = []
  var idealWorkout: IdealWorkoutProtocol = Deadlift(url: "")
  var cameraAngle: Bool = false
  var workoutResult: WorkoutResult = WorkoutResult()
  var startTimestamp: Float = 0
  var endTimestamp: Float = 0
  
  func compare() -> WorkoutResult {
    return WorkoutResult(
      score: 0,
      incorrectJoints: [],
      incorrectAccelerations: []
    )
  }
  
  func save() -> Bool {
    let workoutResultItem = WorkoutResultModel(
        score: 1020,
        incorrectJoints: [],
        incorrectAccelerations: [])
    Amplify.DataStore.save(workoutResultItem) { result in
        switch(result) {
        case .success(let savedItem):
            print("Saved item: \(savedItem.id)")
        case .failure(let error):
            print("Could not save item to DataStore: \(error)")
        }
    }
    
    let idealWorkoutItem = IdealWorkoutModel(
        workoutType: "Lorem ipsum dolor sit amet",
        jointAngles: [],
        accelerations: [])
    Amplify.DataStore.save(idealWorkoutItem) { result in
        switch(result) {
        case .success(let savedItem):
            print("Saved item: \(savedItem.id)")
        case .failure(let error):
            print("Could not save item to DataStore: \(error)")
        }
    }
    
    let item = WorkoutSessionModel(
        poseNetData: [],
        imuData: [],
        cameraAngle: true,
        endTimestamp: 1023123,
        startTimestamp: 1023123,
        result: workoutResultItem,
        ideal: idealWorkoutItem)
    Amplify.DataStore.save(item) { result in
        switch(result) {
        case .success(let savedItem):
            print("Saved item: \(savedItem.id)")
        case .failure(let error):
            print("Could not save item to DataStore: \(error)")
        }
    }
    return true
  }
}
