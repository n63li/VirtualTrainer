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
 "squat": Squat()
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

public struct Deadlift {
  static let jointAngles = [
    WorkoutOrientation.front: [
      DeadliftElement(orientation: "front", LeftKneeAngle: 179.3810663925355, RightKneeAngle: 174.44456262741164, LeftHipAngle: 166.2306509715523, RightHipAngle: 172.20387248749512, LeftAnkleAngle: 178.65832210506247, RightAnkleAngle: 175.9133484267583, LeftTrunkAngle: 80.31341269497882, RightTrunkAngle: 0.0, LeftShoulderAngle: 24.914843750289737, RightShoulderAngle: 22.98292610065798, LeftElbowAngle: 174.44736425704323, RightElbowAngle: 171.88930036293652),
      DeadliftElement(orientation: "front", LeftKneeAngle: 179.61659731598962, RightKneeAngle: 175.4610040992984, LeftHipAngle: 161.48359483824947, RightHipAngle: 162.99009206856618, LeftAnkleAngle: 176.65646191690902, RightAnkleAngle: 174.03449532238378, LeftTrunkAngle: 75.4292179662036, RightTrunkAngle: 0.0, LeftShoulderAngle: 26.54556066483766, RightShoulderAngle: 27.799350132646815, LeftElbowAngle: 175.934060916468, RightElbowAngle: 176.35751072703692),
      DeadliftElement(orientation: "front", LeftKneeAngle: 165.71069172908466, RightKneeAngle: 164.19263667720213, LeftHipAngle: 133.0213051132276, RightHipAngle: 128.51105403437418, LeftAnkleAngle: 170.84746771417238, RightAnkleAngle: 163.9106360327126, LeftTrunkAngle: 53.546637968587014, RightTrunkAngle: 0.0, LeftShoulderAngle: 50.784327029575465, RightShoulderAngle: 56.02082682228046, LeftElbowAngle: 165.65192410590296, RightElbowAngle: 164.72837246203238),
      DeadliftElement(orientation: "front", LeftKneeAngle: 166.80548463740917, RightKneeAngle: 155.7492094237309, LeftHipAngle: 142.7326500349571, RightHipAngle: 140.80441294400342, LeftAnkleAngle: 170.05958650033588, RightAnkleAngle: 169.81103269891628, LeftTrunkAngle: 64.79386760818672, RightTrunkAngle: 0.0, LeftShoulderAngle: 41.10405097195401, RightShoulderAngle: 39.98330202574226, LeftElbowAngle: 169.124943547679, RightElbowAngle: 167.64496532084354),
      DeadliftElement(orientation: "front", LeftKneeAngle: 163.96254107715703, RightKneeAngle: 169.90300030828612, LeftHipAngle: 139.07800495244513, RightHipAngle: 149.56207738039495, LeftAnkleAngle: 174.33653366840315, RightAnkleAngle: 176.8703829996868, LeftTrunkAngle: 64.22983258792259, RightTrunkAngle: 0.0, LeftShoulderAngle: 41.75762547932264, RightShoulderAngle: 36.37195788252838, LeftElbowAngle: 167.21132156733918, RightElbowAngle: 170.53886700629542)
      ],
    WorkoutOrientation.left: [
      DeadliftElement(orientation: "left", LeftKneeAngle: 80.46148969174499, RightKneeAngle: 97.11696269182517, LeftHipAngle: 51.49970004678993, RightHipAngle: 48.048764998948556, LeftAnkleAngle: 94.51023216676681, RightAnkleAngle: 110.15436533449922, LeftTrunkAngle: 28.62371039854733, RightTrunkAngle: 0.0, LeftShoulderAngle: 35.629748676596996, RightShoulderAngle: 36.58114027596558, LeftElbowAngle: 167.1490864301984, RightElbowAngle: 160.41688139874742),
      DeadliftElement(orientation: "left", LeftKneeAngle: 168.3593211332179, RightKneeAngle: 128.4956263576795, LeftHipAngle: 176.2443586926745, RightHipAngle: 160.1253705856579, LeftAnkleAngle: 105.68164208078771, RightAnkleAngle: 107.86726131532235, LeftTrunkAngle: 87.67142233722882, RightTrunkAngle: 0.0, LeftShoulderAngle: 1.6132744458346426, RightShoulderAngle: 2.46919517495502, LeftElbowAngle: 156.0458887201461, RightElbowAngle: 158.51845016362998),
      DeadliftElement(orientation: "left", LeftKneeAngle: 176.52268756028133, RightKneeAngle: 174.60630055169577, LeftHipAngle: 166.07965362817913, RightHipAngle: 167.49259807664257, LeftAnkleAngle: 124.89498263003422, RightAnkleAngle: 138.3395252299484, LeftTrunkAngle: 79.42109459486481, RightTrunkAngle: 0.0, LeftShoulderAngle: 12.336086463425586, RightShoulderAngle: 25.128411519317652, LeftElbowAngle: 153.95948874571835, RightElbowAngle: 133.11088383986146),
      DeadliftElement(orientation: "left", LeftKneeAngle: 137.11112832830767, RightKneeAngle: 153.5134433868136, LeftHipAngle: 130.41254038395985, RightHipAngle: 136.2987913913805, LeftAnkleAngle: 118.69785893817777, RightAnkleAngle: 130.68407915848195, LeftTrunkAngle: 77.69623893845626, RightTrunkAngle: 0.0, LeftShoulderAngle: 20.70306418124873, RightShoulderAngle: 14.775262499517565, LeftElbowAngle: 129.82193038644556, RightElbowAngle: 138.2892599900244)
    ],
    WorkoutOrientation.right: [
      DeadliftElement(orientation: "right", LeftKneeAngle: 94.30379973407244, RightKneeAngle: 67.49262784880875, LeftHipAngle: 43.33674012160151, RightHipAngle: 51.09009095704931, LeftAnkleAngle: 118.12240945637777, RightAnkleAngle: 105.96518366781754, LeftTrunkAngle: 26.100003257624905, RightTrunkAngle: 0.0, LeftShoulderAngle: 45.3659938812711, RightShoulderAngle: 38.286842120746044, LeftElbowAngle: 173.23125124497253, RightElbowAngle: 169.63730232743512),
      DeadliftElement(orientation: "right", LeftKneeAngle: 158.2632641811643, RightKneeAngle: 173.21650018433263, LeftHipAngle: 171.47327979502862, RightHipAngle: 177.41282241365204, LeftAnkleAngle: 108.97346098202897, RightAnkleAngle: 102.32880443097156, LeftTrunkAngle: 87.64334240276267, RightTrunkAngle: 0.0, LeftShoulderAngle: 5.5989136919804805, RightShoulderAngle: 6.979294023332606, LeftElbowAngle: 155.97193909440924, RightElbowAngle: 158.07468548625852),
      DeadliftElement(orientation: "right", LeftKneeAngle: 132.54086991204767, RightKneeAngle: 177.98970363553548, LeftHipAngle: 147.89034973581073, RightHipAngle: 171.12958047982158, LeftAnkleAngle: 112.299066048506, RightAnkleAngle: 114.79895619647237, LeftTrunkAngle: 78.96587034847141, RightTrunkAngle: 0.0, LeftShoulderAngle: 15.864855550646244, RightShoulderAngle: 19.12104647734964, LeftElbowAngle: 150.83127233403647, RightElbowAngle: 149.52533489665907),
      DeadliftElement(orientation: "right", LeftKneeAngle: 124.0101457535097, RightKneeAngle: 123.22516315344534, LeftHipAngle: 119.75795193385827, RightHipAngle: 115.53339534195402, LeftAnkleAngle: 126.30890949911213, RightAnkleAngle: 117.38187382506203, LeftTrunkAngle: 75.79251791292472, RightTrunkAngle: 0.0, LeftShoulderAngle: 21.027083818013487, RightShoulderAngle: 16.567497983545724, LeftElbowAngle: 133.556030115311, RightElbowAngle: 143.98657184216597)
    ]
  ] as [AnyHashable : [DeadliftElement]]
}
