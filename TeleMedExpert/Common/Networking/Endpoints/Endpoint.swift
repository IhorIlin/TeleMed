//
//  Endpoint.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

protocol Endpoint {
    var url: URL { get }
    var method: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}
