// swiftlint:disable all
import Amplify
import Foundation

extension IdealWorkoutModel {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case workoutType
    case jointAngles
    case accelerations
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let idealWorkoutModel = IdealWorkoutModel.keys
    
    model.pluralName = "IdealWorkoutModels"
    
    model.fields(
      .id(),
      .field(idealWorkoutModel.workoutType, is: .required, ofType: .string),
      .field(idealWorkoutModel.jointAngles, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(idealWorkoutModel.accelerations, is: .optional, ofType: .embeddedCollection(of: Double.self))
    )
    }
}