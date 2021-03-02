// swiftlint:disable all
import Amplify
import Foundation

public struct DeadliftElement: Embeddable {
  var orientation: String
  var rightKneeAngle: Double
  var leftHipAngle: Double
  var rightHipAngle: Double
  var leftAnkleAngle: Double
  var rightAnkleAngle: Double
  var leftTrunkAngle: Double
  var rightTrunkAngle: Double
  var leftShoulderAngle: Double
  var rightShoulderAngle: Double
  var leftElbowAngle: Double
  var rightElbowAngle: Double
  var leftKneeAngle: Double
}