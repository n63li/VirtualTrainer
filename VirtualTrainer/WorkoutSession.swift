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
  var videoURL: String? = ""
  var jointAnglesList: [[String: CGFloat]] = []
  
  init(workoutType: String, cameraAngle: WorkoutOrientation) {
    self.workoutType = workoutType
    self.cameraAngle = cameraAngle
    self.workoutResult = WorkoutResult(score: 0, incorrectJoints: [0], incorrectAccelerations: [0])
    self.startTimestamp = NSDate().timeIntervalSince1970
  }
  
//  func compare() -> WorkoutResultModel {
//    let k = IdealWorkoutModel.keys
//
//    Amplify.DataStore.query(IdealWorkoutModel.self, where: k.workoutType == workoutType) { result in
//      switch(result) {
//      case .success(let items):
//        for item in items {
//            print("IdealWorkoutModel ID: \(item.id)")
//            do comparison here
//        }
//      case .failure(let error):
//          print("Could not query DataStore: \(error)")
//        }
//      }
//
//    self.workoutResult = WorkoutResult(
//        score: 1020,
//        incorrectJoints: [0],
//        incorrectAccelerations: [0])
//    )
//
//    return workoutResultItem
//  }
  
  func save() {
    let encoder = JSONEncoder()
    var encodedJointAnglesList: [String] = []
    
    for jointAngles in self.jointAnglesList {
      var encodedJointAngles = ""
      do {
        let jsonData = try encoder.encode(jointAngles)
        encodedJointAngles = String(data: jsonData, encoding: .utf8)!
      } catch {
        print("Unable to encode joint angles")
      }
      
      encodedJointAnglesList.append(encodedJointAngles)
    }
        
    let workoutSessionItem = WorkoutSessionModel(
      imuData: self.imuData,
      cameraAngle: self.cameraAngle.rawValue,
      workoutType: self.workoutType,
      startTimestamp: Int(self.startTimestamp),
      endTimestamp: Int(self.endTimestamp),
      squatElements: self.squatElements,
      deadliftElements: self.deadliftElements,
      workoutResult: self.workoutResult,
      videoURL: self.videoURL,
      jointAnglesList: encodedJointAnglesList)
    Amplify.DataStore.save(workoutSessionItem) { result in
      switch(result) {
      case .success(let savedItem):
          print("Saved workout session: \(savedItem.id)")
      case .failure(let error):
          print("Could not save workout session to DataStore: \(error)")
      }
    }
  }
}
