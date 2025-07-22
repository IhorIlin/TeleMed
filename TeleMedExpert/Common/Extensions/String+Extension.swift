//
//  String+Extension.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation

extension String {
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}

extension String {
    /// True if the JWT token is expired (based on exp claim)
    var isJWTExpired: Bool {
        guard
            let payload = self.decodeJWTPayload(),
            let exp = payload["expiration"] as? TimeInterval
        else {
            return true // treat invalid token as expired
        }
        
        let expiryDate = Date(timeIntervalSince1970: exp)
        return expiryDate < Date()
    }
    
    /// Decodes the payload section of the JWT into a dictionary
    func decodeJWTPayload() -> [String: Any]? {
        let segments = self.split(separator: ".")
        guard segments.count > 1 else { return nil }
        
        let payloadSegment = segments[1]
        
        var base64 = String(payloadSegment)
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddedLength = (4 - (base64.count % 4)) % 4
        base64 += String(repeating: "=", count: paddedLength)
        
        guard let payloadData = Data(base64Encoded: base64) else {
            return nil
        }
        
        let json = try? JSONSerialization.jsonObject(with: payloadData, options: [])
        return json as? [String: Any]
    }
}
