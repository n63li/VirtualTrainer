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
  var poseNetData: [Double] = []
  var imuData: [Double] = []
  var cameraAngle: Bool
  var workoutResult: WorkoutResultModel
  var startTimestamp: Double = 0
  var endTimestamp: Double = 0
  
  init(workoutType: String, cameraAngle: Bool) {
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
    let workoutSessionItem = WorkoutSessionModel(
      poseNetData: [],
      imuData: [],
      cameraAngle: self.cameraAngle,
      workoutType: self.workoutType,
      startTimestamp: Int(self.startTimestamp),
      result: self.workoutResult,
      endTimestamp: Int(self.endTimestamp))
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
