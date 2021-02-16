//
//  WorkoutSessionProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//  Copyright © 2021 Google Inc. All rights reserved.
//

class WorkoutSession {
  var poseNetData: Array<Float> = []
  var imuData: Array<Float> = []
  var idealWorkout: IdealWorkoutProtocol
  var cameraAngle: Bool = false
  var startTimestamp: Float = 0
  var endTimestamp: Float = 0
  
  init(workout: IdealWorkoutProtocol) {
    idealWorkout = workout
  }
  
  func compare() -> WorkoutResult {
    return WorkoutResult(
      score: 0,
      incorrectJoints: [],
      incorrectAccelerations: []
    )
  }
}
