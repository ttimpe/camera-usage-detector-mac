//
//  AppDelegate.swift
//  CameraUsage
//
//  Created by Tobias Timpe on 20.08.20.
//  Copyright © 2020 Tobias Timpe. All rights reserved.
//

import Cocoa
import CoreImage
import CoreMedia
import CoreMediaIO


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let cameraUsageController = CameraUsageController()

    @IBOutlet weak var updateURLField: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
       
        cameraUsageController.startUpdating()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        cameraUsageController.stopUpdating()
    }

    @IBAction func showPreferencesWindow(_ sender: Any) {
        self.window.setIsVisible(true)
        self.window.makeKey()
        if let updateURLString = UserDefaults.standard.url(forKey: "updateURL")?.absoluteString {
            self.updateURLField.stringValue = updateURLString
        }
    }
    
    @IBAction func saveUpdateURL(_ sender: Any) {
        if let url = URL(string: self.updateURLField.stringValue) {
            UserDefaults.standard.set(url, forKey: "updateURL")
            UserDefaults.standard.synchronize()
        }
    }
}

