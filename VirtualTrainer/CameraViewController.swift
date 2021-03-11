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
import Photos

@objc(CameraViewController)
class CameraViewController: UIViewController {
    
    var workoutSession: WorkoutSession? = nil
    
    private var avAssetWriter: AVAssetWriter? = nil
    private var avAssetWriterInput: AVAssetWriterInput? = nil
    private var avAssetWriterAdapter: AVAssetWriterInputPixelBufferAdaptor? = nil
    private var initialTimestamp: Double = 0
    
    private var isRecording: Bool = false
    
    private var isUsingFrontCamera = false
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
    
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        sessionQueue.async {
            self.stopRecording()
            self.captureSession.stopRunning()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func process(_ sender: Any) {
        let outputURL = self.avAssetWriter?.outputURL
        stopRecording()
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                self.transition()
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL!)
            }) { saved, error in
                print("Successfully saved \(saved), outputURL \(outputURL!.absoluteString)")
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject
                PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                    let newObj = avurlAsset as! AVURLAsset
                    self.workoutSession?.videoURL = newObj.url.absoluteString
                    self.transition()
                })
            }
        }
    }
    
    @IBAction func switchCamera(_ sender: Any) {
        isUsingFrontCamera = !isUsingFrontCamera
        removeDetectionAnnotations()
        setUpCaptureSessionInput()
    }
    
    private func transition() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            destination.workoutSession = self.workoutSession
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    private func stopRecording() {
        self.avAssetWriterInput?.markAsFinished()
        self.avAssetWriter?.finishWriting {
            self.avAssetWriter = nil
            self.avAssetWriterInput = nil
            self.avAssetWriterAdapter = nil
        }
    }
    
    // MARK: - Private
    
    private func setUpCaptureSessionOutput() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
            ]
            output.alwaysDiscardsLateVideoFrames = true
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            output.setSampleBufferDelegate(self, queue: outputQueue)
            self.captureSession.addOutput(output)
            self.captureSession.commitConfiguration()
            
            try? self.avAssetWriter = AVAssetWriter(outputURL: CameraViewController.getFileURL(), fileType: .mov)
            let settings = output.recommendedVideoSettingsForAssetWriter(writingTo: .mov)
            // let settings = [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 360, AVVideoHeightKey: 480]
            self.avAssetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: settings)
            self.avAssetWriterInput?.expectsMediaDataInRealTime = true
            // self.avAssetWriterInput?.mediaTimeScale = CMTimeScale(bitPattern: 600)
            self.avAssetWriterInput?.transform = CGAffineTransform(rotationAngle: .pi/2)
            // self.avAssetWriterInput?.transform = self.getVideoTransform()
            self.avAssetWriterAdapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: self.avAssetWriterInput!, sourcePixelBufferAttributes: nil)
            self.avAssetWriter?.add(self.avAssetWriterInput!)
            
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
        let image = UIImage(cgImage: cgImage)
        previewOverlayView.image = image
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
    
    // MARK: On-Device Detections
    private func detectPose(in image: VisionImage, width: CGFloat, height: CGFloat) {
        let poses = self.poseDetectorHelper.detectPose(in: image)
        DispatchQueue.main.sync {
            self.updatePreviewOverlayView()
            self.removeDetectionAnnotations()
        }
        guard !poses.isEmpty else {
            return
        }
        DispatchQueue.main.sync {
            poses.forEach { pose in
                PoseUtilities.displaySkeleton(pose: pose, width: width, height: height, previewLayer: previewLayer, annotationOverlayView: self.annotationOverlayView)
                
                let jointAngles = PoseUtilities.getAngles(pose: pose, orientation: workoutSession!.cameraAngle)
                workoutSession?.jointAnglesList.append(jointAngles)
                
                PoseUtilities.displayOverlay(pose: pose, to: self.annotationOverlayView, jointAngles: jointAngles, orientation: workoutSession?.cameraAngle ?? WorkoutOrientation.left, width: width, height: height, previewLayer: previewLayer)
            }
        }
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
        visionImage.orientation = UIUtilities.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back
        )
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        print("Buffer: \(imageWidth), \(imageHeight)")
        
        detectPose(in: visionImage, width: imageWidth, height: imageHeight)
        
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds
        if (self.isRecording == false) {
            self.initialTimestamp = timestamp
            self.avAssetWriter?.startWriting()
            self.avAssetWriter?.startSession(atSourceTime: .zero)
            self.isRecording = true
        }
        let time = CMTime(seconds: timestamp - self.initialTimestamp, preferredTimescale: CMTimeScale(600))
        self.avAssetWriterAdapter?.append(imageBuffer, withPresentationTime: time)
    }
}

extension CameraViewController {
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
}

extension CameraViewController {
    static func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let timestamp = NSDate().timeIntervalSince1970
        let fileUrl = paths[0].appendingPathComponent("\(timestamp)_workout.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        return fileUrl
    }
    
    static func getVideoTransform() -> CGAffineTransform {
        switch UIDevice.current.orientation {
            case .portrait:
                return .identity
            case .portraitUpsideDown:
                return CGAffineTransform(rotationAngle: .pi)
            case .landscapeLeft:
                return CGAffineTransform(rotationAngle: .pi/2)
            case .landscapeRight:
                return CGAffineTransform(rotationAngle: -.pi/2)
            default:
                return .identity
            }
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
