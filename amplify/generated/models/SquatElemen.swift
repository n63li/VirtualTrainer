// swiftlint:disable all
import Amplify
import Foundation

public struct SquatElemen: Model {
  public let id: String
  public var orientation: String
  public var hipAngle: Double
  public var ankleAngle: Double
  public var trunkAngle: Double
  public var kneeAngle: Double
  
  public init(id: String = UUID().uuidString,
      orientation: String,
      hipAngle: Double,
      ankleAngle: Double,
      trunkAngle: Double,
      kneeAngle: Double) {
      self.id = id
      self.orientation = orientation
      self.hipAngle = hipAngle
      self.ankleAngle = ankleAngle
      self.trunkAngle = trunkAngle
      self.kneeAngle = kneeAngle
  }
}