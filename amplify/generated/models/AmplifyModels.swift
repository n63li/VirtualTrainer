// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f7dfd39025316aba8763b7dfc48479e9"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
    ModelRegistry.register(modelType: WorkoutResultModel.self)
    ModelRegistry.register(modelType: IdealWorkoutModel.self)
  }
}