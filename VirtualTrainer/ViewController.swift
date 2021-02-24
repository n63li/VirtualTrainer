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
import MLKit
import UIKit

/// Main view controller class.
@objc(ViewController)
class ViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
  /// An image picker for accessing the photo library or camera.
  var imagePicker = UIImagePickerController()

  // Image counter.
  var currentImage = 0
    
  // Workout sessions
  var workoutSessions = [] as [WorkoutSession]
    
  let cellReuseIdentifier = "WorkoutTableViewCell"
    
  // MARK: - IBOutlets
  @IBOutlet fileprivate weak var videoCameraButton: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    let isCameraAvailable =
      UIImagePickerController.isCameraDeviceAvailable(.front)
      || UIImagePickerController.isCameraDeviceAvailable(.rear)
    if isCameraAvailable {
      // `CameraViewController` uses `AVCaptureDevice.DiscoverySession` which is only supported for
      // iOS 10 or newer.
      if #available(iOS 10.0, *) {
        videoCameraButton.isEnabled = true
      }
    }
      
    Amplify.DataStore.query(WorkoutSessionModel.self) { result in
      switch(result) {
      case .success(let items):
        for item in items {
          print("WorkoutSessionModel ID: \(item.id)")
        }
        workoutSessions = convertWorkoutSessionModelsToWorkoutSessions(workoutSessionModels: items)
      case .failure(let error):
        print("Could not query DataStore: \(error)")
      }
    }
    
    tableView.reloadData()
    tableView.register(UINib(nibName: "WorkoutTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    tableView.delegate = self
    tableView.dataSource = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  @IBAction func openPhotoLibrary(_ sender: Any) {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true)
  }
    
  // MARK: - UITableViewController
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return workoutSessions.count;
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: WorkoutTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! WorkoutTableViewCell

    let workoutSession = workoutSessions[indexPath.row]
    
    cell.set(session: workoutSession)
    return cell
    
  }
  
  func convertWorkoutSessionModelsToWorkoutSessions(workoutSessionModels: [WorkoutSessionModel]) -> [WorkoutSession]{
    var workoutSessionsList = [] as [WorkoutSession]
    
    for model in workoutSessionModels {
      let workoutSession = WorkoutSession(workoutType: model.workoutType, cameraAngle: model.cameraAngle)
      workoutSession.poseNetData = model.poseNetData
      workoutSession.imuData = model.imuData
//      workoutSession.workoutResult
      workoutSession.startTimestamp = Double(model.startTimestamp)
      workoutSession.endTimestamp = Double(model.endTimestamp)
     
      workoutSessionsList.append(workoutSession)
    }
    
    return workoutSessionsList
  }
}
