//
//  PreCameraViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-22.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class PreCameraViewController: UIViewController {
    private var workoutType: String = ""
    private var cameraAngle: SquatOrientation = SquatOrientation.left
    
    @IBOutlet weak var deadliftWorkoutType: UIButton!
    @IBOutlet weak var squatWorkoutType: UIButton!
    
    @IBOutlet weak var leftCameraAngle: UIButton!
    @IBOutlet weak var frontCameraAngle: UIButton!
    @IBOutlet weak var rightCameraAngle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startWorkoutSegue") {
            let vc = segue.destination as! CameraViewController
            vc.workoutSession = WorkoutSession(
                workoutType: workoutType,
                cameraAngle: cameraAngle != nil
            )
          print("workout initialized \(vc.workoutSession?.workoutType)")
        }
    }
    
    @IBAction func startWorkout(_ sender: Any) {
    }
    
    @IBAction func onSquatSelected(_ sender: Any) {
        squatWorkoutType.backgroundColor = .yellow
        deadliftWorkoutType.backgroundColor = .systemBackground
    }
    
    @IBAction func onDeadliftSelected(_ sender: Any) {
        
        workoutType = "Deadlift"
        deadliftWorkoutType.backgroundColor = .yellow
        squatWorkoutType.backgroundColor = .systemBackground
    }
    
    
    @IBAction func onLeftSelected(_ sender: Any) {
        cameraAngle = SquatOrientation.left
        leftCameraAngle.backgroundColor = .yellow
        rightCameraAngle.backgroundColor = .systemBackground
        frontCameraAngle.backgroundColor = .systemBackground
    }

    @IBAction func onFrontSelected(_ sender: Any) {
        frontCameraAngle.backgroundColor = .yellow
        leftCameraAngle.backgroundColor = .systemBackground
        rightCameraAngle.backgroundColor = .systemBackground
    }
    
    @IBAction func onRightSelected(_ sender: Any) {
        cameraAngle = SquatOrientation.right
        rightCameraAngle.backgroundColor = .yellow
        leftCameraAngle.backgroundColor = .systemBackground
        frontCameraAngle.backgroundColor = .systemBackground
    }
}
