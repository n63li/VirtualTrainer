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
    var fromHistoryViewController: Bool = false

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var videoView: OverlayVideoView!
    @IBOutlet weak var feedbackTextView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try workoutSession?.calculateScore()
        }
        catch {
            print("Did not calculate score")
        }
    
        if (fromHistoryViewController) {
            self.doneButton.isEnabled = false
            self.doneButton.tintColor = .clear
        }

        let textLabel = "Score: \(workoutSession!.workoutResult.score!)"
        scoreLabel?.text = textLabel

        if workoutSession!.workoutResult.score! <= Double(0) {
            feedbackTextView.isHidden = true

            if !fromHistoryViewController {
                let alert = UIAlertController(title: "Workout Warning", message: "Could not detect proper postures at all - are you sure you uploaded the correct video for the selected exercise and camera angle?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ignore", comment: "Cancel action"), style: .cancel, handler: { _ in

                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Restart", comment: "Default action"), style: .destructive, handler: { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                scoreLabel?.text = "Could not detect proper postures - are you sure you uploaded the correct video for the selected exercise and camera angle?"
            }
        }
        else {
            let feedback = workoutSession?.generateFeedback()
            var feedbackParagraph = feedback?[0]
            
            for sentence in feedback![1...] {
                feedbackParagraph! += "\n" + sentence
            }
            
            feedbackTextView.text = feedbackParagraph!
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
        videoView.workoutSession = workoutSession
        videoView.load(video: videoURL!)
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        playerViewController.delegate = self
//        playerViewController.view.frame = videoView.bounds
//        playerViewController.showsPlaybackControls = true
//        videoView.addSubview(playerViewController.view)
//        self.addChild(playerViewController)
    }

    @IBAction func finish(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
        workoutSession?.endTimestamp = NSDate().timeIntervalSince1970
        workoutSession?.save()
    }
}
