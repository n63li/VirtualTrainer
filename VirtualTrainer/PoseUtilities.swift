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

public struct PoseData {
    let name: String
    var data: [CGFloat]
    
    init(name: String, data: [CGFloat] = []) {
        self.name = name
        self.data = data
    }
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
    
    public static func calcJointAngle(
        firstLandmark: PoseLandmark,
        midLandmark: PoseLandmark,
        lastLandmark: PoseLandmark
    ) -> CGFloat {
        let radians: CGFloat =
            atan2(lastLandmark.position.y - midLandmark.position.y,
                  lastLandmark.position.x - midLandmark.position.x) -
            atan2(firstLandmark.position.y - midLandmark.position.y,
                  firstLandmark.position.x - midLandmark.position.x)
        var degrees = radians * 180.0 / .pi
        degrees = abs(degrees) // Angle should never be negative
        if degrees > 180.0 {
            degrees = 360.0 - degrees // Always get the acute representation of the angle
        }
        return degrees
    }
    
    public static func poseLandmarkToCGPoint(l: PoseLandmark) -> CGPoint {
        return CGPoint(x: l.position.x, y: l.position.y)
    }
    
    public static func getAngles(pose: Pose, orientation: WorkoutOrientation) -> [String: CGFloat] {
        
        let leftShoulderXHipY = CGPoint(x: pose.landmark(ofType: .leftShoulder).position.x, y: pose.landmark(ofType: .leftHip).position.y)
        let rightShoulderXHipY = CGPoint(x: pose.landmark(ofType: .rightShoulder).position.x, y: pose.landmark(ofType: .rightShoulder).position.y)
        
        let LeftKneeAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .leftHip),
            midLandmark: pose.landmark(ofType: .leftKnee),
            lastLandmark: pose.landmark(ofType: .leftAnkle)
        )
        let RightKneeAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .rightHip),
            midLandmark: pose.landmark(ofType: .rightKnee),
            lastLandmark: pose.landmark(ofType: .rightAnkle)
        )
        let LeftHipAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .leftShoulder),
            midLandmark: pose.landmark(ofType: .leftHip),
            lastLandmark: pose.landmark(ofType: .leftKnee)
        )
        let RightHipAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .rightShoulder),
            midLandmark: pose.landmark(ofType: .rightHip),
            lastLandmark: pose.landmark(ofType: .rightKnee)
        )
        let LeftAnkleAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .leftKnee),
            midLandmark: pose.landmark(ofType: .leftAnkle),
            lastLandmark: pose.landmark(ofType: .leftToe)
        )
        let RightAnkleAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .rightKnee),
            midLandmark: pose.landmark(ofType: .rightAnkle),
            lastLandmark: pose.landmark(ofType: .rightToe)
        )
        let LeftTrunkAngle = calcJointAngle(
            firstLandmark: poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftShoulder)),
            midLandmark: poseLandmarkToCGPoint(l: pose.landmark(ofType: .leftHip)),
            lastLandmark: leftShoulderXHipY
        )
        let RightTrunkAngle = calcJointAngle(
            firstLandmark: poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightShoulder)),
            midLandmark: poseLandmarkToCGPoint(l: pose.landmark(ofType: .rightHip)),
            lastLandmark: rightShoulderXHipY
        )
        let LeftShoulderAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .leftElbow),
            midLandmark: pose.landmark(ofType: .leftShoulder),
            lastLandmark: pose.landmark(ofType: .leftHip)
        )
        let RightShoulderAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .rightElbow),
            midLandmark: pose.landmark(ofType: .rightShoulder),
            lastLandmark: pose.landmark(ofType: .rightHip)
        )
        let LeftElbowAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .leftShoulder),
            midLandmark: pose.landmark(ofType: .leftElbow),
            lastLandmark: pose.landmark(ofType: .leftWrist)
        )
        let RightElbowAngle = calcJointAngle(
            firstLandmark: pose.landmark(ofType: .rightShoulder),
            midLandmark: pose.landmark(ofType: .rightElbow),
            lastLandmark: pose.landmark(ofType: .rightWrist)
        )
        
        var jointAngles: [String: CGFloat] = [:]
        
        switch orientation {
        case .left:
            jointAngles = [
                "LeftKneeAngle": LeftKneeAngle,
                "LeftHipAngle": LeftHipAngle,
                "LeftAnkleAngle": LeftAnkleAngle,
                "LeftTrunkAngle": LeftTrunkAngle,
                "LeftShoulderAngle": LeftShoulderAngle,
                "LeftElbowAngle": LeftElbowAngle,
            ]
        case .right:
            jointAngles = [
                "RightKneeAngle": RightKneeAngle,
                "RightHipAngle": RightHipAngle,
                "RightAnkleAngle": RightAnkleAngle,
                "RightTrunkAngle": RightTrunkAngle,
                "RightShoulderAngle": RightShoulderAngle,
                "RightElbowAngle": RightElbowAngle
            ]
        case .front:
            jointAngles = [
                "LeftKneeAngle": LeftKneeAngle,
                "LeftHipAngle": LeftHipAngle,
                "LeftAnkleAngle": LeftAnkleAngle,
                "LeftTrunkAngle": LeftTrunkAngle,
                "LeftShoulderAngle": LeftShoulderAngle,
                "LeftElbowAngle": LeftElbowAngle,
                "RightKneeAngle": RightKneeAngle,
                "RightHipAngle": RightHipAngle,
                "RightAnkleAngle": RightAnkleAngle,
                "RightTrunkAngle": RightTrunkAngle,
                "RightShoulderAngle": RightShoulderAngle,
                "RightElbowAngle": RightElbowAngle
            ]
        }
        
        return jointAngles
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
    
    public static func displayOverlay(pose: Pose, to view: UIView, jointAngles: [String: CGFloat], orientation: WorkoutOrientation, width: CGFloat, height: CGFloat, previewLayer: AVCaptureVideoPreviewLayer) {
        
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
        case .left:
            UIUtilities.addLabel(atPoint: leftKnee, to: view, label: String(Int(jointAngles["LeftKneeAngle"]!)))
            UIUtilities.addLabel(atPoint: leftHip, to: view, label: String(Int(jointAngles["LeftHipAngle"]!)))
            UIUtilities.addLabel(atPoint: leftAnkle, to: view, label: String(Int(jointAngles["LeftAnkleAngle"]!)))
            UIUtilities.addLabel(atPoint: leftShoulder, to: view, label: String(Int(jointAngles["LeftTrunkAngle"]!)))
            UIUtilities.addLabel(atPoint: leftElbow, to: view, label: String(Int(jointAngles["LeftElbowAngle"]!)))
        case .right:
            UIUtilities.addLabel(atPoint: rightKnee, to: view, label: String(Int(jointAngles["RightKneeAngle"]!)))
            UIUtilities.addLabel(atPoint: rightHip, to: view, label: String(Int(jointAngles["RightHipAngle"]!)))
            UIUtilities.addLabel(atPoint: rightAnkle, to: view, label: String(Int(jointAngles["RightAnkleAngle"]!)))
            UIUtilities.addLabel(atPoint: rightShoulder, to: view, label: String(Int(jointAngles["RightTrunkAngle"]!)))
            UIUtilities.addLabel(atPoint: rightElbow, to: view, label: String(Int(jointAngles["RightElbowAngle"]!)))
        case .front:
            UIUtilities.addLabel(atPoint: leftKnee, to: view, label: String(Int(jointAngles["LeftKneeAngle"]!)))
            UIUtilities.addLabel(atPoint: leftHip, to: view, label: String(Int(jointAngles["LeftHipAngle"]!)))
            UIUtilities.addLabel(atPoint: leftAnkle, to: view, label: String(Int(jointAngles["LeftAnkleAngle"]!)))
            UIUtilities.addLabel(atPoint: leftShoulder, to: view, label: String(Int(jointAngles["LeftTrunkAngle"]!)))
            UIUtilities.addLabel(atPoint: leftElbow, to: view, label: String(Int(jointAngles["LeftElbowAngle"]!)))
            
            UIUtilities.addLabel(atPoint: rightKnee, to: view, label: String(Int(jointAngles["RightKneeAngle"]!)))
            UIUtilities.addLabel(atPoint: rightHip, to: view, label: String(Int(jointAngles["RightHipAngle"]!)))
            UIUtilities.addLabel(atPoint: rightAnkle, to: view, label: String(Int(jointAngles["RightAnkleAngle"]!)))
            UIUtilities.addLabel(atPoint: rightShoulder, to: view, label: String(Int(jointAngles["RightTrunkAngle"]!)))
            UIUtilities.addLabel(atPoint: rightElbow, to: view, label: String(Int(jointAngles["RightElbowAngle"]!)))
        }
    }
}
