//
//  Font.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 14.05.2025.
//

import UIKit

enum Font {
    enum Name {
        static let black = "Inter-Black"
        static let bold = "Inter-Bold"
        static let light = "Inter-Light"
        static let medium = "Inter-Medium"
        static let regular = "Inter-Regular"
        static let semibold = "Inter-Semibold"
        static let thin = "Inter-Thin"
    }
    
    // MARK: - Predefined Text Styles
    enum TextStyle {
        static func titleLarge() -> UIFont {
            Font.custom(weight: .bold, size: 24)
        }
        
        static func titleMedium() -> UIFont {
            Font.custom(weight: .medium, size: 18)
        }
        
        static func body() -> UIFont {
            Font.custom(weight: .regular, size: 16)
        }
        
        static func caption() -> UIFont {
            Font.custom(weight: .bold, size: 12)
        }
        
        static func button() -> UIFont {
            Font.custom(weight: .medium, size: 16)
        }
    }
    
    enum Weight {
        case black
        case bold
        case light
        case medium
        case regular
        case semibold
        case thin
        
        func toWeight() -> UIFont.Weight {
            switch self {
            case .black: return UIFont.Weight.black
            case .bold: return UIFont.Weight.bold
            case .light: return UIFont.Weight.light
            case .medium: return UIFont.Weight.medium
            case .regular: return UIFont.Weight.regular
            case .semibold: return UIFont.Weight.semibold
            case .thin: return UIFont.Weight.thin
            }
        }
    }
    
    static func custom(weight: Weight, size: CGFloat) -> UIFont {
        let name: String
        
        switch weight {
        case .black: name = Name.black
        case .bold: name = Name.bold
        case .light: name = Name.light
        case .medium: name = Name.medium
        case .regular: name = Name.regular
        case .semibold: name = Name.semibold
        case .thin: name = Name.thin
        }
        
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: weight.toWeight())
    }
}
