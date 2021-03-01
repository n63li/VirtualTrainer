// swiftlint:disable all
import Amplify
import Foundation

public struct DeadliftElement: Model {
  public let id: String
  public var orientation: String
  public var leftKneeAngle: Double
  public var rightKneeAngl: Double
  public var leftHipAngle: Double
  public var rightHipAngle: Double
  public var leftAnkleAngle: Double
  public var rightAnkleAngle: Double
  public var leftTrunkAngle: Double
  public var rightTrunkAngle: Double
  public var leftShoulderAngle: Double
  public var rightShoulderAngl: Double
  public var leftElbowAngle: Double
  public var rightElbowAngle: Double
  
  public init(id: String = UUID().uuidString,
      orientation: String,
      leftKneeAngle: Double,
      rightKneeAngl: Double,
      leftHipAngle: Double,
      rightHipAngle: Double,
      leftAnkleAngle: Double,
      rightAnkleAngle: Double,
      leftTrunkAngle: Double,
      rightTrunkAngle: Double,
      leftShoulderAngle: Double,
      rightShoulderAngl: Double,
      leftElbowAngle: Double,
      rightElbowAngle: Double) {
      self.id = id
      self.orientation = orientation
      self.leftKneeAngle = leftKneeAngle
      self.rightKneeAngl = rightKneeAngl
      self.leftHipAngle = leftHipAngle
      self.rightHipAngle = rightHipAngle
      self.leftAnkleAngle = leftAnkleAngle
      self.rightAnkleAngle = rightAnkleAngle
      self.leftTrunkAngle = leftTrunkAngle
      self.rightTrunkAngle = rightTrunkAngle
      self.leftShoulderAngle = leftShoulderAngle
      self.rightShoulderAngl = rightShoulderAngl
      self.leftElbowAngle = leftElbowAngle
      self.rightElbowAngle = rightElbowAngle
  }
}