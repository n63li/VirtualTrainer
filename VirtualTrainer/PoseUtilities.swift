//
//  PoseUtilities.swift
//  VirtualTrainer
//
//  Created by Jeremy Afoke on 2021-02-19.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation
import AVFoundation
import MLKit
import UIKit

protocol Loopable {
    func allProperties() throws -> [String: Any]
}

extension Loopable {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
          
            if property == "orientation" { continue }

            result[property] = value
        }

        return result
    }
}

public struct PoseData {
  let name: String
  var data: [CGFloat]

  init(name: String, data: [CGFloat] = []) {
    self.name = name
    self.data = data
  }
}

public struct SquatElement: Codable, Loopable {
  var orientation: String
  var KneeAngle: CGFloat
  var HipAngle: CGFloat
  var AnkleAngle: CGFloat
  var TrunkAngle: CGFloat
  
  func valueByPropertyName(name: String) -> CGFloat {
      switch name {
      case "KneeAngle": return self.KneeAngle
      case "HipAngle": return self.HipAngle
      case "AnkleAngle": return self.AnkleAngle
      case "TrunkAngle": return self.TrunkAngle
      default: fatalError("Wrong property name")
      }
  }
}

public struct DeadliftElement: Codable, Loopable {
  var orientation: String
  var LeftKneeAngle: CGFloat
  var RightKneeAngle: CGFloat
  var LeftHipAngle: CGFloat
  var RightHipAngle: CGFloat
  var LeftAnkleAngle: CGFloat
  var RightAnkleAngle: CGFloat
  var LeftTrunkAngle: CGFloat
  var RightTrunkAngle: CGFloat
  var LeftShoulderAngle: CGFloat
  var RightShoulderAngle: CGFloat
  var LeftElbowAngle: CGFloat
  var RightElbowAngle: CGFloat
}

public enum WorkoutOrientation: String {
  case left = "left"
  case right = "right"
  case front = "front"
}


public class PoseUtilities {
  public static func calcJointAngle(
        firstLandmark: CGPoint,
        midLandmark: CGPoint,
        lastLandmark: CGPoint
    ) -> CGFloat {
        let radians: CGFloat =
            atan2(lastLandmark.y - midLandmark.y,
                      lastLandmark.x - midLandmark.x) -
              atan2(firstLandmark.y - midLandmark.y,
                      firstLandmark.x - midLandmark.x)
        var degrees = radians * 180.0 / .pi
        degrees = abs(degrees) // Angle should never be negative
        if degrees > 180.0 {
            degrees = 360.0 - degrees // Always get the acute representation of the angle
        }
        return degrees
    }

  public static func getSquatAngles(pose: Pose, orientation: WorkoutOrientation) -> SquatElement {
    var knee: CGPoint
    var hip: CGPoint
    var ankle: CGPoint
    var shoulder: CGPoint
    var toe: CGPoint
    var shoulderXHipY: CGPoint


    switch orientation {
    case .left, .front:
          knee = CGPoint(x: pose.landmark(ofType: .leftKnee).position.x, y: pose.landmark(ofType: .leftKnee).position.y)
          hip = CGPoint(x: pose.landmark(ofType: .leftHip).position.x, y: pose.landmark(ofType: .leftHip).position.y)
          ankle = CGPoint(x: pose.landmark(ofType: .leftAnkle).position.x, y: pose.landmark(ofType: .leftAnkle).position.y)
          shoulder = CGPoint(x: pose.landmark(ofType: .leftShoulder).position.x, y: pose.landmark(ofType: .leftShoulder).position.y)
          toe = CGPoint(x: pose.landmark(ofType: .leftToe).position.x, y: pose.landmark(ofType: .leftToe).position.y)
          shoulderXHipY = CGPoint(x: pose.landmark(ofType: .leftShoulder).position.x, y: pose.landmark(ofType: .leftHip).position.y)

    case .right:
          knee = CGPoint(x: pose.landmark(ofType: .rightKnee).position.x, y: pose.landmark(ofType: .rightKnee).position.y)
          hip = CGPoint(x: pose.landmark(ofType: .rightHip).position.x, y: pose.landmark(ofType: .rightHip).position.y)
          ankle = CGPoint(x: pose.landmark(ofType: .rightAnkle).position.x, y: pose.landmark(ofType: .rightAnkle).position.y)
          shoulder = CGPoint(x: pose.landmark(ofType: .rightShoulder).position.x, y: pose.landmark(ofType: .rightShoulder).position.y)
          toe = CGPoint(x: pose.landmark(ofType: .rightToe).position.x, y: pose.landmark(ofType: .rightToe).position.y)
          shoulderXHipY = CGPoint(x: pose.landmark(ofType: .rightShoulder).position.x, y: pose.landmark(ofType: .rightShoulder).position.y)
    }
    
    return SquatElement(orientation: orientation.rawValue,
                        KneeAngle: calcJointAngle(
                          firstLandmark: hip,
                          midLandmark: knee,
                          lastLandmark: ankle
                        ),
                        HipAngle: calcJointAngle(
                          firstLandmark: shoulder,
                          midLandmark: hip,
                          lastLandmark: knee
                        ),
                        AnkleAngle: calcJointAngle(
                          firstLandmark: knee,
                          midLandmark: ankle,
                          lastLandmark: toe
                        ),
                        TrunkAngle: calcJointAngle(
                          firstLandmark: shoulder,
                          midLandmark: hip,
                          lastLandmark: shoulderXHipY
                        )
    )
  }

  public static func poseLandmarkToCGPoint(l: PoseLandmark) -> CGPoint {
    return CGPoint(x: l.position.x, y: l.position.y)
  }

  public static func getDeadLiftAngles(pose: Pose, orientation: WorkoutOrientation) -> DeadliftElement {
    let leftKnee = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftKnee))
    let leftHip = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftHip))
    let leftAnkle = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftAnkle))
    let leftShoulder = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftShoulder))
    let leftToe = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftToe))
    let leftElbow = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftElbow))
    let leftWrist = poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftWrist))
    let leftShoulderXHipY = CGPoint(x: pose.landmark(ofType: .leftShoulder).position.x, y: pose.landmark(ofType: .leftHip).position.y)
    
    let rightKnee = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightKnee))
    let rightHip = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightHip))
    let rightAnkle = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightAnkle))
    let rightShoulder = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightShoulder))
    let rightToe = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightToe))
    let rightElbow = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightElbow))
    let rightWrist = poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightWrist))
    let rightShoulderXHipY = CGPoint(x: pose.landmark(ofType: .rightShoulder).position.x, y: pose.landmark(ofType: .rightShoulder).position.y)

    return DeadliftElement(orientation: orientation.rawValue,
                           LeftKneeAngle: calcJointAngle(
                              firstLandmark: leftHip,
                              midLandmark: leftKnee,
                              lastLandmark: leftAnkle
                           ),
                           RightKneeAngle: calcJointAngle(
                              firstLandmark: rightHip,
                              midLandmark: rightKnee,
                              lastLandmark: rightAnkle
                           ),
                           LeftHipAngle: calcJointAngle(
                              firstLandmark: leftShoulder,
                              midLandmark: leftHip,
                              lastLandmark: leftKnee
                           ),
                           RightHipAngle: calcJointAngle(
                              firstLandmark: rightShoulder,
                              midLandmark: rightHip,
                              lastLandmark: rightKnee
                           ),
                           LeftAnkleAngle: calcJointAngle(
                              firstLandmark: leftKnee,
                              midLandmark: leftAnkle,
                              lastLandmark: leftToe
                           ),
                           RightAnkleAngle: calcJointAngle(
                              firstLandmark: rightKnee,
                              midLandmark: rightAnkle,
                              lastLandmark: rightToe
                           ),
                           LeftTrunkAngle: calcJointAngle(
                              firstLandmark: leftShoulder,
                              midLandmark: leftHip,
                              lastLandmark: leftShoulderXHipY
                           ),
                           RightTrunkAngle: calcJointAngle(
                              firstLandmark: rightShoulder,
                              midLandmark: rightHip,
                              lastLandmark: rightShoulderXHipY
                           ),
                           LeftShoulderAngle: calcJointAngle(
                            firstLandmark: leftElbow,
                            midLandmark: leftShoulder,
                            lastLandmark: leftHip
                         ),
                           RightShoulderAngle: calcJointAngle(
                            firstLandmark: rightElbow,
                            midLandmark: rightShoulder,
                            lastLandmark: rightHip
                         ),
                           LeftElbowAngle: calcJointAngle(
                            firstLandmark: leftShoulder,
                            midLandmark: leftElbow,
                            lastLandmark: leftWrist
                         ),
                           RightElbowAngle: calcJointAngle(
                            firstLandmark: rightShoulder,
                            midLandmark: rightElbow,
                            lastLandmark: rightWrist
                         )
    )
  }
  
  public static func normalizedPoint(
    fromVisionPoint point: VisionPoint,
    width: CGFloat,
    height: CGFloat,
    previewLayer: AVCaptureVideoPreviewLayer
  ) -> CGPoint {
    let cgPoint = CGPoint(x: point.x, y: point.y)
    var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
    normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
    return normalizedPoint
  }
  
  public static func displaySkeleton(pose: Pose, width: CGFloat, height: CGFloat, previewLayer: AVCaptureVideoPreviewLayer, annotationOverlayView: UIView) {
    for (startLandmarkType, endLandmarkTypesArray) in UIUtilities.poseConnections() {
      let startLandmark = pose.landmark(ofType: startLandmarkType)
      if (startLandmark.inFrameLikelihood > 0.6) {
        for endLandmarkType in endLandmarkTypesArray {
          let endLandmark = pose.landmark(ofType: endLandmarkType)
          let startLandmarkPoint = normalizedPoint(
            fromVisionPoint: startLandmark.position, width: width, height: height, previewLayer: previewLayer)
          let endLandmarkPoint = normalizedPoint(
            fromVisionPoint: endLandmark.position, width: width, height: height, previewLayer: previewLayer)
          UIUtilities.addLineSegment(
            fromPoint: startLandmarkPoint,
            toPoint: endLandmarkPoint,
            inView: annotationOverlayView,
            color: UIColor.green,
            width: 3.0
          )
        }
      }
    }
    
    for landmark in pose.landmarks {
      let landmarkPoint = normalizedPoint(
        fromVisionPoint: landmark.position, width: width, height: height, previewLayer: previewLayer)
      UIUtilities.addCircle(
        atPoint: landmarkPoint,
        to: annotationOverlayView,
        color: UIColor.blue,
        radius: 4.0
      )
    }
  }
  
  public static func displaySquatOverlay(pose: Pose, to view: UIView, squatElement: SquatElement, orientation: WorkoutOrientation, width: CGFloat, height: CGFloat, previewLayer: AVCaptureVideoPreviewLayer) {
    var knee: CGPoint
    var hip: CGPoint
    var ankle: CGPoint
    var shoulder: CGPoint


    switch orientation {
    case .left, .front:
            knee = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftKnee).position, width: width, height: height, previewLayer: previewLayer)
            hip = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftHip).position, width: width, height: height, previewLayer: previewLayer)
            ankle = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftAnkle).position, width: width, height: height, previewLayer: previewLayer)
            shoulder = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftShoulder).position, width: width, height: height, previewLayer: previewLayer)
        case .right:
            knee = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightKnee).position, width: width, height: height, previewLayer: previewLayer)
            hip = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightHip).position, width: width, height: height, previewLayer: previewLayer)
            ankle = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightAnkle).position, width: width, height: height, previewLayer: previewLayer)
            shoulder = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightShoulder).position, width: width, height: height, previewLayer: previewLayer)
    }

    UIUtilities.addLabel(atPoint: knee, to: view, label: String(Int(squatElement.KneeAngle)))
    UIUtilities.addLabel(atPoint: hip, to: view, label: String(Int(squatElement.HipAngle)))
    UIUtilities.addLabel(atPoint: ankle, to: view, label: String(Int(squatElement.AnkleAngle)))
    UIUtilities.addLabel(atPoint: shoulder, to: view, label: String(Int(squatElement.TrunkAngle)))
  }
  
  public static func displayDeadliftOverlay(pose: Pose, to view: UIView, deadliftElement: DeadliftElement, orientation: WorkoutOrientation, width: CGFloat, height: CGFloat, previewLayer: AVCaptureVideoPreviewLayer) {
    
    let leftKnee = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftKnee).position, width: width, height: height, previewLayer: previewLayer)
    let leftHip = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftHip).position, width: width, height: height, previewLayer: previewLayer)
    let leftAnkle = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftAnkle).position, width: width, height: height, previewLayer: previewLayer)
    let leftShoulder = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftShoulder).position, width: width, height: height, previewLayer: previewLayer)
    let leftElbow = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .leftElbow).position, width: width, height: height, previewLayer: previewLayer)
    
    let rightKnee = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightKnee).position, width: width, height: height, previewLayer: previewLayer)
    let rightHip = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightHip).position, width: width, height: height, previewLayer: previewLayer)
    let rightAnkle = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightAnkle).position, width: width, height: height, previewLayer: previewLayer)
    let rightShoulder = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightShoulder).position, width: width, height: height, previewLayer: previewLayer)
    let rightElbow = normalizedPoint(fromVisionPoint: pose.landmark(ofType: .rightElbow).position, width: width, height: height, previewLayer: previewLayer)


    switch orientation {
    case .left, .right:
        UIUtilities.addLabel(atPoint: rightKnee, to: view, label: String(Int(deadliftElement.RightKneeAngle)))
        UIUtilities.addLabel(atPoint: rightHip, to: view, label: String(Int(deadliftElement.RightHipAngle)))
        UIUtilities.addLabel(atPoint: rightAnkle, to: view, label: String(Int(deadliftElement.RightAnkleAngle)))
        UIUtilities.addLabel(atPoint: rightShoulder, to: view, label: String(Int(deadliftElement.RightTrunkAngle)))
        UIUtilities.addLabel(atPoint: rightElbow, to: view, label: String(Int(deadliftElement.RightElbowAngle)))
      case .front:
        UIUtilities.addLabel(atPoint: leftKnee, to: view, label: String(Int(deadliftElement.LeftKneeAngle)))
        UIUtilities.addLabel(atPoint: leftHip, to: view, label: String(Int(deadliftElement.LeftHipAngle)))
        UIUtilities.addLabel(atPoint: leftAnkle, to: view, label: String(Int(deadliftElement.LeftAnkleAngle)))
        UIUtilities.addLabel(atPoint: leftShoulder, to: view, label: String(Int(deadliftElement.LeftTrunkAngle)))
        UIUtilities.addLabel(atPoint: leftElbow, to: view, label: String(Int(deadliftElement.LeftElbowAngle)))
        
        UIUtilities.addLabel(atPoint: rightKnee, to: view, label: String(Int(deadliftElement.RightKneeAngle)))
        UIUtilities.addLabel(atPoint: rightHip, to: view, label: String(Int(deadliftElement.RightHipAngle)))
        UIUtilities.addLabel(atPoint: rightAnkle, to: view, label: String(Int(deadliftElement.RightAnkleAngle)))
        UIUtilities.addLabel(atPoint: rightShoulder, to: view, label: String(Int(deadliftElement.RightTrunkAngle)))
        UIUtilities.addLabel(atPoint: rightElbow, to: view, label: String(Int(deadliftElement.RightElbowAngle)))
    }

  }
}
