//
//  BluetoothManage.swift
//  VirtualTrainer
//
//  Created by Peter Xu on 2021-03-11.
//  Copyright © 2021 Google Inc. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {

    private var centralManager: CBCentralManager!
    private var peripheralIMU: CBPeripheral!
    private var imuAccelXOffset: Double = 0
    private var imuAccelYOffset: Double = 0.8
    private var imuAccelZOffset: Double = -0.4
    
    var workoutSession: WorkoutSession? = nil
    // MARK: - Properties

    static let shared = BluetoothManager()

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn{
            print("Central is not powered")
        } else {
            print("Central scanning for", IMUPeripheral.IMUServiceUUID)
            centralManager.scanForPeripherals(withServices: [IMUPeripheral.IMUServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.centralManager.stopScan()
        
        self.peripheralIMU = peripheral
        self.peripheralIMU.delegate = self
        self.centralManager.connect(self.peripheralIMU, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheralIMU {
            peripheral.discoverServices([IMUPeripheral.IMUServiceUUID])
            print("Connected to IMU")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovering Services")
        if let services = peripheral.services {
            for service in services {
                if service.uuid == IMUPeripheral.IMUServiceUUID     {
                    peripheral.discoverCharacteristics(
                        [IMUPeripheral.XAccelCharacteristicUUID,
                        IMUPeripheral.YAccelCharacteristicUUID,
                        IMUPeripheral.ZAccelCharacteristicUUID], for: service)
                    return
                }
            }

        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == IMUPeripheral.XAccelCharacteristicUUID {
                    print("X Accel characteristic found")
                } else if characteristic.uuid == IMUPeripheral.YAccelCharacteristicUUID {
                    print("Y Accel characteristic found")
                } else if characteristic.uuid == IMUPeripheral.ZAccelCharacteristicUUID {
                    print("Z Accel characteristic found");
                }
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
            case IMUPeripheral.XAccelCharacteristicUUID:
                if let value = characteristic.value {
                    let uncodedVal = (String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.doubleValue
                    self.workoutSession?.IMUQueueAppend(value: (uncodedVal!+imuAccelXOffset), direction: "x")
                    print("X: \((String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.floatValue)")
                }
                else {
                    print("Bad data for X-Accel")
                }
            case IMUPeripheral.YAccelCharacteristicUUID:
                if let value = characteristic.value {
                    let uncodedVal = (String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.doubleValue
                    self.workoutSession?.IMUQueueAppend(value: (uncodedVal!+imuAccelYOffset), direction: "y")
                    print("Y: \((String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.floatValue)")
                }
                else {
                    print("Bad data for Y-Accel")
                }
            case IMUPeripheral.ZAccelCharacteristicUUID:
                if let value = characteristic.value {
                    let uncodedVal = (String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.doubleValue
                    self.workoutSession?.IMUQueueAppend(value: (uncodedVal!+imuAccelZOffset), direction: "z")
                    print("Z: \((String(bytes: value, encoding: String.Encoding.utf8) as NSString?)?.floatValue)")
                }
                else {
                    print("Bad data for Z-Accel")
                }
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
    
    func setup() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}
