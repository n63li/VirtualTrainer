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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try workoutSession?.calculateScore()
        }
        catch {
            print("Did not calculate score")
        }
        
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
        
        workoutSession?.endTimestamp = NSDate().timeIntervalSince1970
        let date =  Date(timeIntervalSince1970: workoutSession?.startTimestamp ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE, MMM d" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        self.title = strDate
        let videoURL = URL(string: (workoutSession?.videoURL)!)
        
        print("Playing from URL: \(videoURL?.absoluteString)")
        
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
        workoutSession?.endTimestamp = NSDate().timeIntervalSince1970
        workoutSession?.save()
    }
}
