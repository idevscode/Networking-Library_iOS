//
//  NetworkConfiguration.swift
//  Data
//

import Foundation

/// A public configuration holder that the App layer uses to inject
/// the base URL into the Data module at startup.
/// This preserves unidirectional data flow: App → Data.
public final class NetworkConfiguration: @unchecked Sendable {
    public static let shared = NetworkConfiguration()

    private(set) var baseURL: String = ""

    private init() {}

    /// Call this once from the App layer (e.g. in `App.init()`)
    /// to provide the base URL read from Info.plist / xcconfig.
    public func configure(baseURL: String) {
        self.baseURL = baseURL
    }
}
