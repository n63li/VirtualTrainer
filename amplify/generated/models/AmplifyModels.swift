// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "e1e74c94bc447e2580c143f638ceb670"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
    ModelRegistry.register(modelType: WorkoutResultModel.self)
    ModelRegistry.register(modelType: IdealWorkoutModel.self)
  }
}