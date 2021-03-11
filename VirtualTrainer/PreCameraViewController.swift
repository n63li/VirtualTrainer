//
//  PreCameraViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-22.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
import AVKit
import CoreBluetooth


class PreCameraViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private var centralManager: CBCentralManager!
    private var peripheralIMU: CBPeripheral!
    private var isIMUEnabled: Bool = false
    
    private var workoutType: String = "squat"
    private var cameraAngle: WorkoutOrientation = WorkoutOrientation.left
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var toggleIMUButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn{
            print("Central is not powered")
        } else {
            print("Central scanning for", IMUPeripheral.IMUServiceUUID)
            centralManager.scanForPeripherals(withServices: [IMUPeripheral.IMUServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.centralManager.stopScan()
        
        self.peripheralIMU = peripheral
        self.peripheralIMU.delegate = self
        self.centralManager.connect(self.peripheralIMU, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheralIMU {
            print("Connected to IMU")
            peripheral.discoverServices([IMUPeripheral.IMUServiceUUID])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == IMUPeripheral.IMUServiceUUID	 {
                    peripheral.discoverCharacteristics(
                        [IMUPeripheral.XAccelCharacteristicUUID,
                        IMUPeripheral.YAccelCharacteristicUUID,
                        IMUPeripheral.ZAccelCharacteristicUUID], for: service)
                    return
                }
            }

        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == IMUPeripheral.XAccelCharacteristicUUID {
                    print("X Accel characteristic found")
                } else if characteristic.uuid == IMUPeripheral.YAccelCharacteristicUUID {
                    print("Y Accel characteristic found")
                } else if characteristic.uuid == IMUPeripheral.ZAccelCharacteristicUUID {
                    print("Z Accel characteristic found");
                }
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
            case IMUPeripheral.XAccelCharacteristicUUID:
                if let value = characteristic.value {
                    print("X: \((String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.floatValue)")
                }
                else {
                    print("Bad data for X-Accel")
                }
            case IMUPeripheral.YAccelCharacteristicUUID:
                if let value = characteristic.value {
                    print("Y: \((String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.floatValue)")
                }
                else {
                    print("Bad data for Y-Accel")
                }
            case IMUPeripheral.ZAccelCharacteristicUUID:
                if let value = characteristic.value {
                    print("Z: \((String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.floatValue)")
                }
                else {
                    print("Bad data for Z-Accel")
                }
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
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
            
            poses.forEach { pose in
                let jointAngles = PoseUtilities.getAngles(pose: pose, orientation: workoutSession.cameraAngle)
                workoutSession.jointAnglesList.append(jointAngles)
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
    
    @IBAction func toggleConnectIMU(_ sender: UIButton) {
        self.isIMUEnabled.toggle()
        if self.isIMUEnabled {
            sender.setTitle("Disconnect IMU", for: .normal)
            sender.setTitleColor(.red, for: .normal)
            print("IMU connected")
        } else {
            sender.setTitle("Connect IMU", for: .normal)
            sender.setTitleColor(.systemBlue, for: .normal)
            print("IMU disconnected")
        }
    }
}
