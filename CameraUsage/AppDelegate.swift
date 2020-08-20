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

    @IBOutlet weak var cameraOnURLField: NSTextField!
    @IBOutlet weak var cameraOffURLField: NSTextField!
    
    
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
        UserDefaults.standard.synchronize()

        if let cameraOnURLString = UserDefaults.standard.url(forKey: "cameraOnURL")?.absoluteString {
            self.cameraOnURLField.stringValue = cameraOnURLString
        }
        if let cameraOffURLString = UserDefaults.standard.url(forKey: "cameraOffURL")?.absoluteString {
            self.cameraOffURLField.stringValue = cameraOffURLString
        }
    }
    
    @IBAction func saveUpdateURLs(_ sender: Any) {
        if let cameraOnURL = URL(string: self.cameraOnURLField.stringValue) {
            UserDefaults.standard.set(cameraOnURL, forKey: "cameraOnURL")
        }
        if let cameraOffURL = URL(string: self.cameraOffURLField.stringValue) {
            UserDefaults.standard.set(cameraOffURL, forKey: "cameraOffURL")
        }
        UserDefaults.standard.synchronize()
    }
}

