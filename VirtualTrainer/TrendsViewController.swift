//
//  TrendsViewController.swift
//  VirtualTrainer
//
//  Created by Henry Xu on 2021-03-06.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import UIKit
import Charts
import Amplify

class TrendsViewController: UIViewController {
    @IBOutlet weak var scatterChartView: ScatterChartView!
    
    private var workoutSessions: [WorkoutSession]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        query()
    }
    
    @IBAction func refresh(_ sender: Any) {
        query()
    }
    
    func query() {
        Amplify.DataStore.query(WorkoutSessionModel.self, sort: .ascending(WorkoutSessionModel.keys.startTimestamp)) { result in
            switch(result) {
            case .success(let items):
                for item in items {
                    print("WorkoutSessionModel ID: \(item.id)")
                }
                workoutSessions = WorkoutSession.convertWorkoutSessionModelsToWorkoutSessions(workoutSessionModels: items)
                updateGraph()
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    func updateGraph() {
        var minDate = Double(Int.max)
        var maxDate = Double(Int.min)
        var squatEntries = [ChartDataEntry]()
        var deadliftEntries = [ChartDataEntry]()
        for (index, workout) in workoutSessions!.enumerated() {
            let date =  Date(timeIntervalSince1970: workout.startTimestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM d" //Specify your format that you want
            let timestamp = dateFormatter.date(from: dateFormatter.string(from: date))!.timeIntervalSince1970
            
            let value = ChartDataEntry(x: timestamp, y: workout.workoutResult.score!)
            if (workout.workoutType == "squat") {
                squatEntries.append(value)
            } else {
                deadliftEntries.append(value)
            }
            minDate = Double.minimum(timestamp, minDate)
            maxDate = Double.maximum(timestamp, maxDate)
        }
        
        let squat = ScatterChartDataSet(entries: squatEntries)
        squat.setScatterShape(.x)
        let deadlift = ScatterChartDataSet(entries: deadliftEntries)
        deadlift.setScatterShape(.circle)
        
        let data = ScatterChartData(dataSets: [squat, deadlift])
        scatterChartView.data = data
        scatterChartView.xAxis.axisMinimum = minDate
        scatterChartView.xAxis.axisMinimum = maxDate
        scatterChartView.xAxis.valueFormatter = XAxisFormatter()
        scatterChartView.xAxis.avoidFirstLastClippingEnabled = true
        scatterChartView.chartDescription?.text = "Workout Scores"
    }
}

class XAxisFormatter : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date =  Date(timeIntervalSince1970: value)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM d" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
}
