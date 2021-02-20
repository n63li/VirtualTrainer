//
//  Copyright (c) 2018 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Amplify
import AmplifyPlugins
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
      //let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels()) // UNCOMMENT this line once backend is deployed

      do {
          try Amplify.add(plugin: dataStorePlugin)
          //try Amplify.add(plugin: apiPlugin) // UNCOMMENT this line once backend is deployed
          try Amplify.configure()
          print("Initialized Amplify");
          let idealWorkout = IdealWorkout(
            name: "deadlift",
            url: "https://www.youtube.com/watch?v=ytGaGIn3SjE"
          )
        let workoutSession = WorkoutSession(workoutType: "deadlift", cameraAngle: false)
          workoutSession.save()
      } catch {
          print("Could not initialize Amplify: \(error)")
      }
    return true
  }
}
