//
//  WorkoutTableCell.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-02-22.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    func set(session: WorkoutSession) {
        let date =  Date(timeIntervalSince1970: Double(session.startTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
//        print("Loading session \(session)")
//        print("TypeLabel: \(typeLabel)")
        
        typeLabel?.text = session.workoutType
        dateLabel?.text = strDate
//        accuracyLabel?.text = String(session.workoutResult.score)
    }
}
