// swiftlint:disable all
import Amplify
import Foundation

public struct IdealWorkout: Model {
  public let id: String
  public var workoutType: String
  public var jointAngles: [String]
  public var accelerations: [Double]?
  
  public init(id: String = UUID().uuidString,
      workoutType: String,
      jointAngles: [String] = [],
      accelerations: [Double]? = []) {
      self.id = id
      self.workoutType = workoutType
      self.jointAngles = jointAngles
      self.accelerations = accelerations
  }
}