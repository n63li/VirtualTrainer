//
//  WorkoutResult.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//  Copyright © 2021 Google Inc. All rights reserved.
//

public struct WorkoutResult: Codable {
    var score: Double?
    var incorrectJoints: [String]?
    var incorrectAccelerations: [Double]?
    init(score: Double? = 0.0, incorrectJoints: [String]? = [""], incorrectAccelerations: [Double]? = [0]) {
        self.score = score
        self.incorrectJoints = incorrectJoints
        self.incorrectAccelerations = incorrectAccelerations
    }
}
