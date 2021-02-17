// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutResultModel: Model {
  public let id: String
  public var score: Int
  public var incorrectJoints: [Double]
  public var incorrectAccelerations: [Double]?
  
  public init(id: String = UUID().uuidString,
      score: Int,
      incorrectJoints: [Double] = [],
      incorrectAccelerations: [Double]? = []) {
      self.id = id
      self.score = score
      self.incorrectJoints = incorrectJoints
      self.incorrectAccelerations = incorrectAccelerations
  }
}