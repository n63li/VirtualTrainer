// swiftlint:disable all
import Amplify
import Foundation

public struct SquatElement: Embeddable {
  var orientation: String
  var kneeAngle: Double
  var hipAngle: Double
  var ankleAngle: Double
  var trunkAngle: Double
}