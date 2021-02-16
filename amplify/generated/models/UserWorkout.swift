// swiftlint:disable all
import Amplify
import Foundation

public struct UserWorkout: Model {
  public let id: String
  public var poseNetData: [Double]
  public var imuData: [Double]
  public var workoutType: String
  public var cameraAngle: Bool
  public var startTimestamp: Int
  public var endTimestamp: Int
  
  public init(id: String = UUID().uuidString,
      poseNetData: [Double] = [],
      imuData: [Double] = [],
      workoutType: String,
      cameraAngle: Bool,
      startTimestamp: Int,
      endTimestamp: Int) {
      self.id = id
      self.poseNetData = poseNetData
      self.imuData = imuData
      self.workoutType = workoutType
      self.cameraAngle = cameraAngle
      self.startTimestamp = startTimestamp
      self.endTimestamp = endTimestamp
  }
}