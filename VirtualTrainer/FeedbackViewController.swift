//
//  FeedbackViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-03.
//  Copyright © 2021 Google Inc. All rights reserved.
//
import Amplify
import UIKit
import AVKit

@objc(FeedbackViewController)
class FeedbackViewController: UIViewController {
  var workoutSession: WorkoutSession? = nil
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var videoView: UIView!
    
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
    
    @IBAction func finish(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)

        print(workoutSession?.squatElements)
        print(workoutSession?.deadliftElements)
        workoutSession?.workoutResult = WorkoutResult(
          score: 1020,
          incorrectJoints: [],
          incorrectAccelerations: []
        )
        workoutSession?.endTimestamp = NSDate().timeIntervalSince1970
        workoutSession?.save()
    }
}
