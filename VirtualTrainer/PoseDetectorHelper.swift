//
//  PoseDetectorHelper.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-24.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import AVFoundation
import UIKit
import MLKit

class PoseDetectorHelper {
    /// Initialized when one of the pose detector rows are chosen. Reset to `nil` when neither are.
    private var poseDetector: PoseDetector? = nil
    
    init(frames: [UIImage] ) {
        resetManagedLifecycleDetectors()
        frames.forEach { frame in
            detectPose(in: VisionImage(image: frame))
        }
    }
    
    init() {
        
    }
    
    func getResults() {
        
    }
    
    func detectPose(in image: VisionImage) -> [Pose] {
      if let poseDetector = self.poseDetector {
        var poses: [Pose]
        do {
          poses = try poseDetector.results(in: image)
        } catch let error {
          print("Failed to detect poses with error: \(error.localizedDescription).")
          return []
        }

        guard !poses.isEmpty else {
          print("Pose detector returned no results.")
          return []
        }
        return poses
      }
        return []
    }
    
    /// Resets any detector instances which use a conventional lifecycle paradigm. This method is
    /// expected to be invoked on the AVCaptureOutput queue - the same queue on which detection is
    /// run.
    func resetManagedLifecycleDetectors() {
      if (self.poseDetector != nil) {
          return
      }
      let options = AccuratePoseDetectorOptions()
      options.detectorMode = .stream
      self.poseDetector = PoseDetector.poseDetector(options: options)
    }
}
