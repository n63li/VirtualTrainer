// swiftlint:disable all
import Amplify
import Foundation

public struct WorkoutSessionModel: Model {
  public let id: String
  public var imuData: [Double]
  public var cameraAngle: String
  public var workoutType: String
  public var startTimestamp: Int
  public var endTimestamp: Int
  public var workoutResult: WorkoutResult?
  public var videoURL: String?
  public var jointAnglesList: [String]?
  
  public init(id: String = UUID().uuidString,
      imuData: [Double] = [],
      cameraAngle: String,
      workoutType: String,
      startTimestamp: Int,
      endTimestamp: Int,
      workoutResult: WorkoutResult? = nil,
      videoURL: String? = nil,
      jointAnglesList: [String]? = []) {
      self.id = id
      self.imuData = imuData
      self.cameraAngle = cameraAngle
      self.workoutType = workoutType
      self.startTimestamp = startTimestamp
      self.endTimestamp = endTimestamp
      self.workoutResult = workoutResult
      self.videoURL = videoURL
      self.jointAnglesList = jointAnglesList
  }
}