//
//  WorkoutResultViewController.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-25.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
import AVKit

@objc(WorkoutResultViewController)
class WorkoutResultViewController: UIViewController {
    
  @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    
    var workoutSession: WorkoutSession?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let date =  Date(timeIntervalSince1970: workoutSession?.startTimestamp ?? 0)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "EEEE, MMM d" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    
    dateLabel?.text = strDate
    
    let videoURL = URL(string: (workoutSession?.videoURL)!)
    
    let player = AVPlayer(url: videoURL!)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    playerViewController.view.frame = videoView.bounds
    playerViewController.showsPlaybackControls = true
    videoView.addSubview(playerViewController.view)
    self.addChild(playerViewController)
  }
}
