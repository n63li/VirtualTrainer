// swiftlint:disable all
import Amplify
import Foundation

extension WorkoutSessionModel {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case imuData
    case cameraAngle
    case workoutType
    case startTimestamp
    case result
    case endTimestamp
    case squatElements
    case deadliftElements
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let workoutSessionModel = WorkoutSessionModel.keys
    
    model.pluralName = "WorkoutSessionModels"
    
    model.fields(
      .id(),
      .field(workoutSessionModel.imuData, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(workoutSessionModel.cameraAngle, is: .required, ofType: .string),
      .field(workoutSessionModel.workoutType, is: .required, ofType: .string),
      .field(workoutSessionModel.startTimestamp, is: .required, ofType: .int),
      .belongsTo(workoutSessionModel.result, is: .optional, ofType: WorkoutResultModel.self, targetName: "workoutSessionModelResultId"),
      .field(workoutSessionModel.endTimestamp, is: .required, ofType: .int),
      .field(workoutSessionModel.squatElements, is: .optional, ofType: .embeddedCollection(of: SquatElement.self)),
      .field(workoutSessionModel.deadliftElements, is: .optional, ofType: .embeddedCollection(of: DeadliftElement.self))
    )
    }
}