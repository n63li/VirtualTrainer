//
//  WorkoutResult.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//  Copyright © 2021 Google Inc. All rights reserved.
//

public struct WorkoutResult: Codable {
  var score: Int?
  var incorrectJoints: [Double]?
  var incorrectAccelerations: [Double]?
  init(score: Int? = nil, incorrectJoints: [Double]? = nil, incorrectAccelerations: [Double]? = nil) {
    self.score = score
    self.incorrectJoints = incorrectJoints
    self.incorrectAccelerations = incorrectAccelerations
  }
}
