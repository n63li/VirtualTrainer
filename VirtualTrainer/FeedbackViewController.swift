//
//  FeedbackViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-03.
//  Copyright © 2021 Google Inc. All rights reserved.
//
import Amplify
import UIKit

@objc(FeedbackViewController)
class FeedbackViewController: UIViewController {
    var workoutSession: WorkoutSession? = nil
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finish(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
        let item = WorkoutResultModel(
                score: 1020,
                incorrectJoints: [],
                incorrectAccelerations: [])
        Amplify.DataStore.save(item) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.id)")
            case .failure(let error):
                print("Could not save item to DataStore: \(error)")
            }
        }
        
        workoutSession?.workoutResult = item
        workoutSession?.endTimestamp = NSDate().timeIntervalSince1970
        workoutSession?.save()
    }
}
