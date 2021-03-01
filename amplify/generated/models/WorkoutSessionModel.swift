// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutSessionModel: Model {
  public let id: String
  public var poseNetData: [Double]
  public var imuData: [Double]
  public var cameraAngle: String
  public var workoutType: String
  public var startTimestamp: Int
  public var result: WorkoutResultModel?
  public var endTimestamp: Int
  
  public init(id: String = UUID().uuidString,
      poseNetData: [Double] = [],
      imuData: [Double] = [],
      cameraAngle: String,
      workoutType: String,
      startTimestamp: Int,
      result: WorkoutResultModel? = nil,
      endTimestamp: Int) {
      self.id = id
      self.poseNetData = poseNetData
      self.imuData = imuData
      self.cameraAngle = cameraAngle
      self.workoutType = workoutType
      self.startTimestamp = startTimestamp
      self.result = result
      self.endTimestamp = endTimestamp
  }
}