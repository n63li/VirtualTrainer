//
//  PreCameraViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-22.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
import AVKit

class PreCameraViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private var workoutType: String = ""
    private var cameraAngle: SquatOrientation = SquatOrientation.left
    
    @IBOutlet weak var deadliftWorkoutType: UIButton!
    @IBOutlet weak var squatWorkoutType: UIButton!
    
    @IBOutlet weak var leftCameraAngle: UIButton!
    @IBOutlet weak var frontCameraAngle: UIButton!
    @IBOutlet weak var rightCameraAngle: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startWorkoutSegue") {
            let vc = segue.destination as! CameraViewController
            vc.workoutSession = WorkoutSession(workoutType: workoutType, cameraAngle: cameraAngle != nil)
        } else if (segue.identifier == "feedbackSegue") {
            let vc = segue.destination as! FeedbackViewController
            vc.workoutSession = WorkoutSession(workoutType: workoutType, cameraAngle: cameraAngle != nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        print(videoURL)
        imagePickerController.dismiss(animated: true, completion: nil)
        let frames = UIUtilities.getAllFrames(videoURL: videoURL)
        DispatchQueue.global(qos: .background).async {
            let poseDetectorHelper = PoseDetectorHelper(frames: frames)
            poseDetectorHelper.getResults()

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "feedbackSegue", sender: PreCameraViewController.self)
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func startWorkout(_ sender: Any) {
    }
    
    @IBAction func uploadRecording(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]

        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Workout Type Selection
    @IBAction func onSquatSelected(_ sender: Any) {
        workoutType = "Squat"
        squatWorkoutType.backgroundColor = .yellow
        deadliftWorkoutType.backgroundColor = .systemBackground
    }
    
    @IBAction func onDeadliftSelected(_ sender: Any) {
        workoutType = "Deadlift"
        deadliftWorkoutType.backgroundColor = .yellow
        squatWorkoutType.backgroundColor = .systemBackground
    }
    
    // MARK: Select Camera Angle
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
