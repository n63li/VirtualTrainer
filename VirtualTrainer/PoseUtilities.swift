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

struct PoseData {
  let name: String
  var data: [Double]

  init(name: String, data: [Double] = []) {
    self.name = name
    self.data = data
  }
}

public struct SquatElement {
  let KneeAngle: CGFloat
  let HipAngle: CGFloat
  let AnkleAngle: CGFloat
  let TrunkAngle: CGFloat
}

public enum SquatOrientation: String {
  case left = "left"
  case right = "right"
  // front = "front"
//  case back = "back"
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
  
  public static func getSquatAngles(pose: Pose, orientation: SquatOrientation) -> SquatElement {
    var knee: CGPoint
    var hip: CGPoint
    var ankle: CGPoint
    var shoulder: CGPoint
    var toe: CGPoint
    var shoulderXHipY: CGPoint
    

    switch orientation {
      case .left:
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

    let kneeAngle = calcJointAngle(
      firstLandmark: hip,
      midLandmark: knee,
      lastLandmark: ankle)
    
    let hipAngle = calcJointAngle(
      firstLandmark: shoulder,
      midLandmark: hip,
      lastLandmark: knee)
    
    let ankleAngle = calcJointAngle(
      firstLandmark: knee,
      midLandmark: ankle,
      lastLandmark: toe)
    
    let trunkAngle = calcJointAngle(
      firstLandmark: shoulder,
      midLandmark: hip,
      lastLandmark: shoulderXHipY)

    return SquatElement(KneeAngle: kneeAngle, HipAngle: hipAngle, AnkleAngle: ankleAngle, TrunkAngle: trunkAngle)
  }
}
