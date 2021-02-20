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
  let KneeAngle: Double
  let HipAngle: Double
  let AnkleAngle: Double
  let TrunkAngle: Double
}

public enum SquatOrientation: String {
  case left = "left"
  case right = "right"
//  case front = "front"
//  case back = "back"
}


public class PoseUtilities {
  public static func getSquatAngles(pose: Pose, orientation: SquatOrientation) -> SquatElement {
    switch orientation {
      case .left:
        let knee = CGPoint(x: pose.landmark(ofType: .leftKnee).position.x, y: pose.landmark(ofType: .leftKnee).position.y)
        let hip = CGPoint(x: pose.landmark(ofType: .leftHip).position.x, y: pose.landmark(ofType: .leftHip).position.y)
        let ankle = CGPoint(x: pose.landmark(ofType: .leftAnkle).position.x, y: pose.landmark(ofType: .leftAnkle).position.y)
        let shoulder = CGPoint(x: pose.landmark(ofType: .leftShoulder).position.x, y: pose.landmark(ofType: .leftShoulder).position.y)
        let anKnee = CGPoint(x: knee.x, y: ankle.y)
        let sHip = CGPoint(x: shoulder.x, y: hip.y)

        let kneeAngle = calcAngle(p1: ankle, p2: knee, p3: hip)
  //        (atan2(ankle.y - knee.y, ankle.x - knee.x) - atan2(hip.y - knee.y, hip.x - knee.x)) * (180 / Double.pi)
        let hipAngle = calcAngle(p1: knee, p2: hip, p3: shoulder, quadrantAdjust: true)
  //        360 - (atan2(knee.y - hip.y, knee.x - hip.x) - atan2(shoulder.y - hip.y, shoulder.x - hip.x)) * (180 / Double.pi)
        let ankleAngle = calcAngle(p1: anKnee, p2: ankle, p3: knee, quadrantAdjust: true)
  //        360 - (atan2(anKnee.y - ankle.y, anKnee.x - ankle.x) - atan2(knee.y - ankle.y, knee.x - ankle.x)) * (180 / Double.pi)
        let trunkAngle = calcAngle(p1: sHip, p2: hip, p3: shoulder, quadrantAdjust: true)
  //        360 - (atan2(sHip.y - hip.y, sHip.x - hip.x) - atan2(shoulder.y - hip.y, shoulder.x - hip.x)) * (180 / Double.pi)

        return SquatElement(KneeAngle: kneeAngle, HipAngle: hipAngle, AnkleAngle: ankleAngle, TrunkAngle: trunkAngle)
      case .right:
        let knee = CGPoint(x: pose.landmark(ofType: .rightKnee).position.x, y: pose.landmark(ofType: .rightKnee).position.y)
        let hip = CGPoint(x: pose.landmark(ofType: .rightHip).position.x, y: pose.landmark(ofType: .rightHip).position.y)
        let ankle = CGPoint(x: pose.landmark(ofType: .rightAnkle).position.x, y: pose.landmark(ofType: .rightAnkle).position.y)
        let shoulder = CGPoint(x: pose.landmark(ofType: .rightShoulder).position.x, y: pose.landmark(ofType: .rightShoulder).position.y)
        let anKnee = CGPoint(x: knee.x, y: ankle.y)
        let sHip = CGPoint(x: shoulder.x, y: hip.y)

        let kneeAngle = calcAngle(p1: anKnee, p2: knee, p3: hip, quadrantAdjust: true)
//          360 - (Math.atan2(ankle.y - knee.y, ankle.x - knee.x) - Math.atan2(hip.y - knee.y, hip.x - knee.x)) * (180 / Math.PI);
        let hipAngle = calcAngle(p1: knee, p2: hip, p3: shoulder)
//          (Math.atan2(knee.y - hip.y, knee.x - hip.x) - Math.atan2(shoulder.y - hip.y, shoulder.x - hip.x)) * (180 / Math.PI);
        let ankleAngle = calcAngle(p1: anKnee, p2: ankle, p3: knee)
//          (Math.atan2(anKnee.y - ankle.y, anKnee.x - ankle.x) - Math.atan2(knee.y - ankle.y, knee.x - ankle.x)) * (180 / Math.PI);
        let trunkAngle = calcAngle(p1: sHip, p2: hip, p3: shoulder)
//          (Math.atan2(sHip.y - hip.y, sHip.x - hip.x) - Math.atan2(shoulder.y - hip.y, shoulder.x - hip.x)) * (180 / Math.PI);

        return SquatElement(KneeAngle: kneeAngle, HipAngle: hipAngle, AnkleAngle: ankleAngle, TrunkAngle: trunkAngle)
    }
  }
  
//  public static func getSquatAngles(pose: Pose, orientation: SquatOrientation) -> SquatElement {
//    var knee: CGPoint
//    var hip: CGPoint
//    var ankle: CGPoint
//    var shoulder: CGPoint
//
//    switch orientation {
//      case .left:
//        knee = CGPoint(x: pose.landmark(ofType: .leftKnee).position.x, y: pose.landmark(ofType: .leftKnee).position.y)
//        hip = CGPoint(x: pose.landmark(ofType: .leftHip).position.x, y: pose.landmark(ofType: .leftHip).position.y)
//        ankle = CGPoint(x: pose.landmark(ofType: .leftAnkle).position.x, y: pose.landmark(ofType: .leftAnkle).position.y)
//        shoulder = CGPoint(x: pose.landmark(ofType: .leftShoulder).position.x, y: pose.landmark(ofType: .leftShoulder).position.y)
//
//      case .right:
//        knee = CGPoint(x: pose.landmark(ofType: .rightKnee).position.x, y: pose.landmark(ofType: .rightKnee).position.y)
//        hip = CGPoint(x: pose.landmark(ofType: .rightHip).position.x, y: pose.landmark(ofType: .rightHip).position.y)
//        ankle = CGPoint(x: pose.landmark(ofType: .rightAnkle).position.x, y: pose.landmark(ofType: .rightAnkle).position.y)
//        shoulder = CGPoint(x: pose.landmark(ofType: .rightShoulder).position.x, y: pose.landmark(ofType: .rightShoulder).position.y)
//    }
//
//    let hip1 = atan2(abs(shoulder.y - hip.y), abs(shoulder.x - hip.x))
//    let hip2 = atan2(abs(hip.y - knee.y), abs(hip.x - knee.x))
//    let knee1 = hip2
//    let knee2 = atan2(abs(knee.y - ankle.y), abs(knee.x - ankle.x))
//
//    let kneeAngle = Double(knee1 + knee2) * (180/Double.pi)
//    let hipAngle = Double(hip1 + hip2) * (180/Double.pi)
//    let ankleAngle = Double(knee2) * (180/Double.pi)
//    let trunkAngle = Double(hip1) * (180/Double.pi)
//
//    return SquatElement(KneeAngle: kneeAngle, HipAngle: hipAngle, AnkleAngle: ankleAngle, TrunkAngle: trunkAngle)
//  }

  public static func calcAngle(p1: CGPoint, p2: CGPoint, p3: CGPoint, quadrantAdjust: Bool = false) -> Double {
     let angle = (atan2(Double(p1.y - p2.y), Double(p1.x - p2.x)) - atan2(Double(p3.y - p2.y), Double(p3.x - p2.x)))*(180/Double.pi)

     if (quadrantAdjust) {
       return 360 - angle
     }
     return angle
  }
}
