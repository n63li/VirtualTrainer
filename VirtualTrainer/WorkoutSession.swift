//
//  WorkoutSessionProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//
import Amplify

class WorkoutSession {
    var id: String = ""
    var workoutType: String = ""
    var imuData: [Double] = []
    var cameraAngle: WorkoutOrientation
    var workoutResult: WorkoutResult
    var startTimestamp: Double = 0
    var endTimestamp: Double = 0
    var videoURL: String? = ""
    var jointAnglesList: [[String: CGFloat]] = []
    
    init(workoutType: String, cameraAngle: WorkoutOrientation) {
        self.workoutType = workoutType
        self.cameraAngle = cameraAngle
        self.workoutResult = WorkoutResult(score: 0, incorrectJoints: [0], incorrectAccelerations: [0])
        self.startTimestamp = NSDate().timeIntervalSince1970
    }
    
    func calculateScore() throws {
        let idealWorkouts = [
            "squat": Squat(),
            "deadlift": Deadlift()
        ] as [String : IdealWorkout]
        
        let idealJointAnglesList = idealWorkouts[self.workoutType]!.jointAngles[self.cameraAngle]
        var currentIdealJointAngleListIndex = 0
        let keys = self.jointAnglesList[0].keys
        var tolerance = 4.0
        var score = 100.0
        var iterations = 1
        let matchedFrames = []
        while currentIdealJointAngleListIndex < idealJointAnglesList!.count {
            tolerance += Double(iterations) * 2
            for jointAngles in self.jointAnglesList {
                if currentIdealJointAngleListIndex >= idealJointAnglesList!.count {
                    break
                }
                let currentIdealJointAngles = idealJointAnglesList![currentIdealJointAngleListIndex]
                var isUserJointAngleGood = false
                var scoreDeduction = 0.0
                let scoreDeductionWeighting = 0.25
                for key in keys {
                    let userVal = jointAngles[key]
                    let idealJointAngle = currentIdealJointAngles[key]
                    let difference = Double(abs(userVal! - CGFloat(idealJointAngle!)))
                    if (difference <= tolerance) {
                        scoreDeduction += difference * scoreDeductionWeighting * Double(iterations) / 14
                        isUserJointAngleGood = true
                    } else {
                        isUserJointAngleGood = false
                        break
                    }
                }
                
                if isUserJointAngleGood {
                    print("We found frame \(currentIdealJointAngleListIndex)")
                    matchedFrames.append(jointAngles)
                    currentIdealJointAngleListIndex += 1
                    score -= Double(scoreDeduction)
                }
            }
            iterations += 1
        }
        
        if currentIdealJointAngleListIndex < idealJointAnglesList!.count || score < 0 {
            // means that we couldn't find any user poses that resembles the ideal poses
            // user has bad pose, might need to ask them to try again
            print("User has bad pose, cannot match user poses to ideal poses")
            score = 0.0
        } else {
            print("Hey we have a score of: \(score)")
        }
        self.workoutResult = WorkoutResult(
            score: Double(round(100 * score) / 100),
            incorrectJoints: matchedFrames,
            incorrectAccelerations: [0]
        )
    }
    
    func save() {
        let encoder = JSONEncoder()
        var encodedJointAnglesList: [String] = []
        
        for jointAngles in self.jointAnglesList {
            var encodedJointAngles = ""
            do {
                let jsonData = try encoder.encode(jointAngles)
                encodedJointAngles = String(data: jsonData, encoding: .utf8)!
            } catch {
                print("Unable to encode joint angles")
            }
            
            encodedJointAnglesList.append(encodedJointAngles)
        }
        
        let workoutSessionItem = WorkoutSessionModel(
            imuData: self.imuData,
            cameraAngle: self.cameraAngle.rawValue,
            workoutType: self.workoutType,
            startTimestamp: Int(self.startTimestamp),
            endTimestamp: Int(self.endTimestamp),
            workoutResult: self.workoutResult,
            videoURL: self.videoURL,
            jointAnglesList: encodedJointAnglesList)
        Amplify.DataStore.save(workoutSessionItem) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved workout session: \(savedItem.id)")
            case .failure(let error):
                print("Could not save workout session to DataStore: \(error)")
            }
        }
    }
}
