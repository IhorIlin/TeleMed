//
//  Data+Extension.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import Foundation

extension Data {
    var hexString: String {
        self.map { String(format: "%02x", $0) }.joined()
    }
}
