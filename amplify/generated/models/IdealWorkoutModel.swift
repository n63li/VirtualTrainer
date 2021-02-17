// swiftlint:disable all
import Amplify
import Foundation

public struct IdealWorkoutModel: Model {
  public let id: String
  public var workoutType: String
  public var jointAngles: [Double]
  public var accelerations: [Double]?
  
  public init(id: String = UUID().uuidString,
      workoutType: String,
      jointAngles: [Double] = [],
      accelerations: [Double]? = []) {
      self.id = id
      self.workoutType = workoutType
      self.jointAngles = jointAngles
      self.accelerations = accelerations
  }
}