//
//  FeedbackViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-03.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

@objc(FeedbackViewController)
class FeedbackViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finish(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
