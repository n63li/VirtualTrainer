// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "10dfbad3731f932e026c358b3c3ab257"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
    ModelRegistry.register(modelType: WorkoutResultModel.self)
    ModelRegistry.register(modelType: IdealWorkoutModel.self)
  }
}