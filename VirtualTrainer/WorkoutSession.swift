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
        self.workoutResult = WorkoutResult(score: 0, incorrectJoints: [], incorrectAccelerations: [0])
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
        var matchedFrames: [String] = []
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
                    do {
                        let jsonData = try JSONEncoder().encode(jointAngles)
                        matchedFrames.append(String(data: jsonData, encoding: .utf8)!)
                    } catch {
                        print("Unable to encode data... try again")
                    }
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
    
    func generateFeedback() -> [String] {
        let idealJointAngles = idealWorkouts[self.workoutType]!.jointAngles[self.cameraAngle]
        let userJointAngles = self.getIncorrectJointAngles()
        
        var feedback: [String] = []
        
        for (i, angles) in userJointAngles.enumerated() {
            var diff = 0.0
            if (i == 1) {
                for (key, value) in angles {
                    diff = idealJointAngles?[i][key]! ?? 0.0 - Double(value)
                    switch self.workoutType {
                        case "deadlift":
                            if diff < 0 {
                                if key.contains("Knee") {
                                    feedback.append("Your knee position is good. You have reached full knee extension.")
                                }
                                else if key.contains("Ankle") {
                                    feedback.append("Your ankle position is good")
                                }
                                else if key.contains("Hip") {
                                    feedback.append("Your hip position is good. You have reached full hip extension.")
                                }
                                else if key.contains("Trunk") {
                                    feedback.append("Your torso flexion is good. Keep bracing your core.")
                                }
                                else if key.contains("Elbow") {
                                    feedback.append("Keep a more neutral elbow position. Don't flare them in.")
                                }
                                else {
                                    feedback.append("Keep your shoulders in a neutral position.")
                                }
                            }
                            else {
                                if key.contains("Knee") {
                                    feedback.append("Your knee position is too low. Try pulling the bar to full knee extension.")
                                }
                                else if key.contains("Ankle") {
                                    feedback.append("Your ankles are too far forward. Keep going to full hip extension")
                                }
                                else if key.contains("Hip") {
                                    feedback.append("Your hip is still too angled. Go to full hip extension.")
                                }
                                else if key.contains("Trunk") {
                                    feedback.append("Your torso is in too much flexion. Bracing your core.")
                                }
                                else if key.contains("Elbow") {
                                    feedback.append("Keep a more neutral elbow position. Don't flare them out.")
                                }
                                else {
                                    feedback.append("Keep your shoulders in a neutral position.")
                                }
                            }
                        default:
                            if diff < 0 {
                                if key.contains("Knee") {
                                    feedback.append("Your squat is too deep. Maintain a 90 degree knee angle for conventional squats.")
                                }
                                else if key.contains("Ankle") {
                                    feedback.append("Your ankles are too far forward. Try keeping a more upright knee.")
                                }
                                else if key.contains("Hip") {
                                    feedback.append("Your hip is hinging too much. Please try and keep a more posterior tilt.")
                                }
                                else if key.contains("Trunk") {
                                    feedback.append("Your torso is bending too much. Brace your core and keep a straighter back.")
                                }
                                else if key.contains("Elbow") {
                                    feedback.append("Your elbows are flaring out too much. Rest the barbell on your neck.")
                                }
                                else {
                                    feedback.append("Your shoulder angle is too large. Retract your scapula for better upper back engagement.")
                                }
                            }
                            else {
                                if key.contains("Knee") {
                                    feedback.append("Your squat depth is too high. Try reaching 90 degrees knee angle for depth.")
                                }
                                else if key.contains("Ankle") {
                                    feedback.append("Your ankles are too far back. Try going down a bit more.")
                                }
                                else if key.contains("Hip") {
                                    feedback.append("Your hip is hinging too little. Please try and keep a more anterior tilt.")
                                }
                                else if key.contains("Trunk") {
                                    feedback.append("Your torso is position is good. Keep bracing your core.")
                                }
                                else if key.contains("Elbow") {
                                    feedback.append("Your elbow position is good. Rest the barbell on your neck.")
                                }
                                else {
                                    feedback.append("Your shoulder position is good.")
                                }
                            }
                    }
                }
            }
        }
        return feedback
    }
    
    func save() {
        let encoder = JSONEncoder()
        var encodedJointAnglesList: [String] = []

        do {
            for jointAngles in self.jointAnglesList {
                let jsonData = try encoder.encode(jointAngles)
                encodedJointAnglesList.append(String(data: jsonData, encoding: .utf8)!)
            }
        } catch {
            print("Unable to encode data... try again")
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

    func getIncorrectJointAngles() -> [[String: CGFloat]]{
        let decoder = JSONDecoder()
        var decodedAnglesList: [[String: CGFloat]] = []
        do {
            for jointString in self.workoutResult.incorrectJoints ?? [] {
                let decoded = try decoder.decode([String: CGFloat].self, from: Data(jointString.utf8))
                decodedAnglesList.append(decoded)
            }
        } catch {
            print("Unable to decode the incorrect joint angles")
        }

        return decodedAnglesList
    }
}
