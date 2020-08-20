//
//  CameraUsageController.swift
//  CameraUsage
//
//  Created by Tobias Timpe on 20.08.20.
//  Copyright © 2020 Tobias Timpe. All rights reserved.
//

import Foundation
import IsCameraOn

class CameraUsageController {
    var timer: Timer?
    var lastCameraState: Bool = false
    
    

    
    func startUpdating() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(check), userInfo: nil, repeats: true)
        timer?.tolerance = 0.2
    }
    func stopUpdating() {
        timer?.invalidate()
    }
    
    @objc func check() {
        if (self.lastCameraState != isCameraOn()) {
            // Got update
            self.lastCameraState = isCameraOn()
            print("State changed")
            self.sendUpdateToServer()
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
