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
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    private var workoutSessions: [WorkoutSession]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Amplify.DataStore.query(WorkoutSessionModel.self, sort: .descending(WorkoutSessionModel.keys.startTimestamp)) { result in
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
        var lineData = [ChartDataEntry]()
        for (index, workout) in workoutSessions!.enumerated() {
            let value = ChartDataEntry(x: workout.startTimestamp, y: workout.workoutResult.score!)
            lineData.append(value)
        }
        
        let line = LineChartDataSet(entries: lineData, label: "Scores")
        line.colors = [.blue]
        let data = LineChartData()
        data.addDataSet(line)
        lineChartView.data = data
        lineChartView.xAxis.valueFormatter = XAxisFormatter()
        lineChartView.chartDescription?.text = "Workout Scores"
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
