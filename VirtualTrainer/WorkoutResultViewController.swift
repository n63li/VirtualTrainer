//
//  WorkoutResultViewController.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-25.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

@objc(WorkoutResultViewController)
class WorkoutResultViewController: UIViewController {
    
  @IBOutlet weak var dateLabel: UILabel!
  var workoutSession: WorkoutSession?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let date =  Date(timeIntervalSince1970: workoutSession?.startTimestamp ?? 0)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
    let strDate = dateFormatter.string(from: date)
    
    dateLabel?.text = strDate
  }
}
