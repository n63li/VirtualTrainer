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
  var cameraAngle: WorkoutOrientation
  var workoutResult: WorkoutResult
  var startTimestamp: Double = 0
  var endTimestamp: Double = 0
  var squatElements: [SquatElement] = []
  var deadliftElements: [DeadliftElement] = []
  
  init(workoutType: String, cameraAngle: WorkoutOrientation) {
    self.workoutType = workoutType
    self.cameraAngle = cameraAngle
    self.workoutResult = WorkoutResult(score: 0, incorrectJoints: [0], incorrectAccelerations: [0])
    self.startTimestamp = NSDate().timeIntervalSince1970
  }
  
  func compare() {
    var currentIdealFrame = 0
    
    for element in self.squatElements {
      
    }
    
    self.workoutResult = WorkoutResult(
        score: 1020,
        incorrectJoints: [0],
        incorrectAccelerations: [0]
    )
  }
  
  func save() -> Bool {
    print(self.workoutResult)
    let workoutSessionItem = WorkoutSessionModel(
      imuData: self.imuData,
      cameraAngle: self.cameraAngle.rawValue,
      workoutType: self.workoutType,
      startTimestamp: Int(self.startTimestamp),
      endTimestamp: Int(self.endTimestamp),
      squatElements: self.squatElements,
      deadliftElements: self.deadliftElements,
      workoutResult: self.workoutResult)
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
