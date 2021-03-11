//
//  OverlayVideoView.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-03-10.
//  Copyright © 2021 Google Inc. All rights reserved.
//
import UIKit
import AVKit
import MLKit

class OverlayVideoView: UIView {
    var workoutSession: WorkoutSession? = nil
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    private var output: AVPlayerItemVideoOutput!
    private var displayLink: CADisplayLink!
    private var context: CIContext = CIContext(options: [CIContextOption.workingColorSpace : NSNull()])

    private var poseDetectorHelper = PoseDetectorHelper()

    private var isRecordedByApp = false

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func load(video: URL) {
        print("Playing video from \(video.absoluteString)")
        layer.isOpaque = true
        self.backgroundColor = .systemBackground
        poseDetectorHelper.resetManagedLifecycleDetectors()

        let item = AVPlayerItem(url: video)
        output = AVPlayerItemVideoOutput(outputSettings: nil)

        item.add(output)

        player = AVPlayer(playerItem: item)
        playerLayer.frame = self.bounds
        setupDisplayLink()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    @objc func playerDidFinishPlaying() {
        player?.seek(to: CMTime.zero)
    }

    @objc func displayLinkUpdated(link: CADisplayLink) {
        let time = output.itemTime(forHostTime: CACurrentMediaTime())
        guard output.hasNewPixelBuffer(forItemTime: time),
              let pixbuf = output.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else { return }
        let baseImg = CIImage(cvImageBuffer: pixbuf)

        guard let cgImg = context.createCGImage(baseImg, from: baseImg.extent) else { return }
        var img = UIImage(cgImage: cgImg)

        let imgRatio = Double(round(1000 * img.size.width / img.size.height) / 1000)
        let videoRatio = Double(round(1000 * playerLayer.videoRect.width / playerLayer.videoRect.height) / 1000)

        if (imgRatio != videoRatio) {
            img = img.rotate(radians: .pi / 2)!
        }

        self.subviews.forEach { view in
            view.removeFromSuperview()
        }

        DispatchQueue.global(qos: .background).async {
            let visionImg = VisionImage(image: img)
            let poses = self.poseDetectorHelper.detectPose(in: visionImg)

            poses.forEach { pose in
                DispatchQueue.main.sync {
                    PoseUtilities.displaySkeleton2(pose: pose, width: img.size.width, height: img.size.height, rect: self.playerLayer.videoRect, view: self)

                    let jointAngles = PoseUtilities.getAngles(pose: pose, orientation: self.workoutSession!.cameraAngle)
                    self.workoutSession?.jointAnglesList.append(jointAngles)

                    PoseUtilities.displayOverlay2(pose: pose, to: self, jointAngles: jointAngles, orientation: self.workoutSession?.cameraAngle ?? WorkoutOrientation.left, width: img.size.width, height: img.size.height, rect: self.playerLayer.videoRect)
                }
            }
        }
    }

    func stop() {
        player?.rate = 0
        displayLink.invalidate()
    }

    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkUpdated(link:)))
        displayLink.preferredFramesPerSecond = 20
        displayLink.add(to: .main, forMode: .common)
    }

    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }

    @objc func tapped(_ sender: UITapGestureRecognizer) {
        updateStatus()
    }

    private func updateStatus() {
        if isPlaying {
            player?.pause()
            // self.actionView?.isHidden = false
        } else {
            player?.play()
            // self.actionView?.isHidden = true
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
