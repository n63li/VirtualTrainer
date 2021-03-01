// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "1b66e447581d49c0c22fef80cebcca8c"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
    ModelRegistry.register(modelType: WorkoutResultModel.self)
    ModelRegistry.register(modelType: IdealWorkoutModel.self)
  }
}