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
  func uploadIdealWorkout() -> Bool
  func calculateJointAngles() -> Void
  func calculateAccelerations() -> Void
}

//class Deadlift: IdealWorkoutProtocol{
//  func saveWorkout() -> Bool {
//    <#code#>
//  }
//}
//
//class Squat: IdealWorkoutProtocol {
//  func saveWorkout() -> Bool {
//
//  }
//}
