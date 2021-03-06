// swiftlint:disable all
import Amplify
import Foundation

extension WorkoutElement {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case orientation
    case jointAngles
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let workoutElement = WorkoutElement.keys
    
    model.pluralName = "WorkoutElements"
    
    model.fields(
      .field(workoutElement.orientation, is: .optional, ofType: .string),
      .field(workoutElement.jointAngles, is: .optional, ofType: .string)
    )
    }
}