//
//  WorkoutProtocol.swift
//  VirtualTrainer
//
//  Created by Nathan Li on 2021-02-16.
//
public let idealSquatRight = [
  SquatElement(orientation: "right", KneeAngle: 179.7561044347451, HipAngle: 177.23966649398434, AnkleAngle: 128.48408243711748, TrunkAngle: 0.0),
  SquatElement(orientation: "right", KneeAngle: 90.86861052318542, HipAngle: 100.48350676788714, AnkleAngle: 106.3977112137546, TrunkAngle: 0.0),
  SquatElement(orientation: "right", KneeAngle: 178.21735024388704, HipAngle: 177.7292506491383, AnkleAngle: 119.23408719256155, TrunkAngle: 0.0)
]

protocol IdealWorkout {
  var jointAngles: [WorkoutOrientation: [[String: Double]]] { get }
}

let idealWorkouts = [
  "squat": Squat(),
  "deadlift": Deadlift()
] as [String : IdealWorkout]

public struct Squat: IdealWorkout {
  var jointAngles = [
    WorkoutOrientation.front: [
      ["RightShoulderAngle": 38.16231214342122, "LeftKneeAngle": 177.29731477223768, "LeftShoulderAngle": 46.285662494807525, "RightKneeAngle": 174.58379960055166, "RightHipAngle": 167.89887777086682, "RightElbowAngle": 45.94609932076504, "RightAnkleAngle": 171.67517404293554, "LeftHipAngle": 165.70027412540324, "LeftElbowAngle": 45.530589578538354, "LeftAnkleAngle": 172.04846577917957, "RightTrunkAngle": 0.0, "LeftTrunkAngle": 8.10697522502299],
      ["RightShoulderAngle": 52.0777872397814, "LeftHipAngle": 105.15215480811875, "LeftShoulderAngle": 47.88985398135958, "RightHipAngle": 93.11345595996133, "LeftAnkleAngle": 132.74975896015468, "LeftTrunkAngle": 8.089458544923234, "RightAnkleAngle": 122.84632432287565, "LeftKneeAngle": 90.67210958654549, "RightKneeAngle": 76.9736288047997, "LeftElbowAngle": 56.299649717540944, "RightElbowAngle": 53.083459933434064, "RightTrunkAngle": 0.0],
      ["LeftShoulderAngle": 45.52509129227491, "RightElbowAngle": 45.84481254938037, "RightKneeAngle": 178.54880462540126, "LeftHipAngle": 168.58054669669033, "LeftTrunkAngle": 6.260647360070038, "LeftElbowAngle": 53.611158967593795, "LeftAnkleAngle": 160.83931933758575, "RightHipAngle": 163.9499441636227, "RightTrunkAngle": 0.0, "RightShoulderAngle": 40.06159308502009, "LeftKneeAngle": 178.31033671232677, "RightAnkleAngle": 164.99578576039528]
    ],
    WorkoutOrientation.left: [
      ["LeftKneeAngle": 179.78213541342345, "LeftHipAngle": 175.6111980330109, "LeftAnkleAngle": 121.7293104665186, "LeftShoulderAngle": 12.9774090974701, "LeftElbowAngle": 12.342832233163394, "LeftTrunkAngle": 85.72558079861318],
      ["LeftElbowAngle": 2.0999834801215793, "LeftHipAngle": 98.5621563234215, "LeftTrunkAngle": 71.7994800801165, "LeftShoulderAngle": 1.6507321996977595, "LeftAnkleAngle": 99.84946697640163, "LeftKneeAngle": 90.70850838944541],
      ["LeftKneeAngle": 178.19955980695278, "LeftTrunkAngle": 86.06226388615482, "LeftAnkleAngle": 108.52084164244343, "LeftHipAngle": 177.53116284178572, "LeftShoulderAngle": 15.437416472007946, "LeftElbowAngle": 10.660974404614118]
    ],
    WorkoutOrientation.right: [
      ["RightElbowAngle": 19.227568520585475, "RightTrunkAngle": 0.0, "RightHipAngle": 177.07018889999227, "RightAnkleAngle": 127.49587505605791, "RightKneeAngle": 178.71358742348656, "RightShoulderAngle": 22.44236436529397],
      ["RightShoulderAngle": 2.177821377329432, "RightHipAngle": 107.73005739132337, "RightAnkleAngle": 104.50271339770194, "RightElbowAngle": 0.9066790123419027, "RightTrunkAngle": 0.0, "RightKneeAngle": 95.42618823791067],
      ["RightAnkleAngle": 120.29136729121312, "RightHipAngle": 177.5267296097333, "RightTrunkAngle": 0.0, "RightShoulderAngle": 28.957519998456483, "RightElbowAngle": 13.436350725078965, "RightKneeAngle": 178.7561545144063]
    ]
  ]
}

public struct Deadlift: IdealWorkout {
  var jointAngles = [
    WorkoutOrientation.front: [
      ["LeftAnkleAngle": 171.93793678974873, "LeftElbowAngle": 171.10395568353755, "RightHipAngle": 113.64217531695202, "RightAnkleAngle": 169.10129700557135, "LeftTrunkAngle": 18.26548840960009, "LeftShoulderAngle": 33.917823748545175, "LeftHipAngle": 139.4769653936344, "RightKneeAngle": 128.42858432809095, "RightElbowAngle": 165.87982707526524, "LeftKneeAngle": 155.50040054712937, "RightShoulderAngle": 41.33970270016795, "RightTrunkAngle": 0.0],
      ["LeftShoulderAngle": 23.76365417074527, "RightHipAngle": 173.2259801132512, "RightShoulderAngle": 20.17863464001647, "RightTrunkAngle": 0.0, "LeftHipAngle": 165.72758966093895, "RightElbowAngle": 174.23708845687202, "RightAnkleAngle": 175.40909111834515, "RightKneeAngle": 172.05176184572304, "LeftAnkleAngle": 175.5371284493889, "LeftElbowAngle": 174.49871980394786, "LeftTrunkAngle": 9.569483273504682, "LeftKneeAngle": 179.73490655239343],
      ["LeftTrunkAngle": 26.240718332178997, "LeftAnkleAngle": 159.64751184024738, "LeftElbowAngle": 167.1144457345168, "RightKneeAngle": 157.73953279854305, "RightAnkleAngle": 161.1115896978337, "LeftKneeAngle": 151.2135271845295, "RightShoulderAngle": 39.73186917428126, "RightTrunkAngle": 0.0, "LeftHipAngle": 132.82200224133362, "LeftShoulderAngle": 42.24448281660983, "RightHipAngle": 138.29162066785497, "RightElbowAngle": 168.79059791890012]
    ],
    WorkoutOrientation.left: [
      ["LeftHipAngle": 44.55173436091411, "LeftElbowAngle": 176.6548777651898, "LeftKneeAngle": 92.65263872343651, "LeftAnkleAngle": 116.79513054308129, "LeftTrunkAngle": 26.606378848154804, "LeftShoulderAngle": 46.465622153489186],
      ["LeftShoulderAngle": 0.1351078740480742, "LeftKneeAngle": 160.9459187602941, "LeftAnkleAngle": 95.81697156912327, "LeftHipAngle": 170.58935102220326, "LeftTrunkAngle": 87.33797688013448, "LeftElbowAngle": 155.30715315977415],
      ["LeftHipAngle": 42.253017382519204, "LeftAnkleAngle": 68.27330936084445, "LeftElbowAngle": 175.93744418089346, "LeftTrunkAngle": 19.952392265309925, "LeftShoulderAngle": 57.460842238016234, "LeftKneeAngle": 62.344342434717994]
    ],
    WorkoutOrientation.right: [
      ["RightElbowAngle": 165.9200432961416, "RightHipAngle": 50.38896314264876, "RightKneeAngle": 94.24633108237616, "RightAnkleAngle": 111.39956359768752, "RightTrunkAngle": 0.0, "RightShoulderAngle": 36.030651453545545],
      ["RightHipAngle": 166.6053268222345, "RightElbowAngle": 154.60539914608148, "RightTrunkAngle": 0.0, "RightShoulderAngle": 4.3386554940654145, "RightAnkleAngle": 111.43473417612044, "RightKneeAngle": 152.44805390339607],
      ["RightHipAngle": 54.444715727554964, "RightAnkleAngle": 64.35088836098579, "RightElbowAngle": 167.0264330463517, "RightTrunkAngle": 0.0, "RightShoulderAngle": 54.89391294577525, "RightKneeAngle": 74.94360247705346]
    ]
  ]
}
