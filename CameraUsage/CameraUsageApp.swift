//
//  CameraUsageApp.swift
//  CameraUsage
//
//  Created by Tobias Timpe on 22.09.22.
//  Copyright © 2022 Tobias Timpe. All rights reserved.
//
import SwiftUI
import Foundation

@main
struct CameraUsageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        MenuBarExtra("", systemImage: "camera") {
            Button(action: {
                
            }) {
                Text("Boom")
            }
        }
    }
}
