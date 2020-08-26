//
//  CameraUsageController.swift
//  CameraUsage
//
//  Created by Tobias Timpe on 20.08.20.
//  Copyright © 2020 Tobias Timpe. All rights reserved.
//

import Foundation
import CoreMediaIO


class CameraUsageController {
    var timer: Timer?
    var lastCameraState: Bool = false
    
    
    
    var cameras: [Camera]  {
        get {
            var innerArray :[Camera] = []
            var opa = CMIOObjectPropertyAddress(
                mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyDevices),
                mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
                mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster)
            )

            var dataSize: UInt32 = 0
            var dataUsed: UInt32 = 0
            var result = CMIOObjectGetPropertyDataSize(CMIOObjectID(kCMIOObjectSystemObject), &opa, 0, nil, &dataSize)
            var devices: UnsafeMutableRawPointer?

            repeat {
                if devices != nil {
                    free(devices)
                    devices = nil
                }

                devices = malloc(Int(dataSize))
                result = CMIOObjectGetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &opa, 0, nil, dataSize, &dataUsed, devices)
            } while result == OSStatus(kCMIOHardwareBadPropertySizeError)


            if let devices = devices {
                for offset in stride(from: 0, to: dataSize, by: MemoryLayout<CMIOObjectID>.size) {
                    let current = devices.advanced(by: Int(offset)).assumingMemoryBound(to: CMIOObjectID.self)
                    innerArray.append(Camera(id: current.pointee))
                }
            }

            free(devices)


            return innerArray
        }
        
    }
    
    func isAnyCameraOn() -> Bool {
        for camera in self.cameras {
            if camera.isOn {
                return true
            }
        }
        return false
    }
    
    func getCameraById(id: UInt32) -> Camera? {
        for camera in self.cameras {
            if camera.id == id {
                return camera
            }
        }
        return nil
    }

    
    func startUpdating() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(check), userInfo: nil, repeats: true)
        timer?.tolerance = 0.2
    }
    func stopUpdating() {
        timer?.invalidate()
    }
    
    @objc func check() {
        let id: Int = UserDefaults.standard.integer(forKey: "selectedCameraId")
        
        if id == 0 {
            // any camera
            if (self.lastCameraState != isAnyCameraOn()) {
                   // Got update
                   self.lastCameraState = isAnyCameraOn()
                   print("State changed")
                   self.sendUpdateToServer()
               }
        } else {
            // single camera
            if let camera = getCameraById(id: UInt32(id)) {
            
            if (self.lastCameraState != camera.isOn) {
                   // Got update
                self.lastCameraState = camera.isOn
                   print("State changed")
                   self.sendUpdateToServer()
            }
            }
        }
        
        
   
    }
    func sendUpdateToServer() {
        UserDefaults.standard.synchronize()
        var urlKey = "cameraOffURL"
        if self.lastCameraState {
            urlKey = "cameraOnURL"
        }
        if let url = UserDefaults.standard.url(forKey: urlKey) {
            
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("done updating")
            }.resume()
        }

    }

    
}
