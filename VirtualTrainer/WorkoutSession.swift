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
  
  init(workoutType: String, cameraAngle: WorkoutOrientation) {
    self.workoutType = workoutType
    self.cameraAngle = cameraAngle
    self.workoutResult = WorkoutResult(score: 0, incorrectJoints: [0], incorrectAccelerations: [0])
    self.startTimestamp = NSDate().timeIntervalSince1970
  }
  
  func compare() throws {
      var currentIdealFrameIndex = 0
      let keys = try self.squatElements[0].allProperties()
      let tolerance = 15.0
      var score = 100.0
      for userFrame in self.squatElements {
        let currentIdealFrame = idealSquatRight[currentIdealFrameIndex]
        var isUserFrameGood = false
        var scoreDeduction = 0
        let scoreDeductionWeighting = 0.5
        for (key, val): (String, Any) in keys {
          let userVal = userFrame[keyPath: \SquatElement.key]
          let idealVal = currentIdealFrame[keyPath: \SquatElement.key]
           let difference = abs(userVal - idealVal)
           if (difference <= tolerance) {
             scoreDeduction += difference * 0.5
             isUserFrameGood = true
           } else {
             isUserFrameGood = false
             break
           }
         }

        if isUserFrameGood {
          currentIdealFrameIndex += 1
          score -= Double(scoreDeduction)
        }
      }
      if currentIdealFrameIndex != idealSquatRight.count {
        // means that we couldn't find any user poses that resembles the ideal poses
        // user has bad pose, might need to ask them to try again
        print("User has bad pose, cannot match user poses to ideal poses")
      }
      print("Hey we have a score of this: \(score)")
    self.workoutResult = WorkoutResult(
      score: score,
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
      workoutResult: self.workoutResult,
        videoURL: self.videoURL  )
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
