//
//  Storyboarded.swift
//  TeleMed
//
//  Created by Ihor Ilin on 11.05.2025.
//

import UIKit

protocol Storyboarded {
    static var storyboard: Storyboard { get }
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = Self.storyboard.instance
        
        return storyboard.instantiateViewController(identifier: id)
    }
}
