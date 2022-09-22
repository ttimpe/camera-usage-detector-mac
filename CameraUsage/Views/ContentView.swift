//
//  ContentView.swift
//  CameraUsage
//
//  Created by Tobias Timpe on 22.09.22.
//  Copyright © 2022 Tobias Timpe. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var cameras: [Camera] = []
    @State var selectedCamera: Camera?
    @State var cameraOnURL: String = ""
    @State var cameraOffURL: String = ""
    var body: some View {
        Form {
            Picker("Select Camera", selection: self.$selectedCamera) {
                ForEach(cameras) { camera in
                    Text(camera.name ?? "")
                }
            }
            TextField("Camera on URL", text: self.$cameraOnURL)
            TextField("Camera off URL", text: self.$cameraOffURL)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
