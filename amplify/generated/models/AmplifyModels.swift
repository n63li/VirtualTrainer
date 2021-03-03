// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b974932b173884afe5daef5e07f85071"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
  }
}