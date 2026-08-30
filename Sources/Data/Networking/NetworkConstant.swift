//
//  NetworkConstant.swift
//  Data
//

import Foundation

enum NetworkConstant {
    static var baseURL: String {
        NetworkConfiguration.shared.baseURL
    }
}
