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
  
  func calculateScore() throws {
      var idealWorkouts = [
       "squat": Squat()
      ] as [String : IdealWorkout]
    
      let idealWorkout = idealWorkouts[self.workoutType]?.jointAngles[self.cameraAngle] ?? [SquatElement(orientation: "right", KneeAngle: 179.7561044347451, HipAngle: 177.23966649398434, AnkleAngle: 128.48408243711748, TrunkAngle: 0.0)]
      print(idealWorkout)
      var currentIdealFrameIndex = 0
      let keys = try self.squatElements[0].allProperties()
    let tolerance = 5.0
      var score = 100.0
    print(self.squatElements.count)
    print(self.squatElements[0])
      var minRequiredDetections = 5
      for userFrame in self.squatElements {
        if currentIdealFrameIndex >= idealWorkout.count {
          print("current ideal frame index out of bounds")
          break
        }
        let currentIdealFrame = idealWorkout[currentIdealFrameIndex]
        var isUserFrameGood = false
        var scoreDeduction = 0.0
        let scoreDeductionWeighting = 0.5
        for (key, _): (String, Any) in keys {
          let userVal = userFrame.valueByPropertyName(name: key)
          let idealVal = currentIdealFrame.valueByPropertyName(name: key)
           let difference = Double(abs(userVal - idealVal))
           if (difference <= tolerance) {
             scoreDeduction += difference * scoreDeductionWeighting
             isUserFrameGood = true
           } else {
             isUserFrameGood = false
             break
           }
         }

        if isUserFrameGood {
          minRequiredDetections -= 1

          if minRequiredDetections == 0 {
            print("We found frame \(currentIdealFrameIndex)")
            currentIdealFrameIndex += 1
            score -= Double(scoreDeduction)
            minRequiredDetections = 5
          }
        }
      }
    if currentIdealFrameIndex < idealWorkout.count {
        // means that we couldn't find any user poses that resembles the ideal poses
        // user has bad pose, might need to ask them to try again
        print("User has bad pose, cannot match user poses to ideal poses")
        score = 0.0
      } else {
        print("Hey we have a score of: \(score)")
      }
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
      videoURL: self.videoURL)
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
