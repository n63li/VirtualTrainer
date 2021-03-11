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
        
        let feedback = workoutSession?.generateFeedback()
        var feedbackParagraph = feedback?[0]

        for sentence in feedback! {
            feedbackParagraph! += " " + sentence
        }
        
        feedbackLabel.text = feedbackParagraph!        
        let date =  Date(timeIntervalSince1970: workoutSession?.startTimestamp ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE, MMM d" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        self.title = strDate
        scoreLabel?.text = "You achieved a score of \(workoutSession!.workoutResult.score!)"

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
