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
@objc(HistoryViewController)
class HistoryViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
  /// An image picker for accessing the photo library or camera.
  var imagePicker = UIImagePickerController()

  // Image counter.
  var currentImage = 0
    
  // Workout sessions
  var workoutSessions = [] as [WorkoutSession]
    
  var refreshControl = UIRefreshControl()

    
  let cellReuseIdentifier = "WorkoutTableViewCell"
    
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
      
    queryWorkoutSessions()
    tableView.reloadData()
    tableView.register(UINib(nibName: "WorkoutTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    tableView.addSubview(refreshControl) // not required when using UITableViewController

    
    tableView.delegate = self
    tableView.dataSource = self
  }
    
  @objc func refresh(_ sender: AnyObject) {
    queryWorkoutSessions()
    refreshControl.endRefreshing()
    tableView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
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
    
  func queryWorkoutSessions() {
      Amplify.DataStore.query(WorkoutSessionModel.self, sort: .descending(WorkoutSessionModel.keys.startTimestamp)) { result in
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
  }
  
  func convertWorkoutSessionModelsToWorkoutSessions(workoutSessionModels: [WorkoutSessionModel]) -> [WorkoutSession]{
    var workoutSessionsList = [] as [WorkoutSession]
    
    for model in workoutSessionModels {
      let workoutSession = WorkoutSession(workoutType: model.workoutType, cameraAngle: model.cameraAngle)
      workoutSession.poseNetData = model.poseNetData
      workoutSession.imuData = model.imuData
//      workoutSession.workoutResult = WorkoutResult(
//        score: model.result?.score,
//        incorrectJoints: model.result?.incorrectJoints,
//        incorrectAccelerations: model.result?.incorrectAccelerations
//      )
      workoutSession.startTimestamp = Double(model.startTimestamp)
      workoutSession.endTimestamp = Double(model.endTimestamp)
     
      workoutSessionsList.append(workoutSession)
    }
    
    return workoutSessionsList
  }
}
