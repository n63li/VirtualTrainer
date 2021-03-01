//
//  WorkoutSessionProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//
import Amplify

class WorkoutSession {
  var id: String = ""
  var workoutType: String = ""
  var imuData: [Double] = []
  var cameraAngle: String
  var workoutResult: WorkoutResultModel
  var startTimestamp: Double = 0
  var endTimestamp: Double = 0
  var squatElements: [SquatElement] = []
  var deadliftElements: [DeadliftElement] = []
  
  init(workoutType: String, cameraAngle: String) {
    self.workoutType = workoutType
    self.cameraAngle = cameraAngle
    self.workoutResult = WorkoutResultModel(score: 0, incorrectJoints: [0], incorrectAccelerations: [0])
    self.startTimestamp = NSDate().timeIntervalSince1970
  }
  
  func compare() -> WorkoutResultModel {
    let k = IdealWorkoutModel.keys
    
    Amplify.DataStore.query(IdealWorkoutModel.self, where: k.workoutType == workoutType) { result in
      switch(result) {
      case .success(let items):
        for item in items {
            print("IdealWorkoutModel ID: \(item.id)")
//            do comparison here
        }
      case .failure(let error):
          print("Could not query DataStore: \(error)")
        }
      }
    
    let workoutResultItem = WorkoutResultModel(
        score: 1020,
        incorrectJoints: [0],
        incorrectAccelerations: [0])
    Amplify.DataStore.save(workoutResultItem) { result in
        switch(result) {
        case .success(let savedItem):
          print("Saved workout result: \(savedItem.id)")
          self.workoutResult = savedItem
        case .failure(let error):
          print("Could not save workout result to DataStore: \(error)")
        }
    }
    
    return workoutResultItem
  }
  
  func save() -> Bool {
    print(self.workoutType)
    let workoutSessionItem = WorkoutSessionModel(
      imuData: self.imuData,
      cameraAngle: self.cameraAngle,
      workoutType: self.workoutType,
      result: self.workoutResult,
      startTimestamp: Int(self.startTimestamp),
      endTimestamp: Int(self.endTimestamp),
      squatElements: self.squatElements,
      deadliftElements: self.deadliftElements)
    Amplify.DataStore.save(workoutSessionItem) { result in
      switch(result) {
      case .success(let savedItem):
          print("Saved workout session: \(savedItem.id)")
      case .failure(let error):
          print("Could not save workout session to DataStore: \(error)")
      }
    }
    return true
  }
}
