//
//  PreCameraViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-22.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class PreCameraViewController: UIViewController, UITextFieldDelegate {
    private var workoutType: String = ""
    private var cameraAngle: SquatOrientation = SquatOrientation.left
    
    @IBOutlet weak var leftCameraAngle: UIButton!
    @IBOutlet weak var frontCameraAngle: UIButton!
    @IBOutlet weak var rightCameraAngle: UIButton!
    @IBOutlet weak var workoutTypeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutTypeTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startWorkoutSegue") {
            let vc = segue.destination as! CameraViewController
            vc.workoutSession = WorkoutSession(workoutType: workoutType, cameraAngle: cameraAngle != nil)
        }
    }
    
    @IBAction func workoutTypeChanged(_ sender: Any) {
        workoutType = workoutTypeTextField.text ?? ""
    }
    
    @IBAction func startWorkout(_ sender: Any) {
    }
    
    @IBAction func onLeftSelected(_ sender: Any) {
        cameraAngle = SquatOrientation.left
        leftCameraAngle.backgroundColor = .gray
        rightCameraAngle.backgroundColor = .systemBackground
        frontCameraAngle.backgroundColor = .systemBackground
    }

    @IBAction func onFrontSelected(_ sender: Any) {
        frontCameraAngle.backgroundColor = .gray
        leftCameraAngle.backgroundColor = .systemBackground
        rightCameraAngle.backgroundColor = .systemBackground
    }
    
    @IBAction func onRightSelected(_ sender: Any) {
        cameraAngle = SquatOrientation.right
        rightCameraAngle.backgroundColor = .gray
        leftCameraAngle.backgroundColor = .systemBackground
        frontCameraAngle.backgroundColor = .systemBackground
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
