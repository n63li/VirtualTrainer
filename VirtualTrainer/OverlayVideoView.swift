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
    
    private var actionView: UIImageView? = nil
    
    private var isLive: Bool = false
    
    func load(video: URL, live: Bool = false) {
        isLive = live
        layer.isOpaque = true
        self.backgroundColor = .systemBackground
        poseDetectorHelper.resetManagedLifecycleDetectors()
        
        let item = AVPlayerItem(url: video)
        output = AVPlayerItemVideoOutput(outputSettings: nil)
    
        item.add(output)
        
        player = AVPlayer(playerItem: item)
        playerLayer.frame = self.bounds
        if (isLive) {
            playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2))
        }
        setupDisplayLink()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        
        actionView = UIImageView(frame: CGRect(x: self.frame.midX - 25, y: self.frame.midY - 25, width: 50, height: 50))
        actionView?.image = UIImage(named: "play-button")
        actionView?.backgroundColor = .green
        self.addSubview(actionView!)
    }
    
    @objc func displayLinkUpdated(link: CADisplayLink) {
        let time = output.itemTime(forHostTime: CACurrentMediaTime())
        guard output.hasNewPixelBuffer(forItemTime: time),
              let pixbuf = output.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else { return }
        let baseImg = CIImage(cvImageBuffer: pixbuf)
        let imageWidth = CGFloat(CVPixelBufferGetWidth(pixbuf))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(pixbuf))
        
        guard let cgImg = context.createCGImage(baseImg, from: baseImg.extent) else { return }
        let img = UIImage(cgImage: cgImg)
        
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        DispatchQueue.global(qos: .background).async {
            let visionImg = VisionImage(image: img)
            if (self.isLive) {
                visionImg.orientation = .right
            }
            let poses = self.poseDetectorHelper.detectPose(in: visionImg)
        
            poses.forEach { pose in
                DispatchQueue.main.sync {
                    if (self.isLive) {
                        PoseUtilities.displaySkeleton3(pose: pose, width: imageWidth, height: imageHeight, rect: self.playerLayer.videoRect, view: self)
                    } else {
                        PoseUtilities.displaySkeleton2(pose: pose, width: imageWidth, height: imageHeight, rect: self.playerLayer.videoRect, view: self)
                    }

                    print("frame: \(self.frame.width), \(self.frame.height)")
                    print("img: \(imageWidth), \(imageHeight)")
                    print("Video Rect: \(self.playerLayer.videoRect.width), \(self.playerLayer.videoRect.height)")
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
            self.actionView?.isHidden = false
        } else {
            player?.play()
            self.actionView?.isHidden = true
        }
    }
}
