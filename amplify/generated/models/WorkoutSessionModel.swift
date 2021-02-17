// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutSessionModel: Model {
  public let id: String
  public var poseNetData: [Double]
  public var imuData: [Double]
  public var cameraAngle: Bool
  public var endTimestamp: Int
  public var startTimestamp: Int
  public var result: WorkoutResultModel?
  public var ideal: IdealWorkoutModel?
  
  public init(id: String = UUID().uuidString,
      poseNetData: [Double] = [],
      imuData: [Double] = [],
      cameraAngle: Bool,
      endTimestamp: Int,
      startTimestamp: Int,
      result: WorkoutResultModel? = nil,
      ideal: IdealWorkoutModel? = nil) {
      self.id = id
      self.poseNetData = poseNetData
      self.imuData = imuData
      self.cameraAngle = cameraAngle
      self.endTimestamp = endTimestamp
      self.startTimestamp = startTimestamp
      self.result = result
      self.ideal = ideal
  }
}