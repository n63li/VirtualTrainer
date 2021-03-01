// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutSessionModel: Model {
  public let id: String
  public var imuData: [Double]
  public var cameraAngle: String
  public var workoutType: String
  public var startTimestamp: Int
  public var result: WorkoutResultModel?
  public var endTimestamp: Int
  public var squatElements: [SquatElement]?
  public var deadliftElements: [DeadliftElement]?
  
  public init(id: String = UUID().uuidString,
      imuData: [Double] = [],
      cameraAngle: String,
      workoutType: String,
      startTimestamp: Int,
      result: WorkoutResultModel? = nil,
      endTimestamp: Int,
      squatElements: [SquatElement]? = [],
      deadliftElements: [DeadliftElement]? = []) {
      self.id = id
      self.imuData = imuData
      self.cameraAngle = cameraAngle
      self.workoutType = workoutType
      self.startTimestamp = startTimestamp
      self.result = result
      self.endTimestamp = endTimestamp
      self.squatElements = squatElements
      self.deadliftElements = deadliftElements
  }
}