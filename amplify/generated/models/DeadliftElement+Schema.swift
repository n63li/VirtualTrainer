// swiftlint:disable all
import Amplify
import Foundation

extension DeadliftElement {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case orientation
    case leftKneeAngle
    case rightKneeAngle
    case leftHipAngle
    case rightHipAngle
    case leftAnkleAngle
    case rightAnkleAngle
    case leftTrunkAngle
    case rightTrunkAngle
    case leftShoulderAngle
    case rightShoulderAngle
    case leftElbowAngle
    case rightElbowAngle
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let deadliftElement = DeadliftElement.keys
    
    model.pluralName = "DeadliftElements"
    
    model.fields(
      .field(deadliftElement.orientation, is: .required, ofType: .string),
      .field(deadliftElement.leftKneeAngle, is: .required, ofType: .double),
      .field(deadliftElement.rightKneeAngle, is: .required, ofType: .double),
      .field(deadliftElement.leftHipAngle, is: .required, ofType: .double),
      .field(deadliftElement.rightHipAngle, is: .required, ofType: .double),
      .field(deadliftElement.leftAnkleAngle, is: .required, ofType: .double),
      .field(deadliftElement.rightAnkleAngle, is: .required, ofType: .double),
      .field(deadliftElement.leftTrunkAngle, is: .required, ofType: .double),
      .field(deadliftElement.rightTrunkAngle, is: .required, ofType: .double),
      .field(deadliftElement.leftShoulderAngle, is: .required, ofType: .double),
      .field(deadliftElement.rightShoulderAngle, is: .required, ofType: .double),
      .field(deadliftElement.leftElbowAngle, is: .required, ofType: .double),
      .field(deadliftElement.rightElbowAngle, is: .required, ofType: .double)
    )
    }
}