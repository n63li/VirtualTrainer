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
class HistoryViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIContextMenuInteractionDelegate {
    
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
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let workoutSession = workoutSessions[indexPath.row]
            
            // remove the item from the data model
            workoutSessions.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete from Amplify datastore
            Amplify.DataStore.delete(WorkoutSessionModel.self, withId: workoutSession.id) { result in
                switch(result) {
                case .success:
                    print("Deleted item: \(workoutSession.id)")
                case .failure(let error):
                    print("Could not update data in Datastore: \(error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "WorkoutResultViewController") as! WorkoutResultViewController
        destination.workoutSession = workoutSessions[indexPath.row]
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        // 1
        guard
            let identifier = configuration.identifier as? String,
            let index = Int(identifier)
        else {
            return
        }
        
        // 2
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        
        // 3
        animator.addCompletion {
            self.performSegue(
                withIdentifier: "showHistoryViewController",
                sender: cell)
        }
    }
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint)
    -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: { _ in
                let children: [UIMenuElement] = []
                return UIMenu(title: "", children: children)
            })
    }
    
    func queryWorkoutSessions() {
        Amplify.DataStore.query(WorkoutSessionModel.self, sort: .descending(WorkoutSessionModel.keys.startTimestamp)) { result in
            switch(result) {
            case .success(let items):
                for item in items {
                    print("WorkoutSessionModel ID: \(item.id)")
                }
                workoutSessions = WorkoutSession.convertWorkoutSessionModelsToWorkoutSessions(workoutSessionModels: items)
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
}
