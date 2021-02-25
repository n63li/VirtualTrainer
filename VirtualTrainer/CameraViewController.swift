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

import AVFoundation
import CoreVideo
import MLKit

@objc(CameraViewController)
class CameraViewController: UIViewController {
    
  var workoutSession: WorkoutSession? = nil

  private var isUsingFrontCamera = true
  private var previewLayer: AVCaptureVideoPreviewLayer!
  private lazy var captureSession = AVCaptureSession()
  private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
  private var lastFrame: CMSampleBuffer?
    
    private var poseDetectorHelper: PoseDetectorHelper = PoseDetectorHelper()

  private lazy var previewOverlayView: UIImageView = {

    precondition(isViewLoaded)
    let previewOverlayView = UIImageView(frame: .zero)
    previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
    previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
    return previewOverlayView
  }()

  private lazy var annotationOverlayView: UIView = {
    precondition(isViewLoaded)
    let annotationOverlayView = UIView(frame: .zero)
    annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
    return annotationOverlayView
  }()

  // MARK: - IBOutlets

  @IBOutlet private weak var cameraView: UIView!

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    setUpPreviewOverlayView()
    setUpAnnotationOverlayView()
    setUpCaptureSessionOutput()
    setUpCaptureSessionInput()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    startSession()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    stopSession()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    previewLayer.frame = cameraView.frame
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "processWorkoutSegue") {
            let vc = segue.destination as! FeedbackViewController
            vc.workoutSession = workoutSession
        }
    }

  // MARK: - IBActions

  @IBAction func switchCamera(_ sender: Any) {
    isUsingFrontCamera = !isUsingFrontCamera
    removeDetectionAnnotations()
    setUpCaptureSessionInput()
  }

  // MARK: On-Device Detections
  private func detectPose(in image: VisionImage, width: CGFloat, height: CGFloat) {
    let poses = self.poseDetectorHelper.detectPose(in: image)
      DispatchQueue.main.sync {
        self.updatePreviewOverlayView()
        self.removeDetectionAnnotations()
      }
      guard !poses.isEmpty else {
        print("Pose detector returned no results.")
        return
      }
      DispatchQueue.main.sync {
        // Pose detected. Currently, only single person detection is supported.
        poses.forEach { pose in
          for (startLandmarkType, endLandmarkTypesArray) in UIUtilities.poseConnections() {
            let startLandmark = pose.landmark(ofType: startLandmarkType)
            if (startLandmark.inFrameLikelihood > 0.6) {
              for endLandmarkType in endLandmarkTypesArray {
                let endLandmark = pose.landmark(ofType: endLandmarkType)
                let startLandmarkPoint = normalizedPoint(
                  fromVisionPoint: startLandmark.position, width: width, height: height)
                let endLandmarkPoint = normalizedPoint(
                  fromVisionPoint: endLandmark.position, width: width, height: height)
                UIUtilities.addLineSegment(
                  fromPoint: startLandmarkPoint,
                  toPoint: endLandmarkPoint,
                  inView: self.annotationOverlayView,
                  color: UIColor.green,
                  width: Constant.lineWidth
                )
              }
            }
          }
          for landmark in pose.landmarks {
            let landmarkPoint = normalizedPoint(
              fromVisionPoint: landmark.position, width: width, height: height)
            UIUtilities.addCircle(
              atPoint: landmarkPoint,
              to: self.annotationOverlayView,
              color: UIColor.blue,
              radius: Constant.smallDotRadius
            )
          }
          
          var squatData: [SquatElement] = []
          let squatElement = PoseUtilities.getSquatAngles(pose: pose, orientation: .left)
          squatData.append(squatElement)
          displaySquatOverlay(pose: pose, to: self.annotationOverlayView, squatElement: squatElement, orientation: .left, width: width, height: height)
        }
      }
  }
    
    private func displaySquatOverlay(pose: Pose, to view: UIView, squatElement: SquatElement, orientation: SquatOrientation, width: CGFloat, height: CGFloat) {
      var knee: CGPoint
      var hip: CGPoint
      var ankle: CGPoint
      var shoulder: CGPoint
      
      
      switch orientation {
        case .left:
          knee = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftKnee).position, width: width, height: height)
          hip = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftHip).position, width: width, height: height)
          ankle = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftAnkle).position, width: width, height: height)
          shoulder = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftShoulder).position, width: width, height: height)
        case .right:
          knee = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightKnee).position, width: width, height: height)
          hip = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightHip).position, width: width, height: height)
          ankle = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightAnkle).position, width: width, height: height)
          shoulder = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightShoulder).position, width: width, height: height)
      }
      
      UIUtilities.addLabel(atPoint: knee, to: view, label: String(Int(squatElement.KneeAngle)))
      UIUtilities.addLabel(atPoint: hip, to: view, label: String(Int(squatElement.HipAngle)))
      UIUtilities.addLabel(atPoint: ankle, to: view, label: String(Int(squatElement.AnkleAngle)))
      UIUtilities.addLabel(atPoint: shoulder, to: view, label: String(Int(squatElement.TrunkAngle)))
    }

  // MARK: - Private

  private func setUpCaptureSessionOutput() {
    sessionQueue.async {
      self.captureSession.beginConfiguration()
      // When performing latency tests to determine ideal capture settings,
      // run the app in 'release' mode to get accurate performance metrics
      self.captureSession.sessionPreset = AVCaptureSession.Preset.medium

      let output = AVCaptureVideoDataOutput()
      output.videoSettings = [
        (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
      ]
      output.alwaysDiscardsLateVideoFrames = true
      let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
      output.setSampleBufferDelegate(self, queue: outputQueue)
      guard self.captureSession.canAddOutput(output) else {
        print("Failed to add capture session output.")
        return
      }
      self.captureSession.addOutput(output)
      self.captureSession.commitConfiguration()
    }
  }

  private func setUpCaptureSessionInput() {
    sessionQueue.async {
      let cameraPosition: AVCaptureDevice.Position = self.isUsingFrontCamera ? .front : .back
      guard let device = self.captureDevice(forPosition: cameraPosition) else {
        print("Failed to get capture device for camera position: \(cameraPosition)")
        return
      }
      do {
        self.captureSession.beginConfiguration()
        let currentInputs = self.captureSession.inputs
        for input in currentInputs {
          self.captureSession.removeInput(input)
        }

        let input = try AVCaptureDeviceInput(device: device)
        guard self.captureSession.canAddInput(input) else {
          print("Failed to add capture session input.")
          return
        }
        self.captureSession.addInput(input)
        self.captureSession.commitConfiguration()
      } catch {
        print("Failed to create capture device input: \(error.localizedDescription)")
      }
    }
  }

  private func startSession() {
    sessionQueue.async {
      self.captureSession.startRunning()
    }
  }

  private func stopSession() {
    sessionQueue.async {
      self.captureSession.stopRunning()
    }
  }

  private func setUpPreviewOverlayView() {
    cameraView.addSubview(previewOverlayView)
    NSLayoutConstraint.activate([
      previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
      previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
      previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
      previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),

    ])
  }

  private func setUpAnnotationOverlayView() {
    cameraView.addSubview(annotationOverlayView)
    NSLayoutConstraint.activate([
      annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
      annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
      annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
      annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
    ])
  }

  private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    if #available(iOS 10.0, *) {
      let discoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.builtInWideAngleCamera],
        mediaType: .video,
        position: .unspecified
      )
      return discoverySession.devices.first { $0.position == position }
    }
    return nil
  }

  private func removeDetectionAnnotations() {
    for annotationView in annotationOverlayView.subviews {
      annotationView.removeFromSuperview()
    }
  }

  private func updatePreviewOverlayView() {
    guard let lastFrame = lastFrame,
      let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
    else {
      return
    }
    let ciImage = CIImage(cvPixelBuffer: imageBuffer)
    let context = CIContext(options: nil)
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
      return
    }
    let rotatedImage = UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .right)
    if isUsingFrontCamera {
      guard let rotatedCGImage = rotatedImage.cgImage else {
        return
      }
      let mirroredImage = UIImage(
        cgImage: rotatedCGImage, scale: Constant.originalScale, orientation: .leftMirrored)
      previewOverlayView.image = mirroredImage
    } else {
      previewOverlayView.image = rotatedImage
    }
  }

  private func convertedPoints(
    from points: [NSValue]?,
    width: CGFloat,
    height: CGFloat
  ) -> [NSValue]? {
    return points?.map {
      let cgPointValue = $0.cgPointValue
      let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
      let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
      let value = NSValue(cgPoint: cgPoint)
      return value
    }
  }

  private func normalizedPoint(
    fromVisionPoint point: VisionPoint,
    width: CGFloat,
    height: CGFloat
  ) -> CGPoint {
    let cgPoint = CGPoint(x: point.x, y: point.y)
    var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
    normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
    return normalizedPoint
  }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      print("Failed to get image buffer from sample buffer.")
      return
    }
    self.poseDetectorHelper.resetManagedLifecycleDetectors()

    lastFrame = sampleBuffer
    let visionImage = VisionImage(buffer: sampleBuffer)
    let orientation = UIUtilities.imageOrientation(
      fromDevicePosition: isUsingFrontCamera ? .front : .back
    )

    visionImage.orientation = orientation
    let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
    let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))

    detectPose(in: visionImage, width: imageWidth, height: imageHeight)

  }
}

// MARK: - Constants

public enum Detector: String {
  case pose = "Pose Detection"
  case poseAccurate = "Pose Detection, accurate"
}

private enum Constant {
  static let alertControllerTitle = "Vision Detectors"
  static let alertControllerMessage = "Select a detector"
  static let cancelActionTitleText = "Cancel"
  static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
  static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
  static let noResultsMessage = "No Results"
  static let localModelFile = (name: "bird", type: "tflite")
  static let labelConfidenceThreshold: Float = 0.75
  static let smallDotRadius: CGFloat = 4.0
  static let lineWidth: CGFloat = 3.0
  static let originalScale: CGFloat = 1.0
  static let padding: CGFloat = 10.0
  static let resultsLabelHeight: CGFloat = 200.0
  static let resultsLabelLines = 5
}
