// swiftlint:disable all
import Amplify
import Foundation

extension SquatElemen {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case orientation
    case hipAngle
    case ankleAngle
    case trunkAngle
    case kneeAngle
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let squatElemen = SquatElemen.keys
    
    model.pluralName = "SquatElemen"
    
    model.fields(
      .id(),
      .field(squatElemen.orientation, is: .required, ofType: .string),
      .field(squatElemen.hipAngle, is: .required, ofType: .double),
      .field(squatElemen.ankleAngle, is: .required, ofType: .double),
      .field(squatElemen.trunkAngle, is: .required, ofType: .double),
      .field(squatElemen.kneeAngle, is: .required, ofType: .double)
    )
    }
}