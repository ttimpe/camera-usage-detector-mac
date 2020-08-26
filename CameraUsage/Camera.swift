//
//  Camera.swift
//  CameraUsage
//
//  Created by Tobias Timpe on 26.08.20.
//  Copyright © 2020 Tobias Timpe. All rights reserved.
//

import Foundation
import CoreMediaIO

struct Camera {
    var id: CMIOObjectID
    var name: String? {
        get {
            var address:CMIOObjectPropertyAddress = CMIOObjectPropertyAddress(
                mSelector:CMIOObjectPropertySelector(kCMIOObjectPropertyName),
                mScope:CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
                mElement:CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))

            var name:CFString? = nil
            let propsize:UInt32 = UInt32(MemoryLayout<CFString?>.size)
            var dataUsed: UInt32 = 0

            let result:OSStatus = CMIOObjectGetPropertyData(self.id, &address, 0, nil, propsize, &dataUsed, &name)
            if (result != 0) {
                return ""
            }

            return name as String?
        }
    }
    var isOn: Bool {
        var opa = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIODevicePropertyDeviceIsRunningSomewhere),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeWildcard),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementWildcard)
        )

        
        var isUsed = false
        
        var dataSize: UInt32 = 0
        var dataUsed: UInt32 = 0
        var result = CMIOObjectGetPropertyDataSize(self.id, &opa, 0, nil, &dataSize)
        if result == OSStatus(kCMIOHardwareNoError) {
            if let data = malloc(Int(dataSize)) {
                result = CMIOObjectGetPropertyData(self.id, &opa, 0, nil, dataSize, &dataUsed, data)
                let on = data.assumingMemoryBound(to: UInt8.self)
                isUsed = on.pointee != 0
            }
        }

        return isUsed
    }
}
