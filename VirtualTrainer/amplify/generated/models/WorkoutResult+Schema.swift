// swiftlint:disable all
import Amplify
import Foundation

extension WorkoutResult {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case score
    case incorrectJoints
    case incorrectAccelerations
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let workoutResult = WorkoutResult.keys
    
    model.pluralName = "WorkoutResults"
    
    model.fields(
      .field(workoutResult.score, is: .required, ofType: .int),
      .field(workoutResult.incorrectJoints, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(workoutResult.incorrectAccelerations, is: .optional, ofType: .embeddedCollection(of: Double.self))
    )
    }
}