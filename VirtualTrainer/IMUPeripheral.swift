//
//  IMUPeripheral.swift
//  VirtualTrainer
//
//  Created by Peter Xu on 2021-03-01.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class IMUPeripheral: NSObject {

    public static let IMUServiceUUID = CBUUID.init(string: "62030cd8-4861-49b0-a581-90c2ac45d70e")
    public static let XAccelCharacteristicUUID = CBUUID.init(string: "73f0762b-dbc2-4e4b-a2a8-9868fd04bce1")
    public static let YAccelCharacteristicUUID = CBUUID.init(string: "73f0762b-dbc2-4e4b-a2a8-9868fd04bce2")
    public static let ZAccelCharacteristicUUID = CBUUID.init(string: "73f0762b-dbc2-4e4b-a2a8-9868fd04bce3")

}
