//
//  SharedConvenienceFunctions.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import Foundation

public var isPreview: Bool {
#if DEBUG
    // For Previews only
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        return true
    }
#endif
    return false
}
