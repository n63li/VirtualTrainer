// swiftlint:disable all
import Amplify
import Foundation

extension UserWorkout {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case poseNetData
    case imuData
    case workoutType
    case cameraAngle
    case startTimestamp
    case endTimestamp
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userWorkout = UserWorkout.keys
    
    model.pluralName = "UserWorkouts"
    
    model.fields(
      .id(),
      .field(userWorkout.poseNetData, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(userWorkout.imuData, is: .required, ofType: .embeddedCollection(of: Double.self)),
      .field(userWorkout.workoutType, is: .required, ofType: .string),
      .field(userWorkout.cameraAngle, is: .required, ofType: .bool),
      .field(userWorkout.startTimestamp, is: .required, ofType: .int),
      .field(userWorkout.endTimestamp, is: .required, ofType: .int)
    )
    }
}