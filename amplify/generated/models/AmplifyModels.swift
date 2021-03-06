// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "d11519106917b77cddf82adee922a4e9"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: WorkoutSessionModel.self)
  }
}