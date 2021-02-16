// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutResult: Model {
  public let id: String
  public var score: Int
  public var incorrectJoints: [String]
  public var incorrectAccelerations: [Double]?
  
  public init(id: String = UUID().uuidString,
      score: Int,
      incorrectJoints: [String] = [],
      incorrectAccelerations: [Double]? = []) {
      self.id = id
      self.score = score
      self.incorrectJoints = incorrectJoints
      self.incorrectAccelerations = incorrectAccelerations
  }
}