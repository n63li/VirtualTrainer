// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutResult: Embeddable {
  var score: Int
  var incorrectJoints: [String]?
  var incorrectAccelerations: [Double]?
}