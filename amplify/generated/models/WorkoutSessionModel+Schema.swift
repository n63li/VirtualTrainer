// swiftlint:disable all
import Amplify
import Foundation

extension WorkoutSessionModel {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case poseNetData
    case imuData
    case cameraAngle
    case endTimestamp
    case startTimestamp
    case result
    case ideal
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let workoutSessionModel = WorkoutSessionModel.keys
    
    model.pluralName = "WorkoutSessionModels"
    
    model.fields(
      .id(),
      .field(workoutSessionModel.poseNetData, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(workoutSessionModel.imuData, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(workoutSessionModel.cameraAngle, is: .required, ofType: .bool),
      .field(workoutSessionModel.endTimestamp, is: .required, ofType: .int),
      .field(workoutSessionModel.startTimestamp, is: .required, ofType: .int),
      .belongsTo(workoutSessionModel.result, is: .optional, ofType: WorkoutResultModel.self, targetName: "workoutSessionModelResultId"),
      .belongsTo(workoutSessionModel.ideal, is: .optional, ofType: IdealWorkoutModel.self, targetName: "workoutSessionModelIdealId")
    )
    }
}