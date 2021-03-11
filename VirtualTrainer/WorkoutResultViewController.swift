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
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var workoutSession: WorkoutSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if workoutSession!.workoutResult.score! <= Double(0) {
            scoreLabel?.text = "Could not detect proper postures - are you sure you uploaded the correct video for the selected exercise and camera angle?"
            feedbackLabel.isHidden = true
        }
        else {
            scoreLabel?.text = "You have achieved a score of \(workoutSession!.workoutResult.score!)"
            let feedback = workoutSession?.generateFeedback()
            var feedbackParagraph = feedback?[0]
            
            for sentence in feedback![1...] {
                feedbackParagraph! += " " + sentence
            }
            
            feedbackLabel.text = feedbackParagraph!
        }
        
        let date =  Date(timeIntervalSince1970: workoutSession?.startTimestamp ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE, MMM d" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        self.title = strDate

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
