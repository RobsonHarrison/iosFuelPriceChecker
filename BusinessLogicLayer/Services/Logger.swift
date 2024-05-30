//
//  Logger.swift
//  fuelPrices
//
//  Created by Robson Harrison on 21/05/2024.
//

import Foundation
import os

enum Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.robson-harrison.fuelPrices"

    static let networkLogger = OSLog(subsystem: subsystem, category: "Network")
    static let systemLogger = OSLog(subsystem: subsystem, category: "Error")

    static func logNetworkError(_ message: String, error: Error, url: String) {
        #if DEBUG
            os_log("%{public}@ - %{public}@ - %{public}@", log: networkLogger, type: .error, message, error.localizedDescription, url)
        #endif
    }

    #if DEBUG
        static func logNetworkInfo(_ message: String, url: String) {
            os_log("%{public}@ - %{public}@", log: networkLogger, type: .error, message, url)
        }
    #endif

    #if DEBUG
        static func logSystemError(_ message: String, type: OSLogType) {
            os_log("%{public}@", log: networkLogger, type: type, message)
        }
    #endif
}
