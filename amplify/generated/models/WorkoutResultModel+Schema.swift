// swiftlint:disable all
import Amplify
import Foundation

extension WorkoutResultModel {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case score
    case incorrectJoints
    case incorrectAccelerations
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let workoutResultModel = WorkoutResultModel.keys
    
    model.pluralName = "WorkoutResultModels"
    
    model.fields(
      .id(),
      .field(workoutResultModel.score, is: .required, ofType: .int),
      .field(workoutResultModel.incorrectJoints, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(workoutResultModel.incorrectAccelerations, is: .optional, ofType: .embeddedCollection(of: Double.self))
    )
    }
}