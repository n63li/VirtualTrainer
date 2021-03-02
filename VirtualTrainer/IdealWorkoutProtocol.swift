//
//  WorkoutProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//
public struct idealSquatFront {
  static let workoutType = "squat"
  static let cameraAngle = "front"
  static let jointAngles = [
    SquatElement(orientation: "front", KneeAngle: 179.6099312342993, HipAngle: 164.87005306411166, AnkleAngle: 170.0828288218672, TrunkAngle: 82.0075221223597),
    SquatElement(orientation: "front", KneeAngle: 121.26256833371818, HipAngle: 129.75911995111406, AnkleAngle: 127.8847898113248, TrunkAngle: 80.897916478019),
    SquatElement(orientation: "front", KneeAngle: 87.88416669956626, HipAngle: 100.33090900944711, AnkleAngle: 126.02424551473915, TrunkAngle: 79.04702835542136),
    SquatElement(orientation: "front", KneeAngle: 71.22893405406865, HipAngle: 82.60236641479229, AnkleAngle: 126.84316631636784, TrunkAngle: 80.53104852279795)
  ]
}

public struct idealSquatLeft {
  static let workoutType = "squat"
  static let cameraAngle = "left"
  static let jointAngles = [
    SquatElement(orientation: "left", KneeAngle: 177.237857386819, HipAngle: 172.79732456011516, AnkleAngle: 106.1491845234079, TrunkAngle: 85.75752712166738),
    SquatElement(orientation: "left", KneeAngle: 148.05029193586032, HipAngle: 145.26628116171472, AnkleAngle: 101.50820768945607, TrunkAngle: 78.52557551472361),
    SquatElement(orientation: "left", KneeAngle: 54.72509180203564, HipAngle: 68.31149095326951, AnkleAngle: 93.09683438421493, TrunkAngle: 72.27319056795133)
  ]
}

public struct idealSquatRight {
  static let workoutType = "squat"
  static let cameraAngle = "left"
  static let jointAngles = [
    SquatElement(orientation: "right", KneeAngle: 169.81827071540508, HipAngle: 172.10633874850615, AnkleAngle: 107.26840872846148, TrunkAngle: 0.0),
    SquatElement(orientation: "right", KneeAngle: 58.74163972790378, HipAngle: 71.07479796450882, AnkleAngle: 98.18637220630455, TrunkAngle: 0.0),
    SquatElement(orientation: "right", KneeAngle: 60.36755038198676, HipAngle: 74.36094169034101, AnkleAngle: 94.26787428293488, TrunkAngle: 0.0)
  ]
}

public struct IdealDeadliftFront {
  static let workoutType = "deadlift"
  static let cameraAngle = "front"
  static let jointAngles = [
    DeadliftElement(orientation: "front", LeftKneeAngle: 179.3810663925355, RightKneeAngle: 174.44456262741164, LeftHipAngle: 166.2306509715523, RightHipAngle: 172.20387248749512, LeftAnkleAngle: 178.65832210506247, RightAnkleAngle: 175.9133484267583, LeftTrunkAngle: 80.31341269497882, RightTrunkAngle: 0.0, LeftShoulderAngle: 24.914843750289737, RightShoulderAngle: 22.98292610065798, LeftElbowAngle: 174.44736425704323, RightElbowAngle: 171.88930036293652),
    DeadliftElement(orientation: "front", LeftKneeAngle: 179.61659731598962, RightKneeAngle: 175.4610040992984, LeftHipAngle: 161.48359483824947, RightHipAngle: 162.99009206856618, LeftAnkleAngle: 176.65646191690902, RightAnkleAngle: 174.03449532238378, LeftTrunkAngle: 75.4292179662036, RightTrunkAngle: 0.0, LeftShoulderAngle: 26.54556066483766, RightShoulderAngle: 27.799350132646815, LeftElbowAngle: 175.934060916468, RightElbowAngle: 176.35751072703692),
    DeadliftElement(orientation: "front", LeftKneeAngle: 165.71069172908466, RightKneeAngle: 164.19263667720213, LeftHipAngle: 133.0213051132276, RightHipAngle: 128.51105403437418, LeftAnkleAngle: 170.84746771417238, RightAnkleAngle: 163.9106360327126, LeftTrunkAngle: 53.546637968587014, RightTrunkAngle: 0.0, LeftShoulderAngle: 50.784327029575465, RightShoulderAngle: 56.02082682228046, LeftElbowAngle: 165.65192410590296, RightElbowAngle: 164.72837246203238),
    DeadliftElement(orientation: "front", LeftKneeAngle: 166.80548463740917, RightKneeAngle: 155.7492094237309, LeftHipAngle: 142.7326500349571, RightHipAngle: 140.80441294400342, LeftAnkleAngle: 170.05958650033588, RightAnkleAngle: 169.81103269891628, LeftTrunkAngle: 64.79386760818672, RightTrunkAngle: 0.0, LeftShoulderAngle: 41.10405097195401, RightShoulderAngle: 39.98330202574226, LeftElbowAngle: 169.124943547679, RightElbowAngle: 167.64496532084354),
    DeadliftElement(orientation: "front", LeftKneeAngle: 163.96254107715703, RightKneeAngle: 169.90300030828612, LeftHipAngle: 139.07800495244513, RightHipAngle: 149.56207738039495, LeftAnkleAngle: 174.33653366840315, RightAnkleAngle: 176.8703829996868, LeftTrunkAngle: 64.22983258792259, RightTrunkAngle: 0.0, LeftShoulderAngle: 41.75762547932264, RightShoulderAngle: 36.37195788252838, LeftElbowAngle: 167.21132156733918, RightElbowAngle: 170.53886700629542)
  ]
}

public struct IdealDeadliftLeft {
  static let workoutType = "deadlift"
  static let cameraAngle = "left"
  static let jointAngles = [
    DeadliftElement(orientation: "left", LeftKneeAngle: 80.46148969174499, RightKneeAngle: 97.11696269182517, LeftHipAngle: 51.49970004678993, RightHipAngle: 48.048764998948556, LeftAnkleAngle: 94.51023216676681, RightAnkleAngle: 110.15436533449922, LeftTrunkAngle: 28.62371039854733, RightTrunkAngle: 0.0, LeftShoulderAngle: 35.629748676596996, RightShoulderAngle: 36.58114027596558, LeftElbowAngle: 167.1490864301984, RightElbowAngle: 160.41688139874742),
    DeadliftElement(orientation: "left", LeftKneeAngle: 168.3593211332179, RightKneeAngle: 128.4956263576795, LeftHipAngle: 176.2443586926745, RightHipAngle: 160.1253705856579, LeftAnkleAngle: 105.68164208078771, RightAnkleAngle: 107.86726131532235, LeftTrunkAngle: 87.67142233722882, RightTrunkAngle: 0.0, LeftShoulderAngle: 1.6132744458346426, RightShoulderAngle: 2.46919517495502, LeftElbowAngle: 156.0458887201461, RightElbowAngle: 158.51845016362998),
    DeadliftElement(orientation: "left", LeftKneeAngle: 176.52268756028133, RightKneeAngle: 174.60630055169577, LeftHipAngle: 166.07965362817913, RightHipAngle: 167.49259807664257, LeftAnkleAngle: 124.89498263003422, RightAnkleAngle: 138.3395252299484, LeftTrunkAngle: 79.42109459486481, RightTrunkAngle: 0.0, LeftShoulderAngle: 12.336086463425586, RightShoulderAngle: 25.128411519317652, LeftElbowAngle: 153.95948874571835, RightElbowAngle: 133.11088383986146),
    DeadliftElement(orientation: "left", LeftKneeAngle: 137.11112832830767, RightKneeAngle: 153.5134433868136, LeftHipAngle: 130.41254038395985, RightHipAngle: 136.2987913913805, LeftAnkleAngle: 118.69785893817777, RightAnkleAngle: 130.68407915848195, LeftTrunkAngle: 77.69623893845626, RightTrunkAngle: 0.0, LeftShoulderAngle: 20.70306418124873, RightShoulderAngle: 14.775262499517565, LeftElbowAngle: 129.82193038644556, RightElbowAngle: 138.2892599900244)
  ]
}

public struct idealDeadliftRight {
  let workoutType = "deadlift"
  let cameraAngle = "right"
  let jointAngles = [
    DeadliftElement(orientation: "right", LeftKneeAngle: 94.30379973407244, RightKneeAngle: 67.49262784880875, LeftHipAngle: 43.33674012160151, RightHipAngle: 51.09009095704931, LeftAnkleAngle: 118.12240945637777, RightAnkleAngle: 105.96518366781754, LeftTrunkAngle: 26.100003257624905, RightTrunkAngle: 0.0, LeftShoulderAngle: 45.3659938812711, RightShoulderAngle: 38.286842120746044, LeftElbowAngle: 173.23125124497253, RightElbowAngle: 169.63730232743512),
    DeadliftElement(orientation: "right", LeftKneeAngle: 158.2632641811643, RightKneeAngle: 173.21650018433263, LeftHipAngle: 171.47327979502862, RightHipAngle: 177.41282241365204, LeftAnkleAngle: 108.97346098202897, RightAnkleAngle: 102.32880443097156, LeftTrunkAngle: 87.64334240276267, RightTrunkAngle: 0.0, LeftShoulderAngle: 5.5989136919804805, RightShoulderAngle: 6.979294023332606, LeftElbowAngle: 155.97193909440924, RightElbowAngle: 158.07468548625852),
    DeadliftElement(orientation: "right", LeftKneeAngle: 132.54086991204767, RightKneeAngle: 177.98970363553548, LeftHipAngle: 147.89034973581073, RightHipAngle: 171.12958047982158, LeftAnkleAngle: 112.299066048506, RightAnkleAngle: 114.79895619647237, LeftTrunkAngle: 78.96587034847141, RightTrunkAngle: 0.0, LeftShoulderAngle: 15.864855550646244, RightShoulderAngle: 19.12104647734964, LeftElbowAngle: 150.83127233403647, RightElbowAngle: 149.52533489665907),
    DeadliftElement(orientation: "right", LeftKneeAngle: 124.0101457535097, RightKneeAngle: 123.22516315344534, LeftHipAngle: 119.75795193385827, RightHipAngle: 115.53339534195402, LeftAnkleAngle: 126.30890949911213, RightAnkleAngle: 117.38187382506203, LeftTrunkAngle: 75.79251791292472, RightTrunkAngle: 0.0, LeftShoulderAngle: 21.027083818013487, RightShoulderAngle: 16.567497983545724, LeftElbowAngle: 133.556030115311, RightElbowAngle: 143.98657184216597)
  ]
}
