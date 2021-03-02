// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutSessionModel: Model {
  public let id: String
  public var imuData: [Double]
  public var cameraAngle: String
  public var workoutType: String
  public var result: WorkoutResultModel?
  public var startTimestamp: Int
  public var endTimestamp: Int
  public var squatElements: [SquatElement]?
  public var deadliftElements: [DeadliftElement]?
  
  public init(id: String = UUID().uuidString,
      imuData: [Double] = [],
      cameraAngle: String,
      workoutType: String,
      result: WorkoutResultModel? = nil,
      startTimestamp: Int,
      endTimestamp: Int,
      squatElements: [SquatElement]? = [],
      deadliftElements: [DeadliftElement]? = []) {
      self.id = id
      self.imuData = imuData
      self.cameraAngle = cameraAngle
      self.workoutType = workoutType
      self.result = result
      self.startTimestamp = startTimestamp
      self.endTimestamp = endTimestamp
      self.squatElements = squatElements
      self.deadliftElements = deadliftElements
  }
}