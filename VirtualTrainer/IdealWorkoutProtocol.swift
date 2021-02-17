//
//  WorkoutProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//  Copyright © 2021 Google Inc. All rights reserved.
//

protocol IdealWorkoutProtocol {
  var name: String {get}
  var jointAngles: Array<Float> {get}
  var accelerations: Array<Float> {get}
  func uploadIdealWorkout(url: String) -> Bool
  func calculateJointAngles() -> Void
  func calculateAccelerations() -> Void
}

class Deadlift: IdealWorkoutProtocol{
  var name: String = "deadlift"
  var jointAngles: Array<Float> = [0]
  var accelerations: Array<Float> = [0]
  
  init(url: String) {
    uploadIdealWorkout(url: url)
  }
  
  func uploadIdealWorkout(url: String) -> Bool {
    print("Uploaded video at url: " + url)
    return true
  }
  
  func calculateJointAngles() {
    print("Calculating joint angles")
  }
  
  func calculateAccelerations() {
    print("Calculating accelerations")
  }
}

//class Squat: IdealWorkoutProtocol {
//  func saveWorkout() -> Bool {
//
//  }
//}
