// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "faf28ca8b1bacf4502544e5b5ae9ceba"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
  }
}