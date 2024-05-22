//
//  Logger.swift
//  fuelPrices
//
//  Created by Robson Harrison on 21/05/2024.
//

import Foundation
import os

struct Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.robson-harrison.fuelPrices"
    
    static let networkLogger = OSLog(subsystem: subsystem, category: "Network")
    static let systemLogger = OSLog(subsystem: subsystem, category: "Error")
    
    static func logNetworkError(_ message: String, error: Error, url: String? = nil) {
        let urlString = url ?? ""
        os_log("%{public}@: %{public}@: %{public}@", log: networkLogger, type: .error, message, error.localizedDescription, urlString)
    }
    
    static func logNetworkInfo(_ message: String, url: String? = nil) {
        let urlString = url ?? ""
        os_log("%{public}@: %{public}@", log: networkLogger, type: .info, message, urlString)
    }
    
    static func logSystemError(_ message: String) {
        os_log("%{public}@", log: systemLogger, type: .info, message)
    }
    
}



