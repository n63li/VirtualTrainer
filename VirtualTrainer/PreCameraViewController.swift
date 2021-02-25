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
    
    let imagePickerController = UIImagePickerController()
    
    
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
        } else if (segue.identifier == "feedbackSegue") {
            let vc = segue.destination as! FeedbackViewController
            vc.workoutSession = WorkoutSession(
                workoutType: workoutType,
                cameraAngle: cameraAngle != nil
            )
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
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
    
    
    @IBAction func onWorkoutTypeChanged(_ sender: UISegmentedControl) {
        workoutType = sender.titleForSegment(at: sender.selectedSegmentIndex)!.lowercased()
    }
    
    
    @IBAction func onCameraAngleChanged(_ sender: UISegmentedControl) {
        switch(sender.titleForSegment(at: sender.selectedSegmentIndex)!.lowercased()) {
        case "left":
            cameraAngle = SquatOrientation.left
        case "front":
            cameraAngle = SquatOrientation.right
        case "right":
            cameraAngle = SquatOrientation.left
        default:
            cameraAngle = SquatOrientation.left
        }
    }
}
