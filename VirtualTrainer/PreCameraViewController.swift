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
    private var workoutType: String = "squat"
    private var cameraAngle: WorkoutOrientation = WorkoutOrientation.left

    let imagePickerController = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startWorkoutSegue") {
            let vc = segue.destination as! CameraViewController
            vc.workoutSession = WorkoutSession(
                workoutType: workoutType,
                cameraAngle: cameraAngle.rawValue
            )
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        imagePickerController.dismiss(animated: true, completion: nil)
        let frames = UIUtilities.getAllFrames(videoURL: videoURL)
        DispatchQueue.global(qos: .background).async {
            let poseDetectorHelper = PoseDetectorHelper(frames: frames)
            let poses = poseDetectorHelper.getResults()
            guard !poses.isEmpty else {
              print("Pose detector returned no results.")
              return
            }

            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                vc.workoutSession = WorkoutSession(
                    workoutType: self.workoutType,
                    cameraAngle: self.cameraAngle.rawValue
                )
                poses.forEach { pose in
                  switch vc.workoutSession?.workoutType {
                    case "squat":
                      let squatElement = PoseUtilities.getSquatAngles(pose: pose, orientation: vc.workoutSession?.cameraAngle ?? WorkoutOrientation.left.rawValue)
                      vc.workoutSession?.squatElements.append(squatElement)
                    case "deadlift":
                        let deadliftElement = PoseUtilities.getDeadLiftAngles(pose: pose, orientation: vc.workoutSession?.cameraAngle ?? WorkoutOrientation.left.rawValue)
                        vc.workoutSession?.deadliftElements.append(deadliftElement)
                    default:
                      break
                  }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    // MARK: Actions

    @IBAction func startWorkout(_ sender: Any) {
        let alert = UIAlertController(title: "Select Workout Source", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Default action"), style: .default, handler: { _ in
            self.upload()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: "Default action 2"), style: .default, handler: { _ in
            self.performSegue(withIdentifier: "startWorkoutSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func upload() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]

        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func onWorkoutTypeChanged(_ sender: UISegmentedControl) {
        self.workoutType = sender.titleForSegment(at: sender.selectedSegmentIndex)!.lowercased()
    }


    @IBAction func onCameraAngleChanged(_ sender: UISegmentedControl) {
        self.cameraAngle = WorkoutOrientation(rawValue: sender.titleForSegment(at: sender.selectedSegmentIndex)!.lowercased()) ?? WorkoutOrientation.left
    }
}
