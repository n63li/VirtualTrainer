// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "65714c5a6b8a2cbbc4f08644dfdf21f8"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: DeadliftElement.self)
    ModelRegistry.register(modelType: SquatElemen.self)
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
    ModelRegistry.register(modelType: WorkoutResultModel.self)
    ModelRegistry.register(modelType: IdealWorkoutModel.self)
  }
}