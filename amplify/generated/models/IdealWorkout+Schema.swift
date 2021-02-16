// swiftlint:disable all
import Amplify
import Foundation

extension IdealWorkout {
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
    let idealWorkout = IdealWorkout.keys
    
    model.pluralName = "IdealWorkouts"
    
    model.fields(
      .id(),
      .field(idealWorkout.workoutType, is: .required, ofType: .string),
      .field(idealWorkout.jointAngles, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(idealWorkout.accelerations, is: .optional, ofType: .embeddedCollection(of: Double.self))
    )
    }
}