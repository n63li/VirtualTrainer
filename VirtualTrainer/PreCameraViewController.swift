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

    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startWorkoutSegue") {
            let vc = segue.destination as! CameraViewController
            vc.workoutSession = WorkoutSession(
                workoutType: workoutType,
                cameraAngle: cameraAngle
            )
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPreset1920x1080
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        imagePickerController.dismiss(animated: true, completion: nil)
        self.progressBar.setProgress(0, animated: false)
        self.progressBar.isHidden = false
        DispatchQueue.global(qos: .background).async {
            let buffers = UIUtilities.getAllFrames(videoURL: videoURL)
            let poseDetectorHelper = PoseDetectorHelper(buffers: buffers) { (progress) -> () in
                DispatchQueue.main.async {
                    self.progressBar.setProgress(progress, animated: true)
                }
            }
            let poses = poseDetectorHelper.getResults()
            let workoutSession = WorkoutSession(
                workoutType: self.workoutType,
                cameraAngle: self.cameraAngle
            )
            let width = CGFloat(CVPixelBufferGetWidth(CMSampleBufferGetImageBuffer(buffers[0])!))
            let height = CGFloat(CVPixelBufferGetHeight(CMSampleBufferGetImageBuffer(buffers[0])!))
          
            let encoder = JSONEncoder()
          
            poses.forEach { pose in
              let jointAngles = PoseUtilities.getAngles(pose: pose, orientation: workoutSession.cameraAngle)
              var encodedJointAngles = ""
              
              do {
                let jsonData = try encoder.encode(jointAngles)
                encodedJointAngles = String(data: jsonData, encoding: .utf8)!
              } catch {
                print("Unable to encode joint angles")
              }
              
              
              let workoutElement = WorkoutElement(
                orientation: self.cameraAngle.rawValue,
                jointAngles: encodedJointAngles
              )
              
              workoutSession.workoutElements.append(workoutElement)
//              add video overlay later => miss preview layer
//              PoseUtilities.displayOverlay(pose: pose, to: self.annotationOverlayView, workoutElement: workoutElement, orientation: workoutSession?.cameraAngle ?? WorkoutOrientation.left, width: width, height: height, previewLayer: previewLayer)
            }
            
            DispatchQueue.main.async {
                workoutSession.videoURL = videoURL.absoluteString
                self.progressBar.isHidden = true
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                vc.workoutSession = workoutSession
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
