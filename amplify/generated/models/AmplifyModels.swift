// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "bb8a0d09901a4e7505ac282608915baf"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: UserWorkout.self)
    ModelRegistry.register(modelType: WorkoutResult.self)
    ModelRegistry.register(modelType: IdealWorkout.self)
  }
}