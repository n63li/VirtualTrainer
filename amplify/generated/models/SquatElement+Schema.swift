// swiftlint:disable all
import Amplify
import Foundation

extension SquatElement {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case orientation
    case hipAngle
    case ankleAngle
    case trunkAngle
    case kneeAngle
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let squatElement = SquatElement.keys
    
    model.pluralName = "SquatElements"
    
    model.fields(
      .field(squatElement.orientation, is: .required, ofType: .string),
      .field(squatElement.hipAngle, is: .required, ofType: .double),
      .field(squatElement.ankleAngle, is: .required, ofType: .double),
      .field(squatElement.trunkAngle, is: .required, ofType: .double),
      .field(squatElement.kneeAngle, is: .required, ofType: .double)
    )
    }
}